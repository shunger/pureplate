// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_dao.dart';

// ignore_for_file: type=lint
mixin _$MealPlanDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealPlansTable get mealPlans => attachedDatabase.mealPlans;
  $RecipesTable get recipes => attachedDatabase.recipes;
  $MealPlanDaysTable get mealPlanDays => attachedDatabase.mealPlanDays;
  MealPlanDaoManager get managers => MealPlanDaoManager(this);
}

class MealPlanDaoManager {
  final _$MealPlanDaoMixin _db;
  MealPlanDaoManager(this._db);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db.attachedDatabase, _db.mealPlans);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db.attachedDatabase, _db.recipes);
  $$MealPlanDaysTableTableManager get mealPlanDays =>
      $$MealPlanDaysTableTableManager(_db.attachedDatabase, _db.mealPlanDays);
}
