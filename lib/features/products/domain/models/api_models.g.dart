// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpenFoodFactsResponse _$OpenFoodFactsResponseFromJson(
  Map<String, dynamic> json,
) => _OpenFoodFactsResponse(
  code: json['code'] as String,
  status: (json['status'] as num).toInt(),
  statusVerbose: json['status_verbose'] as String,
  product: json['product'] == null
      ? null
      : OpenFoodFactsProduct.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OpenFoodFactsResponseToJson(
  _OpenFoodFactsResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'status': instance.status,
  'status_verbose': instance.statusVerbose,
  'product': instance.product,
};

_OpenFoodFactsProduct _$OpenFoodFactsProductFromJson(
  Map<String, dynamic> json,
) => _OpenFoodFactsProduct(
  id: json['_id'] as String?,
  productName: json['product_name'] as String?,
  brands: json['brands'] as String?,
  categories: json['categories'] as String?,
  ingredientsText: json['ingredients_text'] as String?,
  imageUrl: json['image_url'] as String?,
  imageFrontUrl: json['image_front_url'] as String?,
  imageIngredientsUrl: json['image_ingredients_url'] as String?,
  imageNutritionUrl: json['image_nutrition_url'] as String?,
  nutriments: json['nutriments'] == null
      ? null
      : OpenFoodFactsNutriments.fromJson(
          json['nutriments'] as Map<String, dynamic>,
        ),
  allergens: json['allergens'] as String?,
  traces: json['traces'] as String?,
  countries: json['countries'] as String?,
  manufacturingPlaces: json['manufacturing_places'] as String?,
  stores: json['stores'] as String?,
  packaging: json['packaging'] as String?,
);

Map<String, dynamic> _$OpenFoodFactsProductToJson(
  _OpenFoodFactsProduct instance,
) => <String, dynamic>{
  '_id': instance.id,
  'product_name': instance.productName,
  'brands': instance.brands,
  'categories': instance.categories,
  'ingredients_text': instance.ingredientsText,
  'image_url': instance.imageUrl,
  'image_front_url': instance.imageFrontUrl,
  'image_ingredients_url': instance.imageIngredientsUrl,
  'image_nutrition_url': instance.imageNutritionUrl,
  'nutriments': instance.nutriments,
  'allergens': instance.allergens,
  'traces': instance.traces,
  'countries': instance.countries,
  'manufacturing_places': instance.manufacturingPlaces,
  'stores': instance.stores,
  'packaging': instance.packaging,
};

_OpenFoodFactsNutriments _$OpenFoodFactsNutrimentsFromJson(
  Map<String, dynamic> json,
) => _OpenFoodFactsNutriments(
  energyKj: (json['energy-kj_100g'] as num?)?.toDouble(),
  energyKcal: (json['energy-kcal_100g'] as num?)?.toDouble(),
  fat: (json['fat_100g'] as num?)?.toDouble(),
  saturatedFat: (json['saturated-fat_100g'] as num?)?.toDouble(),
  carbohydrates: (json['carbohydrates_100g'] as num?)?.toDouble(),
  sugars: (json['sugars_100g'] as num?)?.toDouble(),
  fiber: (json['fiber_100g'] as num?)?.toDouble(),
  proteins: (json['proteins_100g'] as num?)?.toDouble(),
  salt: (json['salt_100g'] as num?)?.toDouble(),
  sodium: (json['sodium_100g'] as num?)?.toDouble(),
  vitaminC: (json['vitamin-c_100g'] as num?)?.toDouble(),
  calcium: (json['calcium_100g'] as num?)?.toDouble(),
  iron: (json['iron_100g'] as num?)?.toDouble(),
);

Map<String, dynamic> _$OpenFoodFactsNutrimentsToJson(
  _OpenFoodFactsNutriments instance,
) => <String, dynamic>{
  'energy-kj_100g': instance.energyKj,
  'energy-kcal_100g': instance.energyKcal,
  'fat_100g': instance.fat,
  'saturated-fat_100g': instance.saturatedFat,
  'carbohydrates_100g': instance.carbohydrates,
  'sugars_100g': instance.sugars,
  'fiber_100g': instance.fiber,
  'proteins_100g': instance.proteins,
  'salt_100g': instance.salt,
  'sodium_100g': instance.sodium,
  'vitamin-c_100g': instance.vitaminC,
  'calcium_100g': instance.calcium,
  'iron_100g': instance.iron,
};

_OpenFoodFactsSearchResponse _$OpenFoodFactsSearchResponseFromJson(
  Map<String, dynamic> json,
) => _OpenFoodFactsSearchResponse(
  count: (json['count'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageCount: (json['page_count'] as num).toInt(),
  pageSize: (json['page_size'] as num).toInt(),
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => OpenFoodFactsProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OpenFoodFactsSearchResponseToJson(
  _OpenFoodFactsSearchResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'page': instance.page,
  'page_count': instance.pageCount,
  'page_size': instance.pageSize,
  'products': instance.products,
};

_UPCDatabaseResponse _$UPCDatabaseResponseFromJson(Map<String, dynamic> json) =>
    _UPCDatabaseResponse(
      code: json['code'] as String,
      total: (json['total'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => UPCDatabaseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UPCDatabaseResponseToJson(
  _UPCDatabaseResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'total': instance.total,
  'offset': instance.offset,
  'items': instance.items,
};

_UPCDatabaseItem _$UPCDatabaseItemFromJson(
  Map<String, dynamic> json,
) => _UPCDatabaseItem(
  ean: json['ean'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  upcCode: json['upc_code'] as String?,
  gtin: json['gtin'] as String?,
  elid: json['elid'] as String?,
  brand: json['brand'] as String?,
  model: json['model'] as String?,
  color: json['color'] as String?,
  size: json['size'] as String?,
  dimension: json['dimension'] as String?,
  weight: json['weight'] as String?,
  category: json['category'] as String?,
  currency: json['currency'] as String?,
  lowestRecordedPrice: (json['lowest_recorded_price'] as num?)?.toDouble(),
  highestRecordedPrice: (json['highest_recorded_price'] as num?)?.toDouble(),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UPCDatabaseItemToJson(_UPCDatabaseItem instance) =>
    <String, dynamic>{
      'ean': instance.ean,
      'title': instance.title,
      'description': instance.description,
      'upc_code': instance.upcCode,
      'gtin': instance.gtin,
      'elid': instance.elid,
      'brand': instance.brand,
      'model': instance.model,
      'color': instance.color,
      'size': instance.size,
      'dimension': instance.dimension,
      'weight': instance.weight,
      'category': instance.category,
      'currency': instance.currency,
      'lowest_recorded_price': instance.lowestRecordedPrice,
      'highest_recorded_price': instance.highestRecordedPrice,
      'images': instance.images,
    };
