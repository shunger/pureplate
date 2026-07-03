// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  barcode: json['barcode'] as String?,
  pluCode: json['pluCode'] as String?,
  identifierType:
      $enumDecodeNullable(_$IdentifierTypeEnumMap, json['identifierType']) ??
      IdentifierType.barcode,
  name: json['name'] as String,
  brand: json['brand'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  category:
      $enumDecodeNullable(_$ProductCategoryEnumMap, json['category']) ??
      ProductCategory.other,
  imageUrl: json['imageUrl'] as String?,
  nutritionInfo: json['nutritionInfo'] == null
      ? null
      : NutritionInfo.fromJson(json['nutritionInfo'] as Map<String, dynamic>),
  ingredients: (json['ingredients'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  allergens: (json['allergens'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$AllergenEnumMap, e))
      .toList(),
  isWeightBased: json['isWeightBased'] as bool? ?? false,
  unitType:
      $enumDecodeNullable(_$ProductUnitEnumMap, json['unitType']) ??
      ProductUnit.each,
  averageWeight: (json['averageWeight'] as num?)?.toDouble(),
  seasonality: (json['seasonality'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  storageInstructions: json['storageInstructions'] as String?,
  ripenessIndicators: (json['ripenessIndicators'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isOrganic: json['isOrganic'] as bool? ?? false,
  isGlutenFree: json['isGlutenFree'] as bool? ?? false,
  isVegan: json['isVegan'] as bool? ?? false,
  isCustom: json['isCustom'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  source: json['source'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastLookedUp: json['lastLookedUp'] == null
      ? null
      : DateTime.parse(json['lastLookedUp'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'barcode': instance.barcode,
  'pluCode': instance.pluCode,
  'identifierType': _$IdentifierTypeEnumMap[instance.identifierType]!,
  'name': instance.name,
  'brand': instance.brand,
  'description': instance.description,
  'price': instance.price,
  'currency': instance.currency,
  'category': _$ProductCategoryEnumMap[instance.category]!,
  'imageUrl': instance.imageUrl,
  'nutritionInfo': instance.nutritionInfo,
  'ingredients': instance.ingredients,
  'allergens': instance.allergens?.map((e) => _$AllergenEnumMap[e]!).toList(),
  'isWeightBased': instance.isWeightBased,
  'unitType': _$ProductUnitEnumMap[instance.unitType]!,
  'averageWeight': instance.averageWeight,
  'seasonality': instance.seasonality,
  'storageInstructions': instance.storageInstructions,
  'ripenessIndicators': instance.ripenessIndicators,
  'isOrganic': instance.isOrganic,
  'isGlutenFree': instance.isGlutenFree,
  'isVegan': instance.isVegan,
  'isCustom': instance.isCustom,
  'isFavorite': instance.isFavorite,
  'source': instance.source,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastLookedUp': instance.lastLookedUp?.toIso8601String(),
};

const _$IdentifierTypeEnumMap = {
  IdentifierType.barcode: 'barcode',
  IdentifierType.plu: 'plu',
  IdentifierType.custom: 'custom',
  IdentifierType.visual: 'visual',
};

const _$ProductCategoryEnumMap = {
  ProductCategory.produce: 'produce',
  ProductCategory.dairy: 'dairy',
  ProductCategory.meat: 'meat',
  ProductCategory.bakery: 'bakery',
  ProductCategory.beverages: 'beverages',
  ProductCategory.canned: 'canned',
  ProductCategory.frozen: 'frozen',
  ProductCategory.pantryStaple: 'pantryStaple',
  ProductCategory.snacks: 'snacks',
  ProductCategory.condiments: 'condiments',
  ProductCategory.spices: 'spices',
  ProductCategory.healthBeauty: 'healthBeauty',
  ProductCategory.household: 'household',
  ProductCategory.other: 'other',
};

const _$AllergenEnumMap = {
  Allergen.milk: 'milk',
  Allergen.eggs: 'eggs',
  Allergen.fish: 'fish',
  Allergen.shellfish: 'shellfish',
  Allergen.nuts: 'nuts',
  Allergen.peanuts: 'peanuts',
  Allergen.wheat: 'wheat',
  Allergen.soy: 'soy',
  Allergen.sesame: 'sesame',
};

const _$ProductUnitEnumMap = {
  ProductUnit.each: 'each',
  ProductUnit.pound: 'pound',
  ProductUnit.kilogram: 'kilogram',
  ProductUnit.ounce: 'ounce',
  ProductUnit.gram: 'gram',
  ProductUnit.bunch: 'bunch',
  ProductUnit.bag: 'bag',
  ProductUnit.container: 'container',
  ProductUnit.bottle: 'bottle',
  ProductUnit.can: 'can',
  ProductUnit.box: 'box',
  ProductUnit.package: 'package',
};
