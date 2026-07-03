import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_info.freezed.dart';
part 'nutrition_info.g.dart';

@freezed
class NutritionInfo with _$NutritionInfo {
  const factory NutritionInfo({
    @Default(0) int calories,
    @Default(0) double proteinG,
    @Default(0) double carbsG,
    @Default(0) double fatG,
    @Default(0) double fiberG,
    @Default(0) double sodiumMg,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}
