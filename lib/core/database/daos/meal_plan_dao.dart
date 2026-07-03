import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/meal_plans_table.dart';
import '../tables/meal_plan_days_table.dart';

part 'meal_plan_dao.g.dart';

@DriftAccessor(tables: [MealPlans, MealPlanDays])
class MealPlanDao extends DatabaseAccessor<AppDatabase>
    with _$MealPlanDaoMixin {
  MealPlanDao(super.db);

  // ── Plan queries ────────────────────────────────────────

  Future<List<MealPlan>> getAllPlans() =>
      (select(mealPlans)..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .get();

  Stream<List<MealPlan>> watchAllPlans() =>
      (select(mealPlans)..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .watch();

  Future<MealPlan?> getLatestPlan() =>
      (select(mealPlans)
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  // ── Day queries ─────────────────────────────────────────

  Future<List<MealPlanDay>> getDaysForPlan(String planId) =>
      (select(mealPlanDays)
            ..where((d) => d.planId.equals(planId))
            ..orderBy([(d) => OrderingTerm.asc(d.date)]))
          .get();

  Stream<List<MealPlanDay>> watchDaysForPlan(String planId) =>
      (select(mealPlanDays)
            ..where((d) => d.planId.equals(planId))
            ..orderBy([(d) => OrderingTerm.asc(d.date)]))
          .watch();

  /// Get today's meal plan day (if any plan covers today).
  Future<MealPlanDay?> getTodaysMeal() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return (select(mealPlanDays)
          ..where((d) =>
              d.date.isBiggerOrEqualValue(todayStart) &
              d.date.isSmallerThanValue(todayEnd)))
        .getSingleOrNull();
  }

  /// Get recent meal plan days for the last N days (for AI context).
  Future<List<MealPlanDay>> getRecentMeals({int withinDays = 14}) {
    final cutoff = DateTime.now().subtract(Duration(days: withinDays));
    return (select(mealPlanDays)
          ..where((d) =>
              d.date.isBiggerOrEqualValue(cutoff) &
              d.isCooked.equals(true))
          ..orderBy([(d) => OrderingTerm.desc(d.date)]))
        .get();
  }

  // ── Mutations ───────────────────────────────────────────

  Future<void> insertPlan(MealPlansCompanion plan) =>
      into(mealPlans).insertOnConflictUpdate(plan);

  Future<void> insertPlanDays(List<MealPlanDaysCompanion> days) =>
      batch((b) => b.insertAllOnConflictUpdate(mealPlanDays, days));

  Future<void> deletePlan(String id) => transaction(() async {
        await (delete(mealPlanDays)..where((d) => d.planId.equals(id))).go();
        await (delete(mealPlans)..where((p) => p.id.equals(id))).go();
      });

  Future<void> markCooked(String dayId, bool isCooked) =>
      (update(mealPlanDays)..where((d) => d.id.equals(dayId)))
          .write(MealPlanDaysCompanion(isCooked: Value(isCooked)));

  Future<void> updateDayRecipe(
          String dayId, String recipeId, String recipeName) =>
      (update(mealPlanDays)..where((d) => d.id.equals(dayId))).write(
          MealPlanDaysCompanion(
              recipeId: Value(recipeId), recipeName: Value(recipeName)));

  /// Swap dates of two plan days (for drag-and-drop reorder).
  Future<void> swapDayDates(String dayId1, String dayId2) =>
      transaction(() async {
        final day1 = await (select(mealPlanDays)
              ..where((d) => d.id.equals(dayId1)))
            .getSingle();
        final day2 = await (select(mealPlanDays)
              ..where((d) => d.id.equals(dayId2)))
            .getSingle();
        await (update(mealPlanDays)..where((d) => d.id.equals(dayId1)))
            .write(MealPlanDaysCompanion(date: Value(day2.date)));
        await (update(mealPlanDays)..where((d) => d.id.equals(dayId2)))
            .write(MealPlanDaysCompanion(date: Value(day1.date)));
      });
}
