// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PantryItem _$PantryItemFromJson(Map<String, dynamic> json) => _PantryItem(
  id: json['id'] as String,
  productId: json['productId'] as String?,
  name: json['name'] as String,
  brand: json['brand'] as String?,
  category:
      $enumDecodeNullable(_$ProductCategoryEnumMap, json['category']) ??
      ProductCategory.other,
  quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
  unitType: json['unitType'] as String? ?? 'count',
  location:
      $enumDecodeNullable(_$PantryLocationEnumMap, json['location']) ??
      PantryLocation.pantry,
  purchasedAt: json['purchasedAt'] == null
      ? null
      : DateTime.parse(json['purchasedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  isStaple: json['isStaple'] as bool? ?? false,
  reorderThreshold: (json['reorderThreshold'] as num?)?.toDouble() ?? 0,
  isBulk: json['isBulk'] as bool? ?? false,
  purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  imageUrl: json['imageUrl'] as String?,
  firestorePantryId: json['firestorePantryId'] as String?,
  firestoreItemId: json['firestoreItemId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PantryItemToJson(_PantryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'brand': instance.brand,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'quantity': instance.quantity,
      'unitType': instance.unitType,
      'location': _$PantryLocationEnumMap[instance.location]!,
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isStaple': instance.isStaple,
      'reorderThreshold': instance.reorderThreshold,
      'isBulk': instance.isBulk,
      'purchasePrice': instance.purchasePrice,
      'notes': instance.notes,
      'imageUrl': instance.imageUrl,
      'firestorePantryId': instance.firestorePantryId,
      'firestoreItemId': instance.firestoreItemId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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

const _$PantryLocationEnumMap = {
  PantryLocation.pantry: 'pantry',
  PantryLocation.fridge: 'fridge',
  PantryLocation.freezer: 'freezer',
};
