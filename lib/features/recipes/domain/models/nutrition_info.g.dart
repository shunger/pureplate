// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NutritionInfo _$NutritionInfoFromJson(Map<String, dynamic> json) =>
    _NutritionInfo(
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinG: (json['proteinG'] as num?)?.toDouble() ?? 0,
      carbsG: (json['carbsG'] as num?)?.toDouble() ?? 0,
      fatG: (json['fatG'] as num?)?.toDouble() ?? 0,
      fiberG: (json['fiberG'] as num?)?.toDouble() ?? 0,
      sodiumMg: (json['sodiumMg'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$NutritionInfoToJson(_NutritionInfo instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
      'fiberG': instance.fiberG,
      'sodiumMg': instance.sodiumMg,
    };
