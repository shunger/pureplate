import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';
import '../../data/datasources/meal_plan_mapper.dart';
import '../../domain/models/meal_plan.dart';

/// All meal plans mapped to domain models with their days.
final allMealPlansDomainProvider = StreamProvider<List<MealPlan>>((ref) {
  final mealPlanDao = ref.watch(mealPlanDaoProvider);
  return mealPlanDao.watchAllPlans().asyncMap((plans) async {
    final result = <MealPlan>[];
    for (final plan in plans) {
      final days = await mealPlanDao.getDaysForPlan(plan.id);
      result.add(MealPlanMapper.fromDbWithDays(plan, days));
    }
    return result;
  });
});

/// The most recent meal plan with its days.
final latestMealPlanProvider = StreamProvider<MealPlan?>((ref) {
  final mealPlanDao = ref.watch(mealPlanDaoProvider);
  return mealPlanDao.watchAllPlans().asyncMap((plans) async {
    if (plans.isEmpty) return null;
    final latest = plans.first; // Already sorted by createdAt desc
    final days = await mealPlanDao.getDaysForPlan(latest.id);
    return MealPlanMapper.fromDbWithDays(latest, days);
  });
});

/// A single meal plan with its days, by ID.
final mealPlanDetailProvider =
    StreamProvider.family<MealPlan?, String>((ref, planId) {
  final mealPlanDao = ref.watch(mealPlanDaoProvider);
  return mealPlanDao.watchDaysForPlan(planId).asyncMap((days) async {
    final plans = await mealPlanDao.getAllPlans();
    final plan = plans.where((p) => p.id == planId).firstOrNull;
    if (plan == null) return null;
    return MealPlanMapper.fromDbWithDays(plan, days);
  });
});

/// All meal plan days for a given recipe ID (for "Mark Cooked" on detail screen).
final mealPlanDaysForRecipeProvider =
    StreamProvider.family<List<MealPlanDay>, String>((ref, recipeId) {
  final mealPlanDao = ref.watch(mealPlanDaoProvider);
  return mealPlanDao
      .watchDaysForRecipe(recipeId)
      .map((days) => days.map(MealPlanMapper.dayFromDb).toList());
});

/// Days for a specific plan.
final planDaysProvider =
    StreamProvider.family<List<MealPlanDay>, String>((ref, planId) {
  final mealPlanDao = ref.watch(mealPlanDaoProvider);
  return mealPlanDao.watchDaysForPlan(planId).map(
      (days) => days.map(MealPlanMapper.dayFromDb).toList());
});
