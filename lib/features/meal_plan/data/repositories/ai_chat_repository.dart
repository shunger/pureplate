import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  }) async {
    try {
      final result =
          await _functions.httpsCallable('chatWithChef').call({
        'userMessage': userMessage,
        'chatHistory': chatHistory,
        'preferenceSummary': preferenceSummary,
        if (activePlan != null) 'activePlan': activePlan,
      });

      final data = result.data as Map<String, dynamic>;
      final responseText = data['responseText'] as String? ?? '';
      final recipesData = data['recipes'] as List<dynamic>? ?? [];

      final recipes = recipesData
          .cast<Map<String, dynamic>>()
          .map(_parseRecipe)
          .toList();

      return ChatResponse(responseText: responseText, recipes: recipes);
    } on FirebaseFunctionsException catch (e) {
      throw AiChatException(_userFriendlyMessage(e.code), code: e.code);
    } catch (e) {
      throw AiChatException(
        'Something went wrong. Please try again.',
        code: 'unknown',
      );
    }
  }

  Recipe _parseRecipe(Map<String, dynamic> m) {
    return Recipe(
      id: m['id'] as String? ?? '',
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
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

/// Response from the AI chat Cloud Function.
class ChatResponse {
  final String responseText;
  final List<Recipe> recipes;

  const ChatResponse({required this.responseText, required this.recipes});
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
