import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/ai_quota.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../recipes/domain/models/ingredient.dart';
import '../../../recipes/domain/models/instruction_step.dart';
import '../../../recipes/domain/models/nutrition_info.dart';

/// Repository for the chat-based meal planning AI.
///
/// Calls the `chatWithChef` Cloud Function with the user's message,
/// conversation history, and preference context.
class AiChatRepository {
  final FirebaseFunctions _functions;

  AiChatRepository(this._functions);

  /// Send a message to the AI chef and get a response.
  ///
  /// [userMessage] — the latest user input.
  /// [chatHistory] — formatted string of prior conversation turns.
  /// [preferenceSummary] — structured family/pantry/preference context.
  /// [activePlan] — optional current meal plan summary for context.
  Future<ChatResponse> sendMessage({
    required String userMessage,
    required String chatHistory,
    required Map<String, dynamic> preferenceSummary,
    String? activePlan,
    String? imageBase64,
    String? imageMediaType,
  }) async {
    final params = {
      'userMessage': userMessage,
      'chatHistory': chatHistory,
      'preferenceSummary': preferenceSummary,
      if (activePlan != null) 'activePlan': activePlan,
      if (imageBase64 != null) 'imageBase64': imageBase64,
      if (imageMediaType != null) 'imageMediaType': imageMediaType,
    };

    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final result =
            await _functions.httpsCallable('chatWithChef').call(params);

        final data = _deepCast(result.data);
        final responseText = data['responseText'] as String? ?? '';
        final recipesData = data['recipes'] as List<dynamic>? ?? [];

        final recipes = recipesData
            .whereType<Map>()
            .map((m) => _parseRecipe(_deepCast(m)))
            .toList();

        return ChatResponse(
          responseText: responseText,
          recipes: recipes,
          quota: AiQuotaStatus.fromJson(data['quota'] as Map<String, dynamic>?),
        );
      } on FirebaseFunctionsException catch (e) {
        final isAppCheckError =
            e.code == 'unauthenticated' || e.code == 'UNAUTHENTICATED';
        if (isAppCheckError && attempt == 0) {
          // App Check token may be stale — force refresh and retry once.
          debugPrint('App Check token may be stale, forcing refresh...');
          try {
            await FirebaseAppCheck.instance.getToken(true);
          } catch (_) {}
          continue;
        }
        debugPrint('AiChat FirebaseFunctionsException: code=${e.code}, '
            'message=${e.message}');
        throw AiChatException(_userFriendlyMessage(e.code), code: e.code);
      } catch (e, stackTrace) {
        debugPrint('AiChatRepository error: $e');
        debugPrint('AiChatRepository stack: $stackTrace');
        throw AiChatException(
          'Something went wrong. Please try again.',
          code: e.runtimeType.toString(),
        );
      }
    }

    // Unreachable — the loop always returns or throws.
    throw AiChatException(
      'Something went wrong. Please try again.',
      code: 'unknown',
    );
  }

  Recipe _parseRecipe(Map<String, dynamic> m) {
    final rawId = m['id'] as String?;
    return Recipe(
      id: (rawId != null && rawId.isNotEmpty) ? rawId : const Uuid().v4(),
      name: m['name'] as String? ?? 'Untitled Recipe',
      description: m['description'] as String?,
      cuisine: m['cuisine'] as String?,
      prepTimeMinutes: m['prep_time'] as int? ?? 0,
      cookTimeMinutes: m['cook_time'] as int? ?? 0,
      servings: m['servings'] as int? ?? 4,
      ingredients: _parseIngredients(m['ingredients'] as List?),
      instructions: _parseInstructions(m['instructions'] as List?),
      nutrition: m['nutrition'] != null
          ? NutritionInfo.fromJson(m['nutrition'] as Map<String, dynamic>)
          : null,
      source: RecipeSource.aiGenerated,
      createdAt: DateTime.now(),
    );
  }

  List<Ingredient> _parseIngredients(List<dynamic>? data) {
    if (data == null) return [];
    return data.cast<Map<String, dynamic>>().map((m) {
      return Ingredient(
        name: m['name'] as String,
        quantity: m['quantity']?.toString(),
        unit: m['unit'] as String?,
        category: m['category'] as String?,
        optional: m['optional'] as bool? ?? false,
      );
    }).toList();
  }

  List<InstructionStep> _parseInstructions(List<dynamic>? data) {
    if (data == null) return [];
    return data.cast<Map<String, dynamic>>().map((m) {
      return InstructionStep(
        stepNumber: m['step_number'] as int? ?? 0,
        instruction: m['instruction'] as String,
        timeMinutes: m['time_minutes'] as int?,
        tip: m['tip'] as String?,
      );
    }).toList();
  }

  Map<String, dynamic> _deepCast(dynamic data) {
    if (data is Map) {
      return data.map((key, value) => MapEntry(
            key.toString(),
            value is Map
                ? _deepCast(value)
                : value is List
                    ? _deepCastList(value)
                    : value,
          ));
    }
    throw ArgumentError('Expected Map, got ${data.runtimeType}');
  }

  List<dynamic> _deepCastList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) return _deepCast(item);
      if (item is List) return _deepCastList(item);
      return item;
    }).toList();
  }

  String _userFriendlyMessage(String code) {
    switch (code) {
      case 'resource-exhausted':
        return "You've reached your chat limit. Upgrade to Premium for unlimited AI chat!";
      case 'unavailable':
        return 'The AI chef is temporarily unavailable. Try again in a moment.';
      case 'permission-denied':
        return 'Your account has been restricted. Contact support for help.';
      case 'deadline-exceeded':
        return 'The request timed out. Check your connection and try again.';
      case 'unauthenticated':
      case 'UNAUTHENTICATED':
        return 'Unable to verify this app. Please restart the app and try again.';
      case 'internal':
        return 'The AI chef encountered an error. Please try again.';
      case 'not-found':
        return 'This feature is currently unavailable. Please update the app.';
      case 'invalid-argument':
        return 'Something was wrong with the request. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

/// Response from the AI chat Cloud Function.
class ChatResponse {
  final String responseText;
  final List<Recipe> recipes;

  /// Weekly usage after this call, or null if the backend did not report it.
  final AiQuotaStatus? quota;

  const ChatResponse({
    required this.responseText,
    required this.recipes,
    this.quota,
  });
}

class AiChatException implements Exception {
  final String message;
  final String code;
  const AiChatException(this.message, {required this.code});

  @override
  String toString() => message;
}

/// Provider for the AI chat repository.
final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository(FirebaseFunctions.instance);
});
