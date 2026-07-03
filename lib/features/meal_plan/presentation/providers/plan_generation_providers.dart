import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/ai_plan_repository.dart';
import '../../data/datasources/preference_summary_builder.dart';
import '../../domain/models/family_profile.dart';
import '../../domain/models/meal_plan.dart';
import '../../../pantry/domain/models/pantry_item.dart';

/// State for the plan generation flow.
class PlanGenerationState {
  final bool isGenerating;
  final String? planId;
  final String? errorMessage;

  const PlanGenerationState({
    this.isGenerating = false,
    this.planId,
    this.errorMessage,
  });

  PlanGenerationState copyWith({
    bool? isGenerating,
    String? planId,
    String? errorMessage,
  }) {
    return PlanGenerationState(
      isGenerating: isGenerating ?? this.isGenerating,
      planId: planId ?? this.planId,
      errorMessage: errorMessage,
    );
  }
}

/// Manages the full plan generation lifecycle:
/// 1. Build preference summary from local data.
/// 2. Call AI backend via AiPlanRepository.
/// 3. Save results to local DB.
/// 4. Trigger auto-shopping-list generation.
class PlanGenerationNotifier extends StateNotifier<PlanGenerationState> {
  final AiPlanRepository _aiRepo;
  final PreferenceSummaryBuilder _summaryBuilder;
  // TODO: Add DAO references for saving plans, recipes, shopping lists.
  // final MealPlanDao _mealPlanDao;
  // final RecipeDao _recipeDao;
  // final AutoListGenerator _autoListGenerator;

  PlanGenerationNotifier({
    required AiPlanRepository aiRepo,
    required PreferenceSummaryBuilder summaryBuilder,
  })  : _aiRepo = aiRepo,
        _summaryBuilder = summaryBuilder,
        super(const PlanGenerationState());

  /// Generate a plan for [numDays] days.
  ///
  /// Returns the plan ID on success, null on failure.
  Future<String?> generate({required int numDays}) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);

    try {
      // Step 1: Build preference summary from local data.
      // TODO: Read real data from DAOs once wired.
      final profile = FamilyProfile(id: 'default');
      final pantryItems = <PantryItem>[];
      final cuisineAffinities = <String, double>{};
      final recentMeals = <MealPlanDay>[];

      final summary = _summaryBuilder.build(
        profile: profile,
        pantryItems: pantryItems,
        cuisineAffinities: cuisineAffinities,
        recentMeals: recentMeals,
      );

      // Step 2: Compute day labels starting from next Monday.
      final startDate = _nextMonday(DateTime.now());
      final dayLabels = List.generate(
        numDays,
        (i) => DateFormat('EEEE').format(startDate.add(Duration(days: i))),
      );

      // Step 3: Call AI backend.
      final result = await _aiRepo.generatePlan(
        numDays: numDays,
        dayLabels: dayLabels,
        preferenceSummary: summary,
      );

      // Step 4: Save to local DB.
      // TODO: Persist plan, recipes, and generate shopping list.
      // await _mealPlanDao.insertPlan(result.plan);
      // for (final recipe in result.recipes) {
      //   await _recipeDao.insertRecipe(recipe);
      // }
      // final shoppingList = _autoListGenerator.generate(
      //   recipes: result.recipes,
      //   pantryItems: pantryItems,
      //   mealPlanId: result.plan.id,
      // );
      // await _shoppingListDao.insertList(shoppingList);

      state = state.copyWith(
        isGenerating: false,
        planId: result.plan.id,
      );

      return result.plan.id;
    } on AiPlanException catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: e.message,
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }

  DateTime _nextMonday(DateTime from) {
    final daysUntilMonday = (DateTime.monday - from.weekday + 7) % 7;
    if (daysUntilMonday == 0) return from;
    return DateTime(from.year, from.month, from.day + daysUntilMonday);
  }
}

/// Provider for plan generation state.
final planGenerationStateProvider =
    StateNotifierProvider<PlanGenerationNotifier, PlanGenerationState>((ref) {
  return PlanGenerationNotifier(
    aiRepo: ref.watch(aiPlanRepositoryProvider),
    summaryBuilder: ref.watch(preferenceSummaryBuilderProvider),
  );
});
