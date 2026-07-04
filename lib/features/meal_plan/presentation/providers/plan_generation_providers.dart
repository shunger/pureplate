import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/meal_plan_dao.dart';
import '../../../../core/database/daos/recipe_dao.dart';
import '../../../../core/database/daos/shopping_list_dao.dart';
import '../../../../core/database/daos/family_profile_dao.dart';
import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/providers/database_providers.dart';
import '../../data/repositories/ai_plan_repository.dart';
import '../../data/datasources/preference_summary_builder.dart';
import '../../data/datasources/meal_plan_mapper.dart';
import '../../../recipes/data/datasources/recipe_mapper.dart';
import '../../../../shared/models/product_category.dart';
import '../../domain/models/family_profile.dart';
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
  final MealPlanDao _mealPlanDao;
  final RecipeDao _recipeDao;
  final ShoppingListDao _shoppingListDao;
  final FamilyProfileDao _familyProfileDao;
  final PantryDao _pantryDao;

  PlanGenerationNotifier({
    required AiPlanRepository aiRepo,
    required PreferenceSummaryBuilder summaryBuilder,
    required MealPlanDao mealPlanDao,
    required RecipeDao recipeDao,
    required ShoppingListDao shoppingListDao,
    required FamilyProfileDao familyProfileDao,
    required PantryDao pantryDao,
  })  : _aiRepo = aiRepo,
        _summaryBuilder = summaryBuilder,
        _mealPlanDao = mealPlanDao,
        _recipeDao = recipeDao,
        _shoppingListDao = shoppingListDao,
        _familyProfileDao = familyProfileDao,
        _pantryDao = pantryDao,
        super(const PlanGenerationState());

  /// Generate a plan for [numDays] days.
  ///
  /// Returns the plan ID on success, null on failure.
  Future<String?> generate({required int numDays}) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);

    try {
      // Step 1: Build preference summary from local data.
      final dbProfile = await _familyProfileDao.getProfile();
      final profile = dbProfile != null
          ? FamilyProfile(
              id: dbProfile.id,
              adults: dbProfile.adults,
              kids: dbProfile.kids,
            )
          : FamilyProfile(id: 'default');

      final pantryItems = await _pantryDao.getAllItems();
      final domainPantryItems = pantryItems
          .map((item) => PantryItem(
                id: item.id,
                name: item.name,
                category: _parsePantryCategory(item.category),
                quantity: item.quantity,
                unitType: item.unitType,
                expiresAt: item.expiresAt,
                isStaple: item.isStaple,
                reorderThreshold: item.reorderThreshold.toDouble(),
                createdAt: item.createdAt,
              ))
          .toList();

      final recentMeals = await _mealPlanDao.getRecentMeals();
      final domainRecentMeals = recentMeals
          .map(MealPlanMapper.dayFromDb)
          .toList();

      final summary = _summaryBuilder.build(
        profile: profile,
        pantryItems: domainPantryItems,
        recentMeals: domainRecentMeals,
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

      // Step 4: Persist plan, recipes, and generate shopping list.
      // Save recipes first (referenced by meal plan days).
      final recipeCompanions = result.recipes
          .map(RecipeMapper.toCompanion)
          .toList();
      await _recipeDao.insertRecipes(recipeCompanions);

      // Save the meal plan.
      await _mealPlanDao
          .insertPlan(MealPlanMapper.planToCompanion(result.plan));

      // Save the plan days.
      final dayCompanions = result.plan.days
          .map(MealPlanMapper.dayToCompanion)
          .toList();
      await _mealPlanDao.insertPlanDays(dayCompanions);

      // Generate shopping list from AI suggestions.
      if (result.suggestedShoppingItems.isNotEmpty) {
        final uuid = const Uuid();
        final listId = uuid.v4();
        final now = DateTime.now();

        await _shoppingListDao.insertList(db.ShoppingListsCompanion(
          id: Value(listId),
          name: Value(
              'Meal Plan - ${DateFormat('MMM d').format(result.plan.startDate)}'),
          source: const Value('mealPlan'),
          mealPlanId: Value(result.plan.id),
          isActive: const Value(true),
          createdAt: Value(now),
        ));

        final itemCompanions = result.suggestedShoppingItems
            .map((item) => db.ShoppingListItemsCompanion(
                  id: Value(uuid.v4()),
                  listId: Value(listId),
                  name: Value(item.name),
                  category: Value(item.category ?? 'other'),
                  quantity: Value(
                      double.tryParse(item.quantity ?? '1') ?? 1),
                  unitType: Value(item.unit ?? 'count'),
                  addedAt: Value(now),
                ))
            .toList();
        await _shoppingListDao.insertItems(itemCompanions);
      }

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

  // Simple category string passthrough — PantryItem uses ProductCategory enum
  // but the DB stores a plain string. We just pass it through.
  ProductCategory _parsePantryCategory(String category) {
    return ProductCategory.values.firstWhere(
      (c) => c.name == category,
      orElse: () => ProductCategory.other,
    );
  }
}

/// Provider for plan generation state.
final planGenerationStateProvider =
    StateNotifierProvider<PlanGenerationNotifier, PlanGenerationState>((ref) {
  return PlanGenerationNotifier(
    aiRepo: ref.watch(aiPlanRepositoryProvider),
    summaryBuilder: ref.watch(preferenceSummaryBuilderProvider),
    mealPlanDao: ref.watch(mealPlanDaoProvider),
    recipeDao: ref.watch(recipeDaoProvider),
    shoppingListDao: ref.watch(shoppingListDaoProvider),
    familyProfileDao: ref.watch(familyProfileDaoProvider),
    pantryDao: ref.watch(pantryDaoProvider),
  );
});
