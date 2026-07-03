import 'package:drift/drift.dart';
import 'meal_plans_table.dart';
import 'recipes_table.dart';

/// MealPlanDays — individual day entries within a meal plan.
/// From MealPlannerAI.
class MealPlanDays extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(MealPlans, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get recipeId => text().references(Recipes, #id)();
  TextColumn get recipeName => text().nullable()();
  BoolColumn get isCooked => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // Meal type: 'dinner', 'breakfast', 'lunch' (Phase 2 expansion).
  TextColumn get mealType => text().withDefault(const Constant('dinner'))();

  @override
  Set<Column> get primaryKey => {id};
}
