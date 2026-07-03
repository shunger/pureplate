// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealPlanDay _$MealPlanDayFromJson(Map<String, dynamic> json) => _MealPlanDay(
  id: json['id'] as String,
  planId: json['planId'] as String,
  date: DateTime.parse(json['date'] as String),
  recipeId: json['recipeId'] as String,
  recipeName: json['recipeName'] as String,
  isCooked: json['isCooked'] as bool? ?? false,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MealPlanDayToJson(_MealPlanDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planId': instance.planId,
      'date': instance.date.toIso8601String(),
      'recipeId': instance.recipeId,
      'recipeName': instance.recipeName,
      'isCooked': instance.isCooked,
      'sortOrder': instance.sortOrder,
    };

_MealPlan _$MealPlanFromJson(Map<String, dynamic> json) => _MealPlan(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  planType:
      $enumDecodeNullable(_$PlanTypeEnumMap, json['planType']) ??
      PlanType.quick,
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => MealPlanDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MealPlanToJson(_MealPlan instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'planType': _$PlanTypeEnumMap[instance.planType]!,
  'days': instance.days,
};

const _$PlanTypeEnumMap = {
  PlanType.quick: 'quick',
  PlanType.chat: 'chat',
  PlanType.inventory: 'inventory',
};
