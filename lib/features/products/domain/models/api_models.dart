import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_models.freezed.dart';
part 'api_models.g.dart';

// --- Open Food Facts ---

@freezed
abstract class OpenFoodFactsResponse with _$OpenFoodFactsResponse {
  const factory OpenFoodFactsResponse({
    required String code,
    required int status,
    @JsonKey(name: 'status_verbose') required String statusVerbose,
    OpenFoodFactsProduct? product,
  }) = _OpenFoodFactsResponse;

  factory OpenFoodFactsResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenFoodFactsResponseFromJson(json);
}

@freezed
abstract class OpenFoodFactsProduct with _$OpenFoodFactsProduct {
  const factory OpenFoodFactsProduct({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'product_name') String? productName,
    String? brands,
    String? categories,
    @JsonKey(name: 'ingredients_text') String? ingredientsText,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'image_front_url') String? imageFrontUrl,
    @JsonKey(name: 'image_ingredients_url') String? imageIngredientsUrl,
    @JsonKey(name: 'image_nutrition_url') String? imageNutritionUrl,
    OpenFoodFactsNutriments? nutriments,
    String? allergens,
    String? traces,
    String? countries,
    @JsonKey(name: 'manufacturing_places') String? manufacturingPlaces,
    String? stores,
    String? packaging,
  }) = _OpenFoodFactsProduct;

  factory OpenFoodFactsProduct.fromJson(Map<String, dynamic> json) =>
      _$OpenFoodFactsProductFromJson(json);
}

@freezed
abstract class OpenFoodFactsNutriments with _$OpenFoodFactsNutriments {
  const factory OpenFoodFactsNutriments({
    @JsonKey(name: 'energy-kj_100g') double? energyKj,
    @JsonKey(name: 'energy-kcal_100g') double? energyKcal,
    @JsonKey(name: 'fat_100g') double? fat,
    @JsonKey(name: 'saturated-fat_100g') double? saturatedFat,
    @JsonKey(name: 'carbohydrates_100g') double? carbohydrates,
    @JsonKey(name: 'sugars_100g') double? sugars,
    @JsonKey(name: 'fiber_100g') double? fiber,
    @JsonKey(name: 'proteins_100g') double? proteins,
    @JsonKey(name: 'salt_100g') double? salt,
    @JsonKey(name: 'sodium_100g') double? sodium,
    @JsonKey(name: 'vitamin-c_100g') double? vitaminC,
    @JsonKey(name: 'calcium_100g') double? calcium,
    @JsonKey(name: 'iron_100g') double? iron,
  }) = _OpenFoodFactsNutriments;

  factory OpenFoodFactsNutriments.fromJson(Map<String, dynamic> json) =>
      _$OpenFoodFactsNutrimentsFromJson(json);
}

@freezed
abstract class OpenFoodFactsSearchResponse with _$OpenFoodFactsSearchResponse {
  const factory OpenFoodFactsSearchResponse({
    required int count,
    required int page,
    @JsonKey(name: 'page_count') required int pageCount,
    @JsonKey(name: 'page_size') required int pageSize,
    @Default([]) List<OpenFoodFactsProduct> products,
  }) = _OpenFoodFactsSearchResponse;

  factory OpenFoodFactsSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenFoodFactsSearchResponseFromJson(json);
}

// --- UPC Database ---

@freezed
abstract class UPCDatabaseResponse with _$UPCDatabaseResponse {
  const factory UPCDatabaseResponse({
    required String code,
    required int total,
    required int offset,
    @Default([]) List<UPCDatabaseItem> items,
  }) = _UPCDatabaseResponse;

  factory UPCDatabaseResponse.fromJson(Map<String, dynamic> json) =>
      _$UPCDatabaseResponseFromJson(json);
}

@freezed
abstract class UPCDatabaseItem with _$UPCDatabaseItem {
  const factory UPCDatabaseItem({
    required String ean,
    required String title,
    String? description,
    @JsonKey(name: 'upc_code') String? upcCode,
    String? gtin,
    String? elid,
    String? brand,
    String? model,
    String? color,
    String? size,
    String? dimension,
    String? weight,
    String? category,
    String? currency,
    @JsonKey(name: 'lowest_recorded_price') double? lowestRecordedPrice,
    @JsonKey(name: 'highest_recorded_price') double? highestRecordedPrice,
    List<String>? images,
  }) = _UPCDatabaseItem;

  factory UPCDatabaseItem.fromJson(Map<String, dynamic> json) =>
      _$UPCDatabaseItemFromJson(json);
}
