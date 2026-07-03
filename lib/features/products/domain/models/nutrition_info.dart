import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_info.freezed.dart';
part 'nutrition_info.g.dart';

@freezed
abstract class NutritionValue with _$NutritionValue {
  const factory NutritionValue({
    required double amount,
    required String unit,
    double? dailyValuePercent,
  }) = _NutritionValue;

  factory NutritionValue.fromJson(Map<String, dynamic> json) =>
      _$NutritionValueFromJson(json);
}

@freezed
abstract class NutritionInfo with _$NutritionInfo {
  const factory NutritionInfo({
    String? servingSize,
    int? servingsPerContainer,
    int? calories,
    NutritionValue? totalFat,
    NutritionValue? saturatedFat,
    NutritionValue? transFat,
    NutritionValue? cholesterol,
    NutritionValue? sodium,
    NutritionValue? totalCarbohydrates,
    NutritionValue? dietaryFiber,
    NutritionValue? totalSugars,
    NutritionValue? addedSugars,
    NutritionValue? protein,
    NutritionValue? vitaminD,
    NutritionValue? calcium,
    NutritionValue? iron,
    NutritionValue? potassium,
    Map<String, NutritionValue>? additionalNutrients,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}
