// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) =>
    _ShoppingListItem(
      id: json['id'] as String,
      listId: json['listId'] as String,
      productId: json['productId'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      category:
          $enumDecodeNullable(_$ProductCategoryEnumMap, json['category']) ??
          ProductCategory.other,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      unitType: json['unitType'] as String? ?? 'count',
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
      actualPrice: (json['actualPrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      isOnSale: json['isOnSale'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      recipeId: json['recipeId'] as String?,
      recipeName: json['recipeName'] as String?,
      pantryQuantityAvailable:
          (json['pantryQuantityAvailable'] as num?)?.toDouble() ?? 0,
      addedAt: DateTime.parse(json['addedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ShoppingListItemToJson(_ShoppingListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listId': instance.listId,
      'productId': instance.productId,
      'name': instance.name,
      'brand': instance.brand,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'quantity': instance.quantity,
      'unitType': instance.unitType,
      'estimatedPrice': instance.estimatedPrice,
      'actualPrice': instance.actualPrice,
      'salePrice': instance.salePrice,
      'isOnSale': instance.isOnSale,
      'isCompleted': instance.isCompleted,
      'priority': instance.priority,
      'notes': instance.notes,
      'recipeId': instance.recipeId,
      'recipeName': instance.recipeName,
      'pantryQuantityAvailable': instance.pantryQuantityAvailable,
      'addedAt': instance.addedAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'sortOrder': instance.sortOrder,
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

_ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) =>
    _ShoppingList(
      id: json['id'] as String,
      name: json['name'] as String,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      storeId: json['storeId'] as String?,
      storeName: json['storeName'] as String?,
      source:
          $enumDecodeNullable(_$ShoppingListSourceEnumMap, json['source']) ??
          ShoppingListSource.manual,
      mealPlanId: json['mealPlanId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      firestoreId: json['firestoreId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dateShopped: json['dateShopped'] == null
          ? null
          : DateTime.parse(json['dateShopped'] as String),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ShoppingListToJson(_ShoppingList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': instance.items,
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'source': _$ShoppingListSourceEnumMap[instance.source]!,
      'mealPlanId': instance.mealPlanId,
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'isArchived': instance.isArchived,
      'firestoreId': instance.firestoreId,
      'createdAt': instance.createdAt.toIso8601String(),
      'dateShopped': instance.dateShopped?.toIso8601String(),
      'sortOrder': instance.sortOrder,
    };

const _$ShoppingListSourceEnumMap = {
  ShoppingListSource.manual: 'manual',
  ShoppingListSource.mealPlan: 'mealPlan',
};
