import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/recipe.dart';

/// Handles exporting recipes to `.purepantry` JSON files and importing them
/// back into the app.
class RecipeShareService {
  static const _currentVersion = 1;

  /// Exports [recipe] as a `.purepantry` file in the temp directory.
  ///
  /// Embeds the recipe image as base64 if one exists. Strips `isFavorite`
  /// (personal preference) from the exported data.
  Future<File> exportToFile(Recipe recipe) async {
    final recipeJson = recipe.toJson();

    // Embed the actual image data if the local file exists.
    String? imageBase64;
    final imagePath = recipe.imageUrl;
    if (imagePath != null) {
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        imageBase64 = base64Encode(await imageFile.readAsBytes());
      }
    }

    // Strip fields that are device-specific or personal.
    recipeJson.remove('imageUrl');
    recipeJson.remove('isFavorite');

    final envelope = <String, dynamic>{
      'version': _currentVersion,
      'recipe': recipeJson,
      if (imageBase64 != null) 'image': imageBase64,
    };

    final tempDir = await getTemporaryDirectory();
    final safeName =
        recipe.name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
    final file = File(p.join(tempDir.path, '$safeName.purepantry'));
    await file.writeAsString(jsonEncode(envelope));

    return file;
  }

  /// Imports a recipe from a `.purepantry` file at [filePath].
  ///
  /// Assigns a fresh UUID and sets `createdAt` to now so the imported recipe
  /// doesn't collide with existing data.
  Future<Recipe> importFromFile(String filePath) async {
    final file = File(filePath);
    final contents = await file.readAsString();

    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(contents) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('Invalid recipe file format.');
    }

    if (!envelope.containsKey('version') ||
        !envelope.containsKey('recipe')) {
      throw const FormatException('Invalid recipe file format.');
    }

    final recipeData = envelope['recipe'] as Map<String, dynamic>;

    // Clear device-specific fields.
    recipeData.remove('imageUrl');
    recipeData['isFavorite'] = false;

    // Assign a new identity so imported recipes never collide.
    final newId = const Uuid().v4();
    recipeData['id'] = newId;
    recipeData['createdAt'] = DateTime.now().toIso8601String();
    recipeData.remove('updatedAt');

    // Restore embedded image to local storage.
    final imageBase64 = envelope['image'] as String?;
    if (imageBase64 != null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final imgDir = Directory(p.join(docsDir.path, 'recipe_images'));
      if (!imgDir.existsSync()) {
        imgDir.createSync(recursive: true);
      }
      final destPath = p.join(imgDir.path, '$newId.jpg');
      await File(destPath).writeAsBytes(base64Decode(imageBase64));
      recipeData['imageUrl'] = destPath;
    }

    return Recipe.fromJson(recipeData);
  }
}
