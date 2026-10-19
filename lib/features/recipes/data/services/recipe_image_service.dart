import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/recipe_dao.dart';
import '../../../../core/services/local_image_path.dart';

/// Gives every recipe a photo: recipes without one (AI-made recipes) get one
/// drawn by the `generateRecipeImage` Cloud Function, saved on the device.
///
/// Watches the recipe table, so recipes added later (meal plans, chat) get a
/// photo too. Works one recipe at a time in the background.
class RecipeImageService {
  final RecipeDao _dao;
  final FirebaseFunctions _functions;

  StreamSubscription<List<db.Recipe>>? _subscription;
  bool _running = false;

  /// Set when the server says no more for now (daily limit, no access, or
  /// unreachable); tried again next launch.
  bool _stopped = false;

  /// Recipes the image model declined; not retried this session.
  final _skipped = <String>{};

  RecipeImageService(this._dao, {FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  /// Start filling in missing photos, now and whenever recipes change.
  void start() {
    _subscription ??= _dao.watchAllRecipes().listen((rows) {
      final missing = rows.any(
        (r) => _needsImage(r) && !_skipped.contains(r.id),
      );
      if (missing) unawaited(_fillMissing());
    });
  }

  void dispose() => _subscription?.cancel();

  static bool _needsImage(db.Recipe r) =>
      r.imageUrl == null || r.imageUrl!.isEmpty;

  /// AI-drawn photos end in "-ai.jpg"; the user's own photos never do.
  static bool isAiPhoto(String? imageUrl) =>
      imageUrl != null && imageUrl.endsWith('-ai.jpg');

  /// Draws a new photo for [recipeId], replacing an AI-drawn one (never the
  /// user's own photo). Returns false when it couldn't.
  Future<bool> redraw(String recipeId) async {
    final recipe = await _dao.getRecipeById(recipeId);
    if (recipe == null) return false;
    if (!_needsImage(recipe) && !isAiPhoto(recipe.imageUrl)) return false;
    try {
      final path = await _draw(recipe);
      final current = await _dao.getRecipeById(recipeId);
      if (current == null ||
          (!_needsImage(current) && !isAiPhoto(current.imageUrl))) {
        return false;
      }
      await _dao.updateImageUrl(recipeId, path);
      final old = current.imageUrl;
      if (old != null && old != path) {
        unawaited(
          File(
            LocalImagePath.resolve(old),
          ).delete().then((_) {}, onError: (_) {}),
        );
      }
      return true;
    } catch (e) {
      debugPrint('RecipeImageService: redraw failed for "${recipe.name}": $e');
      return false;
    }
  }

  Future<void> _fillMissing() async {
    if (_running || _stopped) return;
    _running = true;
    try {
      while (!_stopped) {
        final next = (await _dao.getRecipesWithoutImage())
            .where((r) => !_skipped.contains(r.id))
            .firstOrNull;
        if (next == null) break;
        await _generate(next);
      }
    } finally {
      _running = false;
    }
  }

  /// Draws a photo for [recipe] and saves it; returns the file's path.
  Future<String> _draw(db.Recipe recipe) async {
    try {
      return await _drawOnce(recipe);
    } on FirebaseFunctionsException catch (e) {
      // The App Check token can go stale while the app sits open; get a
      // fresh one and try once more.
      if (e.code != 'unauthenticated') rethrow;
      debugPrint('RecipeImageService: refreshing App Check token');
      try {
        await FirebaseAppCheck.instance
            .getToken(true)
            .timeout(const Duration(seconds: 15));
      } catch (_) {}
      return _drawOnce(recipe);
    }
  }

  Future<String> _drawOnce(db.Recipe recipe) async {
    final result = await _functions
        .httpsCallable(
          'generateRecipeImage',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 90)),
        )
        .call({
          'name': recipe.name,
          'description': recipe.description,
          'cuisine': recipe.cuisine,
          'ingredients': _ingredientNames(recipe.ingredientsJson),
          'steps': _stepTexts(recipe.instructionsJson),
        })
        // Also bounds getting an App Check token first.
        .timeout(const Duration(seconds: 100));
    final bytes = base64Decode(
      (Map<String, dynamic>.from(result.data as Map))['image'] as String,
    );

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'recipe_images'));
    await dir.create(recursive: true);
    // "-ai" keeps these apart from photos the user took themselves. The time
    // makes a redrawn photo a new file, so the screen doesn't show a cached
    // copy of the old one.
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final path = p.join(dir.path, '${recipe.id}-$stamp-ai.jpg');
    final tmp = File('$path.part');
    await tmp.writeAsBytes(bytes, flush: true);
    await tmp.rename(path);
    return path;
  }

  Future<void> _generate(db.Recipe recipe) async {
    try {
      final path = await _draw(recipe);

      // The user may have added their own photo while this was drawing.
      final current = await _dao.getRecipeById(recipe.id);
      if (current != null && _needsImage(current)) {
        await _dao.updateImageUrl(recipe.id, path);
      }
      debugPrint('RecipeImageService: photo for "${recipe.name}"');
    } on FirebaseFunctionsException catch (e) {
      debugPrint(
        'RecipeImageService: ${e.code} for "${recipe.name}": ${e.message}',
      );
      if (e.code == 'failed-precondition' || e.code == 'invalid-argument') {
        _skipped.add(recipe.id);
      } else {
        // Daily limit, not signed in, no access, or server trouble: stop
        // until next launch rather than retrying in a loop.
        _stopped = true;
      }
    } catch (e) {
      debugPrint('RecipeImageService: failed for "${recipe.name}": $e');
      _stopped = true;
    }
  }

  static List<String> _stepTexts(String json) {
    try {
      return (jsonDecode(json) as List)
          .whereType<Map>()
          .map((s) => '${s['instruction'] ?? ''}'.trim())
          .where((s) => s.isNotEmpty)
          .take(20)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static List<String> _ingredientNames(String json) {
    try {
      return (jsonDecode(json) as List)
          .whereType<Map>()
          .map((i) => '${i['name'] ?? ''}'.trim())
          .where((n) => n.isNotEmpty)
          .take(8)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
