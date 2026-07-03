import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/product_category.dart';
import 'allergen.dart';
import 'product_unit.dart';
import 'identifier_type.dart';
import 'nutrition_info.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    String? barcode,
    String? pluCode,
    @Default(IdentifierType.barcode) IdentifierType identifierType,
    required String name,
    String? brand,
    String? description,
    double? price,
    String? currency,
    @Default(ProductCategory.other) ProductCategory category,
    String? imageUrl,
    NutritionInfo? nutritionInfo,
    List<String>? ingredients,
    List<Allergen>? allergens,
    @Default(false) bool isWeightBased,
    @Default(ProductUnit.each) ProductUnit unitType,
    double? averageWeight,
    List<int>? seasonality,
    String? storageInstructions,
    List<String>? ripenessIndicators,
    @Default(false) bool isOrganic,
    @Default(false) bool isGlutenFree,
    @Default(false) bool isVegan,
    @Default(false) bool isCustom,
    @Default(false) bool isFavorite,
    String? source,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastLookedUp,
  }) = _Product;

  String get uniqueIdentifier {
    if (barcode != null && barcode!.isNotEmpty) return barcode!;
    if (pluCode != null && pluCode!.isNotEmpty) return 'PLU-$pluCode';
    return 'custom-$id';
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
