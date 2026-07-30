import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/models/meal_plan.dart';

/// Maps between Drift DB rows and domain MealPlan/MealPlanDay models.
class MealPlanMapper {
  MealPlanMapper._();

  /// Convert a DB [db.MealPlan] row + its [db.MealPlanDay] rows to a domain [MealPlan].
  static MealPlan fromDbWithDays(
      db.MealPlan plan, List<db.MealPlanDay> dayRows) {
    return MealPlan(
      id: plan.id,
      createdAt: plan.createdAt,
      startDate: plan.startDate,
      endDate: plan.endDate,
      planType: _parsePlanType(plan.planType),
      days: dayRows.map(dayFromDb).toList(),
    );
  }

  /// Convert a single DB [db.MealPlanDay] row to a domain [MealPlanDay].
  static MealPlanDay dayFromDb(db.MealPlanDay row) {
    return MealPlanDay(
      id: row.id,
      planId: row.planId,
      date: row.date,
      recipeId: row.recipeId,
      recipeName: row.recipeName ?? '',
      isCooked: row.isCooked,
      sortOrder: row.sortOrder,
      mealType: row.mealType,
    );
  }

  /// Convert a domain [MealPlan] to a Drift [db.MealPlansCompanion].
  static db.MealPlansCompanion planToCompanion(MealPlan plan) {
    return db.MealPlansCompanion(
      id: Value(plan.id),
      createdAt: Value(plan.createdAt),
      startDate: Value(plan.startDate),
      endDate: Value(plan.endDate),
      planType: Value(_planTypeToString(plan.planType)),
    );
  }

  /// Convert a domain [MealPlanDay] to a Drift [db.MealPlanDaysCompanion].
  static db.MealPlanDaysCompanion dayToCompanion(MealPlanDay day) {
    return db.MealPlanDaysCompanion(
      id: Value(day.id),
      planId: Value(day.planId),
      date: Value(day.date),
      recipeId: Value(day.recipeId),
      recipeName: Value(day.recipeName),
      isCooked: Value(day.isCooked),
      sortOrder: Value(day.sortOrder),
      mealType: Value(day.mealType),
    );
  }

  // ── Private helpers ───────────────────────────────────────

  static PlanType _parsePlanType(String type) {
    switch (type) {
      case 'chat':
        return PlanType.chat;
      case 'inventory':
        return PlanType.inventory;
      default:
        return PlanType.quick;
    }
  }

  static String _planTypeToString(PlanType type) {
    switch (type) {
      case PlanType.chat:
        return 'chat';
      case PlanType.inventory:
        return 'inventory';
      case PlanType.quick:
        return 'quick';
    }
  }
}
