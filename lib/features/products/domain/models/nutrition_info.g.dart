// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NutritionValue _$NutritionValueFromJson(Map<String, dynamic> json) =>
    _NutritionValue(
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      dailyValuePercent: (json['dailyValuePercent'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NutritionValueToJson(_NutritionValue instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'unit': instance.unit,
      'dailyValuePercent': instance.dailyValuePercent,
    };

_NutritionInfo _$NutritionInfoFromJson(
  Map<String, dynamic> json,
) => _NutritionInfo(
  servingSize: json['servingSize'] as String?,
  servingsPerContainer: (json['servingsPerContainer'] as num?)?.toInt(),
  calories: (json['calories'] as num?)?.toInt(),
  totalFat: json['totalFat'] == null
      ? null
      : NutritionValue.fromJson(json['totalFat'] as Map<String, dynamic>),
  saturatedFat: json['saturatedFat'] == null
      ? null
      : NutritionValue.fromJson(json['saturatedFat'] as Map<String, dynamic>),
  transFat: json['transFat'] == null
      ? null
      : NutritionValue.fromJson(json['transFat'] as Map<String, dynamic>),
  cholesterol: json['cholesterol'] == null
      ? null
      : NutritionValue.fromJson(json['cholesterol'] as Map<String, dynamic>),
  sodium: json['sodium'] == null
      ? null
      : NutritionValue.fromJson(json['sodium'] as Map<String, dynamic>),
  totalCarbohydrates: json['totalCarbohydrates'] == null
      ? null
      : NutritionValue.fromJson(
          json['totalCarbohydrates'] as Map<String, dynamic>,
        ),
  dietaryFiber: json['dietaryFiber'] == null
      ? null
      : NutritionValue.fromJson(json['dietaryFiber'] as Map<String, dynamic>),
  totalSugars: json['totalSugars'] == null
      ? null
      : NutritionValue.fromJson(json['totalSugars'] as Map<String, dynamic>),
  addedSugars: json['addedSugars'] == null
      ? null
      : NutritionValue.fromJson(json['addedSugars'] as Map<String, dynamic>),
  protein: json['protein'] == null
      ? null
      : NutritionValue.fromJson(json['protein'] as Map<String, dynamic>),
  vitaminD: json['vitaminD'] == null
      ? null
      : NutritionValue.fromJson(json['vitaminD'] as Map<String, dynamic>),
  calcium: json['calcium'] == null
      ? null
      : NutritionValue.fromJson(json['calcium'] as Map<String, dynamic>),
  iron: json['iron'] == null
      ? null
      : NutritionValue.fromJson(json['iron'] as Map<String, dynamic>),
  potassium: json['potassium'] == null
      ? null
      : NutritionValue.fromJson(json['potassium'] as Map<String, dynamic>),
  additionalNutrients: (json['additionalNutrients'] as Map<String, dynamic>?)
      ?.map(
        (k, e) =>
            MapEntry(k, NutritionValue.fromJson(e as Map<String, dynamic>)),
      ),
);

Map<String, dynamic> _$NutritionInfoToJson(_NutritionInfo instance) =>
    <String, dynamic>{
      'servingSize': instance.servingSize,
      'servingsPerContainer': instance.servingsPerContainer,
      'calories': instance.calories,
      'totalFat': instance.totalFat,
      'saturatedFat': instance.saturatedFat,
      'transFat': instance.transFat,
      'cholesterol': instance.cholesterol,
      'sodium': instance.sodium,
      'totalCarbohydrates': instance.totalCarbohydrates,
      'dietaryFiber': instance.dietaryFiber,
      'totalSugars': instance.totalSugars,
      'addedSugars': instance.addedSugars,
      'protein': instance.protein,
      'vitaminD': instance.vitaminD,
      'calcium': instance.calcium,
      'iron': instance.iron,
      'potassium': instance.potassium,
      'additionalNutrients': instance.additionalNutrients,
    };
