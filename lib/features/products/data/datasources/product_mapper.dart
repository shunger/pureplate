import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' hide Product;
import '../../../../shared/models/product_category.dart';
import '../../domain/models/allergen.dart';
import '../../domain/models/api_models.dart';
import '../../domain/models/identifier_type.dart';
import '../../domain/models/nutrition_info.dart';
import '../../domain/models/product.dart';
import '../../domain/models/product_unit.dart';
import 'firestore_community_product_datasource.dart';

class ProductMapper {
  static const _uuid = Uuid();

  /// Convert OpenFoodFacts product to domain Product.
  static Product fromOpenFoodFacts(
      OpenFoodFactsProduct offProduct, String barcode) {
    final now = DateTime.now();
    return Product(
      id: _uuid.v4(),
      barcode: barcode,
      identifierType: IdentifierType.barcode,
      name: offProduct.productName ?? 'Unknown Product',
      brand: offProduct.brands,
      category: ProductCategory.fromOpenFoodFacts(offProduct.categories),
      imageUrl: offProduct.imageFrontUrl ?? offProduct.imageUrl,
      nutritionInfo: _mapNutritionInfo(offProduct.nutriments),
      ingredients: _parseIngredients(offProduct.ingredientsText),
      allergens: Allergen.fromOpenFoodFacts(
        [offProduct.allergens, offProduct.traces]
            .whereType<String>()
            .join(', '),
      ),
      source: 'openFoodFacts',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Convert a community-contributed product to domain Product.
  static Product fromCommunityProduct(CommunityProduct cp) {
    final now = DateTime.now();
    return Product(
      id: _uuid.v4(),
      barcode: cp.barcode,
      identifierType: IdentifierType.barcode,
      name: cp.name,
      brand: cp.brand,
      category: ProductCategory.values.firstWhere(
        (e) => e.name == cp.category,
        orElse: () => ProductCategory.other,
      ),
      source: 'community',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Convert UPC Database item to domain Product.
  static Product fromUPCDatabase(UPCDatabaseItem upcItem) {
    final now = DateTime.now();
    return Product(
      id: _uuid.v4(),
      barcode: upcItem.ean,
      identifierType: IdentifierType.barcode,
      name: upcItem.title,
      brand: upcItem.brand,
      description: upcItem.description,
      price: upcItem.lowestRecordedPrice,
      currency: upcItem.currency,
      category: ProductCategory.fromUPCDatabase(upcItem.category),
      imageUrl:
          upcItem.images?.isNotEmpty == true ? upcItem.images!.first : null,
      source: 'upcDatabase',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Supplement an existing OFF-based product with UPC Database data.
  /// Only fills in null/default fields — never overwrites OFF data.
  static Product supplementWithUPC(Product base, UPCDatabaseItem upcItem) {
    return base.copyWith(
      description: base.description ?? upcItem.description,
      price: base.price ?? upcItem.lowestRecordedPrice,
      currency: base.currency ?? upcItem.currency,
      category: base.category == ProductCategory.other
          ? ProductCategory.fromUPCDatabase(upcItem.category)
          : base.category,
      imageUrl: base.imageUrl ??
          (upcItem.images?.isNotEmpty == true ? upcItem.images!.first : null),
      source: '${base.source}+upcDatabase',
    );
  }

  // ─── DB <-> Domain Mappers ───

  /// Convert a Drift Products row to a domain Product.
  static Product fromDbRow(dynamic row) {
    final nutritionJson = row.nutritionInfoJson as String?;
    final ingredientsJson = row.ingredientsJson as String?;
    final allergensJson = row.allergensJson as String?;
    final seasonalityJson = row.seasonalityJson as String?;
    final ripenessJson = row.ripenessIndicatorsJson as String?;

    return Product(
      id: row.id as String,
      barcode: row.barcode as String?,
      pluCode: row.pluCode as String?,
      identifierType: IdentifierType.values.firstWhere(
        (e) => e.name == (row.identifierType as String),
        orElse: () => IdentifierType.barcode,
      ),
      name: row.name as String,
      brand: row.brand as String?,
      description: row.description as String?,
      price: row.price as double?,
      currency: row.currency as String?,
      category: ProductCategory.values.firstWhere(
        (e) => e.name == (row.category as String),
        orElse: () => ProductCategory.other,
      ),
      imageUrl: row.imageUrl as String?,
      nutritionInfo: nutritionJson != null
          ? NutritionInfo.fromJson(
              jsonDecode(nutritionJson) as Map<String, dynamic>)
          : null,
      ingredients: ingredientsJson != null
          ? (jsonDecode(ingredientsJson) as List).cast<String>()
          : null,
      allergens: allergensJson != null
          ? (jsonDecode(allergensJson) as List)
              .map((e) {
                final idx = Allergen.values.indexWhere((a) => a.name == e);
                return idx >= 0 ? Allergen.values[idx] : null;
              })
              .whereType<Allergen>()
              .toList()
          : null,
      isWeightBased: row.isWeightBased as bool,
      unitType: ProductUnit.values.firstWhere(
        (e) => e.name == (row.unitType as String),
        orElse: () => ProductUnit.each,
      ),
      averageWeight: row.averageWeight as double?,
      seasonality: seasonalityJson != null
          ? (jsonDecode(seasonalityJson) as List).cast<int>()
          : null,
      storageInstructions: row.storageInstructions as String?,
      ripenessIndicators: ripenessJson != null
          ? (jsonDecode(ripenessJson) as List).cast<String>()
          : null,
      isOrganic: row.isOrganic as bool,
      isGlutenFree: row.isGlutenFree as bool,
      isVegan: row.isVegan as bool,
      isCustom: row.isCustom as bool,
      isFavorite: row.isFavorite as bool,
      source: row.source as String?,
      createdAt: row.createdAt as DateTime,
      updatedAt: row.updatedAt as DateTime,
      lastLookedUp: row.lastLookedUp as DateTime?,
    );
  }

  /// Convert a domain Product to a Drift ProductsCompanion.
  static ProductsCompanion toCompanion(Product product) {
    return ProductsCompanion(
      id: Value(product.id),
      barcode: Value(product.barcode),
      pluCode: Value(product.pluCode),
      identifierType: Value(product.identifierType.name),
      name: Value(product.name),
      brand: Value(product.brand),
      description: Value(product.description),
      price: Value(product.price),
      currency: Value(product.currency),
      category: Value(product.category.name),
      imageUrl: Value(product.imageUrl),
      nutritionInfoJson: Value(
        product.nutritionInfo != null
            ? jsonEncode(product.nutritionInfo!.toJson())
            : null,
      ),
      ingredientsJson: Value(
        product.ingredients != null
            ? jsonEncode(product.ingredients)
            : null,
      ),
      allergensJson: Value(
        product.allergens != null
            ? jsonEncode(product.allergens!.map((a) => a.name).toList())
            : null,
      ),
      isWeightBased: Value(product.isWeightBased),
      unitType: Value(product.unitType.name),
      averageWeight: Value(product.averageWeight),
      seasonalityJson: Value(
        product.seasonality != null
            ? jsonEncode(product.seasonality)
            : null,
      ),
      storageInstructions: Value(product.storageInstructions),
      ripenessIndicatorsJson: Value(
        product.ripenessIndicators != null
            ? jsonEncode(product.ripenessIndicators)
            : null,
      ),
      isOrganic: Value(product.isOrganic),
      isGlutenFree: Value(product.isGlutenFree),
      isVegan: Value(product.isVegan),
      isCustom: Value(product.isCustom),
      isFavorite: Value(product.isFavorite),
      source: Value(product.source),
      createdAt: Value(product.createdAt),
      updatedAt: Value(product.updatedAt),
      lastLookedUp: Value(product.lastLookedUp),
    );
  }

  // ─── Private helpers ───

  static NutritionInfo? _mapNutritionInfo(
      OpenFoodFactsNutriments? nutriments) {
    if (nutriments == null) return null;

    if (nutriments.energyKcal == null &&
        nutriments.fat == null &&
        nutriments.carbohydrates == null &&
        nutriments.proteins == null) {
      return null;
    }

    return NutritionInfo(
      servingSize: '100g',
      calories: nutriments.energyKcal?.round(),
      totalFat: nutriments.fat != null
          ? NutritionValue(amount: nutriments.fat!, unit: 'g')
          : null,
      saturatedFat: nutriments.saturatedFat != null
          ? NutritionValue(amount: nutriments.saturatedFat!, unit: 'g')
          : null,
      sodium: nutriments.sodium != null
          ? NutritionValue(
              amount: nutriments.sodium! * 1000, unit: 'mg') // g to mg
          : null,
      totalCarbohydrates: nutriments.carbohydrates != null
          ? NutritionValue(amount: nutriments.carbohydrates!, unit: 'g')
          : null,
      dietaryFiber: nutriments.fiber != null
          ? NutritionValue(amount: nutriments.fiber!, unit: 'g')
          : null,
      totalSugars: nutriments.sugars != null
          ? NutritionValue(amount: nutriments.sugars!, unit: 'g')
          : null,
      protein: nutriments.proteins != null
          ? NutritionValue(amount: nutriments.proteins!, unit: 'g')
          : null,
      calcium: nutriments.calcium != null
          ? NutritionValue(amount: nutriments.calcium!, unit: 'mg')
          : null,
      iron: nutriments.iron != null
          ? NutritionValue(amount: nutriments.iron!, unit: 'mg')
          : null,
    );
  }

  static List<String>? _parseIngredients(String? ingredientsText) {
    if (ingredientsText == null || ingredientsText.isEmpty) return null;
    return ingredientsText
        .split(RegExp(r'[,;]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
