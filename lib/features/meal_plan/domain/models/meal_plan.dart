import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

enum PlanType { quick, chat, inventory }

@freezed
abstract class MealPlanDay with _$MealPlanDay {
  const factory MealPlanDay({
    required String id,
    required String planId,
    required DateTime date,
    required String recipeId,
    required String recipeName,
    @Default(false) bool isCooked,
    @Default(0) int sortOrder,
  }) = _MealPlanDay;

  factory MealPlanDay.fromJson(Map<String, dynamic> json) =>
      _$MealPlanDayFromJson(json);
}

/// A generated meal plan spanning multiple days.
@freezed
abstract class MealPlan with _$MealPlan {
  const MealPlan._();

  const factory MealPlan({
    required String id,
    required DateTime createdAt,
    required DateTime startDate,
    required DateTime endDate,
    @Default(PlanType.quick) PlanType planType,
    @Default([]) List<MealPlanDay> days,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);

  int get totalDays => days.length;
  int get cookedCount => days.where((d) => d.isCooked).length;
  double get completionPercent =>
      totalDays == 0 ? 0 : cookedCount / totalDays;
}
