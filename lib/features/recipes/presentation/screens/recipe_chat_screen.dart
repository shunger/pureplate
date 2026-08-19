import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/voice_input_button.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../../../core/providers/database_providers.dart';
import '../../../meal_plan/data/repositories/ai_chat_repository.dart';
import '../../../meal_plan/data/datasources/preference_summary_builder.dart';
import '../../../meal_plan/data/datasources/meal_plan_mapper.dart';
import '../../../meal_plan/domain/models/family_profile.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../domain/models/recipe.dart';
import '../../../../shared/models/dietary_restriction.dart';
import '../../../../shared/models/product_category.dart';
import '../../data/datasources/recipe_mapper.dart';
import '../providers/recipe_providers.dart';

/// Chat screen for modifying an existing recipe via AI conversation.
///
/// Seeds the conversation with the current recipe's full details so the AI
/// has context. When the AI returns a modified recipe, it updates the existing
/// recipe in the DB (same ID) so the detail screen auto-refreshes.
class RecipeChatScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeChatScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeChatScreen> createState() => _RecipeChatScreenState();
}

class _RecipeChatScreenState extends ConsumerState<RecipeChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];
  bool _isLoading = false;

  // Original recipe fields to preserve across modifications.
  Recipe? _originalRecipe;

  @override
  void initState() {
    super.initState();
    _loadRecipeAndGreet();
  }

  Future<void> _loadRecipeAndGreet() async {
    try {
      final recipe =
          await ref.read(recipeDetailProvider(widget.recipeId).future);
      if (recipe == null || !mounted) return;

      _originalRecipe = recipe;

      setState(() {
        _messages.add(_ChatMessage(
          text: 'I have the recipe for **${recipe.name}** open. '
              'What would you like to change? You can ask me things like:\n\n'
              '"Make it vegan"\n'
              '"Reduce the cooking time"\n'
              '"Double the servings"',
          isUser: false,
        ));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(const _ChatMessage(
          text: 'Failed to load recipe. Please go back and try again.',
          isUser: false,
        ));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Modify Recipe'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return _buildLoadingBubble();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),

            // Input area
            Container(
              padding: EdgeInsets.fromLTRB(
                  16, 8, 16, MediaQuery.of(context).viewPadding.bottom + 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'How should I change this recipe?',
                        filled: true,
                        fillColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  VoiceInputButton(
                    controller: _controller,
                    color: AppColors.coral,
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: const Icon(Icons.send, size: 20),
                    tooltip: 'Send message',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.coral
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight:
                      message.isUser ? const Radius.circular(4) : null,
                  bottomLeft:
                      !message.isUser ? const Radius.circular(4) : null,
                ),
                border: message.isUser
                    ? null
                    : Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 0.5),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            if (message.recipes.isNotEmpty)
              ...message.recipes
                  .where((r) => r.id.isNotEmpty)
                  .map((recipe) => _buildRecipeCard(recipe)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      margin: const EdgeInsets.only(top: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.coral.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => context.push('/recipes/${recipe.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${recipe.totalTimeDisplay} · ${recipe.servings} servings',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.coral,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
          border: Border.all(
              color: Theme.of(context).colorScheme.outline, width: 0.5),
        ),
        child: const SizedBox(
          width: 40,
          height: 20,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.coral,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // Build chat history, injecting the recipe context at the start.
      final historyBuffer = StringBuffer();

      // Prepend full recipe details so the AI knows what we're modifying.
      if (_originalRecipe != null) {
        final r = _originalRecipe!;
        historyBuffer.writeln('[Recipe: ${r.name}]');
        historyBuffer.writeln('Description: ${r.description ?? "none"}');
        historyBuffer.writeln('Cuisine: ${r.cuisine ?? "unspecified"}');
        historyBuffer.writeln('Prep time: ${r.prepTimeMinutes} min');
        historyBuffer.writeln('Cook time: ${r.cookTimeMinutes} min');
        historyBuffer.writeln('Servings: ${r.servings}');
        historyBuffer.writeln('Difficulty: ${r.difficulty ?? "unspecified"}');
        historyBuffer.writeln(
            'Ingredients: ${r.ingredients.map((i) => '${i.quantity ?? ""} ${i.unit ?? ""} ${i.name}'.trim()).join(", ")}');
        historyBuffer.writeln(
            'Instructions: ${r.instructions.map((i) => '${i.stepNumber}. ${i.instruction}').join(" ")}');
        if (r.nutrition != null) {
          historyBuffer.writeln(
              'Nutrition per serving: ${r.nutrition!.calories} cal, '
              '${r.nutrition!.proteinG.round()}g protein, '
              '${r.nutrition!.carbsG.round()}g carbs, '
              '${r.nutrition!.fatG.round()}g fat');
        }
        historyBuffer.writeln('[/Recipe]');
        historyBuffer.writeln();
      }

      // Append conversation history.
      for (final msg in _messages) {
        final role = msg.isUser ? 'User' : 'Chef';
        historyBuffer.writeln('$role: ${msg.text}');
        if (!msg.isUser && msg.recipes.isNotEmpty) {
          for (final recipe in msg.recipes) {
            historyBuffer.writeln('[Recipe: ${recipe.name}]');
            historyBuffer.writeln(
                'Cuisine: ${recipe.cuisine ?? "unspecified"}');
            historyBuffer.writeln(
                'Ingredients: ${recipe.ingredients.map((i) => '${i.quantity ?? ""} ${i.unit ?? ""} ${i.name}'.trim()).join(", ")}');
            historyBuffer.writeln(
                'Instructions: ${recipe.instructions.map((i) => '${i.stepNumber}. ${i.instruction}').join(" ")}');
            historyBuffer.writeln('[/Recipe]');
          }
        }
      }

      // Build preference summary from local data.
      final familyProfileDao = ref.read(familyProfileDaoProvider);
      final pantryDao = ref.read(pantryDaoProvider);
      final summaryBuilder = ref.read(preferenceSummaryBuilderProvider);

      final dbProfile = await familyProfileDao.getProfile();
      final profile = dbProfile != null
          ? _profileFromDb(dbProfile)
          : FamilyProfile(id: 'default');

      final pantryItems = await pantryDao.getAllItems();
      final domainPantryItems = pantryItems
          .map((item) => PantryItem(
                id: item.id,
                name: item.name,
                category: ProductCategory.values.firstWhere(
                  (c) => c.name == item.category,
                  orElse: () => ProductCategory.other,
                ),
                quantity: item.quantity,
                unitType: item.unitType,
                expiresAt: item.expiresAt,
                isStaple: item.isStaple,
                reorderThreshold: item.reorderThreshold.toDouble(),
                createdAt: item.createdAt,
              ))
          .toList();

      // Fetch recent cooked meals.
      final mealPlanDao = ref.read(mealPlanDaoProvider);
      final recentMealRows = await mealPlanDao.getRecentMeals();
      final domainRecentMeals =
          recentMealRows.map(MealPlanMapper.dayFromDb).toList();

      // Build feedback-cuisine pairs.
      final feedbackDao = ref.read(feedbackDaoProvider);
      final recipeDao = ref.read(recipeDaoProvider);
      final allFeedback = await feedbackDao.getAllFeedback();
      final feedbackWithCuisine = <FeedbackCuisine>[];
      for (final fb in allFeedback) {
        final recipe = await recipeDao.getRecipeById(fb.recipeId);
        if (recipe != null && recipe.cuisine.isNotEmpty) {
          feedbackWithCuisine.add(FeedbackCuisine(
            feedback: fb.feedback,
            cuisine: recipe.cuisine,
          ));
        }
      }

      // Collect recipe names already suggested in this session.
      final sessionSuggestions = _messages
          .expand((m) => m.recipes)
          .map((r) => r.name)
          .where((name) => name.isNotEmpty)
          .toList();

      final summary = summaryBuilder.build(
        profile: profile,
        pantryItems: domainPantryItems,
        recentMeals: domainRecentMeals,
        recentSuggestions: sessionSuggestions,
        feedbackWithCuisine: feedbackWithCuisine,
      );

      // Call the AI chat Cloud Function.
      final chatRepo = ref.read(aiChatRepositoryProvider);
      final response = await chatRepo.sendMessage(
        userMessage: text,
        chatHistory: historyBuffer.toString(),
        preferenceSummary: summary,
      );

      // If the AI returned a modified recipe, remap to the original ID
      // and preserve user-specific fields, then upsert to DB.
      if (response.recipes.isNotEmpty && _originalRecipe != null) {
        final original = _originalRecipe!;
        final modifiedRecipe = response.recipes.first.copyWith(
          id: original.id,
          isFavorite: original.isFavorite,
          imageUrl: original.imageUrl,
          createdAt: original.createdAt,
          updatedAt: DateTime.now(),
        );

        await ref
            .read(recipeDaoProvider)
            .insertRecipe(RecipeMapper.toCompanion(modifiedRecipe));

        // Update our reference so subsequent modifications build on the latest.
        _originalRecipe = modifiedRecipe;

        // Replace the first recipe in the response list for display.
        final displayRecipes = [
          modifiedRecipe,
          ...response.recipes.skip(1),
        ];

        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _messages.add(_ChatMessage(
            text: response.responseText,
            isUser: false,
            recipes: displayRecipes,
          ));
        });
      } else {
        // No recipes returned — just a text response.
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _messages.add(_ChatMessage(
            text: response.responseText,
            isUser: false,
            recipes: response.recipes,
          ));
        });
      }
    } on AiChatException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(text: e.message, isUser: false));
      });
    } catch (e, stackTrace) {
      debugPrint('RecipeChatScreen error: $e');
      debugPrint('RecipeChatScreen stack: $stackTrace');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(const _ChatMessage(
          text: 'Something went wrong. Please try again.',
          isUser: false,
        ));
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  FamilyProfile _profileFromDb(db.FamilyProfile row) {
    final parsedRestrictions =
        _parseDietaryRestrictions(row.dietaryRestrictionsJson);
    return FamilyProfile(
      id: row.id,
      adults: row.adults,
      kids: row.kids,
      dietaryRestrictions: parsedRestrictions.enumRestrictions,
      customDietaryRestrictions: parsedRestrictions.customRestrictions,
      skillLevel: SkillLevel.values
              .where((s) => s.name == row.skillLevel)
              .firstOrNull ??
          SkillLevel.comfortable,
      spiceTolerance: SpiceTolerance.values
              .where((s) => s.name == row.spiceTolerance)
              .firstOrNull ??
          SpiceTolerance.medium,
      varietyPreference: VarietyPreference.values
              .where((v) => v.name == row.varietyPreference)
              .firstOrNull ??
          VarietyPreference.mixed,
      dislikedIngredients: _parseJsonList(row.dislikedIngredientsJson),
    );
  }

  ({
    List<DietaryRestriction> enumRestrictions,
    List<String> customRestrictions
  }) _parseDietaryRestrictions(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      final enumRestrictions = <DietaryRestriction>[];
      final customRestrictions = <String>[];
      for (final item in list) {
        final name = item.toString();
        final dr = DietaryRestriction.values
            .where((d) => d.name == name)
            .firstOrNull;
        if (dr != null) {
          enumRestrictions.add(dr);
        } else {
          customRestrictions.add(name);
        }
      }
      return (
        enumRestrictions: enumRestrictions,
        customRestrictions: customRestrictions
      );
    } catch (_) {
      return (
        enumRestrictions: <DietaryRestriction>[],
        customRestrictions: <String>[]
      );
    }
  }

  List<String> _parseJsonList(String json) {
    try {
      return (jsonDecode(json) as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } catch (_) {
      return [];
    }
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final List<Recipe> recipes;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.recipes = const [],
  });
}
