import '../../../meal_plan/data/repositories/ai_chat_repository.dart';
import '../../domain/models/recipe.dart';

/// AI service for the voice cooking assistant.
///
/// Builds cooking-specific context and calls the AI chat API.
/// Keeps conversation history for the session so follow-up questions work.
class CookingAssistantAiService {
  final AiChatRepository _chatRepo;

  final _conversationHistory = <({String role, String text})>[];

  CookingAssistantAiService({
    required AiChatRepository chatRepo,
  }) : _chatRepo = chatRepo;

  /// Ask a free-form question about the recipe being cooked.
  ///
  /// [question] — the user's spoken question.
  /// [recipe] — the full recipe being cooked.
  /// [currentStep] — 0-indexed current step number.
  /// [preferenceSummary] — pre-built preference context.
  Future<String> askQuestion({
    required String question,
    required Recipe recipe,
    required int currentStep,
    required Map<String, dynamic> preferenceSummary,
  }) async {
    // Build recipe context block.
    final recipeContext = StringBuffer();
    recipeContext.writeln('[Recipe: ${recipe.name}]');
    recipeContext.writeln('Description: ${recipe.description ?? "none"}');
    recipeContext.writeln('Cuisine: ${recipe.cuisine ?? "unspecified"}');
    recipeContext.writeln('Prep time: ${recipe.prepTimeMinutes} min');
    recipeContext.writeln('Cook time: ${recipe.cookTimeMinutes} min');
    recipeContext.writeln('Servings: ${recipe.servings}');
    recipeContext.writeln('Difficulty: ${recipe.difficulty ?? "unspecified"}');
    recipeContext.writeln(
      'Ingredients: ${recipe.ingredients.map((i) => '${i.quantity ?? ""} ${i.unit ?? ""} ${i.name}'.trim()).join(", ")}',
    );
    recipeContext.writeln(
      'Instructions: ${recipe.instructions.map((i) => '${i.stepNumber}. ${i.instruction}').join(" ")}',
    );
    if (recipe.nutrition != null) {
      recipeContext.writeln(
        'Nutrition per serving: ${recipe.nutrition!.calories} cal, '
        '${recipe.nutrition!.proteinG.round()}g protein, '
        '${recipe.nutrition!.carbsG.round()}g carbs, '
        '${recipe.nutrition!.fatG.round()}g fat',
      );
    }
    recipeContext.writeln('[/Recipe]');
    recipeContext.writeln();
    recipeContext.writeln(
      'The user is currently on step ${currentStep + 1} of ${recipe.instructions.length}.',
    );
    recipeContext.writeln(
      'Keep responses concise (2-3 sentences max) since they will be read aloud by text-to-speech.',
    );
    recipeContext.writeln();

    // Append conversation history.
    for (final entry in _conversationHistory) {
      recipeContext.writeln('${entry.role}: ${entry.text}');
    }

    // Add current question to history.
    _conversationHistory.add((role: 'User', text: question));

    try {
      final response = await _chatRepo.sendMessage(
        userMessage: question,
        chatHistory: recipeContext.toString(),
        preferenceSummary: preferenceSummary,
      );

      final answer = response.responseText;
      _conversationHistory.add((role: 'Chef', text: answer));

      return answer;
    } on AiChatException {
      rethrow;
    } catch (_) {
      return "Sorry, I couldn't process that question. Try again or say a command like next or repeat.";
    }
  }

  /// Clear conversation history (e.g. when starting over).
  void clearHistory() => _conversationHistory.clear();
}
