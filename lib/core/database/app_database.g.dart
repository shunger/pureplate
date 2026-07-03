// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pluCodeMeta = const VerificationMeta(
    'pluCode',
  );
  @override
  late final GeneratedColumn<String> pluCode = GeneratedColumn<String>(
    'plu_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identifierTypeMeta = const VerificationMeta(
    'identifierType',
  );
  @override
  late final GeneratedColumn<String> identifierType = GeneratedColumn<String>(
    'identifier_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('barcode'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nutritionInfoJsonMeta = const VerificationMeta(
    'nutritionInfoJson',
  );
  @override
  late final GeneratedColumn<String> nutritionInfoJson =
      GeneratedColumn<String>(
        'nutrition_info_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ingredientsJsonMeta = const VerificationMeta(
    'ingredientsJson',
  );
  @override
  late final GeneratedColumn<String> ingredientsJson = GeneratedColumn<String>(
    'ingredients_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergensJsonMeta = const VerificationMeta(
    'allergensJson',
  );
  @override
  late final GeneratedColumn<String> allergensJson = GeneratedColumn<String>(
    'allergens_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWeightBasedMeta = const VerificationMeta(
    'isWeightBased',
  );
  @override
  late final GeneratedColumn<bool> isWeightBased = GeneratedColumn<bool>(
    'is_weight_based',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_weight_based" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('each'),
  );
  static const VerificationMeta _averageWeightMeta = const VerificationMeta(
    'averageWeight',
  );
  @override
  late final GeneratedColumn<double> averageWeight = GeneratedColumn<double>(
    'average_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seasonalityJsonMeta = const VerificationMeta(
    'seasonalityJson',
  );
  @override
  late final GeneratedColumn<String> seasonalityJson = GeneratedColumn<String>(
    'seasonality_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storageInstructionsMeta =
      const VerificationMeta('storageInstructions');
  @override
  late final GeneratedColumn<String> storageInstructions =
      GeneratedColumn<String>(
        'storage_instructions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ripenessIndicatorsJsonMeta =
      const VerificationMeta('ripenessIndicatorsJson');
  @override
  late final GeneratedColumn<String> ripenessIndicatorsJson =
      GeneratedColumn<String>(
        'ripeness_indicators_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isOrganicMeta = const VerificationMeta(
    'isOrganic',
  );
  @override
  late final GeneratedColumn<bool> isOrganic = GeneratedColumn<bool>(
    'is_organic',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_organic" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isGlutenFreeMeta = const VerificationMeta(
    'isGlutenFree',
  );
  @override
  late final GeneratedColumn<bool> isGlutenFree = GeneratedColumn<bool>(
    'is_gluten_free',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_gluten_free" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isVeganMeta = const VerificationMeta(
    'isVegan',
  );
  @override
  late final GeneratedColumn<bool> isVegan = GeneratedColumn<bool>(
    'is_vegan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_vegan" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastLookedUpMeta = const VerificationMeta(
    'lastLookedUp',
  );
  @override
  late final GeneratedColumn<DateTime> lastLookedUp = GeneratedColumn<DateTime>(
    'last_looked_up',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    barcode,
    pluCode,
    identifierType,
    name,
    brand,
    description,
    price,
    currency,
    category,
    imageUrl,
    nutritionInfoJson,
    ingredientsJson,
    allergensJson,
    isWeightBased,
    unitType,
    averageWeight,
    seasonalityJson,
    storageInstructions,
    ripenessIndicatorsJson,
    isOrganic,
    isGlutenFree,
    isVegan,
    isCustom,
    isFavorite,
    source,
    createdAt,
    updatedAt,
    lastLookedUp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('plu_code')) {
      context.handle(
        _pluCodeMeta,
        pluCode.isAcceptableOrUnknown(data['plu_code']!, _pluCodeMeta),
      );
    }
    if (data.containsKey('identifier_type')) {
      context.handle(
        _identifierTypeMeta,
        identifierType.isAcceptableOrUnknown(
          data['identifier_type']!,
          _identifierTypeMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('nutrition_info_json')) {
      context.handle(
        _nutritionInfoJsonMeta,
        nutritionInfoJson.isAcceptableOrUnknown(
          data['nutrition_info_json']!,
          _nutritionInfoJsonMeta,
        ),
      );
    }
    if (data.containsKey('ingredients_json')) {
      context.handle(
        _ingredientsJsonMeta,
        ingredientsJson.isAcceptableOrUnknown(
          data['ingredients_json']!,
          _ingredientsJsonMeta,
        ),
      );
    }
    if (data.containsKey('allergens_json')) {
      context.handle(
        _allergensJsonMeta,
        allergensJson.isAcceptableOrUnknown(
          data['allergens_json']!,
          _allergensJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_weight_based')) {
      context.handle(
        _isWeightBasedMeta,
        isWeightBased.isAcceptableOrUnknown(
          data['is_weight_based']!,
          _isWeightBasedMeta,
        ),
      );
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    }
    if (data.containsKey('average_weight')) {
      context.handle(
        _averageWeightMeta,
        averageWeight.isAcceptableOrUnknown(
          data['average_weight']!,
          _averageWeightMeta,
        ),
      );
    }
    if (data.containsKey('seasonality_json')) {
      context.handle(
        _seasonalityJsonMeta,
        seasonalityJson.isAcceptableOrUnknown(
          data['seasonality_json']!,
          _seasonalityJsonMeta,
        ),
      );
    }
    if (data.containsKey('storage_instructions')) {
      context.handle(
        _storageInstructionsMeta,
        storageInstructions.isAcceptableOrUnknown(
          data['storage_instructions']!,
          _storageInstructionsMeta,
        ),
      );
    }
    if (data.containsKey('ripeness_indicators_json')) {
      context.handle(
        _ripenessIndicatorsJsonMeta,
        ripenessIndicatorsJson.isAcceptableOrUnknown(
          data['ripeness_indicators_json']!,
          _ripenessIndicatorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_organic')) {
      context.handle(
        _isOrganicMeta,
        isOrganic.isAcceptableOrUnknown(data['is_organic']!, _isOrganicMeta),
      );
    }
    if (data.containsKey('is_gluten_free')) {
      context.handle(
        _isGlutenFreeMeta,
        isGlutenFree.isAcceptableOrUnknown(
          data['is_gluten_free']!,
          _isGlutenFreeMeta,
        ),
      );
    }
    if (data.containsKey('is_vegan')) {
      context.handle(
        _isVeganMeta,
        isVegan.isAcceptableOrUnknown(data['is_vegan']!, _isVeganMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_looked_up')) {
      context.handle(
        _lastLookedUpMeta,
        lastLookedUp.isAcceptableOrUnknown(
          data['last_looked_up']!,
          _lastLookedUpMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      pluCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plu_code'],
      ),
      identifierType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier_type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      nutritionInfoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrition_info_json'],
      ),
      ingredientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients_json'],
      ),
      allergensJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergens_json'],
      ),
      isWeightBased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_weight_based'],
      )!,
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      )!,
      averageWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_weight'],
      ),
      seasonalityJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seasonality_json'],
      ),
      storageInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_instructions'],
      ),
      ripenessIndicatorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ripeness_indicators_json'],
      ),
      isOrganic: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_organic'],
      )!,
      isGlutenFree: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_gluten_free'],
      )!,
      isVegan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_vegan'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastLookedUp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_looked_up'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String? barcode;
  final String? pluCode;
  final String identifierType;
  final String name;
  final String? brand;
  final String? description;
  final double? price;
  final String? currency;
  final String category;
  final String? imageUrl;
  final String? nutritionInfoJson;
  final String? ingredientsJson;
  final String? allergensJson;
  final bool isWeightBased;
  final String unitType;
  final double? averageWeight;
  final String? seasonalityJson;
  final String? storageInstructions;
  final String? ripenessIndicatorsJson;
  final bool isOrganic;
  final bool isGlutenFree;
  final bool isVegan;
  final bool isCustom;
  final bool isFavorite;
  final String? source;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLookedUp;
  const Product({
    required this.id,
    this.barcode,
    this.pluCode,
    required this.identifierType,
    required this.name,
    this.brand,
    this.description,
    this.price,
    this.currency,
    required this.category,
    this.imageUrl,
    this.nutritionInfoJson,
    this.ingredientsJson,
    this.allergensJson,
    required this.isWeightBased,
    required this.unitType,
    this.averageWeight,
    this.seasonalityJson,
    this.storageInstructions,
    this.ripenessIndicatorsJson,
    required this.isOrganic,
    required this.isGlutenFree,
    required this.isVegan,
    required this.isCustom,
    required this.isFavorite,
    this.source,
    required this.createdAt,
    required this.updatedAt,
    this.lastLookedUp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || pluCode != null) {
      map['plu_code'] = Variable<String>(pluCode);
    }
    map['identifier_type'] = Variable<String>(identifierType);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || nutritionInfoJson != null) {
      map['nutrition_info_json'] = Variable<String>(nutritionInfoJson);
    }
    if (!nullToAbsent || ingredientsJson != null) {
      map['ingredients_json'] = Variable<String>(ingredientsJson);
    }
    if (!nullToAbsent || allergensJson != null) {
      map['allergens_json'] = Variable<String>(allergensJson);
    }
    map['is_weight_based'] = Variable<bool>(isWeightBased);
    map['unit_type'] = Variable<String>(unitType);
    if (!nullToAbsent || averageWeight != null) {
      map['average_weight'] = Variable<double>(averageWeight);
    }
    if (!nullToAbsent || seasonalityJson != null) {
      map['seasonality_json'] = Variable<String>(seasonalityJson);
    }
    if (!nullToAbsent || storageInstructions != null) {
      map['storage_instructions'] = Variable<String>(storageInstructions);
    }
    if (!nullToAbsent || ripenessIndicatorsJson != null) {
      map['ripeness_indicators_json'] = Variable<String>(
        ripenessIndicatorsJson,
      );
    }
    map['is_organic'] = Variable<bool>(isOrganic);
    map['is_gluten_free'] = Variable<bool>(isGlutenFree);
    map['is_vegan'] = Variable<bool>(isVegan);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastLookedUp != null) {
      map['last_looked_up'] = Variable<DateTime>(lastLookedUp);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      pluCode: pluCode == null && nullToAbsent
          ? const Value.absent()
          : Value(pluCode),
      identifierType: Value(identifierType),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      category: Value(category),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      nutritionInfoJson: nutritionInfoJson == null && nullToAbsent
          ? const Value.absent()
          : Value(nutritionInfoJson),
      ingredientsJson: ingredientsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientsJson),
      allergensJson: allergensJson == null && nullToAbsent
          ? const Value.absent()
          : Value(allergensJson),
      isWeightBased: Value(isWeightBased),
      unitType: Value(unitType),
      averageWeight: averageWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(averageWeight),
      seasonalityJson: seasonalityJson == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonalityJson),
      storageInstructions: storageInstructions == null && nullToAbsent
          ? const Value.absent()
          : Value(storageInstructions),
      ripenessIndicatorsJson: ripenessIndicatorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ripenessIndicatorsJson),
      isOrganic: Value(isOrganic),
      isGlutenFree: Value(isGlutenFree),
      isVegan: Value(isVegan),
      isCustom: Value(isCustom),
      isFavorite: Value(isFavorite),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastLookedUp: lastLookedUp == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLookedUp),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      pluCode: serializer.fromJson<String?>(json['pluCode']),
      identifierType: serializer.fromJson<String>(json['identifierType']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double?>(json['price']),
      currency: serializer.fromJson<String?>(json['currency']),
      category: serializer.fromJson<String>(json['category']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      nutritionInfoJson: serializer.fromJson<String?>(
        json['nutritionInfoJson'],
      ),
      ingredientsJson: serializer.fromJson<String?>(json['ingredientsJson']),
      allergensJson: serializer.fromJson<String?>(json['allergensJson']),
      isWeightBased: serializer.fromJson<bool>(json['isWeightBased']),
      unitType: serializer.fromJson<String>(json['unitType']),
      averageWeight: serializer.fromJson<double?>(json['averageWeight']),
      seasonalityJson: serializer.fromJson<String?>(json['seasonalityJson']),
      storageInstructions: serializer.fromJson<String?>(
        json['storageInstructions'],
      ),
      ripenessIndicatorsJson: serializer.fromJson<String?>(
        json['ripenessIndicatorsJson'],
      ),
      isOrganic: serializer.fromJson<bool>(json['isOrganic']),
      isGlutenFree: serializer.fromJson<bool>(json['isGlutenFree']),
      isVegan: serializer.fromJson<bool>(json['isVegan']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      source: serializer.fromJson<String?>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastLookedUp: serializer.fromJson<DateTime?>(json['lastLookedUp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'barcode': serializer.toJson<String?>(barcode),
      'pluCode': serializer.toJson<String?>(pluCode),
      'identifierType': serializer.toJson<String>(identifierType),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double?>(price),
      'currency': serializer.toJson<String?>(currency),
      'category': serializer.toJson<String>(category),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'nutritionInfoJson': serializer.toJson<String?>(nutritionInfoJson),
      'ingredientsJson': serializer.toJson<String?>(ingredientsJson),
      'allergensJson': serializer.toJson<String?>(allergensJson),
      'isWeightBased': serializer.toJson<bool>(isWeightBased),
      'unitType': serializer.toJson<String>(unitType),
      'averageWeight': serializer.toJson<double?>(averageWeight),
      'seasonalityJson': serializer.toJson<String?>(seasonalityJson),
      'storageInstructions': serializer.toJson<String?>(storageInstructions),
      'ripenessIndicatorsJson': serializer.toJson<String?>(
        ripenessIndicatorsJson,
      ),
      'isOrganic': serializer.toJson<bool>(isOrganic),
      'isGlutenFree': serializer.toJson<bool>(isGlutenFree),
      'isVegan': serializer.toJson<bool>(isVegan),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'source': serializer.toJson<String?>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastLookedUp': serializer.toJson<DateTime?>(lastLookedUp),
    };
  }

  Product copyWith({
    String? id,
    Value<String?> barcode = const Value.absent(),
    Value<String?> pluCode = const Value.absent(),
    String? identifierType,
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<double?> price = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    String? category,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> nutritionInfoJson = const Value.absent(),
    Value<String?> ingredientsJson = const Value.absent(),
    Value<String?> allergensJson = const Value.absent(),
    bool? isWeightBased,
    String? unitType,
    Value<double?> averageWeight = const Value.absent(),
    Value<String?> seasonalityJson = const Value.absent(),
    Value<String?> storageInstructions = const Value.absent(),
    Value<String?> ripenessIndicatorsJson = const Value.absent(),
    bool? isOrganic,
    bool? isGlutenFree,
    bool? isVegan,
    bool? isCustom,
    bool? isFavorite,
    Value<String?> source = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastLookedUp = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    barcode: barcode.present ? barcode.value : this.barcode,
    pluCode: pluCode.present ? pluCode.value : this.pluCode,
    identifierType: identifierType ?? this.identifierType,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    description: description.present ? description.value : this.description,
    price: price.present ? price.value : this.price,
    currency: currency.present ? currency.value : this.currency,
    category: category ?? this.category,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    nutritionInfoJson: nutritionInfoJson.present
        ? nutritionInfoJson.value
        : this.nutritionInfoJson,
    ingredientsJson: ingredientsJson.present
        ? ingredientsJson.value
        : this.ingredientsJson,
    allergensJson: allergensJson.present
        ? allergensJson.value
        : this.allergensJson,
    isWeightBased: isWeightBased ?? this.isWeightBased,
    unitType: unitType ?? this.unitType,
    averageWeight: averageWeight.present
        ? averageWeight.value
        : this.averageWeight,
    seasonalityJson: seasonalityJson.present
        ? seasonalityJson.value
        : this.seasonalityJson,
    storageInstructions: storageInstructions.present
        ? storageInstructions.value
        : this.storageInstructions,
    ripenessIndicatorsJson: ripenessIndicatorsJson.present
        ? ripenessIndicatorsJson.value
        : this.ripenessIndicatorsJson,
    isOrganic: isOrganic ?? this.isOrganic,
    isGlutenFree: isGlutenFree ?? this.isGlutenFree,
    isVegan: isVegan ?? this.isVegan,
    isCustom: isCustom ?? this.isCustom,
    isFavorite: isFavorite ?? this.isFavorite,
    source: source.present ? source.value : this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastLookedUp: lastLookedUp.present ? lastLookedUp.value : this.lastLookedUp,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      pluCode: data.pluCode.present ? data.pluCode.value : this.pluCode,
      identifierType: data.identifierType.present
          ? data.identifierType.value
          : this.identifierType,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      description: data.description.present
          ? data.description.value
          : this.description,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      category: data.category.present ? data.category.value : this.category,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      nutritionInfoJson: data.nutritionInfoJson.present
          ? data.nutritionInfoJson.value
          : this.nutritionInfoJson,
      ingredientsJson: data.ingredientsJson.present
          ? data.ingredientsJson.value
          : this.ingredientsJson,
      allergensJson: data.allergensJson.present
          ? data.allergensJson.value
          : this.allergensJson,
      isWeightBased: data.isWeightBased.present
          ? data.isWeightBased.value
          : this.isWeightBased,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      averageWeight: data.averageWeight.present
          ? data.averageWeight.value
          : this.averageWeight,
      seasonalityJson: data.seasonalityJson.present
          ? data.seasonalityJson.value
          : this.seasonalityJson,
      storageInstructions: data.storageInstructions.present
          ? data.storageInstructions.value
          : this.storageInstructions,
      ripenessIndicatorsJson: data.ripenessIndicatorsJson.present
          ? data.ripenessIndicatorsJson.value
          : this.ripenessIndicatorsJson,
      isOrganic: data.isOrganic.present ? data.isOrganic.value : this.isOrganic,
      isGlutenFree: data.isGlutenFree.present
          ? data.isGlutenFree.value
          : this.isGlutenFree,
      isVegan: data.isVegan.present ? data.isVegan.value : this.isVegan,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastLookedUp: data.lastLookedUp.present
          ? data.lastLookedUp.value
          : this.lastLookedUp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('pluCode: $pluCode, ')
          ..write('identifierType: $identifierType, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('nutritionInfoJson: $nutritionInfoJson, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('allergensJson: $allergensJson, ')
          ..write('isWeightBased: $isWeightBased, ')
          ..write('unitType: $unitType, ')
          ..write('averageWeight: $averageWeight, ')
          ..write('seasonalityJson: $seasonalityJson, ')
          ..write('storageInstructions: $storageInstructions, ')
          ..write('ripenessIndicatorsJson: $ripenessIndicatorsJson, ')
          ..write('isOrganic: $isOrganic, ')
          ..write('isGlutenFree: $isGlutenFree, ')
          ..write('isVegan: $isVegan, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastLookedUp: $lastLookedUp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    barcode,
    pluCode,
    identifierType,
    name,
    brand,
    description,
    price,
    currency,
    category,
    imageUrl,
    nutritionInfoJson,
    ingredientsJson,
    allergensJson,
    isWeightBased,
    unitType,
    averageWeight,
    seasonalityJson,
    storageInstructions,
    ripenessIndicatorsJson,
    isOrganic,
    isGlutenFree,
    isVegan,
    isCustom,
    isFavorite,
    source,
    createdAt,
    updatedAt,
    lastLookedUp,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.pluCode == this.pluCode &&
          other.identifierType == this.identifierType &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.description == this.description &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.category == this.category &&
          other.imageUrl == this.imageUrl &&
          other.nutritionInfoJson == this.nutritionInfoJson &&
          other.ingredientsJson == this.ingredientsJson &&
          other.allergensJson == this.allergensJson &&
          other.isWeightBased == this.isWeightBased &&
          other.unitType == this.unitType &&
          other.averageWeight == this.averageWeight &&
          other.seasonalityJson == this.seasonalityJson &&
          other.storageInstructions == this.storageInstructions &&
          other.ripenessIndicatorsJson == this.ripenessIndicatorsJson &&
          other.isOrganic == this.isOrganic &&
          other.isGlutenFree == this.isGlutenFree &&
          other.isVegan == this.isVegan &&
          other.isCustom == this.isCustom &&
          other.isFavorite == this.isFavorite &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastLookedUp == this.lastLookedUp);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String?> barcode;
  final Value<String?> pluCode;
  final Value<String> identifierType;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> description;
  final Value<double?> price;
  final Value<String?> currency;
  final Value<String> category;
  final Value<String?> imageUrl;
  final Value<String?> nutritionInfoJson;
  final Value<String?> ingredientsJson;
  final Value<String?> allergensJson;
  final Value<bool> isWeightBased;
  final Value<String> unitType;
  final Value<double?> averageWeight;
  final Value<String?> seasonalityJson;
  final Value<String?> storageInstructions;
  final Value<String?> ripenessIndicatorsJson;
  final Value<bool> isOrganic;
  final Value<bool> isGlutenFree;
  final Value<bool> isVegan;
  final Value<bool> isCustom;
  final Value<bool> isFavorite;
  final Value<String?> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastLookedUp;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.pluCode = const Value.absent(),
    this.identifierType = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.nutritionInfoJson = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.allergensJson = const Value.absent(),
    this.isWeightBased = const Value.absent(),
    this.unitType = const Value.absent(),
    this.averageWeight = const Value.absent(),
    this.seasonalityJson = const Value.absent(),
    this.storageInstructions = const Value.absent(),
    this.ripenessIndicatorsJson = const Value.absent(),
    this.isOrganic = const Value.absent(),
    this.isGlutenFree = const Value.absent(),
    this.isVegan = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastLookedUp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    this.barcode = const Value.absent(),
    this.pluCode = const Value.absent(),
    this.identifierType = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.nutritionInfoJson = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.allergensJson = const Value.absent(),
    this.isWeightBased = const Value.absent(),
    this.unitType = const Value.absent(),
    this.averageWeight = const Value.absent(),
    this.seasonalityJson = const Value.absent(),
    this.storageInstructions = const Value.absent(),
    this.ripenessIndicatorsJson = const Value.absent(),
    this.isOrganic = const Value.absent(),
    this.isGlutenFree = const Value.absent(),
    this.isVegan = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastLookedUp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? barcode,
    Expression<String>? pluCode,
    Expression<String>? identifierType,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? description,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? category,
    Expression<String>? imageUrl,
    Expression<String>? nutritionInfoJson,
    Expression<String>? ingredientsJson,
    Expression<String>? allergensJson,
    Expression<bool>? isWeightBased,
    Expression<String>? unitType,
    Expression<double>? averageWeight,
    Expression<String>? seasonalityJson,
    Expression<String>? storageInstructions,
    Expression<String>? ripenessIndicatorsJson,
    Expression<bool>? isOrganic,
    Expression<bool>? isGlutenFree,
    Expression<bool>? isVegan,
    Expression<bool>? isCustom,
    Expression<bool>? isFavorite,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastLookedUp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (pluCode != null) 'plu_code': pluCode,
      if (identifierType != null) 'identifier_type': identifierType,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (category != null) 'category': category,
      if (imageUrl != null) 'image_url': imageUrl,
      if (nutritionInfoJson != null) 'nutrition_info_json': nutritionInfoJson,
      if (ingredientsJson != null) 'ingredients_json': ingredientsJson,
      if (allergensJson != null) 'allergens_json': allergensJson,
      if (isWeightBased != null) 'is_weight_based': isWeightBased,
      if (unitType != null) 'unit_type': unitType,
      if (averageWeight != null) 'average_weight': averageWeight,
      if (seasonalityJson != null) 'seasonality_json': seasonalityJson,
      if (storageInstructions != null)
        'storage_instructions': storageInstructions,
      if (ripenessIndicatorsJson != null)
        'ripeness_indicators_json': ripenessIndicatorsJson,
      if (isOrganic != null) 'is_organic': isOrganic,
      if (isGlutenFree != null) 'is_gluten_free': isGlutenFree,
      if (isVegan != null) 'is_vegan': isVegan,
      if (isCustom != null) 'is_custom': isCustom,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastLookedUp != null) 'last_looked_up': lastLookedUp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String?>? barcode,
    Value<String?>? pluCode,
    Value<String>? identifierType,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? description,
    Value<double?>? price,
    Value<String?>? currency,
    Value<String>? category,
    Value<String?>? imageUrl,
    Value<String?>? nutritionInfoJson,
    Value<String?>? ingredientsJson,
    Value<String?>? allergensJson,
    Value<bool>? isWeightBased,
    Value<String>? unitType,
    Value<double?>? averageWeight,
    Value<String?>? seasonalityJson,
    Value<String?>? storageInstructions,
    Value<String?>? ripenessIndicatorsJson,
    Value<bool>? isOrganic,
    Value<bool>? isGlutenFree,
    Value<bool>? isVegan,
    Value<bool>? isCustom,
    Value<bool>? isFavorite,
    Value<String?>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastLookedUp,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      pluCode: pluCode ?? this.pluCode,
      identifierType: identifierType ?? this.identifierType,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      nutritionInfoJson: nutritionInfoJson ?? this.nutritionInfoJson,
      ingredientsJson: ingredientsJson ?? this.ingredientsJson,
      allergensJson: allergensJson ?? this.allergensJson,
      isWeightBased: isWeightBased ?? this.isWeightBased,
      unitType: unitType ?? this.unitType,
      averageWeight: averageWeight ?? this.averageWeight,
      seasonalityJson: seasonalityJson ?? this.seasonalityJson,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      ripenessIndicatorsJson:
          ripenessIndicatorsJson ?? this.ripenessIndicatorsJson,
      isOrganic: isOrganic ?? this.isOrganic,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isVegan: isVegan ?? this.isVegan,
      isCustom: isCustom ?? this.isCustom,
      isFavorite: isFavorite ?? this.isFavorite,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLookedUp: lastLookedUp ?? this.lastLookedUp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (pluCode.present) {
      map['plu_code'] = Variable<String>(pluCode.value);
    }
    if (identifierType.present) {
      map['identifier_type'] = Variable<String>(identifierType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (nutritionInfoJson.present) {
      map['nutrition_info_json'] = Variable<String>(nutritionInfoJson.value);
    }
    if (ingredientsJson.present) {
      map['ingredients_json'] = Variable<String>(ingredientsJson.value);
    }
    if (allergensJson.present) {
      map['allergens_json'] = Variable<String>(allergensJson.value);
    }
    if (isWeightBased.present) {
      map['is_weight_based'] = Variable<bool>(isWeightBased.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (averageWeight.present) {
      map['average_weight'] = Variable<double>(averageWeight.value);
    }
    if (seasonalityJson.present) {
      map['seasonality_json'] = Variable<String>(seasonalityJson.value);
    }
    if (storageInstructions.present) {
      map['storage_instructions'] = Variable<String>(storageInstructions.value);
    }
    if (ripenessIndicatorsJson.present) {
      map['ripeness_indicators_json'] = Variable<String>(
        ripenessIndicatorsJson.value,
      );
    }
    if (isOrganic.present) {
      map['is_organic'] = Variable<bool>(isOrganic.value);
    }
    if (isGlutenFree.present) {
      map['is_gluten_free'] = Variable<bool>(isGlutenFree.value);
    }
    if (isVegan.present) {
      map['is_vegan'] = Variable<bool>(isVegan.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastLookedUp.present) {
      map['last_looked_up'] = Variable<DateTime>(lastLookedUp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('pluCode: $pluCode, ')
          ..write('identifierType: $identifierType, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('nutritionInfoJson: $nutritionInfoJson, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('allergensJson: $allergensJson, ')
          ..write('isWeightBased: $isWeightBased, ')
          ..write('unitType: $unitType, ')
          ..write('averageWeight: $averageWeight, ')
          ..write('seasonalityJson: $seasonalityJson, ')
          ..write('storageInstructions: $storageInstructions, ')
          ..write('ripenessIndicatorsJson: $ripenessIndicatorsJson, ')
          ..write('isOrganic: $isOrganic, ')
          ..write('isGlutenFree: $isGlutenFree, ')
          ..write('isVegan: $isVegan, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastLookedUp: $lastLookedUp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProduceTemplatesTable extends ProduceTemplates
    with TableInfo<$ProduceTemplatesTable, ProduceTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProduceTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pluCodeMeta = const VerificationMeta(
    'pluCode',
  );
  @override
  late final GeneratedColumn<String> pluCode = GeneratedColumn<String>(
    'plu_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('produce'),
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('each'),
  );
  static const VerificationMeta _averageWeightMeta = const VerificationMeta(
    'averageWeight',
  );
  @override
  late final GeneratedColumn<double> averageWeight = GeneratedColumn<double>(
    'average_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgPriceLowMeta = const VerificationMeta(
    'avgPriceLow',
  );
  @override
  late final GeneratedColumn<double> avgPriceLow = GeneratedColumn<double>(
    'avg_price_low',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgPriceHighMeta = const VerificationMeta(
    'avgPriceHigh',
  );
  @override
  late final GeneratedColumn<double> avgPriceHigh = GeneratedColumn<double>(
    'avg_price_high',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seasonalityJsonMeta = const VerificationMeta(
    'seasonalityJson',
  );
  @override
  late final GeneratedColumn<String> seasonalityJson = GeneratedColumn<String>(
    'seasonality_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ripenessIndicatorsJsonMeta =
      const VerificationMeta('ripenessIndicatorsJson');
  @override
  late final GeneratedColumn<String> ripenessIndicatorsJson =
      GeneratedColumn<String>(
        'ripeness_indicators_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _storageInstructionsMeta =
      const VerificationMeta('storageInstructions');
  @override
  late final GeneratedColumn<String> storageInstructions =
      GeneratedColumn<String>(
        'storage_instructions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isOrganicMeta = const VerificationMeta(
    'isOrganic',
  );
  @override
  late final GeneratedColumn<bool> isOrganic = GeneratedColumn<bool>(
    'is_organic',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_organic" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    pluCode,
    category,
    unitType,
    averageWeight,
    avgPriceLow,
    avgPriceHigh,
    seasonalityJson,
    ripenessIndicatorsJson,
    storageInstructions,
    isOrganic,
    isBuiltIn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produce_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProduceTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('plu_code')) {
      context.handle(
        _pluCodeMeta,
        pluCode.isAcceptableOrUnknown(data['plu_code']!, _pluCodeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    }
    if (data.containsKey('average_weight')) {
      context.handle(
        _averageWeightMeta,
        averageWeight.isAcceptableOrUnknown(
          data['average_weight']!,
          _averageWeightMeta,
        ),
      );
    }
    if (data.containsKey('avg_price_low')) {
      context.handle(
        _avgPriceLowMeta,
        avgPriceLow.isAcceptableOrUnknown(
          data['avg_price_low']!,
          _avgPriceLowMeta,
        ),
      );
    }
    if (data.containsKey('avg_price_high')) {
      context.handle(
        _avgPriceHighMeta,
        avgPriceHigh.isAcceptableOrUnknown(
          data['avg_price_high']!,
          _avgPriceHighMeta,
        ),
      );
    }
    if (data.containsKey('seasonality_json')) {
      context.handle(
        _seasonalityJsonMeta,
        seasonalityJson.isAcceptableOrUnknown(
          data['seasonality_json']!,
          _seasonalityJsonMeta,
        ),
      );
    }
    if (data.containsKey('ripeness_indicators_json')) {
      context.handle(
        _ripenessIndicatorsJsonMeta,
        ripenessIndicatorsJson.isAcceptableOrUnknown(
          data['ripeness_indicators_json']!,
          _ripenessIndicatorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('storage_instructions')) {
      context.handle(
        _storageInstructionsMeta,
        storageInstructions.isAcceptableOrUnknown(
          data['storage_instructions']!,
          _storageInstructionsMeta,
        ),
      );
    }
    if (data.containsKey('is_organic')) {
      context.handle(
        _isOrganicMeta,
        isOrganic.isAcceptableOrUnknown(data['is_organic']!, _isOrganicMeta),
      );
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProduceTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProduceTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pluCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plu_code'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      )!,
      averageWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_weight'],
      ),
      avgPriceLow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_price_low'],
      ),
      avgPriceHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_price_high'],
      ),
      seasonalityJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seasonality_json'],
      ),
      ripenessIndicatorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ripeness_indicators_json'],
      ),
      storageInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_instructions'],
      ),
      isOrganic: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_organic'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
    );
  }

  @override
  $ProduceTemplatesTable createAlias(String alias) {
    return $ProduceTemplatesTable(attachedDatabase, alias);
  }
}

class ProduceTemplate extends DataClass implements Insertable<ProduceTemplate> {
  final String id;
  final String name;
  final String? pluCode;
  final String category;
  final String unitType;
  final double? averageWeight;
  final double? avgPriceLow;
  final double? avgPriceHigh;
  final String? seasonalityJson;
  final String? ripenessIndicatorsJson;
  final String? storageInstructions;
  final bool isOrganic;
  final bool isBuiltIn;
  const ProduceTemplate({
    required this.id,
    required this.name,
    this.pluCode,
    required this.category,
    required this.unitType,
    this.averageWeight,
    this.avgPriceLow,
    this.avgPriceHigh,
    this.seasonalityJson,
    this.ripenessIndicatorsJson,
    this.storageInstructions,
    required this.isOrganic,
    required this.isBuiltIn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || pluCode != null) {
      map['plu_code'] = Variable<String>(pluCode);
    }
    map['category'] = Variable<String>(category);
    map['unit_type'] = Variable<String>(unitType);
    if (!nullToAbsent || averageWeight != null) {
      map['average_weight'] = Variable<double>(averageWeight);
    }
    if (!nullToAbsent || avgPriceLow != null) {
      map['avg_price_low'] = Variable<double>(avgPriceLow);
    }
    if (!nullToAbsent || avgPriceHigh != null) {
      map['avg_price_high'] = Variable<double>(avgPriceHigh);
    }
    if (!nullToAbsent || seasonalityJson != null) {
      map['seasonality_json'] = Variable<String>(seasonalityJson);
    }
    if (!nullToAbsent || ripenessIndicatorsJson != null) {
      map['ripeness_indicators_json'] = Variable<String>(
        ripenessIndicatorsJson,
      );
    }
    if (!nullToAbsent || storageInstructions != null) {
      map['storage_instructions'] = Variable<String>(storageInstructions);
    }
    map['is_organic'] = Variable<bool>(isOrganic);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    return map;
  }

  ProduceTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ProduceTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      pluCode: pluCode == null && nullToAbsent
          ? const Value.absent()
          : Value(pluCode),
      category: Value(category),
      unitType: Value(unitType),
      averageWeight: averageWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(averageWeight),
      avgPriceLow: avgPriceLow == null && nullToAbsent
          ? const Value.absent()
          : Value(avgPriceLow),
      avgPriceHigh: avgPriceHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(avgPriceHigh),
      seasonalityJson: seasonalityJson == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonalityJson),
      ripenessIndicatorsJson: ripenessIndicatorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ripenessIndicatorsJson),
      storageInstructions: storageInstructions == null && nullToAbsent
          ? const Value.absent()
          : Value(storageInstructions),
      isOrganic: Value(isOrganic),
      isBuiltIn: Value(isBuiltIn),
    );
  }

  factory ProduceTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProduceTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pluCode: serializer.fromJson<String?>(json['pluCode']),
      category: serializer.fromJson<String>(json['category']),
      unitType: serializer.fromJson<String>(json['unitType']),
      averageWeight: serializer.fromJson<double?>(json['averageWeight']),
      avgPriceLow: serializer.fromJson<double?>(json['avgPriceLow']),
      avgPriceHigh: serializer.fromJson<double?>(json['avgPriceHigh']),
      seasonalityJson: serializer.fromJson<String?>(json['seasonalityJson']),
      ripenessIndicatorsJson: serializer.fromJson<String?>(
        json['ripenessIndicatorsJson'],
      ),
      storageInstructions: serializer.fromJson<String?>(
        json['storageInstructions'],
      ),
      isOrganic: serializer.fromJson<bool>(json['isOrganic']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pluCode': serializer.toJson<String?>(pluCode),
      'category': serializer.toJson<String>(category),
      'unitType': serializer.toJson<String>(unitType),
      'averageWeight': serializer.toJson<double?>(averageWeight),
      'avgPriceLow': serializer.toJson<double?>(avgPriceLow),
      'avgPriceHigh': serializer.toJson<double?>(avgPriceHigh),
      'seasonalityJson': serializer.toJson<String?>(seasonalityJson),
      'ripenessIndicatorsJson': serializer.toJson<String?>(
        ripenessIndicatorsJson,
      ),
      'storageInstructions': serializer.toJson<String?>(storageInstructions),
      'isOrganic': serializer.toJson<bool>(isOrganic),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
    };
  }

  ProduceTemplate copyWith({
    String? id,
    String? name,
    Value<String?> pluCode = const Value.absent(),
    String? category,
    String? unitType,
    Value<double?> averageWeight = const Value.absent(),
    Value<double?> avgPriceLow = const Value.absent(),
    Value<double?> avgPriceHigh = const Value.absent(),
    Value<String?> seasonalityJson = const Value.absent(),
    Value<String?> ripenessIndicatorsJson = const Value.absent(),
    Value<String?> storageInstructions = const Value.absent(),
    bool? isOrganic,
    bool? isBuiltIn,
  }) => ProduceTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    pluCode: pluCode.present ? pluCode.value : this.pluCode,
    category: category ?? this.category,
    unitType: unitType ?? this.unitType,
    averageWeight: averageWeight.present
        ? averageWeight.value
        : this.averageWeight,
    avgPriceLow: avgPriceLow.present ? avgPriceLow.value : this.avgPriceLow,
    avgPriceHigh: avgPriceHigh.present ? avgPriceHigh.value : this.avgPriceHigh,
    seasonalityJson: seasonalityJson.present
        ? seasonalityJson.value
        : this.seasonalityJson,
    ripenessIndicatorsJson: ripenessIndicatorsJson.present
        ? ripenessIndicatorsJson.value
        : this.ripenessIndicatorsJson,
    storageInstructions: storageInstructions.present
        ? storageInstructions.value
        : this.storageInstructions,
    isOrganic: isOrganic ?? this.isOrganic,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
  );
  ProduceTemplate copyWithCompanion(ProduceTemplatesCompanion data) {
    return ProduceTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pluCode: data.pluCode.present ? data.pluCode.value : this.pluCode,
      category: data.category.present ? data.category.value : this.category,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      averageWeight: data.averageWeight.present
          ? data.averageWeight.value
          : this.averageWeight,
      avgPriceLow: data.avgPriceLow.present
          ? data.avgPriceLow.value
          : this.avgPriceLow,
      avgPriceHigh: data.avgPriceHigh.present
          ? data.avgPriceHigh.value
          : this.avgPriceHigh,
      seasonalityJson: data.seasonalityJson.present
          ? data.seasonalityJson.value
          : this.seasonalityJson,
      ripenessIndicatorsJson: data.ripenessIndicatorsJson.present
          ? data.ripenessIndicatorsJson.value
          : this.ripenessIndicatorsJson,
      storageInstructions: data.storageInstructions.present
          ? data.storageInstructions.value
          : this.storageInstructions,
      isOrganic: data.isOrganic.present ? data.isOrganic.value : this.isOrganic,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProduceTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pluCode: $pluCode, ')
          ..write('category: $category, ')
          ..write('unitType: $unitType, ')
          ..write('averageWeight: $averageWeight, ')
          ..write('avgPriceLow: $avgPriceLow, ')
          ..write('avgPriceHigh: $avgPriceHigh, ')
          ..write('seasonalityJson: $seasonalityJson, ')
          ..write('ripenessIndicatorsJson: $ripenessIndicatorsJson, ')
          ..write('storageInstructions: $storageInstructions, ')
          ..write('isOrganic: $isOrganic, ')
          ..write('isBuiltIn: $isBuiltIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    pluCode,
    category,
    unitType,
    averageWeight,
    avgPriceLow,
    avgPriceHigh,
    seasonalityJson,
    ripenessIndicatorsJson,
    storageInstructions,
    isOrganic,
    isBuiltIn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProduceTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.pluCode == this.pluCode &&
          other.category == this.category &&
          other.unitType == this.unitType &&
          other.averageWeight == this.averageWeight &&
          other.avgPriceLow == this.avgPriceLow &&
          other.avgPriceHigh == this.avgPriceHigh &&
          other.seasonalityJson == this.seasonalityJson &&
          other.ripenessIndicatorsJson == this.ripenessIndicatorsJson &&
          other.storageInstructions == this.storageInstructions &&
          other.isOrganic == this.isOrganic &&
          other.isBuiltIn == this.isBuiltIn);
}

class ProduceTemplatesCompanion extends UpdateCompanion<ProduceTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> pluCode;
  final Value<String> category;
  final Value<String> unitType;
  final Value<double?> averageWeight;
  final Value<double?> avgPriceLow;
  final Value<double?> avgPriceHigh;
  final Value<String?> seasonalityJson;
  final Value<String?> ripenessIndicatorsJson;
  final Value<String?> storageInstructions;
  final Value<bool> isOrganic;
  final Value<bool> isBuiltIn;
  final Value<int> rowid;
  const ProduceTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pluCode = const Value.absent(),
    this.category = const Value.absent(),
    this.unitType = const Value.absent(),
    this.averageWeight = const Value.absent(),
    this.avgPriceLow = const Value.absent(),
    this.avgPriceHigh = const Value.absent(),
    this.seasonalityJson = const Value.absent(),
    this.ripenessIndicatorsJson = const Value.absent(),
    this.storageInstructions = const Value.absent(),
    this.isOrganic = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProduceTemplatesCompanion.insert({
    required String id,
    required String name,
    this.pluCode = const Value.absent(),
    this.category = const Value.absent(),
    this.unitType = const Value.absent(),
    this.averageWeight = const Value.absent(),
    this.avgPriceLow = const Value.absent(),
    this.avgPriceHigh = const Value.absent(),
    this.seasonalityJson = const Value.absent(),
    this.ripenessIndicatorsJson = const Value.absent(),
    this.storageInstructions = const Value.absent(),
    this.isOrganic = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<ProduceTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pluCode,
    Expression<String>? category,
    Expression<String>? unitType,
    Expression<double>? averageWeight,
    Expression<double>? avgPriceLow,
    Expression<double>? avgPriceHigh,
    Expression<String>? seasonalityJson,
    Expression<String>? ripenessIndicatorsJson,
    Expression<String>? storageInstructions,
    Expression<bool>? isOrganic,
    Expression<bool>? isBuiltIn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pluCode != null) 'plu_code': pluCode,
      if (category != null) 'category': category,
      if (unitType != null) 'unit_type': unitType,
      if (averageWeight != null) 'average_weight': averageWeight,
      if (avgPriceLow != null) 'avg_price_low': avgPriceLow,
      if (avgPriceHigh != null) 'avg_price_high': avgPriceHigh,
      if (seasonalityJson != null) 'seasonality_json': seasonalityJson,
      if (ripenessIndicatorsJson != null)
        'ripeness_indicators_json': ripenessIndicatorsJson,
      if (storageInstructions != null)
        'storage_instructions': storageInstructions,
      if (isOrganic != null) 'is_organic': isOrganic,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProduceTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? pluCode,
    Value<String>? category,
    Value<String>? unitType,
    Value<double?>? averageWeight,
    Value<double?>? avgPriceLow,
    Value<double?>? avgPriceHigh,
    Value<String?>? seasonalityJson,
    Value<String?>? ripenessIndicatorsJson,
    Value<String?>? storageInstructions,
    Value<bool>? isOrganic,
    Value<bool>? isBuiltIn,
    Value<int>? rowid,
  }) {
    return ProduceTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pluCode: pluCode ?? this.pluCode,
      category: category ?? this.category,
      unitType: unitType ?? this.unitType,
      averageWeight: averageWeight ?? this.averageWeight,
      avgPriceLow: avgPriceLow ?? this.avgPriceLow,
      avgPriceHigh: avgPriceHigh ?? this.avgPriceHigh,
      seasonalityJson: seasonalityJson ?? this.seasonalityJson,
      ripenessIndicatorsJson:
          ripenessIndicatorsJson ?? this.ripenessIndicatorsJson,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      isOrganic: isOrganic ?? this.isOrganic,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pluCode.present) {
      map['plu_code'] = Variable<String>(pluCode.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (averageWeight.present) {
      map['average_weight'] = Variable<double>(averageWeight.value);
    }
    if (avgPriceLow.present) {
      map['avg_price_low'] = Variable<double>(avgPriceLow.value);
    }
    if (avgPriceHigh.present) {
      map['avg_price_high'] = Variable<double>(avgPriceHigh.value);
    }
    if (seasonalityJson.present) {
      map['seasonality_json'] = Variable<String>(seasonalityJson.value);
    }
    if (ripenessIndicatorsJson.present) {
      map['ripeness_indicators_json'] = Variable<String>(
        ripenessIndicatorsJson.value,
      );
    }
    if (storageInstructions.present) {
      map['storage_instructions'] = Variable<String>(storageInstructions.value);
    }
    if (isOrganic.present) {
      map['is_organic'] = Variable<bool>(isOrganic.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProduceTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pluCode: $pluCode, ')
          ..write('category: $category, ')
          ..write('unitType: $unitType, ')
          ..write('averageWeight: $averageWeight, ')
          ..write('avgPriceLow: $avgPriceLow, ')
          ..write('avgPriceHigh: $avgPriceHigh, ')
          ..write('seasonalityJson: $seasonalityJson, ')
          ..write('ripenessIndicatorsJson: $ripenessIndicatorsJson, ')
          ..write('storageInstructions: $storageInstructions, ')
          ..write('isOrganic: $isOrganic, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanHistoryEntriesTable extends ScanHistoryEntries
    with TableInfo<$ScanHistoryEntriesTable, ScanHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scanTypeMeta = const VerificationMeta(
    'scanType',
  );
  @override
  late final GeneratedColumn<String> scanType = GeneratedColumn<String>(
    'scan_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    barcode,
    scanType,
    timestamp,
    confidence,
    productId,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('scan_type')) {
      context.handle(
        _scanTypeMeta,
        scanType.isAcceptableOrUnknown(data['scan_type']!, _scanTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scanTypeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      scanType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scan_type'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $ScanHistoryEntriesTable createAlias(String alias) {
    return $ScanHistoryEntriesTable(attachedDatabase, alias);
  }
}

class ScanHistoryEntry extends DataClass
    implements Insertable<ScanHistoryEntry> {
  final String id;
  final String barcode;
  final String scanType;
  final DateTime timestamp;
  final double? confidence;
  final String? productId;
  final String? errorMessage;
  const ScanHistoryEntry({
    required this.id,
    required this.barcode,
    required this.scanType,
    required this.timestamp,
    this.confidence,
    this.productId,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['barcode'] = Variable<String>(barcode);
    map['scan_type'] = Variable<String>(scanType);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  ScanHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScanHistoryEntriesCompanion(
      id: Value(id),
      barcode: Value(barcode),
      scanType: Value(scanType),
      timestamp: Value(timestamp),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory ScanHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      barcode: serializer.fromJson<String>(json['barcode']),
      scanType: serializer.fromJson<String>(json['scanType']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      productId: serializer.fromJson<String?>(json['productId']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'barcode': serializer.toJson<String>(barcode),
      'scanType': serializer.toJson<String>(scanType),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'confidence': serializer.toJson<double?>(confidence),
      'productId': serializer.toJson<String?>(productId),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  ScanHistoryEntry copyWith({
    String? id,
    String? barcode,
    String? scanType,
    DateTime? timestamp,
    Value<double?> confidence = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
  }) => ScanHistoryEntry(
    id: id ?? this.id,
    barcode: barcode ?? this.barcode,
    scanType: scanType ?? this.scanType,
    timestamp: timestamp ?? this.timestamp,
    confidence: confidence.present ? confidence.value : this.confidence,
    productId: productId.present ? productId.value : this.productId,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  ScanHistoryEntry copyWithCompanion(ScanHistoryEntriesCompanion data) {
    return ScanHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      scanType: data.scanType.present ? data.scanType.value : this.scanType,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      productId: data.productId.present ? data.productId.value : this.productId,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanHistoryEntry(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('scanType: $scanType, ')
          ..write('timestamp: $timestamp, ')
          ..write('confidence: $confidence, ')
          ..write('productId: $productId, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    barcode,
    scanType,
    timestamp,
    confidence,
    productId,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanHistoryEntry &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.scanType == this.scanType &&
          other.timestamp == this.timestamp &&
          other.confidence == this.confidence &&
          other.productId == this.productId &&
          other.errorMessage == this.errorMessage);
}

class ScanHistoryEntriesCompanion extends UpdateCompanion<ScanHistoryEntry> {
  final Value<String> id;
  final Value<String> barcode;
  final Value<String> scanType;
  final Value<DateTime> timestamp;
  final Value<double?> confidence;
  final Value<String?> productId;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const ScanHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.scanType = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.confidence = const Value.absent(),
    this.productId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanHistoryEntriesCompanion.insert({
    required String id,
    required String barcode,
    required String scanType,
    required DateTime timestamp,
    this.confidence = const Value.absent(),
    this.productId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       barcode = Value(barcode),
       scanType = Value(scanType),
       timestamp = Value(timestamp);
  static Insertable<ScanHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? barcode,
    Expression<String>? scanType,
    Expression<DateTime>? timestamp,
    Expression<double>? confidence,
    Expression<String>? productId,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (scanType != null) 'scan_type': scanType,
      if (timestamp != null) 'timestamp': timestamp,
      if (confidence != null) 'confidence': confidence,
      if (productId != null) 'product_id': productId,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanHistoryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? barcode,
    Value<String>? scanType,
    Value<DateTime>? timestamp,
    Value<double?>? confidence,
    Value<String?>? productId,
    Value<String?>? errorMessage,
    Value<int>? rowid,
  }) {
    return ScanHistoryEntriesCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      scanType: scanType ?? this.scanType,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
      productId: productId ?? this.productId,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (scanType.present) {
      map['scan_type'] = Variable<String>(scanType.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('scanType: $scanType, ')
          ..write('timestamp: $timestamp, ')
          ..write('confidence: $confidence, ')
          ..write('productId: $productId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PantryItemsTable extends PantryItems
    with TableInfo<$PantryItemsTable, PantryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PantryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('each'),
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pantry'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isStapleMeta = const VerificationMeta(
    'isStaple',
  );
  @override
  late final GeneratedColumn<bool> isStaple = GeneratedColumn<bool>(
    'is_staple',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_staple" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reorderThresholdMeta = const VerificationMeta(
    'reorderThreshold',
  );
  @override
  late final GeneratedColumn<int> reorderThreshold = GeneratedColumn<int>(
    'reorder_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isBulkMeta = const VerificationMeta('isBulk');
  @override
  late final GeneratedColumn<bool> isBulk = GeneratedColumn<bool>(
    'is_bulk',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bulk" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('newItem'),
  );
  static const VerificationMeta _firestorePantryIdMeta = const VerificationMeta(
    'firestorePantryId',
  );
  @override
  late final GeneratedColumn<String> firestorePantryId =
      GeneratedColumn<String>(
        'firestore_pantry_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _firestoreItemIdMeta = const VerificationMeta(
    'firestoreItemId',
  );
  @override
  late final GeneratedColumn<String> firestoreItemId = GeneratedColumn<String>(
    'firestore_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    category,
    quantity,
    unitType,
    purchasedAt,
    expiresAt,
    location,
    notes,
    isStaple,
    reorderThreshold,
    isBulk,
    purchasePrice,
    status,
    firestorePantryId,
    firestoreItemId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pantry_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PantryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_staple')) {
      context.handle(
        _isStapleMeta,
        isStaple.isAcceptableOrUnknown(data['is_staple']!, _isStapleMeta),
      );
    }
    if (data.containsKey('reorder_threshold')) {
      context.handle(
        _reorderThresholdMeta,
        reorderThreshold.isAcceptableOrUnknown(
          data['reorder_threshold']!,
          _reorderThresholdMeta,
        ),
      );
    }
    if (data.containsKey('is_bulk')) {
      context.handle(
        _isBulkMeta,
        isBulk.isAcceptableOrUnknown(data['is_bulk']!, _isBulkMeta),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('firestore_pantry_id')) {
      context.handle(
        _firestorePantryIdMeta,
        firestorePantryId.isAcceptableOrUnknown(
          data['firestore_pantry_id']!,
          _firestorePantryIdMeta,
        ),
      );
    }
    if (data.containsKey('firestore_item_id')) {
      context.handle(
        _firestoreItemIdMeta,
        firestoreItemId.isAcceptableOrUnknown(
          data['firestore_item_id']!,
          _firestoreItemIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PantryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PantryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isStaple: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_staple'],
      )!,
      reorderThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reorder_threshold'],
      )!,
      isBulk: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bulk'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      firestorePantryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firestore_pantry_id'],
      ),
      firestoreItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firestore_item_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PantryItemsTable createAlias(String alias) {
    return $PantryItemsTable(attachedDatabase, alias);
  }
}

class PantryItem extends DataClass implements Insertable<PantryItem> {
  final String id;
  final String? productId;
  final String name;
  final String category;
  final double quantity;
  final String unitType;
  final DateTime? purchasedAt;
  final DateTime? expiresAt;
  final String location;
  final String? notes;
  final bool isStaple;
  final int reorderThreshold;
  final bool isBulk;
  final double? purchasePrice;
  final String status;
  final String? firestorePantryId;
  final String? firestoreItemId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PantryItem({
    required this.id,
    this.productId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unitType,
    this.purchasedAt,
    this.expiresAt,
    required this.location,
    this.notes,
    required this.isStaple,
    required this.reorderThreshold,
    required this.isBulk,
    this.purchasePrice,
    required this.status,
    this.firestorePantryId,
    this.firestoreItemId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<double>(quantity);
    map['unit_type'] = Variable<String>(unitType);
    if (!nullToAbsent || purchasedAt != null) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['location'] = Variable<String>(location);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_staple'] = Variable<bool>(isStaple);
    map['reorder_threshold'] = Variable<int>(reorderThreshold);
    map['is_bulk'] = Variable<bool>(isBulk);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || firestorePantryId != null) {
      map['firestore_pantry_id'] = Variable<String>(firestorePantryId);
    }
    if (!nullToAbsent || firestoreItemId != null) {
      map['firestore_item_id'] = Variable<String>(firestoreItemId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PantryItemsCompanion toCompanion(bool nullToAbsent) {
    return PantryItemsCompanion(
      id: Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      unitType: Value(unitType),
      purchasedAt: purchasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      location: Value(location),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isStaple: Value(isStaple),
      reorderThreshold: Value(reorderThreshold),
      isBulk: Value(isBulk),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      status: Value(status),
      firestorePantryId: firestorePantryId == null && nullToAbsent
          ? const Value.absent()
          : Value(firestorePantryId),
      firestoreItemId: firestoreItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(firestoreItemId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PantryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PantryItem(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String?>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitType: serializer.fromJson<String>(json['unitType']),
      purchasedAt: serializer.fromJson<DateTime?>(json['purchasedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      location: serializer.fromJson<String>(json['location']),
      notes: serializer.fromJson<String?>(json['notes']),
      isStaple: serializer.fromJson<bool>(json['isStaple']),
      reorderThreshold: serializer.fromJson<int>(json['reorderThreshold']),
      isBulk: serializer.fromJson<bool>(json['isBulk']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      status: serializer.fromJson<String>(json['status']),
      firestorePantryId: serializer.fromJson<String?>(
        json['firestorePantryId'],
      ),
      firestoreItemId: serializer.fromJson<String?>(json['firestoreItemId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String?>(productId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<double>(quantity),
      'unitType': serializer.toJson<String>(unitType),
      'purchasedAt': serializer.toJson<DateTime?>(purchasedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'location': serializer.toJson<String>(location),
      'notes': serializer.toJson<String?>(notes),
      'isStaple': serializer.toJson<bool>(isStaple),
      'reorderThreshold': serializer.toJson<int>(reorderThreshold),
      'isBulk': serializer.toJson<bool>(isBulk),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'status': serializer.toJson<String>(status),
      'firestorePantryId': serializer.toJson<String?>(firestorePantryId),
      'firestoreItemId': serializer.toJson<String?>(firestoreItemId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PantryItem copyWith({
    String? id,
    Value<String?> productId = const Value.absent(),
    String? name,
    String? category,
    double? quantity,
    String? unitType,
    Value<DateTime?> purchasedAt = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    String? location,
    Value<String?> notes = const Value.absent(),
    bool? isStaple,
    int? reorderThreshold,
    bool? isBulk,
    Value<double?> purchasePrice = const Value.absent(),
    String? status,
    Value<String?> firestorePantryId = const Value.absent(),
    Value<String?> firestoreItemId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PantryItem(
    id: id ?? this.id,
    productId: productId.present ? productId.value : this.productId,
    name: name ?? this.name,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
    unitType: unitType ?? this.unitType,
    purchasedAt: purchasedAt.present ? purchasedAt.value : this.purchasedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    location: location ?? this.location,
    notes: notes.present ? notes.value : this.notes,
    isStaple: isStaple ?? this.isStaple,
    reorderThreshold: reorderThreshold ?? this.reorderThreshold,
    isBulk: isBulk ?? this.isBulk,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    status: status ?? this.status,
    firestorePantryId: firestorePantryId.present
        ? firestorePantryId.value
        : this.firestorePantryId,
    firestoreItemId: firestoreItemId.present
        ? firestoreItemId.value
        : this.firestoreItemId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PantryItem copyWithCompanion(PantryItemsCompanion data) {
    return PantryItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      location: data.location.present ? data.location.value : this.location,
      notes: data.notes.present ? data.notes.value : this.notes,
      isStaple: data.isStaple.present ? data.isStaple.value : this.isStaple,
      reorderThreshold: data.reorderThreshold.present
          ? data.reorderThreshold.value
          : this.reorderThreshold,
      isBulk: data.isBulk.present ? data.isBulk.value : this.isBulk,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      status: data.status.present ? data.status.value : this.status,
      firestorePantryId: data.firestorePantryId.present
          ? data.firestorePantryId.value
          : this.firestorePantryId,
      firestoreItemId: data.firestoreItemId.present
          ? data.firestoreItemId.value
          : this.firestoreItemId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PantryItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unitType: $unitType, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('isStaple: $isStaple, ')
          ..write('reorderThreshold: $reorderThreshold, ')
          ..write('isBulk: $isBulk, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('status: $status, ')
          ..write('firestorePantryId: $firestorePantryId, ')
          ..write('firestoreItemId: $firestoreItemId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    name,
    category,
    quantity,
    unitType,
    purchasedAt,
    expiresAt,
    location,
    notes,
    isStaple,
    reorderThreshold,
    isBulk,
    purchasePrice,
    status,
    firestorePantryId,
    firestoreItemId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.unitType == this.unitType &&
          other.purchasedAt == this.purchasedAt &&
          other.expiresAt == this.expiresAt &&
          other.location == this.location &&
          other.notes == this.notes &&
          other.isStaple == this.isStaple &&
          other.reorderThreshold == this.reorderThreshold &&
          other.isBulk == this.isBulk &&
          other.purchasePrice == this.purchasePrice &&
          other.status == this.status &&
          other.firestorePantryId == this.firestorePantryId &&
          other.firestoreItemId == this.firestoreItemId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PantryItemsCompanion extends UpdateCompanion<PantryItem> {
  final Value<String> id;
  final Value<String?> productId;
  final Value<String> name;
  final Value<String> category;
  final Value<double> quantity;
  final Value<String> unitType;
  final Value<DateTime?> purchasedAt;
  final Value<DateTime?> expiresAt;
  final Value<String> location;
  final Value<String?> notes;
  final Value<bool> isStaple;
  final Value<int> reorderThreshold;
  final Value<bool> isBulk;
  final Value<double?> purchasePrice;
  final Value<String> status;
  final Value<String?> firestorePantryId;
  final Value<String?> firestoreItemId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PantryItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitType = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    this.isStaple = const Value.absent(),
    this.reorderThreshold = const Value.absent(),
    this.isBulk = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.status = const Value.absent(),
    this.firestorePantryId = const Value.absent(),
    this.firestoreItemId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PantryItemsCompanion.insert({
    required String id,
    this.productId = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitType = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    this.isStaple = const Value.absent(),
    this.reorderThreshold = const Value.absent(),
    this.isBulk = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.status = const Value.absent(),
    this.firestorePantryId = const Value.absent(),
    this.firestoreItemId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PantryItem> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? quantity,
    Expression<String>? unitType,
    Expression<DateTime>? purchasedAt,
    Expression<DateTime>? expiresAt,
    Expression<String>? location,
    Expression<String>? notes,
    Expression<bool>? isStaple,
    Expression<int>? reorderThreshold,
    Expression<bool>? isBulk,
    Expression<double>? purchasePrice,
    Expression<String>? status,
    Expression<String>? firestorePantryId,
    Expression<String>? firestoreItemId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (unitType != null) 'unit_type': unitType,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (isStaple != null) 'is_staple': isStaple,
      if (reorderThreshold != null) 'reorder_threshold': reorderThreshold,
      if (isBulk != null) 'is_bulk': isBulk,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (status != null) 'status': status,
      if (firestorePantryId != null) 'firestore_pantry_id': firestorePantryId,
      if (firestoreItemId != null) 'firestore_item_id': firestoreItemId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PantryItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? productId,
    Value<String>? name,
    Value<String>? category,
    Value<double>? quantity,
    Value<String>? unitType,
    Value<DateTime?>? purchasedAt,
    Value<DateTime?>? expiresAt,
    Value<String>? location,
    Value<String?>? notes,
    Value<bool>? isStaple,
    Value<int>? reorderThreshold,
    Value<bool>? isBulk,
    Value<double?>? purchasePrice,
    Value<String>? status,
    Value<String?>? firestorePantryId,
    Value<String?>? firestoreItemId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PantryItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unitType: unitType ?? this.unitType,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      isStaple: isStaple ?? this.isStaple,
      reorderThreshold: reorderThreshold ?? this.reorderThreshold,
      isBulk: isBulk ?? this.isBulk,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      status: status ?? this.status,
      firestorePantryId: firestorePantryId ?? this.firestorePantryId,
      firestoreItemId: firestoreItemId ?? this.firestoreItemId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isStaple.present) {
      map['is_staple'] = Variable<bool>(isStaple.value);
    }
    if (reorderThreshold.present) {
      map['reorder_threshold'] = Variable<int>(reorderThreshold.value);
    }
    if (isBulk.present) {
      map['is_bulk'] = Variable<bool>(isBulk.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (firestorePantryId.present) {
      map['firestore_pantry_id'] = Variable<String>(firestorePantryId.value);
    }
    if (firestoreItemId.present) {
      map['firestore_item_id'] = Variable<String>(firestoreItemId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unitType: $unitType, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('isStaple: $isStaple, ')
          ..write('reorderThreshold: $reorderThreshold, ')
          ..write('isBulk: $isBulk, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('status: $status, ')
          ..write('firestorePantryId: $firestorePantryId, ')
          ..write('firestoreItemId: $firestoreItemId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListsTable extends ShoppingLists
    with TableInfo<$ShoppingListsTable, ShoppingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeTypeMeta = const VerificationMeta(
    'storeType',
  );
  @override
  late final GeneratedColumn<String> storeType = GeneratedColumn<String>(
    'store_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _mealPlanIdMeta = const VerificationMeta(
    'mealPlanId',
  );
  @override
  late final GeneratedColumn<String> mealPlanId = GeneratedColumn<String>(
    'meal_plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _firestoreIdMeta = const VerificationMeta(
    'firestoreId',
  );
  @override
  late final GeneratedColumn<String> firestoreId = GeneratedColumn<String>(
    'firestore_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateShoppedMeta = const VerificationMeta(
    'dateShopped',
  );
  @override
  late final GeneratedColumn<DateTime> dateShopped = GeneratedColumn<DateTime>(
    'date_shopped',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    storeId,
    storeName,
    storeType,
    source,
    mealPlanId,
    isCompleted,
    isActive,
    isArchived,
    firestoreId,
    sortOrder,
    createdAt,
    updatedAt,
    dateShopped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('store_type')) {
      context.handle(
        _storeTypeMeta,
        storeType.isAcceptableOrUnknown(data['store_type']!, _storeTypeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('meal_plan_id')) {
      context.handle(
        _mealPlanIdMeta,
        mealPlanId.isAcceptableOrUnknown(
          data['meal_plan_id']!,
          _mealPlanIdMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('firestore_id')) {
      context.handle(
        _firestoreIdMeta,
        firestoreId.isAcceptableOrUnknown(
          data['firestore_id']!,
          _firestoreIdMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('date_shopped')) {
      context.handle(
        _dateShoppedMeta,
        dateShopped.isAcceptableOrUnknown(
          data['date_shopped']!,
          _dateShoppedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      ),
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      ),
      storeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_type'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      mealPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_plan_id'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      firestoreId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firestore_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dateShopped: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_shopped'],
      ),
    );
  }

  @override
  $ShoppingListsTable createAlias(String alias) {
    return $ShoppingListsTable(attachedDatabase, alias);
  }
}

class ShoppingList extends DataClass implements Insertable<ShoppingList> {
  final String id;
  final String name;
  final String? storeId;
  final String? storeName;
  final String? storeType;
  final String source;
  final String? mealPlanId;
  final bool isCompleted;
  final bool isActive;
  final bool isArchived;
  final String? firestoreId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dateShopped;
  const ShoppingList({
    required this.id,
    required this.name,
    this.storeId,
    this.storeName,
    this.storeType,
    required this.source,
    this.mealPlanId,
    required this.isCompleted,
    required this.isActive,
    required this.isArchived,
    this.firestoreId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.dateShopped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<String>(storeId);
    }
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    if (!nullToAbsent || storeType != null) {
      map['store_type'] = Variable<String>(storeType);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || mealPlanId != null) {
      map['meal_plan_id'] = Variable<String>(mealPlanId);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_active'] = Variable<bool>(isActive);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || firestoreId != null) {
      map['firestore_id'] = Variable<String>(firestoreId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || dateShopped != null) {
      map['date_shopped'] = Variable<DateTime>(dateShopped);
    }
    return map;
  }

  ShoppingListsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListsCompanion(
      id: Value(id),
      name: Value(name),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      storeType: storeType == null && nullToAbsent
          ? const Value.absent()
          : Value(storeType),
      source: Value(source),
      mealPlanId: mealPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(mealPlanId),
      isCompleted: Value(isCompleted),
      isActive: Value(isActive),
      isArchived: Value(isArchived),
      firestoreId: firestoreId == null && nullToAbsent
          ? const Value.absent()
          : Value(firestoreId),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dateShopped: dateShopped == null && nullToAbsent
          ? const Value.absent()
          : Value(dateShopped),
    );
  }

  factory ShoppingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingList(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      storeId: serializer.fromJson<String?>(json['storeId']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      storeType: serializer.fromJson<String?>(json['storeType']),
      source: serializer.fromJson<String>(json['source']),
      mealPlanId: serializer.fromJson<String?>(json['mealPlanId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      firestoreId: serializer.fromJson<String?>(json['firestoreId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dateShopped: serializer.fromJson<DateTime?>(json['dateShopped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'storeId': serializer.toJson<String?>(storeId),
      'storeName': serializer.toJson<String?>(storeName),
      'storeType': serializer.toJson<String?>(storeType),
      'source': serializer.toJson<String>(source),
      'mealPlanId': serializer.toJson<String?>(mealPlanId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isActive': serializer.toJson<bool>(isActive),
      'isArchived': serializer.toJson<bool>(isArchived),
      'firestoreId': serializer.toJson<String?>(firestoreId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dateShopped': serializer.toJson<DateTime?>(dateShopped),
    };
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    Value<String?> storeId = const Value.absent(),
    Value<String?> storeName = const Value.absent(),
    Value<String?> storeType = const Value.absent(),
    String? source,
    Value<String?> mealPlanId = const Value.absent(),
    bool? isCompleted,
    bool? isActive,
    bool? isArchived,
    Value<String?> firestoreId = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> dateShopped = const Value.absent(),
  }) => ShoppingList(
    id: id ?? this.id,
    name: name ?? this.name,
    storeId: storeId.present ? storeId.value : this.storeId,
    storeName: storeName.present ? storeName.value : this.storeName,
    storeType: storeType.present ? storeType.value : this.storeType,
    source: source ?? this.source,
    mealPlanId: mealPlanId.present ? mealPlanId.value : this.mealPlanId,
    isCompleted: isCompleted ?? this.isCompleted,
    isActive: isActive ?? this.isActive,
    isArchived: isArchived ?? this.isArchived,
    firestoreId: firestoreId.present ? firestoreId.value : this.firestoreId,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dateShopped: dateShopped.present ? dateShopped.value : this.dateShopped,
  );
  ShoppingList copyWithCompanion(ShoppingListsCompanion data) {
    return ShoppingList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      storeType: data.storeType.present ? data.storeType.value : this.storeType,
      source: data.source.present ? data.source.value : this.source,
      mealPlanId: data.mealPlanId.present
          ? data.mealPlanId.value
          : this.mealPlanId,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      firestoreId: data.firestoreId.present
          ? data.firestoreId.value
          : this.firestoreId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dateShopped: data.dateShopped.present
          ? data.dateShopped.value
          : this.dateShopped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('storeId: $storeId, ')
          ..write('storeName: $storeName, ')
          ..write('storeType: $storeType, ')
          ..write('source: $source, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isActive: $isActive, ')
          ..write('isArchived: $isArchived, ')
          ..write('firestoreId: $firestoreId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dateShopped: $dateShopped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    storeId,
    storeName,
    storeType,
    source,
    mealPlanId,
    isCompleted,
    isActive,
    isArchived,
    firestoreId,
    sortOrder,
    createdAt,
    updatedAt,
    dateShopped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingList &&
          other.id == this.id &&
          other.name == this.name &&
          other.storeId == this.storeId &&
          other.storeName == this.storeName &&
          other.storeType == this.storeType &&
          other.source == this.source &&
          other.mealPlanId == this.mealPlanId &&
          other.isCompleted == this.isCompleted &&
          other.isActive == this.isActive &&
          other.isArchived == this.isArchived &&
          other.firestoreId == this.firestoreId &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dateShopped == this.dateShopped);
}

class ShoppingListsCompanion extends UpdateCompanion<ShoppingList> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> storeId;
  final Value<String?> storeName;
  final Value<String?> storeType;
  final Value<String> source;
  final Value<String?> mealPlanId;
  final Value<bool> isCompleted;
  final Value<bool> isActive;
  final Value<bool> isArchived;
  final Value<String?> firestoreId;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> dateShopped;
  final Value<int> rowid;
  const ShoppingListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.storeId = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeType = const Value.absent(),
    this.source = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.firestoreId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dateShopped = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListsCompanion.insert({
    required String id,
    required String name,
    this.storeId = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeType = const Value.absent(),
    this.source = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.firestoreId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.dateShopped = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShoppingList> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? storeId,
    Expression<String>? storeName,
    Expression<String>? storeType,
    Expression<String>? source,
    Expression<String>? mealPlanId,
    Expression<bool>? isCompleted,
    Expression<bool>? isActive,
    Expression<bool>? isArchived,
    Expression<String>? firestoreId,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? dateShopped,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (storeId != null) 'store_id': storeId,
      if (storeName != null) 'store_name': storeName,
      if (storeType != null) 'store_type': storeType,
      if (source != null) 'source': source,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isActive != null) 'is_active': isActive,
      if (isArchived != null) 'is_archived': isArchived,
      if (firestoreId != null) 'firestore_id': firestoreId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dateShopped != null) 'date_shopped': dateShopped,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? storeId,
    Value<String?>? storeName,
    Value<String?>? storeType,
    Value<String>? source,
    Value<String?>? mealPlanId,
    Value<bool>? isCompleted,
    Value<bool>? isActive,
    Value<bool>? isArchived,
    Value<String?>? firestoreId,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? dateShopped,
    Value<int>? rowid,
  }) {
    return ShoppingListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      storeType: storeType ?? this.storeType,
      source: source ?? this.source,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      isArchived: isArchived ?? this.isArchived,
      firestoreId: firestoreId ?? this.firestoreId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateShopped: dateShopped ?? this.dateShopped,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (storeType.present) {
      map['store_type'] = Variable<String>(storeType.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<String>(mealPlanId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (firestoreId.present) {
      map['firestore_id'] = Variable<String>(firestoreId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dateShopped.present) {
      map['date_shopped'] = Variable<DateTime>(dateShopped.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('storeId: $storeId, ')
          ..write('storeName: $storeName, ')
          ..write('storeType: $storeType, ')
          ..write('source: $source, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isActive: $isActive, ')
          ..write('isArchived: $isArchived, ')
          ..write('firestoreId: $firestoreId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dateShopped: $dateShopped, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_lists (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('count'),
  );
  static const VerificationMeta _estimatedPriceMeta = const VerificationMeta(
    'estimatedPrice',
  );
  @override
  late final GeneratedColumn<double> estimatedPrice = GeneratedColumn<double>(
    'estimated_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualPriceMeta = const VerificationMeta(
    'actualPrice',
  );
  @override
  late final GeneratedColumn<double> actualPrice = GeneratedColumn<double>(
    'actual_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOnSaleMeta = const VerificationMeta(
    'isOnSale',
  );
  @override
  late final GeneratedColumn<bool> isOnSale = GeneratedColumn<bool>(
    'is_on_sale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_on_sale" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recipeNameMeta = const VerificationMeta(
    'recipeName',
  );
  @override
  late final GeneratedColumn<String> recipeName = GeneratedColumn<String>(
    'recipe_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pantryQuantityAvailableMeta =
      const VerificationMeta('pantryQuantityAvailable');
  @override
  late final GeneratedColumn<double> pantryQuantityAvailable =
      GeneratedColumn<double>(
        'pantry_quantity_available',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    productId,
    name,
    brand,
    category,
    quantity,
    unitType,
    estimatedPrice,
    actualPrice,
    salePrice,
    isOnSale,
    isCompleted,
    priority,
    notes,
    recipeId,
    recipeName,
    pantryQuantityAvailable,
    sortOrder,
    addedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    }
    if (data.containsKey('estimated_price')) {
      context.handle(
        _estimatedPriceMeta,
        estimatedPrice.isAcceptableOrUnknown(
          data['estimated_price']!,
          _estimatedPriceMeta,
        ),
      );
    }
    if (data.containsKey('actual_price')) {
      context.handle(
        _actualPriceMeta,
        actualPrice.isAcceptableOrUnknown(
          data['actual_price']!,
          _actualPriceMeta,
        ),
      );
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    }
    if (data.containsKey('is_on_sale')) {
      context.handle(
        _isOnSaleMeta,
        isOnSale.isAcceptableOrUnknown(data['is_on_sale']!, _isOnSaleMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('recipe_name')) {
      context.handle(
        _recipeNameMeta,
        recipeName.isAcceptableOrUnknown(data['recipe_name']!, _recipeNameMeta),
      );
    }
    if (data.containsKey('pantry_quantity_available')) {
      context.handle(
        _pantryQuantityAvailableMeta,
        pantryQuantityAvailable.isAcceptableOrUnknown(
          data['pantry_quantity_available']!,
          _pantryQuantityAvailableMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      )!,
      estimatedPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_price'],
      ),
      actualPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_price'],
      ),
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      ),
      isOnSale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_on_sale'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      ),
      recipeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_name'],
      ),
      pantryQuantityAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pantry_quantity_available'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final String id;
  final String listId;
  final String? productId;
  final String name;
  final String? brand;
  final String category;
  final double quantity;
  final String unitType;
  final double? estimatedPrice;
  final double? actualPrice;
  final double? salePrice;
  final bool isOnSale;
  final bool isCompleted;
  final String priority;
  final String? notes;
  final String? recipeId;
  final String? recipeName;
  final double pantryQuantityAvailable;
  final int sortOrder;
  final DateTime addedAt;
  final DateTime updatedAt;
  const ShoppingListItem({
    required this.id,
    required this.listId,
    this.productId,
    required this.name,
    this.brand,
    required this.category,
    required this.quantity,
    required this.unitType,
    this.estimatedPrice,
    this.actualPrice,
    this.salePrice,
    required this.isOnSale,
    required this.isCompleted,
    required this.priority,
    this.notes,
    this.recipeId,
    this.recipeName,
    required this.pantryQuantityAvailable,
    required this.sortOrder,
    required this.addedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_id'] = Variable<String>(listId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<double>(quantity);
    map['unit_type'] = Variable<String>(unitType);
    if (!nullToAbsent || estimatedPrice != null) {
      map['estimated_price'] = Variable<double>(estimatedPrice);
    }
    if (!nullToAbsent || actualPrice != null) {
      map['actual_price'] = Variable<double>(actualPrice);
    }
    if (!nullToAbsent || salePrice != null) {
      map['sale_price'] = Variable<double>(salePrice);
    }
    map['is_on_sale'] = Variable<bool>(isOnSale);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    if (!nullToAbsent || recipeName != null) {
      map['recipe_name'] = Variable<String>(recipeName);
    }
    map['pantry_quantity_available'] = Variable<double>(
      pantryQuantityAvailable,
    );
    map['sort_order'] = Variable<int>(sortOrder);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      category: Value(category),
      quantity: Value(quantity),
      unitType: Value(unitType),
      estimatedPrice: estimatedPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPrice),
      actualPrice: actualPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(actualPrice),
      salePrice: salePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(salePrice),
      isOnSale: Value(isOnSale),
      isCompleted: Value(isCompleted),
      priority: Value(priority),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      recipeName: recipeName == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeName),
      pantryQuantityAvailable: Value(pantryQuantityAvailable),
      sortOrder: Value(sortOrder),
      addedAt: Value(addedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShoppingListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<String>(json['id']),
      listId: serializer.fromJson<String>(json['listId']),
      productId: serializer.fromJson<String?>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitType: serializer.fromJson<String>(json['unitType']),
      estimatedPrice: serializer.fromJson<double?>(json['estimatedPrice']),
      actualPrice: serializer.fromJson<double?>(json['actualPrice']),
      salePrice: serializer.fromJson<double?>(json['salePrice']),
      isOnSale: serializer.fromJson<bool>(json['isOnSale']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      priority: serializer.fromJson<String>(json['priority']),
      notes: serializer.fromJson<String?>(json['notes']),
      recipeId: serializer.fromJson<String?>(json['recipeId']),
      recipeName: serializer.fromJson<String?>(json['recipeName']),
      pantryQuantityAvailable: serializer.fromJson<double>(
        json['pantryQuantityAvailable'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listId': serializer.toJson<String>(listId),
      'productId': serializer.toJson<String?>(productId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<double>(quantity),
      'unitType': serializer.toJson<String>(unitType),
      'estimatedPrice': serializer.toJson<double?>(estimatedPrice),
      'actualPrice': serializer.toJson<double?>(actualPrice),
      'salePrice': serializer.toJson<double?>(salePrice),
      'isOnSale': serializer.toJson<bool>(isOnSale),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'priority': serializer.toJson<String>(priority),
      'notes': serializer.toJson<String?>(notes),
      'recipeId': serializer.toJson<String?>(recipeId),
      'recipeName': serializer.toJson<String?>(recipeName),
      'pantryQuantityAvailable': serializer.toJson<double>(
        pantryQuantityAvailable,
      ),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? listId,
    Value<String?> productId = const Value.absent(),
    String? name,
    Value<String?> brand = const Value.absent(),
    String? category,
    double? quantity,
    String? unitType,
    Value<double?> estimatedPrice = const Value.absent(),
    Value<double?> actualPrice = const Value.absent(),
    Value<double?> salePrice = const Value.absent(),
    bool? isOnSale,
    bool? isCompleted,
    String? priority,
    Value<String?> notes = const Value.absent(),
    Value<String?> recipeId = const Value.absent(),
    Value<String?> recipeName = const Value.absent(),
    double? pantryQuantityAvailable,
    int? sortOrder,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) => ShoppingListItem(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    productId: productId.present ? productId.value : this.productId,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
    unitType: unitType ?? this.unitType,
    estimatedPrice: estimatedPrice.present
        ? estimatedPrice.value
        : this.estimatedPrice,
    actualPrice: actualPrice.present ? actualPrice.value : this.actualPrice,
    salePrice: salePrice.present ? salePrice.value : this.salePrice,
    isOnSale: isOnSale ?? this.isOnSale,
    isCompleted: isCompleted ?? this.isCompleted,
    priority: priority ?? this.priority,
    notes: notes.present ? notes.value : this.notes,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    recipeName: recipeName.present ? recipeName.value : this.recipeName,
    pantryQuantityAvailable:
        pantryQuantityAvailable ?? this.pantryQuantityAvailable,
    sortOrder: sortOrder ?? this.sortOrder,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      estimatedPrice: data.estimatedPrice.present
          ? data.estimatedPrice.value
          : this.estimatedPrice,
      actualPrice: data.actualPrice.present
          ? data.actualPrice.value
          : this.actualPrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      isOnSale: data.isOnSale.present ? data.isOnSale.value : this.isOnSale,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      priority: data.priority.present ? data.priority.value : this.priority,
      notes: data.notes.present ? data.notes.value : this.notes,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      recipeName: data.recipeName.present
          ? data.recipeName.value
          : this.recipeName,
      pantryQuantityAvailable: data.pantryQuantityAvailable.present
          ? data.pantryQuantityAvailable.value
          : this.pantryQuantityAvailable,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unitType: $unitType, ')
          ..write('estimatedPrice: $estimatedPrice, ')
          ..write('actualPrice: $actualPrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('isOnSale: $isOnSale, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeName: $recipeName, ')
          ..write('pantryQuantityAvailable: $pantryQuantityAvailable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    listId,
    productId,
    name,
    brand,
    category,
    quantity,
    unitType,
    estimatedPrice,
    actualPrice,
    salePrice,
    isOnSale,
    isCompleted,
    priority,
    notes,
    recipeId,
    recipeName,
    pantryQuantityAvailable,
    sortOrder,
    addedAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.unitType == this.unitType &&
          other.estimatedPrice == this.estimatedPrice &&
          other.actualPrice == this.actualPrice &&
          other.salePrice == this.salePrice &&
          other.isOnSale == this.isOnSale &&
          other.isCompleted == this.isCompleted &&
          other.priority == this.priority &&
          other.notes == this.notes &&
          other.recipeId == this.recipeId &&
          other.recipeName == this.recipeName &&
          other.pantryQuantityAvailable == this.pantryQuantityAvailable &&
          other.sortOrder == this.sortOrder &&
          other.addedAt == this.addedAt &&
          other.updatedAt == this.updatedAt);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<String> id;
  final Value<String> listId;
  final Value<String?> productId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> category;
  final Value<double> quantity;
  final Value<String> unitType;
  final Value<double?> estimatedPrice;
  final Value<double?> actualPrice;
  final Value<double?> salePrice;
  final Value<bool> isOnSale;
  final Value<bool> isCompleted;
  final Value<String> priority;
  final Value<String?> notes;
  final Value<String?> recipeId;
  final Value<String?> recipeName;
  final Value<double> pantryQuantityAvailable;
  final Value<int> sortOrder;
  final Value<DateTime> addedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitType = const Value.absent(),
    this.estimatedPrice = const Value.absent(),
    this.actualPrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.isOnSale = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeName = const Value.absent(),
    this.pantryQuantityAvailable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    required String id,
    required String listId,
    this.productId = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitType = const Value.absent(),
    this.estimatedPrice = const Value.absent(),
    this.actualPrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.isOnSale = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeName = const Value.absent(),
    this.pantryQuantityAvailable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime addedAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listId = Value(listId),
       name = Value(name),
       addedAt = Value(addedAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShoppingListItem> custom({
    Expression<String>? id,
    Expression<String>? listId,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<double>? quantity,
    Expression<String>? unitType,
    Expression<double>? estimatedPrice,
    Expression<double>? actualPrice,
    Expression<double>? salePrice,
    Expression<bool>? isOnSale,
    Expression<bool>? isCompleted,
    Expression<String>? priority,
    Expression<String>? notes,
    Expression<String>? recipeId,
    Expression<String>? recipeName,
    Expression<double>? pantryQuantityAvailable,
    Expression<int>? sortOrder,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (unitType != null) 'unit_type': unitType,
      if (estimatedPrice != null) 'estimated_price': estimatedPrice,
      if (actualPrice != null) 'actual_price': actualPrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (isOnSale != null) 'is_on_sale': isOnSale,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (priority != null) 'priority': priority,
      if (notes != null) 'notes': notes,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeName != null) 'recipe_name': recipeName,
      if (pantryQuantityAvailable != null)
        'pantry_quantity_available': pantryQuantityAvailable,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (addedAt != null) 'added_at': addedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? listId,
    Value<String?>? productId,
    Value<String>? name,
    Value<String?>? brand,
    Value<String>? category,
    Value<double>? quantity,
    Value<String>? unitType,
    Value<double?>? estimatedPrice,
    Value<double?>? actualPrice,
    Value<double?>? salePrice,
    Value<bool>? isOnSale,
    Value<bool>? isCompleted,
    Value<String>? priority,
    Value<String?>? notes,
    Value<String?>? recipeId,
    Value<String?>? recipeName,
    Value<double>? pantryQuantityAvailable,
    Value<int>? sortOrder,
    Value<DateTime>? addedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unitType: unitType ?? this.unitType,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      salePrice: salePrice ?? this.salePrice,
      isOnSale: isOnSale ?? this.isOnSale,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      pantryQuantityAvailable:
          pantryQuantityAvailable ?? this.pantryQuantityAvailable,
      sortOrder: sortOrder ?? this.sortOrder,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (estimatedPrice.present) {
      map['estimated_price'] = Variable<double>(estimatedPrice.value);
    }
    if (actualPrice.present) {
      map['actual_price'] = Variable<double>(actualPrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (isOnSale.present) {
      map['is_on_sale'] = Variable<bool>(isOnSale.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (recipeName.present) {
      map['recipe_name'] = Variable<String>(recipeName.value);
    }
    if (pantryQuantityAvailable.present) {
      map['pantry_quantity_available'] = Variable<double>(
        pantryQuantityAvailable.value,
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unitType: $unitType, ')
          ..write('estimatedPrice: $estimatedPrice, ')
          ..write('actualPrice: $actualPrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('isOnSale: $isOnSale, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeName: $recipeName, ')
          ..write('pantryQuantityAvailable: $pantryQuantityAvailable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cuisineMeta = const VerificationMeta(
    'cuisine',
  );
  @override
  late final GeneratedColumn<String> cuisine = GeneratedColumn<String>(
    'cuisine',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _prepTimeMinutesMeta = const VerificationMeta(
    'prepTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> prepTimeMinutes = GeneratedColumn<int>(
    'prep_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cookTimeMinutesMeta = const VerificationMeta(
    'cookTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> cookTimeMinutes = GeneratedColumn<int>(
    'cook_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalTimeMinutesMeta = const VerificationMeta(
    'totalTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> totalTimeMinutes = GeneratedColumn<int>(
    'total_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dietaryFlagsJsonMeta = const VerificationMeta(
    'dietaryFlagsJson',
  );
  @override
  late final GeneratedColumn<String> dietaryFlagsJson = GeneratedColumn<String>(
    'dietary_flags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _ingredientsJsonMeta = const VerificationMeta(
    'ingredientsJson',
  );
  @override
  late final GeneratedColumn<String> ingredientsJson = GeneratedColumn<String>(
    'ingredients_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _instructionsJsonMeta = const VerificationMeta(
    'instructionsJson',
  );
  @override
  late final GeneratedColumn<String> instructionsJson = GeneratedColumn<String>(
    'instructions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _nutritionJsonMeta = const VerificationMeta(
    'nutritionJson',
  );
  @override
  late final GeneratedColumn<String> nutritionJson = GeneratedColumn<String>(
    'nutrition_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bundled'),
  );
  static const VerificationMeta _aiMetadataJsonMeta = const VerificationMeta(
    'aiMetadataJson',
  );
  @override
  late final GeneratedColumn<String> aiMetadataJson = GeneratedColumn<String>(
    'ai_metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    cuisine,
    servings,
    prepTimeMinutes,
    cookTimeMinutes,
    totalTimeMinutes,
    difficulty,
    tagsJson,
    dietaryFlagsJson,
    ingredientsJson,
    instructionsJson,
    nutritionJson,
    imageUrl,
    source,
    aiMetadataJson,
    isFavorite,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cuisine')) {
      context.handle(
        _cuisineMeta,
        cuisine.isAcceptableOrUnknown(data['cuisine']!, _cuisineMeta),
      );
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('prep_time_minutes')) {
      context.handle(
        _prepTimeMinutesMeta,
        prepTimeMinutes.isAcceptableOrUnknown(
          data['prep_time_minutes']!,
          _prepTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cook_time_minutes')) {
      context.handle(
        _cookTimeMinutesMeta,
        cookTimeMinutes.isAcceptableOrUnknown(
          data['cook_time_minutes']!,
          _cookTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('total_time_minutes')) {
      context.handle(
        _totalTimeMinutesMeta,
        totalTimeMinutes.isAcceptableOrUnknown(
          data['total_time_minutes']!,
          _totalTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('dietary_flags_json')) {
      context.handle(
        _dietaryFlagsJsonMeta,
        dietaryFlagsJson.isAcceptableOrUnknown(
          data['dietary_flags_json']!,
          _dietaryFlagsJsonMeta,
        ),
      );
    }
    if (data.containsKey('ingredients_json')) {
      context.handle(
        _ingredientsJsonMeta,
        ingredientsJson.isAcceptableOrUnknown(
          data['ingredients_json']!,
          _ingredientsJsonMeta,
        ),
      );
    }
    if (data.containsKey('instructions_json')) {
      context.handle(
        _instructionsJsonMeta,
        instructionsJson.isAcceptableOrUnknown(
          data['instructions_json']!,
          _instructionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('nutrition_json')) {
      context.handle(
        _nutritionJsonMeta,
        nutritionJson.isAcceptableOrUnknown(
          data['nutrition_json']!,
          _nutritionJsonMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('ai_metadata_json')) {
      context.handle(
        _aiMetadataJsonMeta,
        aiMetadataJson.isAcceptableOrUnknown(
          data['ai_metadata_json']!,
          _aiMetadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      cuisine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      prepTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_time_minutes'],
      )!,
      cookTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_time_minutes'],
      )!,
      totalTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_time_minutes'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      dietaryFlagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dietary_flags_json'],
      )!,
      ingredientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients_json'],
      )!,
      instructionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions_json'],
      )!,
      nutritionJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrition_json'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      aiMetadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_metadata_json'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String name;
  final String description;
  final String cuisine;
  final int servings;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int totalTimeMinutes;
  final String difficulty;
  final String tagsJson;
  final String dietaryFlagsJson;
  final String ingredientsJson;
  final String instructionsJson;
  final String? nutritionJson;
  final String? imageUrl;
  final String source;
  final String? aiMetadataJson;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.cuisine,
    required this.servings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.totalTimeMinutes,
    required this.difficulty,
    required this.tagsJson,
    required this.dietaryFlagsJson,
    required this.ingredientsJson,
    required this.instructionsJson,
    this.nutritionJson,
    this.imageUrl,
    required this.source,
    this.aiMetadataJson,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['cuisine'] = Variable<String>(cuisine);
    map['servings'] = Variable<int>(servings);
    map['prep_time_minutes'] = Variable<int>(prepTimeMinutes);
    map['cook_time_minutes'] = Variable<int>(cookTimeMinutes);
    map['total_time_minutes'] = Variable<int>(totalTimeMinutes);
    map['difficulty'] = Variable<String>(difficulty);
    map['tags_json'] = Variable<String>(tagsJson);
    map['dietary_flags_json'] = Variable<String>(dietaryFlagsJson);
    map['ingredients_json'] = Variable<String>(ingredientsJson);
    map['instructions_json'] = Variable<String>(instructionsJson);
    if (!nullToAbsent || nutritionJson != null) {
      map['nutrition_json'] = Variable<String>(nutritionJson);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || aiMetadataJson != null) {
      map['ai_metadata_json'] = Variable<String>(aiMetadataJson);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      cuisine: Value(cuisine),
      servings: Value(servings),
      prepTimeMinutes: Value(prepTimeMinutes),
      cookTimeMinutes: Value(cookTimeMinutes),
      totalTimeMinutes: Value(totalTimeMinutes),
      difficulty: Value(difficulty),
      tagsJson: Value(tagsJson),
      dietaryFlagsJson: Value(dietaryFlagsJson),
      ingredientsJson: Value(ingredientsJson),
      instructionsJson: Value(instructionsJson),
      nutritionJson: nutritionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(nutritionJson),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      source: Value(source),
      aiMetadataJson: aiMetadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(aiMetadataJson),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      cuisine: serializer.fromJson<String>(json['cuisine']),
      servings: serializer.fromJson<int>(json['servings']),
      prepTimeMinutes: serializer.fromJson<int>(json['prepTimeMinutes']),
      cookTimeMinutes: serializer.fromJson<int>(json['cookTimeMinutes']),
      totalTimeMinutes: serializer.fromJson<int>(json['totalTimeMinutes']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      dietaryFlagsJson: serializer.fromJson<String>(json['dietaryFlagsJson']),
      ingredientsJson: serializer.fromJson<String>(json['ingredientsJson']),
      instructionsJson: serializer.fromJson<String>(json['instructionsJson']),
      nutritionJson: serializer.fromJson<String?>(json['nutritionJson']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      source: serializer.fromJson<String>(json['source']),
      aiMetadataJson: serializer.fromJson<String?>(json['aiMetadataJson']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'cuisine': serializer.toJson<String>(cuisine),
      'servings': serializer.toJson<int>(servings),
      'prepTimeMinutes': serializer.toJson<int>(prepTimeMinutes),
      'cookTimeMinutes': serializer.toJson<int>(cookTimeMinutes),
      'totalTimeMinutes': serializer.toJson<int>(totalTimeMinutes),
      'difficulty': serializer.toJson<String>(difficulty),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'dietaryFlagsJson': serializer.toJson<String>(dietaryFlagsJson),
      'ingredientsJson': serializer.toJson<String>(ingredientsJson),
      'instructionsJson': serializer.toJson<String>(instructionsJson),
      'nutritionJson': serializer.toJson<String?>(nutritionJson),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'source': serializer.toJson<String>(source),
      'aiMetadataJson': serializer.toJson<String?>(aiMetadataJson),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    String? cuisine,
    int? servings,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? totalTimeMinutes,
    String? difficulty,
    String? tagsJson,
    String? dietaryFlagsJson,
    String? ingredientsJson,
    String? instructionsJson,
    Value<String?> nutritionJson = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    String? source,
    Value<String?> aiMetadataJson = const Value.absent(),
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    cuisine: cuisine ?? this.cuisine,
    servings: servings ?? this.servings,
    prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
    cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
    totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
    difficulty: difficulty ?? this.difficulty,
    tagsJson: tagsJson ?? this.tagsJson,
    dietaryFlagsJson: dietaryFlagsJson ?? this.dietaryFlagsJson,
    ingredientsJson: ingredientsJson ?? this.ingredientsJson,
    instructionsJson: instructionsJson ?? this.instructionsJson,
    nutritionJson: nutritionJson.present
        ? nutritionJson.value
        : this.nutritionJson,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    source: source ?? this.source,
    aiMetadataJson: aiMetadataJson.present
        ? aiMetadataJson.value
        : this.aiMetadataJson,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      cuisine: data.cuisine.present ? data.cuisine.value : this.cuisine,
      servings: data.servings.present ? data.servings.value : this.servings,
      prepTimeMinutes: data.prepTimeMinutes.present
          ? data.prepTimeMinutes.value
          : this.prepTimeMinutes,
      cookTimeMinutes: data.cookTimeMinutes.present
          ? data.cookTimeMinutes.value
          : this.cookTimeMinutes,
      totalTimeMinutes: data.totalTimeMinutes.present
          ? data.totalTimeMinutes.value
          : this.totalTimeMinutes,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      dietaryFlagsJson: data.dietaryFlagsJson.present
          ? data.dietaryFlagsJson.value
          : this.dietaryFlagsJson,
      ingredientsJson: data.ingredientsJson.present
          ? data.ingredientsJson.value
          : this.ingredientsJson,
      instructionsJson: data.instructionsJson.present
          ? data.instructionsJson.value
          : this.instructionsJson,
      nutritionJson: data.nutritionJson.present
          ? data.nutritionJson.value
          : this.nutritionJson,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      source: data.source.present ? data.source.value : this.source,
      aiMetadataJson: data.aiMetadataJson.present
          ? data.aiMetadataJson.value
          : this.aiMetadataJson,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('cuisine: $cuisine, ')
          ..write('servings: $servings, ')
          ..write('prepTimeMinutes: $prepTimeMinutes, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('totalTimeMinutes: $totalTimeMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('dietaryFlagsJson: $dietaryFlagsJson, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('instructionsJson: $instructionsJson, ')
          ..write('nutritionJson: $nutritionJson, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('source: $source, ')
          ..write('aiMetadataJson: $aiMetadataJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    cuisine,
    servings,
    prepTimeMinutes,
    cookTimeMinutes,
    totalTimeMinutes,
    difficulty,
    tagsJson,
    dietaryFlagsJson,
    ingredientsJson,
    instructionsJson,
    nutritionJson,
    imageUrl,
    source,
    aiMetadataJson,
    isFavorite,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.cuisine == this.cuisine &&
          other.servings == this.servings &&
          other.prepTimeMinutes == this.prepTimeMinutes &&
          other.cookTimeMinutes == this.cookTimeMinutes &&
          other.totalTimeMinutes == this.totalTimeMinutes &&
          other.difficulty == this.difficulty &&
          other.tagsJson == this.tagsJson &&
          other.dietaryFlagsJson == this.dietaryFlagsJson &&
          other.ingredientsJson == this.ingredientsJson &&
          other.instructionsJson == this.instructionsJson &&
          other.nutritionJson == this.nutritionJson &&
          other.imageUrl == this.imageUrl &&
          other.source == this.source &&
          other.aiMetadataJson == this.aiMetadataJson &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> cuisine;
  final Value<int> servings;
  final Value<int> prepTimeMinutes;
  final Value<int> cookTimeMinutes;
  final Value<int> totalTimeMinutes;
  final Value<String> difficulty;
  final Value<String> tagsJson;
  final Value<String> dietaryFlagsJson;
  final Value<String> ingredientsJson;
  final Value<String> instructionsJson;
  final Value<String?> nutritionJson;
  final Value<String?> imageUrl;
  final Value<String> source;
  final Value<String?> aiMetadataJson;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.cuisine = const Value.absent(),
    this.servings = const Value.absent(),
    this.prepTimeMinutes = const Value.absent(),
    this.cookTimeMinutes = const Value.absent(),
    this.totalTimeMinutes = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.dietaryFlagsJson = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.instructionsJson = const Value.absent(),
    this.nutritionJson = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.aiMetadataJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.cuisine = const Value.absent(),
    this.servings = const Value.absent(),
    this.prepTimeMinutes = const Value.absent(),
    this.cookTimeMinutes = const Value.absent(),
    this.totalTimeMinutes = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.dietaryFlagsJson = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.instructionsJson = const Value.absent(),
    this.nutritionJson = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.aiMetadataJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? cuisine,
    Expression<int>? servings,
    Expression<int>? prepTimeMinutes,
    Expression<int>? cookTimeMinutes,
    Expression<int>? totalTimeMinutes,
    Expression<String>? difficulty,
    Expression<String>? tagsJson,
    Expression<String>? dietaryFlagsJson,
    Expression<String>? ingredientsJson,
    Expression<String>? instructionsJson,
    Expression<String>? nutritionJson,
    Expression<String>? imageUrl,
    Expression<String>? source,
    Expression<String>? aiMetadataJson,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (cuisine != null) 'cuisine': cuisine,
      if (servings != null) 'servings': servings,
      if (prepTimeMinutes != null) 'prep_time_minutes': prepTimeMinutes,
      if (cookTimeMinutes != null) 'cook_time_minutes': cookTimeMinutes,
      if (totalTimeMinutes != null) 'total_time_minutes': totalTimeMinutes,
      if (difficulty != null) 'difficulty': difficulty,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (dietaryFlagsJson != null) 'dietary_flags_json': dietaryFlagsJson,
      if (ingredientsJson != null) 'ingredients_json': ingredientsJson,
      if (instructionsJson != null) 'instructions_json': instructionsJson,
      if (nutritionJson != null) 'nutrition_json': nutritionJson,
      if (imageUrl != null) 'image_url': imageUrl,
      if (source != null) 'source': source,
      if (aiMetadataJson != null) 'ai_metadata_json': aiMetadataJson,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? cuisine,
    Value<int>? servings,
    Value<int>? prepTimeMinutes,
    Value<int>? cookTimeMinutes,
    Value<int>? totalTimeMinutes,
    Value<String>? difficulty,
    Value<String>? tagsJson,
    Value<String>? dietaryFlagsJson,
    Value<String>? ingredientsJson,
    Value<String>? instructionsJson,
    Value<String?>? nutritionJson,
    Value<String?>? imageUrl,
    Value<String>? source,
    Value<String?>? aiMetadataJson,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisine: cuisine ?? this.cuisine,
      servings: servings ?? this.servings,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      tagsJson: tagsJson ?? this.tagsJson,
      dietaryFlagsJson: dietaryFlagsJson ?? this.dietaryFlagsJson,
      ingredientsJson: ingredientsJson ?? this.ingredientsJson,
      instructionsJson: instructionsJson ?? this.instructionsJson,
      nutritionJson: nutritionJson ?? this.nutritionJson,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      aiMetadataJson: aiMetadataJson ?? this.aiMetadataJson,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cuisine.present) {
      map['cuisine'] = Variable<String>(cuisine.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (prepTimeMinutes.present) {
      map['prep_time_minutes'] = Variable<int>(prepTimeMinutes.value);
    }
    if (cookTimeMinutes.present) {
      map['cook_time_minutes'] = Variable<int>(cookTimeMinutes.value);
    }
    if (totalTimeMinutes.present) {
      map['total_time_minutes'] = Variable<int>(totalTimeMinutes.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (dietaryFlagsJson.present) {
      map['dietary_flags_json'] = Variable<String>(dietaryFlagsJson.value);
    }
    if (ingredientsJson.present) {
      map['ingredients_json'] = Variable<String>(ingredientsJson.value);
    }
    if (instructionsJson.present) {
      map['instructions_json'] = Variable<String>(instructionsJson.value);
    }
    if (nutritionJson.present) {
      map['nutrition_json'] = Variable<String>(nutritionJson.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (aiMetadataJson.present) {
      map['ai_metadata_json'] = Variable<String>(aiMetadataJson.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('cuisine: $cuisine, ')
          ..write('servings: $servings, ')
          ..write('prepTimeMinutes: $prepTimeMinutes, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('totalTimeMinutes: $totalTimeMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('dietaryFlagsJson: $dietaryFlagsJson, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('instructionsJson: $instructionsJson, ')
          ..write('nutritionJson: $nutritionJson, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('source: $source, ')
          ..write('aiMetadataJson: $aiMetadataJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPlansTable extends MealPlans
    with TableInfo<$MealPlansTable, MealPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('quick'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    startDate,
    endDate,
    planType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      )!,
    );
  }

  @override
  $MealPlansTable createAlias(String alias) {
    return $MealPlansTable(attachedDatabase, alias);
  }
}

class MealPlan extends DataClass implements Insertable<MealPlan> {
  final String id;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final String planType;
  const MealPlan({
    required this.id,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.planType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['plan_type'] = Variable<String>(planType);
    return map;
  }

  MealPlansCompanion toCompanion(bool nullToAbsent) {
    return MealPlansCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      startDate: Value(startDate),
      endDate: Value(endDate),
      planType: Value(planType),
    );
  }

  factory MealPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlan(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      planType: serializer.fromJson<String>(json['planType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'planType': serializer.toJson<String>(planType),
    };
  }

  MealPlan copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    String? planType,
  }) => MealPlan(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    planType: planType ?? this.planType,
  );
  MealPlan copyWithCompanion(MealPlansCompanion data) {
    return MealPlan(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      planType: data.planType.present ? data.planType.value : this.planType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlan(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('planType: $planType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, startDate, endDate, planType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlan &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.planType == this.planType);
}

class MealPlansCompanion extends UpdateCompanion<MealPlan> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> planType;
  final Value<int> rowid;
  const MealPlansCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.planType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlansCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime startDate,
    required DateTime endDate,
    this.planType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<MealPlan> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? planType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (planType != null) 'plan_type': planType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlansCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? planType,
    Value<int>? rowid,
  }) {
    return MealPlansCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      planType: planType ?? this.planType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('planType: $planType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPlanDaysTable extends MealPlanDays
    with TableInfo<$MealPlanDaysTable, MealPlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_plans (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _recipeNameMeta = const VerificationMeta(
    'recipeName',
  );
  @override
  late final GeneratedColumn<String> recipeName = GeneratedColumn<String>(
    'recipe_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCookedMeta = const VerificationMeta(
    'isCooked',
  );
  @override
  late final GeneratedColumn<bool> isCooked = GeneratedColumn<bool>(
    'is_cooked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_cooked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dinner'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    date,
    recipeId,
    recipeName,
    isCooked,
    sortOrder,
    mealType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('recipe_name')) {
      context.handle(
        _recipeNameMeta,
        recipeName.isAcceptableOrUnknown(data['recipe_name']!, _recipeNameMeta),
      );
    }
    if (data.containsKey('is_cooked')) {
      context.handle(
        _isCookedMeta,
        isCooked.isAcceptableOrUnknown(data['is_cooked']!, _isCookedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      recipeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_name'],
      ),
      isCooked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_cooked'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
    );
  }

  @override
  $MealPlanDaysTable createAlias(String alias) {
    return $MealPlanDaysTable(attachedDatabase, alias);
  }
}

class MealPlanDay extends DataClass implements Insertable<MealPlanDay> {
  final String id;
  final String planId;
  final DateTime date;
  final String recipeId;
  final String? recipeName;
  final bool isCooked;
  final int sortOrder;
  final String mealType;
  const MealPlanDay({
    required this.id,
    required this.planId,
    required this.date,
    required this.recipeId,
    this.recipeName,
    required this.isCooked,
    required this.sortOrder,
    required this.mealType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['date'] = Variable<DateTime>(date);
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || recipeName != null) {
      map['recipe_name'] = Variable<String>(recipeName);
    }
    map['is_cooked'] = Variable<bool>(isCooked);
    map['sort_order'] = Variable<int>(sortOrder);
    map['meal_type'] = Variable<String>(mealType);
    return map;
  }

  MealPlanDaysCompanion toCompanion(bool nullToAbsent) {
    return MealPlanDaysCompanion(
      id: Value(id),
      planId: Value(planId),
      date: Value(date),
      recipeId: Value(recipeId),
      recipeName: recipeName == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeName),
      isCooked: Value(isCooked),
      sortOrder: Value(sortOrder),
      mealType: Value(mealType),
    );
  }

  factory MealPlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanDay(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      date: serializer.fromJson<DateTime>(json['date']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      recipeName: serializer.fromJson<String?>(json['recipeName']),
      isCooked: serializer.fromJson<bool>(json['isCooked']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      mealType: serializer.fromJson<String>(json['mealType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'date': serializer.toJson<DateTime>(date),
      'recipeId': serializer.toJson<String>(recipeId),
      'recipeName': serializer.toJson<String?>(recipeName),
      'isCooked': serializer.toJson<bool>(isCooked),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'mealType': serializer.toJson<String>(mealType),
    };
  }

  MealPlanDay copyWith({
    String? id,
    String? planId,
    DateTime? date,
    String? recipeId,
    Value<String?> recipeName = const Value.absent(),
    bool? isCooked,
    int? sortOrder,
    String? mealType,
  }) => MealPlanDay(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    date: date ?? this.date,
    recipeId: recipeId ?? this.recipeId,
    recipeName: recipeName.present ? recipeName.value : this.recipeName,
    isCooked: isCooked ?? this.isCooked,
    sortOrder: sortOrder ?? this.sortOrder,
    mealType: mealType ?? this.mealType,
  );
  MealPlanDay copyWithCompanion(MealPlanDaysCompanion data) {
    return MealPlanDay(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      date: data.date.present ? data.date.value : this.date,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      recipeName: data.recipeName.present
          ? data.recipeName.value
          : this.recipeName,
      isCooked: data.isCooked.present ? data.isCooked.value : this.isCooked,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanDay(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('date: $date, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeName: $recipeName, ')
          ..write('isCooked: $isCooked, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('mealType: $mealType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    date,
    recipeId,
    recipeName,
    isCooked,
    sortOrder,
    mealType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanDay &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.date == this.date &&
          other.recipeId == this.recipeId &&
          other.recipeName == this.recipeName &&
          other.isCooked == this.isCooked &&
          other.sortOrder == this.sortOrder &&
          other.mealType == this.mealType);
}

class MealPlanDaysCompanion extends UpdateCompanion<MealPlanDay> {
  final Value<String> id;
  final Value<String> planId;
  final Value<DateTime> date;
  final Value<String> recipeId;
  final Value<String?> recipeName;
  final Value<bool> isCooked;
  final Value<int> sortOrder;
  final Value<String> mealType;
  final Value<int> rowid;
  const MealPlanDaysCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.date = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.recipeName = const Value.absent(),
    this.isCooked = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.mealType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlanDaysCompanion.insert({
    required String id,
    required String planId,
    required DateTime date,
    required String recipeId,
    this.recipeName = const Value.absent(),
    this.isCooked = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.mealType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       date = Value(date),
       recipeId = Value(recipeId);
  static Insertable<MealPlanDay> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<DateTime>? date,
    Expression<String>? recipeId,
    Expression<String>? recipeName,
    Expression<bool>? isCooked,
    Expression<int>? sortOrder,
    Expression<String>? mealType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (date != null) 'date': date,
      if (recipeId != null) 'recipe_id': recipeId,
      if (recipeName != null) 'recipe_name': recipeName,
      if (isCooked != null) 'is_cooked': isCooked,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (mealType != null) 'meal_type': mealType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlanDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<DateTime>? date,
    Value<String>? recipeId,
    Value<String?>? recipeName,
    Value<bool>? isCooked,
    Value<int>? sortOrder,
    Value<String>? mealType,
    Value<int>? rowid,
  }) {
    return MealPlanDaysCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      date: date ?? this.date,
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      isCooked: isCooked ?? this.isCooked,
      sortOrder: sortOrder ?? this.sortOrder,
      mealType: mealType ?? this.mealType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (recipeName.present) {
      map['recipe_name'] = Variable<String>(recipeName.value);
    }
    if (isCooked.present) {
      map['is_cooked'] = Variable<bool>(isCooked.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('date: $date, ')
          ..write('recipeId: $recipeId, ')
          ..write('recipeName: $recipeName, ')
          ..write('isCooked: $isCooked, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('mealType: $mealType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeFeedbackTable extends RecipeFeedback
    with TableInfo<$RecipeFeedbackTable, RecipeFeedbackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeFeedbackTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _feedbackMeta = const VerificationMeta(
    'feedback',
  );
  @override
  late final GeneratedColumn<String> feedback = GeneratedColumn<String>(
    'feedback',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    feedback,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_feedback';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeFeedbackData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('feedback')) {
      context.handle(
        _feedbackMeta,
        feedback.isAcceptableOrUnknown(data['feedback']!, _feedbackMeta),
      );
    } else if (isInserting) {
      context.missing(_feedbackMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeFeedbackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeFeedbackData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      feedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecipeFeedbackTable createAlias(String alias) {
    return $RecipeFeedbackTable(attachedDatabase, alias);
  }
}

class RecipeFeedbackData extends DataClass
    implements Insertable<RecipeFeedbackData> {
  final String id;
  final String recipeId;
  final String feedback;
  final String? notes;
  final DateTime createdAt;
  const RecipeFeedbackData({
    required this.id,
    required this.recipeId,
    required this.feedback,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['feedback'] = Variable<String>(feedback);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipeFeedbackCompanion toCompanion(bool nullToAbsent) {
    return RecipeFeedbackCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      feedback: Value(feedback),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory RecipeFeedbackData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeFeedbackData(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      feedback: serializer.fromJson<String>(json['feedback']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'feedback': serializer.toJson<String>(feedback),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecipeFeedbackData copyWith({
    String? id,
    String? recipeId,
    String? feedback,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => RecipeFeedbackData(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    feedback: feedback ?? this.feedback,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  RecipeFeedbackData copyWithCompanion(RecipeFeedbackCompanion data) {
    return RecipeFeedbackData(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      feedback: data.feedback.present ? data.feedback.value : this.feedback,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeFeedbackData(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('feedback: $feedback, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, feedback, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeFeedbackData &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.feedback == this.feedback &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class RecipeFeedbackCompanion extends UpdateCompanion<RecipeFeedbackData> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String> feedback;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecipeFeedbackCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.feedback = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeFeedbackCompanion.insert({
    required String id,
    required String recipeId,
    required String feedback,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       feedback = Value(feedback),
       createdAt = Value(createdAt);
  static Insertable<RecipeFeedbackData> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? feedback,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (feedback != null) 'feedback': feedback,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeFeedbackCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String>? feedback,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RecipeFeedbackCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      feedback: feedback ?? this.feedback,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (feedback.present) {
      map['feedback'] = Variable<String>(feedback.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeFeedbackCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('feedback: $feedback, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyProfilesTable extends FamilyProfiles
    with TableInfo<$FamilyProfilesTable, FamilyProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adultsMeta = const VerificationMeta('adults');
  @override
  late final GeneratedColumn<int> adults = GeneratedColumn<int>(
    'adults',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _kidsMeta = const VerificationMeta('kids');
  @override
  late final GeneratedColumn<int> kids = GeneratedColumn<int>(
    'kids',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kidAgeRangesJsonMeta = const VerificationMeta(
    'kidAgeRangesJson',
  );
  @override
  late final GeneratedColumn<String> kidAgeRangesJson = GeneratedColumn<String>(
    'kid_age_ranges_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dietaryRestrictionsJsonMeta =
      const VerificationMeta('dietaryRestrictionsJson');
  @override
  late final GeneratedColumn<String> dietaryRestrictionsJson =
      GeneratedColumn<String>(
        'dietary_restrictions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _cuisinePreferencesJsonMeta =
      const VerificationMeta('cuisinePreferencesJson');
  @override
  late final GeneratedColumn<String> cuisinePreferencesJson =
      GeneratedColumn<String>(
        'cuisine_preferences_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _otherDietaryNotesMeta = const VerificationMeta(
    'otherDietaryNotes',
  );
  @override
  late final GeneratedColumn<String> otherDietaryNotes =
      GeneratedColumn<String>(
        'other_dietary_notes',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preferredCookTimeMeta = const VerificationMeta(
    'preferredCookTime',
  );
  @override
  late final GeneratedColumn<String> preferredCookTime =
      GeneratedColumn<String>(
        'preferred_cook_time',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('30-45'),
      );
  static const VerificationMeta _budgetLevelMeta = const VerificationMeta(
    'budgetLevel',
  );
  @override
  late final GeneratedColumn<String> budgetLevel = GeneratedColumn<String>(
    'budget_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('moderate'),
  );
  static const VerificationMeta _pantryStaplesJsonMeta = const VerificationMeta(
    'pantryStaplesJson',
  );
  @override
  late final GeneratedColumn<String> pantryStaplesJson =
      GeneratedColumn<String>(
        'pantry_staples_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    adults,
    kids,
    kidAgeRangesJson,
    dietaryRestrictionsJson,
    cuisinePreferencesJson,
    otherDietaryNotes,
    preferredCookTime,
    budgetLevel,
    pantryStaplesJson,
    onboardingCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('adults')) {
      context.handle(
        _adultsMeta,
        adults.isAcceptableOrUnknown(data['adults']!, _adultsMeta),
      );
    }
    if (data.containsKey('kids')) {
      context.handle(
        _kidsMeta,
        kids.isAcceptableOrUnknown(data['kids']!, _kidsMeta),
      );
    }
    if (data.containsKey('kid_age_ranges_json')) {
      context.handle(
        _kidAgeRangesJsonMeta,
        kidAgeRangesJson.isAcceptableOrUnknown(
          data['kid_age_ranges_json']!,
          _kidAgeRangesJsonMeta,
        ),
      );
    }
    if (data.containsKey('dietary_restrictions_json')) {
      context.handle(
        _dietaryRestrictionsJsonMeta,
        dietaryRestrictionsJson.isAcceptableOrUnknown(
          data['dietary_restrictions_json']!,
          _dietaryRestrictionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('cuisine_preferences_json')) {
      context.handle(
        _cuisinePreferencesJsonMeta,
        cuisinePreferencesJson.isAcceptableOrUnknown(
          data['cuisine_preferences_json']!,
          _cuisinePreferencesJsonMeta,
        ),
      );
    }
    if (data.containsKey('other_dietary_notes')) {
      context.handle(
        _otherDietaryNotesMeta,
        otherDietaryNotes.isAcceptableOrUnknown(
          data['other_dietary_notes']!,
          _otherDietaryNotesMeta,
        ),
      );
    }
    if (data.containsKey('preferred_cook_time')) {
      context.handle(
        _preferredCookTimeMeta,
        preferredCookTime.isAcceptableOrUnknown(
          data['preferred_cook_time']!,
          _preferredCookTimeMeta,
        ),
      );
    }
    if (data.containsKey('budget_level')) {
      context.handle(
        _budgetLevelMeta,
        budgetLevel.isAcceptableOrUnknown(
          data['budget_level']!,
          _budgetLevelMeta,
        ),
      );
    }
    if (data.containsKey('pantry_staples_json')) {
      context.handle(
        _pantryStaplesJsonMeta,
        pantryStaplesJson.isAcceptableOrUnknown(
          data['pantry_staples_json']!,
          _pantryStaplesJsonMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      adults: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adults'],
      )!,
      kids: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kids'],
      )!,
      kidAgeRangesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kid_age_ranges_json'],
      )!,
      dietaryRestrictionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dietary_restrictions_json'],
      )!,
      cuisinePreferencesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine_preferences_json'],
      )!,
      otherDietaryNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_dietary_notes'],
      ),
      preferredCookTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_cook_time'],
      )!,
      budgetLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_level'],
      )!,
      pantryStaplesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pantry_staples_json'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FamilyProfilesTable createAlias(String alias) {
    return $FamilyProfilesTable(attachedDatabase, alias);
  }
}

class FamilyProfile extends DataClass implements Insertable<FamilyProfile> {
  final String id;
  final int adults;
  final int kids;
  final String kidAgeRangesJson;
  final String dietaryRestrictionsJson;
  final String cuisinePreferencesJson;
  final String? otherDietaryNotes;
  final String preferredCookTime;
  final String budgetLevel;
  final String pantryStaplesJson;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FamilyProfile({
    required this.id,
    required this.adults,
    required this.kids,
    required this.kidAgeRangesJson,
    required this.dietaryRestrictionsJson,
    required this.cuisinePreferencesJson,
    this.otherDietaryNotes,
    required this.preferredCookTime,
    required this.budgetLevel,
    required this.pantryStaplesJson,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['adults'] = Variable<int>(adults);
    map['kids'] = Variable<int>(kids);
    map['kid_age_ranges_json'] = Variable<String>(kidAgeRangesJson);
    map['dietary_restrictions_json'] = Variable<String>(
      dietaryRestrictionsJson,
    );
    map['cuisine_preferences_json'] = Variable<String>(cuisinePreferencesJson);
    if (!nullToAbsent || otherDietaryNotes != null) {
      map['other_dietary_notes'] = Variable<String>(otherDietaryNotes);
    }
    map['preferred_cook_time'] = Variable<String>(preferredCookTime);
    map['budget_level'] = Variable<String>(budgetLevel);
    map['pantry_staples_json'] = Variable<String>(pantryStaplesJson);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FamilyProfilesCompanion toCompanion(bool nullToAbsent) {
    return FamilyProfilesCompanion(
      id: Value(id),
      adults: Value(adults),
      kids: Value(kids),
      kidAgeRangesJson: Value(kidAgeRangesJson),
      dietaryRestrictionsJson: Value(dietaryRestrictionsJson),
      cuisinePreferencesJson: Value(cuisinePreferencesJson),
      otherDietaryNotes: otherDietaryNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(otherDietaryNotes),
      preferredCookTime: Value(preferredCookTime),
      budgetLevel: Value(budgetLevel),
      pantryStaplesJson: Value(pantryStaplesJson),
      onboardingCompleted: Value(onboardingCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FamilyProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyProfile(
      id: serializer.fromJson<String>(json['id']),
      adults: serializer.fromJson<int>(json['adults']),
      kids: serializer.fromJson<int>(json['kids']),
      kidAgeRangesJson: serializer.fromJson<String>(json['kidAgeRangesJson']),
      dietaryRestrictionsJson: serializer.fromJson<String>(
        json['dietaryRestrictionsJson'],
      ),
      cuisinePreferencesJson: serializer.fromJson<String>(
        json['cuisinePreferencesJson'],
      ),
      otherDietaryNotes: serializer.fromJson<String?>(
        json['otherDietaryNotes'],
      ),
      preferredCookTime: serializer.fromJson<String>(json['preferredCookTime']),
      budgetLevel: serializer.fromJson<String>(json['budgetLevel']),
      pantryStaplesJson: serializer.fromJson<String>(json['pantryStaplesJson']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'adults': serializer.toJson<int>(adults),
      'kids': serializer.toJson<int>(kids),
      'kidAgeRangesJson': serializer.toJson<String>(kidAgeRangesJson),
      'dietaryRestrictionsJson': serializer.toJson<String>(
        dietaryRestrictionsJson,
      ),
      'cuisinePreferencesJson': serializer.toJson<String>(
        cuisinePreferencesJson,
      ),
      'otherDietaryNotes': serializer.toJson<String?>(otherDietaryNotes),
      'preferredCookTime': serializer.toJson<String>(preferredCookTime),
      'budgetLevel': serializer.toJson<String>(budgetLevel),
      'pantryStaplesJson': serializer.toJson<String>(pantryStaplesJson),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FamilyProfile copyWith({
    String? id,
    int? adults,
    int? kids,
    String? kidAgeRangesJson,
    String? dietaryRestrictionsJson,
    String? cuisinePreferencesJson,
    Value<String?> otherDietaryNotes = const Value.absent(),
    String? preferredCookTime,
    String? budgetLevel,
    String? pantryStaplesJson,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FamilyProfile(
    id: id ?? this.id,
    adults: adults ?? this.adults,
    kids: kids ?? this.kids,
    kidAgeRangesJson: kidAgeRangesJson ?? this.kidAgeRangesJson,
    dietaryRestrictionsJson:
        dietaryRestrictionsJson ?? this.dietaryRestrictionsJson,
    cuisinePreferencesJson:
        cuisinePreferencesJson ?? this.cuisinePreferencesJson,
    otherDietaryNotes: otherDietaryNotes.present
        ? otherDietaryNotes.value
        : this.otherDietaryNotes,
    preferredCookTime: preferredCookTime ?? this.preferredCookTime,
    budgetLevel: budgetLevel ?? this.budgetLevel,
    pantryStaplesJson: pantryStaplesJson ?? this.pantryStaplesJson,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FamilyProfile copyWithCompanion(FamilyProfilesCompanion data) {
    return FamilyProfile(
      id: data.id.present ? data.id.value : this.id,
      adults: data.adults.present ? data.adults.value : this.adults,
      kids: data.kids.present ? data.kids.value : this.kids,
      kidAgeRangesJson: data.kidAgeRangesJson.present
          ? data.kidAgeRangesJson.value
          : this.kidAgeRangesJson,
      dietaryRestrictionsJson: data.dietaryRestrictionsJson.present
          ? data.dietaryRestrictionsJson.value
          : this.dietaryRestrictionsJson,
      cuisinePreferencesJson: data.cuisinePreferencesJson.present
          ? data.cuisinePreferencesJson.value
          : this.cuisinePreferencesJson,
      otherDietaryNotes: data.otherDietaryNotes.present
          ? data.otherDietaryNotes.value
          : this.otherDietaryNotes,
      preferredCookTime: data.preferredCookTime.present
          ? data.preferredCookTime.value
          : this.preferredCookTime,
      budgetLevel: data.budgetLevel.present
          ? data.budgetLevel.value
          : this.budgetLevel,
      pantryStaplesJson: data.pantryStaplesJson.present
          ? data.pantryStaplesJson.value
          : this.pantryStaplesJson,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyProfile(')
          ..write('id: $id, ')
          ..write('adults: $adults, ')
          ..write('kids: $kids, ')
          ..write('kidAgeRangesJson: $kidAgeRangesJson, ')
          ..write('dietaryRestrictionsJson: $dietaryRestrictionsJson, ')
          ..write('cuisinePreferencesJson: $cuisinePreferencesJson, ')
          ..write('otherDietaryNotes: $otherDietaryNotes, ')
          ..write('preferredCookTime: $preferredCookTime, ')
          ..write('budgetLevel: $budgetLevel, ')
          ..write('pantryStaplesJson: $pantryStaplesJson, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    adults,
    kids,
    kidAgeRangesJson,
    dietaryRestrictionsJson,
    cuisinePreferencesJson,
    otherDietaryNotes,
    preferredCookTime,
    budgetLevel,
    pantryStaplesJson,
    onboardingCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyProfile &&
          other.id == this.id &&
          other.adults == this.adults &&
          other.kids == this.kids &&
          other.kidAgeRangesJson == this.kidAgeRangesJson &&
          other.dietaryRestrictionsJson == this.dietaryRestrictionsJson &&
          other.cuisinePreferencesJson == this.cuisinePreferencesJson &&
          other.otherDietaryNotes == this.otherDietaryNotes &&
          other.preferredCookTime == this.preferredCookTime &&
          other.budgetLevel == this.budgetLevel &&
          other.pantryStaplesJson == this.pantryStaplesJson &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FamilyProfilesCompanion extends UpdateCompanion<FamilyProfile> {
  final Value<String> id;
  final Value<int> adults;
  final Value<int> kids;
  final Value<String> kidAgeRangesJson;
  final Value<String> dietaryRestrictionsJson;
  final Value<String> cuisinePreferencesJson;
  final Value<String?> otherDietaryNotes;
  final Value<String> preferredCookTime;
  final Value<String> budgetLevel;
  final Value<String> pantryStaplesJson;
  final Value<bool> onboardingCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FamilyProfilesCompanion({
    this.id = const Value.absent(),
    this.adults = const Value.absent(),
    this.kids = const Value.absent(),
    this.kidAgeRangesJson = const Value.absent(),
    this.dietaryRestrictionsJson = const Value.absent(),
    this.cuisinePreferencesJson = const Value.absent(),
    this.otherDietaryNotes = const Value.absent(),
    this.preferredCookTime = const Value.absent(),
    this.budgetLevel = const Value.absent(),
    this.pantryStaplesJson = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyProfilesCompanion.insert({
    required String id,
    this.adults = const Value.absent(),
    this.kids = const Value.absent(),
    this.kidAgeRangesJson = const Value.absent(),
    this.dietaryRestrictionsJson = const Value.absent(),
    this.cuisinePreferencesJson = const Value.absent(),
    this.otherDietaryNotes = const Value.absent(),
    this.preferredCookTime = const Value.absent(),
    this.budgetLevel = const Value.absent(),
    this.pantryStaplesJson = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FamilyProfile> custom({
    Expression<String>? id,
    Expression<int>? adults,
    Expression<int>? kids,
    Expression<String>? kidAgeRangesJson,
    Expression<String>? dietaryRestrictionsJson,
    Expression<String>? cuisinePreferencesJson,
    Expression<String>? otherDietaryNotes,
    Expression<String>? preferredCookTime,
    Expression<String>? budgetLevel,
    Expression<String>? pantryStaplesJson,
    Expression<bool>? onboardingCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (adults != null) 'adults': adults,
      if (kids != null) 'kids': kids,
      if (kidAgeRangesJson != null) 'kid_age_ranges_json': kidAgeRangesJson,
      if (dietaryRestrictionsJson != null)
        'dietary_restrictions_json': dietaryRestrictionsJson,
      if (cuisinePreferencesJson != null)
        'cuisine_preferences_json': cuisinePreferencesJson,
      if (otherDietaryNotes != null) 'other_dietary_notes': otherDietaryNotes,
      if (preferredCookTime != null) 'preferred_cook_time': preferredCookTime,
      if (budgetLevel != null) 'budget_level': budgetLevel,
      if (pantryStaplesJson != null) 'pantry_staples_json': pantryStaplesJson,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyProfilesCompanion copyWith({
    Value<String>? id,
    Value<int>? adults,
    Value<int>? kids,
    Value<String>? kidAgeRangesJson,
    Value<String>? dietaryRestrictionsJson,
    Value<String>? cuisinePreferencesJson,
    Value<String?>? otherDietaryNotes,
    Value<String>? preferredCookTime,
    Value<String>? budgetLevel,
    Value<String>? pantryStaplesJson,
    Value<bool>? onboardingCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FamilyProfilesCompanion(
      id: id ?? this.id,
      adults: adults ?? this.adults,
      kids: kids ?? this.kids,
      kidAgeRangesJson: kidAgeRangesJson ?? this.kidAgeRangesJson,
      dietaryRestrictionsJson:
          dietaryRestrictionsJson ?? this.dietaryRestrictionsJson,
      cuisinePreferencesJson:
          cuisinePreferencesJson ?? this.cuisinePreferencesJson,
      otherDietaryNotes: otherDietaryNotes ?? this.otherDietaryNotes,
      preferredCookTime: preferredCookTime ?? this.preferredCookTime,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      pantryStaplesJson: pantryStaplesJson ?? this.pantryStaplesJson,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (adults.present) {
      map['adults'] = Variable<int>(adults.value);
    }
    if (kids.present) {
      map['kids'] = Variable<int>(kids.value);
    }
    if (kidAgeRangesJson.present) {
      map['kid_age_ranges_json'] = Variable<String>(kidAgeRangesJson.value);
    }
    if (dietaryRestrictionsJson.present) {
      map['dietary_restrictions_json'] = Variable<String>(
        dietaryRestrictionsJson.value,
      );
    }
    if (cuisinePreferencesJson.present) {
      map['cuisine_preferences_json'] = Variable<String>(
        cuisinePreferencesJson.value,
      );
    }
    if (otherDietaryNotes.present) {
      map['other_dietary_notes'] = Variable<String>(otherDietaryNotes.value);
    }
    if (preferredCookTime.present) {
      map['preferred_cook_time'] = Variable<String>(preferredCookTime.value);
    }
    if (budgetLevel.present) {
      map['budget_level'] = Variable<String>(budgetLevel.value);
    }
    if (pantryStaplesJson.present) {
      map['pantry_staples_json'] = Variable<String>(pantryStaplesJson.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyProfilesCompanion(')
          ..write('id: $id, ')
          ..write('adults: $adults, ')
          ..write('kids: $kids, ')
          ..write('kidAgeRangesJson: $kidAgeRangesJson, ')
          ..write('dietaryRestrictionsJson: $dietaryRestrictionsJson, ')
          ..write('cuisinePreferencesJson: $cuisinePreferencesJson, ')
          ..write('otherDietaryNotes: $otherDietaryNotes, ')
          ..write('preferredCookTime: $preferredCookTime, ')
          ..write('budgetLevel: $budgetLevel, ')
          ..write('pantryStaplesJson: $pantryStaplesJson, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _preferredCurrencyMeta = const VerificationMeta(
    'preferredCurrency',
  );
  @override
  late final GeneratedColumn<String> preferredCurrency =
      GeneratedColumn<String>(
        'preferred_currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('USD'),
      );
  static const VerificationMeta _dietaryRestrictionsJsonMeta =
      const VerificationMeta('dietaryRestrictionsJson');
  @override
  late final GeneratedColumn<String> dietaryRestrictionsJson =
      GeneratedColumn<String>(
        'dietary_restrictions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _allergenAlertsJsonMeta =
      const VerificationMeta('allergenAlertsJson');
  @override
  late final GeneratedColumn<String> allergenAlertsJson =
      GeneratedColumn<String>(
        'allergen_alerts_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _autoAddToListMeta = const VerificationMeta(
    'autoAddToList',
  );
  @override
  late final GeneratedColumn<bool> autoAddToList = GeneratedColumn<bool>(
    'auto_add_to_list',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_add_to_list" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _defaultQuantityMeta = const VerificationMeta(
    'defaultQuantity',
  );
  @override
  late final GeneratedColumn<int> defaultQuantity = GeneratedColumn<int>(
    'default_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _scanSoundMeta = const VerificationMeta(
    'scanSound',
  );
  @override
  late final GeneratedColumn<bool> scanSound = GeneratedColumn<bool>(
    'scan_sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("scan_sound" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _scanSoundIdMeta = const VerificationMeta(
    'scanSoundId',
  );
  @override
  late final GeneratedColumn<int> scanSoundId = GeneratedColumn<int>(
    'scan_sound_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1108),
  );
  static const VerificationMeta _hapticFeedbackMeta = const VerificationMeta(
    'hapticFeedback',
  );
  @override
  late final GeneratedColumn<bool> hapticFeedback = GeneratedColumn<bool>(
    'haptic_feedback',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptic_feedback" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _selectedListIdMeta = const VerificationMeta(
    'selectedListId',
  );
  @override
  late final GeneratedColumn<String> selectedListId = GeneratedColumn<String>(
    'selected_list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dismissedHintsJsonMeta =
      const VerificationMeta('dismissedHintsJson');
  @override
  late final GeneratedColumn<String> dismissedHintsJson =
      GeneratedColumn<String>(
        'dismissed_hints_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _syncEnabledMeta = const VerificationMeta(
    'syncEnabled',
  );
  @override
  late final GeneratedColumn<bool> syncEnabled = GeneratedColumn<bool>(
    'sync_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _weeklyPlanCountMeta = const VerificationMeta(
    'weeklyPlanCount',
  );
  @override
  late final GeneratedColumn<int> weeklyPlanCount = GeneratedColumn<int>(
    'weekly_plan_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weeklyPlanResetDateMeta =
      const VerificationMeta('weeklyPlanResetDate');
  @override
  late final GeneratedColumn<DateTime> weeklyPlanResetDate =
      GeneratedColumn<DateTime>(
        'weekly_plan_reset_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isPremiumMeta = const VerificationMeta(
    'isPremium',
  );
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
    'is_premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _subscriptionIdMeta = const VerificationMeta(
    'subscriptionId',
  );
  @override
  late final GeneratedColumn<String> subscriptionId = GeneratedColumn<String>(
    'subscription_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subscriptionPlanMeta = const VerificationMeta(
    'subscriptionPlan',
  );
  @override
  late final GeneratedColumn<String> subscriptionPlan = GeneratedColumn<String>(
    'subscription_plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subscriptionExpiresAtMeta =
      const VerificationMeta('subscriptionExpiresAt');
  @override
  late final GeneratedColumn<DateTime> subscriptionExpiresAt =
      GeneratedColumn<DateTime>(
        'subscription_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _voicePersonaMeta = const VerificationMeta(
    'voicePersona',
  );
  @override
  late final GeneratedColumn<String> voicePersona = GeneratedColumn<String>(
    'voice_persona',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dinner'),
  );
  static const VerificationMeta _sharedListIdMeta = const VerificationMeta(
    'sharedListId',
  );
  @override
  late final GeneratedColumn<String> sharedListId = GeneratedColumn<String>(
    'shared_list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedPantryIdMeta = const VerificationMeta(
    'sharedPantryId',
  );
  @override
  late final GeneratedColumn<String> sharedPantryId = GeneratedColumn<String>(
    'shared_pantry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enableNotificationsMeta =
      const VerificationMeta('enableNotifications');
  @override
  late final GeneratedColumn<bool> enableNotifications = GeneratedColumn<bool>(
    'enable_notifications',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_notifications" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifySharingEventsMeta =
      const VerificationMeta('notifySharingEvents');
  @override
  late final GeneratedColumn<bool> notifySharingEvents = GeneratedColumn<bool>(
    'notify_sharing_events',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_sharing_events" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyExpiryAlertsMeta =
      const VerificationMeta('notifyExpiryAlerts');
  @override
  late final GeneratedColumn<bool> notifyExpiryAlerts = GeneratedColumn<bool>(
    'notify_expiry_alerts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_expiry_alerts" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyReorderAlertsMeta =
      const VerificationMeta('notifyReorderAlerts');
  @override
  late final GeneratedColumn<bool> notifyReorderAlerts = GeneratedColumn<bool>(
    'notify_reorder_alerts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_reorder_alerts" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    preferredCurrency,
    dietaryRestrictionsJson,
    allergenAlertsJson,
    autoAddToList,
    defaultQuantity,
    scanSound,
    scanSoundId,
    hapticFeedback,
    selectedListId,
    dismissedHintsJson,
    syncEnabled,
    onboardingCompleted,
    weeklyPlanCount,
    weeklyPlanResetDate,
    isPremium,
    subscriptionId,
    subscriptionPlan,
    subscriptionExpiresAt,
    voicePersona,
    mealType,
    sharedListId,
    sharedPantryId,
    enableNotifications,
    notifySharingEvents,
    notifyExpiryAlerts,
    notifyReorderAlerts,
    theme,
    language,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreferencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('preferred_currency')) {
      context.handle(
        _preferredCurrencyMeta,
        preferredCurrency.isAcceptableOrUnknown(
          data['preferred_currency']!,
          _preferredCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('dietary_restrictions_json')) {
      context.handle(
        _dietaryRestrictionsJsonMeta,
        dietaryRestrictionsJson.isAcceptableOrUnknown(
          data['dietary_restrictions_json']!,
          _dietaryRestrictionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('allergen_alerts_json')) {
      context.handle(
        _allergenAlertsJsonMeta,
        allergenAlertsJson.isAcceptableOrUnknown(
          data['allergen_alerts_json']!,
          _allergenAlertsJsonMeta,
        ),
      );
    }
    if (data.containsKey('auto_add_to_list')) {
      context.handle(
        _autoAddToListMeta,
        autoAddToList.isAcceptableOrUnknown(
          data['auto_add_to_list']!,
          _autoAddToListMeta,
        ),
      );
    }
    if (data.containsKey('default_quantity')) {
      context.handle(
        _defaultQuantityMeta,
        defaultQuantity.isAcceptableOrUnknown(
          data['default_quantity']!,
          _defaultQuantityMeta,
        ),
      );
    }
    if (data.containsKey('scan_sound')) {
      context.handle(
        _scanSoundMeta,
        scanSound.isAcceptableOrUnknown(data['scan_sound']!, _scanSoundMeta),
      );
    }
    if (data.containsKey('scan_sound_id')) {
      context.handle(
        _scanSoundIdMeta,
        scanSoundId.isAcceptableOrUnknown(
          data['scan_sound_id']!,
          _scanSoundIdMeta,
        ),
      );
    }
    if (data.containsKey('haptic_feedback')) {
      context.handle(
        _hapticFeedbackMeta,
        hapticFeedback.isAcceptableOrUnknown(
          data['haptic_feedback']!,
          _hapticFeedbackMeta,
        ),
      );
    }
    if (data.containsKey('selected_list_id')) {
      context.handle(
        _selectedListIdMeta,
        selectedListId.isAcceptableOrUnknown(
          data['selected_list_id']!,
          _selectedListIdMeta,
        ),
      );
    }
    if (data.containsKey('dismissed_hints_json')) {
      context.handle(
        _dismissedHintsJsonMeta,
        dismissedHintsJson.isAcceptableOrUnknown(
          data['dismissed_hints_json']!,
          _dismissedHintsJsonMeta,
        ),
      );
    }
    if (data.containsKey('sync_enabled')) {
      context.handle(
        _syncEnabledMeta,
        syncEnabled.isAcceptableOrUnknown(
          data['sync_enabled']!,
          _syncEnabledMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('weekly_plan_count')) {
      context.handle(
        _weeklyPlanCountMeta,
        weeklyPlanCount.isAcceptableOrUnknown(
          data['weekly_plan_count']!,
          _weeklyPlanCountMeta,
        ),
      );
    }
    if (data.containsKey('weekly_plan_reset_date')) {
      context.handle(
        _weeklyPlanResetDateMeta,
        weeklyPlanResetDate.isAcceptableOrUnknown(
          data['weekly_plan_reset_date']!,
          _weeklyPlanResetDateMeta,
        ),
      );
    }
    if (data.containsKey('is_premium')) {
      context.handle(
        _isPremiumMeta,
        isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta),
      );
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
        _subscriptionIdMeta,
        subscriptionId.isAcceptableOrUnknown(
          data['subscription_id']!,
          _subscriptionIdMeta,
        ),
      );
    }
    if (data.containsKey('subscription_plan')) {
      context.handle(
        _subscriptionPlanMeta,
        subscriptionPlan.isAcceptableOrUnknown(
          data['subscription_plan']!,
          _subscriptionPlanMeta,
        ),
      );
    }
    if (data.containsKey('subscription_expires_at')) {
      context.handle(
        _subscriptionExpiresAtMeta,
        subscriptionExpiresAt.isAcceptableOrUnknown(
          data['subscription_expires_at']!,
          _subscriptionExpiresAtMeta,
        ),
      );
    }
    if (data.containsKey('voice_persona')) {
      context.handle(
        _voicePersonaMeta,
        voicePersona.isAcceptableOrUnknown(
          data['voice_persona']!,
          _voicePersonaMeta,
        ),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    }
    if (data.containsKey('shared_list_id')) {
      context.handle(
        _sharedListIdMeta,
        sharedListId.isAcceptableOrUnknown(
          data['shared_list_id']!,
          _sharedListIdMeta,
        ),
      );
    }
    if (data.containsKey('shared_pantry_id')) {
      context.handle(
        _sharedPantryIdMeta,
        sharedPantryId.isAcceptableOrUnknown(
          data['shared_pantry_id']!,
          _sharedPantryIdMeta,
        ),
      );
    }
    if (data.containsKey('enable_notifications')) {
      context.handle(
        _enableNotificationsMeta,
        enableNotifications.isAcceptableOrUnknown(
          data['enable_notifications']!,
          _enableNotificationsMeta,
        ),
      );
    }
    if (data.containsKey('notify_sharing_events')) {
      context.handle(
        _notifySharingEventsMeta,
        notifySharingEvents.isAcceptableOrUnknown(
          data['notify_sharing_events']!,
          _notifySharingEventsMeta,
        ),
      );
    }
    if (data.containsKey('notify_expiry_alerts')) {
      context.handle(
        _notifyExpiryAlertsMeta,
        notifyExpiryAlerts.isAcceptableOrUnknown(
          data['notify_expiry_alerts']!,
          _notifyExpiryAlertsMeta,
        ),
      );
    }
    if (data.containsKey('notify_reorder_alerts')) {
      context.handle(
        _notifyReorderAlertsMeta,
        notifyReorderAlerts.isAcceptableOrUnknown(
          data['notify_reorder_alerts']!,
          _notifyReorderAlertsMeta,
        ),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreferencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferencesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      preferredCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_currency'],
      )!,
      dietaryRestrictionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dietary_restrictions_json'],
      )!,
      allergenAlertsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergen_alerts_json'],
      )!,
      autoAddToList: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_add_to_list'],
      )!,
      defaultQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_quantity'],
      )!,
      scanSound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}scan_sound'],
      )!,
      scanSoundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scan_sound_id'],
      )!,
      hapticFeedback: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptic_feedback'],
      )!,
      selectedListId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_list_id'],
      ),
      dismissedHintsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dismissed_hints_json'],
      )!,
      syncEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_enabled'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      weeklyPlanCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_plan_count'],
      )!,
      weeklyPlanResetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}weekly_plan_reset_date'],
      ),
      isPremium: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium'],
      )!,
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      ),
      subscriptionPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_plan'],
      ),
      subscriptionExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}subscription_expires_at'],
      ),
      voicePersona: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_persona'],
      ),
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      sharedListId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_list_id'],
      ),
      sharedPantryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_pantry_id'],
      ),
      enableNotifications: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_notifications'],
      )!,
      notifySharingEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_sharing_events'],
      )!,
      notifyExpiryAlerts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_expiry_alerts'],
      )!,
      notifyReorderAlerts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_reorder_alerts'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferencesTableData extends DataClass
    implements Insertable<UserPreferencesTableData> {
  final int id;
  final String preferredCurrency;
  final String dietaryRestrictionsJson;
  final String allergenAlertsJson;
  final bool autoAddToList;
  final int defaultQuantity;
  final bool scanSound;
  final int scanSoundId;
  final bool hapticFeedback;
  final String? selectedListId;
  final String dismissedHintsJson;
  final bool syncEnabled;
  final bool onboardingCompleted;
  final int weeklyPlanCount;
  final DateTime? weeklyPlanResetDate;
  final bool isPremium;
  final String? subscriptionId;
  final String? subscriptionPlan;
  final DateTime? subscriptionExpiresAt;
  final String? voicePersona;
  final String mealType;
  final String? sharedListId;
  final String? sharedPantryId;
  final bool enableNotifications;
  final bool notifySharingEvents;
  final bool notifyExpiryAlerts;
  final bool notifyReorderAlerts;
  final String theme;
  final String language;
  const UserPreferencesTableData({
    required this.id,
    required this.preferredCurrency,
    required this.dietaryRestrictionsJson,
    required this.allergenAlertsJson,
    required this.autoAddToList,
    required this.defaultQuantity,
    required this.scanSound,
    required this.scanSoundId,
    required this.hapticFeedback,
    this.selectedListId,
    required this.dismissedHintsJson,
    required this.syncEnabled,
    required this.onboardingCompleted,
    required this.weeklyPlanCount,
    this.weeklyPlanResetDate,
    required this.isPremium,
    this.subscriptionId,
    this.subscriptionPlan,
    this.subscriptionExpiresAt,
    this.voicePersona,
    required this.mealType,
    this.sharedListId,
    this.sharedPantryId,
    required this.enableNotifications,
    required this.notifySharingEvents,
    required this.notifyExpiryAlerts,
    required this.notifyReorderAlerts,
    required this.theme,
    required this.language,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['preferred_currency'] = Variable<String>(preferredCurrency);
    map['dietary_restrictions_json'] = Variable<String>(
      dietaryRestrictionsJson,
    );
    map['allergen_alerts_json'] = Variable<String>(allergenAlertsJson);
    map['auto_add_to_list'] = Variable<bool>(autoAddToList);
    map['default_quantity'] = Variable<int>(defaultQuantity);
    map['scan_sound'] = Variable<bool>(scanSound);
    map['scan_sound_id'] = Variable<int>(scanSoundId);
    map['haptic_feedback'] = Variable<bool>(hapticFeedback);
    if (!nullToAbsent || selectedListId != null) {
      map['selected_list_id'] = Variable<String>(selectedListId);
    }
    map['dismissed_hints_json'] = Variable<String>(dismissedHintsJson);
    map['sync_enabled'] = Variable<bool>(syncEnabled);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['weekly_plan_count'] = Variable<int>(weeklyPlanCount);
    if (!nullToAbsent || weeklyPlanResetDate != null) {
      map['weekly_plan_reset_date'] = Variable<DateTime>(weeklyPlanResetDate);
    }
    map['is_premium'] = Variable<bool>(isPremium);
    if (!nullToAbsent || subscriptionId != null) {
      map['subscription_id'] = Variable<String>(subscriptionId);
    }
    if (!nullToAbsent || subscriptionPlan != null) {
      map['subscription_plan'] = Variable<String>(subscriptionPlan);
    }
    if (!nullToAbsent || subscriptionExpiresAt != null) {
      map['subscription_expires_at'] = Variable<DateTime>(
        subscriptionExpiresAt,
      );
    }
    if (!nullToAbsent || voicePersona != null) {
      map['voice_persona'] = Variable<String>(voicePersona);
    }
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || sharedListId != null) {
      map['shared_list_id'] = Variable<String>(sharedListId);
    }
    if (!nullToAbsent || sharedPantryId != null) {
      map['shared_pantry_id'] = Variable<String>(sharedPantryId);
    }
    map['enable_notifications'] = Variable<bool>(enableNotifications);
    map['notify_sharing_events'] = Variable<bool>(notifySharingEvents);
    map['notify_expiry_alerts'] = Variable<bool>(notifyExpiryAlerts);
    map['notify_reorder_alerts'] = Variable<bool>(notifyReorderAlerts);
    map['theme'] = Variable<String>(theme);
    map['language'] = Variable<String>(language);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      id: Value(id),
      preferredCurrency: Value(preferredCurrency),
      dietaryRestrictionsJson: Value(dietaryRestrictionsJson),
      allergenAlertsJson: Value(allergenAlertsJson),
      autoAddToList: Value(autoAddToList),
      defaultQuantity: Value(defaultQuantity),
      scanSound: Value(scanSound),
      scanSoundId: Value(scanSoundId),
      hapticFeedback: Value(hapticFeedback),
      selectedListId: selectedListId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedListId),
      dismissedHintsJson: Value(dismissedHintsJson),
      syncEnabled: Value(syncEnabled),
      onboardingCompleted: Value(onboardingCompleted),
      weeklyPlanCount: Value(weeklyPlanCount),
      weeklyPlanResetDate: weeklyPlanResetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyPlanResetDate),
      isPremium: Value(isPremium),
      subscriptionId: subscriptionId == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionId),
      subscriptionPlan: subscriptionPlan == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionPlan),
      subscriptionExpiresAt: subscriptionExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionExpiresAt),
      voicePersona: voicePersona == null && nullToAbsent
          ? const Value.absent()
          : Value(voicePersona),
      mealType: Value(mealType),
      sharedListId: sharedListId == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedListId),
      sharedPantryId: sharedPantryId == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedPantryId),
      enableNotifications: Value(enableNotifications),
      notifySharingEvents: Value(notifySharingEvents),
      notifyExpiryAlerts: Value(notifyExpiryAlerts),
      notifyReorderAlerts: Value(notifyReorderAlerts),
      theme: Value(theme),
      language: Value(language),
    );
  }

  factory UserPreferencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferencesTableData(
      id: serializer.fromJson<int>(json['id']),
      preferredCurrency: serializer.fromJson<String>(json['preferredCurrency']),
      dietaryRestrictionsJson: serializer.fromJson<String>(
        json['dietaryRestrictionsJson'],
      ),
      allergenAlertsJson: serializer.fromJson<String>(
        json['allergenAlertsJson'],
      ),
      autoAddToList: serializer.fromJson<bool>(json['autoAddToList']),
      defaultQuantity: serializer.fromJson<int>(json['defaultQuantity']),
      scanSound: serializer.fromJson<bool>(json['scanSound']),
      scanSoundId: serializer.fromJson<int>(json['scanSoundId']),
      hapticFeedback: serializer.fromJson<bool>(json['hapticFeedback']),
      selectedListId: serializer.fromJson<String?>(json['selectedListId']),
      dismissedHintsJson: serializer.fromJson<String>(
        json['dismissedHintsJson'],
      ),
      syncEnabled: serializer.fromJson<bool>(json['syncEnabled']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      weeklyPlanCount: serializer.fromJson<int>(json['weeklyPlanCount']),
      weeklyPlanResetDate: serializer.fromJson<DateTime?>(
        json['weeklyPlanResetDate'],
      ),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      subscriptionId: serializer.fromJson<String?>(json['subscriptionId']),
      subscriptionPlan: serializer.fromJson<String?>(json['subscriptionPlan']),
      subscriptionExpiresAt: serializer.fromJson<DateTime?>(
        json['subscriptionExpiresAt'],
      ),
      voicePersona: serializer.fromJson<String?>(json['voicePersona']),
      mealType: serializer.fromJson<String>(json['mealType']),
      sharedListId: serializer.fromJson<String?>(json['sharedListId']),
      sharedPantryId: serializer.fromJson<String?>(json['sharedPantryId']),
      enableNotifications: serializer.fromJson<bool>(
        json['enableNotifications'],
      ),
      notifySharingEvents: serializer.fromJson<bool>(
        json['notifySharingEvents'],
      ),
      notifyExpiryAlerts: serializer.fromJson<bool>(json['notifyExpiryAlerts']),
      notifyReorderAlerts: serializer.fromJson<bool>(
        json['notifyReorderAlerts'],
      ),
      theme: serializer.fromJson<String>(json['theme']),
      language: serializer.fromJson<String>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'preferredCurrency': serializer.toJson<String>(preferredCurrency),
      'dietaryRestrictionsJson': serializer.toJson<String>(
        dietaryRestrictionsJson,
      ),
      'allergenAlertsJson': serializer.toJson<String>(allergenAlertsJson),
      'autoAddToList': serializer.toJson<bool>(autoAddToList),
      'defaultQuantity': serializer.toJson<int>(defaultQuantity),
      'scanSound': serializer.toJson<bool>(scanSound),
      'scanSoundId': serializer.toJson<int>(scanSoundId),
      'hapticFeedback': serializer.toJson<bool>(hapticFeedback),
      'selectedListId': serializer.toJson<String?>(selectedListId),
      'dismissedHintsJson': serializer.toJson<String>(dismissedHintsJson),
      'syncEnabled': serializer.toJson<bool>(syncEnabled),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'weeklyPlanCount': serializer.toJson<int>(weeklyPlanCount),
      'weeklyPlanResetDate': serializer.toJson<DateTime?>(weeklyPlanResetDate),
      'isPremium': serializer.toJson<bool>(isPremium),
      'subscriptionId': serializer.toJson<String?>(subscriptionId),
      'subscriptionPlan': serializer.toJson<String?>(subscriptionPlan),
      'subscriptionExpiresAt': serializer.toJson<DateTime?>(
        subscriptionExpiresAt,
      ),
      'voicePersona': serializer.toJson<String?>(voicePersona),
      'mealType': serializer.toJson<String>(mealType),
      'sharedListId': serializer.toJson<String?>(sharedListId),
      'sharedPantryId': serializer.toJson<String?>(sharedPantryId),
      'enableNotifications': serializer.toJson<bool>(enableNotifications),
      'notifySharingEvents': serializer.toJson<bool>(notifySharingEvents),
      'notifyExpiryAlerts': serializer.toJson<bool>(notifyExpiryAlerts),
      'notifyReorderAlerts': serializer.toJson<bool>(notifyReorderAlerts),
      'theme': serializer.toJson<String>(theme),
      'language': serializer.toJson<String>(language),
    };
  }

  UserPreferencesTableData copyWith({
    int? id,
    String? preferredCurrency,
    String? dietaryRestrictionsJson,
    String? allergenAlertsJson,
    bool? autoAddToList,
    int? defaultQuantity,
    bool? scanSound,
    int? scanSoundId,
    bool? hapticFeedback,
    Value<String?> selectedListId = const Value.absent(),
    String? dismissedHintsJson,
    bool? syncEnabled,
    bool? onboardingCompleted,
    int? weeklyPlanCount,
    Value<DateTime?> weeklyPlanResetDate = const Value.absent(),
    bool? isPremium,
    Value<String?> subscriptionId = const Value.absent(),
    Value<String?> subscriptionPlan = const Value.absent(),
    Value<DateTime?> subscriptionExpiresAt = const Value.absent(),
    Value<String?> voicePersona = const Value.absent(),
    String? mealType,
    Value<String?> sharedListId = const Value.absent(),
    Value<String?> sharedPantryId = const Value.absent(),
    bool? enableNotifications,
    bool? notifySharingEvents,
    bool? notifyExpiryAlerts,
    bool? notifyReorderAlerts,
    String? theme,
    String? language,
  }) => UserPreferencesTableData(
    id: id ?? this.id,
    preferredCurrency: preferredCurrency ?? this.preferredCurrency,
    dietaryRestrictionsJson:
        dietaryRestrictionsJson ?? this.dietaryRestrictionsJson,
    allergenAlertsJson: allergenAlertsJson ?? this.allergenAlertsJson,
    autoAddToList: autoAddToList ?? this.autoAddToList,
    defaultQuantity: defaultQuantity ?? this.defaultQuantity,
    scanSound: scanSound ?? this.scanSound,
    scanSoundId: scanSoundId ?? this.scanSoundId,
    hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    selectedListId: selectedListId.present
        ? selectedListId.value
        : this.selectedListId,
    dismissedHintsJson: dismissedHintsJson ?? this.dismissedHintsJson,
    syncEnabled: syncEnabled ?? this.syncEnabled,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    weeklyPlanCount: weeklyPlanCount ?? this.weeklyPlanCount,
    weeklyPlanResetDate: weeklyPlanResetDate.present
        ? weeklyPlanResetDate.value
        : this.weeklyPlanResetDate,
    isPremium: isPremium ?? this.isPremium,
    subscriptionId: subscriptionId.present
        ? subscriptionId.value
        : this.subscriptionId,
    subscriptionPlan: subscriptionPlan.present
        ? subscriptionPlan.value
        : this.subscriptionPlan,
    subscriptionExpiresAt: subscriptionExpiresAt.present
        ? subscriptionExpiresAt.value
        : this.subscriptionExpiresAt,
    voicePersona: voicePersona.present ? voicePersona.value : this.voicePersona,
    mealType: mealType ?? this.mealType,
    sharedListId: sharedListId.present ? sharedListId.value : this.sharedListId,
    sharedPantryId: sharedPantryId.present
        ? sharedPantryId.value
        : this.sharedPantryId,
    enableNotifications: enableNotifications ?? this.enableNotifications,
    notifySharingEvents: notifySharingEvents ?? this.notifySharingEvents,
    notifyExpiryAlerts: notifyExpiryAlerts ?? this.notifyExpiryAlerts,
    notifyReorderAlerts: notifyReorderAlerts ?? this.notifyReorderAlerts,
    theme: theme ?? this.theme,
    language: language ?? this.language,
  );
  UserPreferencesTableData copyWithCompanion(
    UserPreferencesTableCompanion data,
  ) {
    return UserPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      preferredCurrency: data.preferredCurrency.present
          ? data.preferredCurrency.value
          : this.preferredCurrency,
      dietaryRestrictionsJson: data.dietaryRestrictionsJson.present
          ? data.dietaryRestrictionsJson.value
          : this.dietaryRestrictionsJson,
      allergenAlertsJson: data.allergenAlertsJson.present
          ? data.allergenAlertsJson.value
          : this.allergenAlertsJson,
      autoAddToList: data.autoAddToList.present
          ? data.autoAddToList.value
          : this.autoAddToList,
      defaultQuantity: data.defaultQuantity.present
          ? data.defaultQuantity.value
          : this.defaultQuantity,
      scanSound: data.scanSound.present ? data.scanSound.value : this.scanSound,
      scanSoundId: data.scanSoundId.present
          ? data.scanSoundId.value
          : this.scanSoundId,
      hapticFeedback: data.hapticFeedback.present
          ? data.hapticFeedback.value
          : this.hapticFeedback,
      selectedListId: data.selectedListId.present
          ? data.selectedListId.value
          : this.selectedListId,
      dismissedHintsJson: data.dismissedHintsJson.present
          ? data.dismissedHintsJson.value
          : this.dismissedHintsJson,
      syncEnabled: data.syncEnabled.present
          ? data.syncEnabled.value
          : this.syncEnabled,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      weeklyPlanCount: data.weeklyPlanCount.present
          ? data.weeklyPlanCount.value
          : this.weeklyPlanCount,
      weeklyPlanResetDate: data.weeklyPlanResetDate.present
          ? data.weeklyPlanResetDate.value
          : this.weeklyPlanResetDate,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      subscriptionPlan: data.subscriptionPlan.present
          ? data.subscriptionPlan.value
          : this.subscriptionPlan,
      subscriptionExpiresAt: data.subscriptionExpiresAt.present
          ? data.subscriptionExpiresAt.value
          : this.subscriptionExpiresAt,
      voicePersona: data.voicePersona.present
          ? data.voicePersona.value
          : this.voicePersona,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      sharedListId: data.sharedListId.present
          ? data.sharedListId.value
          : this.sharedListId,
      sharedPantryId: data.sharedPantryId.present
          ? data.sharedPantryId.value
          : this.sharedPantryId,
      enableNotifications: data.enableNotifications.present
          ? data.enableNotifications.value
          : this.enableNotifications,
      notifySharingEvents: data.notifySharingEvents.present
          ? data.notifySharingEvents.value
          : this.notifySharingEvents,
      notifyExpiryAlerts: data.notifyExpiryAlerts.present
          ? data.notifyExpiryAlerts.value
          : this.notifyExpiryAlerts,
      notifyReorderAlerts: data.notifyReorderAlerts.present
          ? data.notifyReorderAlerts.value
          : this.notifyReorderAlerts,
      theme: data.theme.present ? data.theme.value : this.theme,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableData(')
          ..write('id: $id, ')
          ..write('preferredCurrency: $preferredCurrency, ')
          ..write('dietaryRestrictionsJson: $dietaryRestrictionsJson, ')
          ..write('allergenAlertsJson: $allergenAlertsJson, ')
          ..write('autoAddToList: $autoAddToList, ')
          ..write('defaultQuantity: $defaultQuantity, ')
          ..write('scanSound: $scanSound, ')
          ..write('scanSoundId: $scanSoundId, ')
          ..write('hapticFeedback: $hapticFeedback, ')
          ..write('selectedListId: $selectedListId, ')
          ..write('dismissedHintsJson: $dismissedHintsJson, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('weeklyPlanCount: $weeklyPlanCount, ')
          ..write('weeklyPlanResetDate: $weeklyPlanResetDate, ')
          ..write('isPremium: $isPremium, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('subscriptionPlan: $subscriptionPlan, ')
          ..write('subscriptionExpiresAt: $subscriptionExpiresAt, ')
          ..write('voicePersona: $voicePersona, ')
          ..write('mealType: $mealType, ')
          ..write('sharedListId: $sharedListId, ')
          ..write('sharedPantryId: $sharedPantryId, ')
          ..write('enableNotifications: $enableNotifications, ')
          ..write('notifySharingEvents: $notifySharingEvents, ')
          ..write('notifyExpiryAlerts: $notifyExpiryAlerts, ')
          ..write('notifyReorderAlerts: $notifyReorderAlerts, ')
          ..write('theme: $theme, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    preferredCurrency,
    dietaryRestrictionsJson,
    allergenAlertsJson,
    autoAddToList,
    defaultQuantity,
    scanSound,
    scanSoundId,
    hapticFeedback,
    selectedListId,
    dismissedHintsJson,
    syncEnabled,
    onboardingCompleted,
    weeklyPlanCount,
    weeklyPlanResetDate,
    isPremium,
    subscriptionId,
    subscriptionPlan,
    subscriptionExpiresAt,
    voicePersona,
    mealType,
    sharedListId,
    sharedPantryId,
    enableNotifications,
    notifySharingEvents,
    notifyExpiryAlerts,
    notifyReorderAlerts,
    theme,
    language,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferencesTableData &&
          other.id == this.id &&
          other.preferredCurrency == this.preferredCurrency &&
          other.dietaryRestrictionsJson == this.dietaryRestrictionsJson &&
          other.allergenAlertsJson == this.allergenAlertsJson &&
          other.autoAddToList == this.autoAddToList &&
          other.defaultQuantity == this.defaultQuantity &&
          other.scanSound == this.scanSound &&
          other.scanSoundId == this.scanSoundId &&
          other.hapticFeedback == this.hapticFeedback &&
          other.selectedListId == this.selectedListId &&
          other.dismissedHintsJson == this.dismissedHintsJson &&
          other.syncEnabled == this.syncEnabled &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.weeklyPlanCount == this.weeklyPlanCount &&
          other.weeklyPlanResetDate == this.weeklyPlanResetDate &&
          other.isPremium == this.isPremium &&
          other.subscriptionId == this.subscriptionId &&
          other.subscriptionPlan == this.subscriptionPlan &&
          other.subscriptionExpiresAt == this.subscriptionExpiresAt &&
          other.voicePersona == this.voicePersona &&
          other.mealType == this.mealType &&
          other.sharedListId == this.sharedListId &&
          other.sharedPantryId == this.sharedPantryId &&
          other.enableNotifications == this.enableNotifications &&
          other.notifySharingEvents == this.notifySharingEvents &&
          other.notifyExpiryAlerts == this.notifyExpiryAlerts &&
          other.notifyReorderAlerts == this.notifyReorderAlerts &&
          other.theme == this.theme &&
          other.language == this.language);
}

class UserPreferencesTableCompanion
    extends UpdateCompanion<UserPreferencesTableData> {
  final Value<int> id;
  final Value<String> preferredCurrency;
  final Value<String> dietaryRestrictionsJson;
  final Value<String> allergenAlertsJson;
  final Value<bool> autoAddToList;
  final Value<int> defaultQuantity;
  final Value<bool> scanSound;
  final Value<int> scanSoundId;
  final Value<bool> hapticFeedback;
  final Value<String?> selectedListId;
  final Value<String> dismissedHintsJson;
  final Value<bool> syncEnabled;
  final Value<bool> onboardingCompleted;
  final Value<int> weeklyPlanCount;
  final Value<DateTime?> weeklyPlanResetDate;
  final Value<bool> isPremium;
  final Value<String?> subscriptionId;
  final Value<String?> subscriptionPlan;
  final Value<DateTime?> subscriptionExpiresAt;
  final Value<String?> voicePersona;
  final Value<String> mealType;
  final Value<String?> sharedListId;
  final Value<String?> sharedPantryId;
  final Value<bool> enableNotifications;
  final Value<bool> notifySharingEvents;
  final Value<bool> notifyExpiryAlerts;
  final Value<bool> notifyReorderAlerts;
  final Value<String> theme;
  final Value<String> language;
  const UserPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.preferredCurrency = const Value.absent(),
    this.dietaryRestrictionsJson = const Value.absent(),
    this.allergenAlertsJson = const Value.absent(),
    this.autoAddToList = const Value.absent(),
    this.defaultQuantity = const Value.absent(),
    this.scanSound = const Value.absent(),
    this.scanSoundId = const Value.absent(),
    this.hapticFeedback = const Value.absent(),
    this.selectedListId = const Value.absent(),
    this.dismissedHintsJson = const Value.absent(),
    this.syncEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.weeklyPlanCount = const Value.absent(),
    this.weeklyPlanResetDate = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.subscriptionPlan = const Value.absent(),
    this.subscriptionExpiresAt = const Value.absent(),
    this.voicePersona = const Value.absent(),
    this.mealType = const Value.absent(),
    this.sharedListId = const Value.absent(),
    this.sharedPantryId = const Value.absent(),
    this.enableNotifications = const Value.absent(),
    this.notifySharingEvents = const Value.absent(),
    this.notifyExpiryAlerts = const Value.absent(),
    this.notifyReorderAlerts = const Value.absent(),
    this.theme = const Value.absent(),
    this.language = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    this.preferredCurrency = const Value.absent(),
    this.dietaryRestrictionsJson = const Value.absent(),
    this.allergenAlertsJson = const Value.absent(),
    this.autoAddToList = const Value.absent(),
    this.defaultQuantity = const Value.absent(),
    this.scanSound = const Value.absent(),
    this.scanSoundId = const Value.absent(),
    this.hapticFeedback = const Value.absent(),
    this.selectedListId = const Value.absent(),
    this.dismissedHintsJson = const Value.absent(),
    this.syncEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.weeklyPlanCount = const Value.absent(),
    this.weeklyPlanResetDate = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.subscriptionPlan = const Value.absent(),
    this.subscriptionExpiresAt = const Value.absent(),
    this.voicePersona = const Value.absent(),
    this.mealType = const Value.absent(),
    this.sharedListId = const Value.absent(),
    this.sharedPantryId = const Value.absent(),
    this.enableNotifications = const Value.absent(),
    this.notifySharingEvents = const Value.absent(),
    this.notifyExpiryAlerts = const Value.absent(),
    this.notifyReorderAlerts = const Value.absent(),
    this.theme = const Value.absent(),
    this.language = const Value.absent(),
  });
  static Insertable<UserPreferencesTableData> custom({
    Expression<int>? id,
    Expression<String>? preferredCurrency,
    Expression<String>? dietaryRestrictionsJson,
    Expression<String>? allergenAlertsJson,
    Expression<bool>? autoAddToList,
    Expression<int>? defaultQuantity,
    Expression<bool>? scanSound,
    Expression<int>? scanSoundId,
    Expression<bool>? hapticFeedback,
    Expression<String>? selectedListId,
    Expression<String>? dismissedHintsJson,
    Expression<bool>? syncEnabled,
    Expression<bool>? onboardingCompleted,
    Expression<int>? weeklyPlanCount,
    Expression<DateTime>? weeklyPlanResetDate,
    Expression<bool>? isPremium,
    Expression<String>? subscriptionId,
    Expression<String>? subscriptionPlan,
    Expression<DateTime>? subscriptionExpiresAt,
    Expression<String>? voicePersona,
    Expression<String>? mealType,
    Expression<String>? sharedListId,
    Expression<String>? sharedPantryId,
    Expression<bool>? enableNotifications,
    Expression<bool>? notifySharingEvents,
    Expression<bool>? notifyExpiryAlerts,
    Expression<bool>? notifyReorderAlerts,
    Expression<String>? theme,
    Expression<String>? language,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preferredCurrency != null) 'preferred_currency': preferredCurrency,
      if (dietaryRestrictionsJson != null)
        'dietary_restrictions_json': dietaryRestrictionsJson,
      if (allergenAlertsJson != null)
        'allergen_alerts_json': allergenAlertsJson,
      if (autoAddToList != null) 'auto_add_to_list': autoAddToList,
      if (defaultQuantity != null) 'default_quantity': defaultQuantity,
      if (scanSound != null) 'scan_sound': scanSound,
      if (scanSoundId != null) 'scan_sound_id': scanSoundId,
      if (hapticFeedback != null) 'haptic_feedback': hapticFeedback,
      if (selectedListId != null) 'selected_list_id': selectedListId,
      if (dismissedHintsJson != null)
        'dismissed_hints_json': dismissedHintsJson,
      if (syncEnabled != null) 'sync_enabled': syncEnabled,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (weeklyPlanCount != null) 'weekly_plan_count': weeklyPlanCount,
      if (weeklyPlanResetDate != null)
        'weekly_plan_reset_date': weeklyPlanResetDate,
      if (isPremium != null) 'is_premium': isPremium,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (subscriptionPlan != null) 'subscription_plan': subscriptionPlan,
      if (subscriptionExpiresAt != null)
        'subscription_expires_at': subscriptionExpiresAt,
      if (voicePersona != null) 'voice_persona': voicePersona,
      if (mealType != null) 'meal_type': mealType,
      if (sharedListId != null) 'shared_list_id': sharedListId,
      if (sharedPantryId != null) 'shared_pantry_id': sharedPantryId,
      if (enableNotifications != null)
        'enable_notifications': enableNotifications,
      if (notifySharingEvents != null)
        'notify_sharing_events': notifySharingEvents,
      if (notifyExpiryAlerts != null)
        'notify_expiry_alerts': notifyExpiryAlerts,
      if (notifyReorderAlerts != null)
        'notify_reorder_alerts': notifyReorderAlerts,
      if (theme != null) 'theme': theme,
      if (language != null) 'language': language,
    });
  }

  UserPreferencesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? preferredCurrency,
    Value<String>? dietaryRestrictionsJson,
    Value<String>? allergenAlertsJson,
    Value<bool>? autoAddToList,
    Value<int>? defaultQuantity,
    Value<bool>? scanSound,
    Value<int>? scanSoundId,
    Value<bool>? hapticFeedback,
    Value<String?>? selectedListId,
    Value<String>? dismissedHintsJson,
    Value<bool>? syncEnabled,
    Value<bool>? onboardingCompleted,
    Value<int>? weeklyPlanCount,
    Value<DateTime?>? weeklyPlanResetDate,
    Value<bool>? isPremium,
    Value<String?>? subscriptionId,
    Value<String?>? subscriptionPlan,
    Value<DateTime?>? subscriptionExpiresAt,
    Value<String?>? voicePersona,
    Value<String>? mealType,
    Value<String?>? sharedListId,
    Value<String?>? sharedPantryId,
    Value<bool>? enableNotifications,
    Value<bool>? notifySharingEvents,
    Value<bool>? notifyExpiryAlerts,
    Value<bool>? notifyReorderAlerts,
    Value<String>? theme,
    Value<String>? language,
  }) {
    return UserPreferencesTableCompanion(
      id: id ?? this.id,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      dietaryRestrictionsJson:
          dietaryRestrictionsJson ?? this.dietaryRestrictionsJson,
      allergenAlertsJson: allergenAlertsJson ?? this.allergenAlertsJson,
      autoAddToList: autoAddToList ?? this.autoAddToList,
      defaultQuantity: defaultQuantity ?? this.defaultQuantity,
      scanSound: scanSound ?? this.scanSound,
      scanSoundId: scanSoundId ?? this.scanSoundId,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      selectedListId: selectedListId ?? this.selectedListId,
      dismissedHintsJson: dismissedHintsJson ?? this.dismissedHintsJson,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      weeklyPlanCount: weeklyPlanCount ?? this.weeklyPlanCount,
      weeklyPlanResetDate: weeklyPlanResetDate ?? this.weeklyPlanResetDate,
      isPremium: isPremium ?? this.isPremium,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      voicePersona: voicePersona ?? this.voicePersona,
      mealType: mealType ?? this.mealType,
      sharedListId: sharedListId ?? this.sharedListId,
      sharedPantryId: sharedPantryId ?? this.sharedPantryId,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notifySharingEvents: notifySharingEvents ?? this.notifySharingEvents,
      notifyExpiryAlerts: notifyExpiryAlerts ?? this.notifyExpiryAlerts,
      notifyReorderAlerts: notifyReorderAlerts ?? this.notifyReorderAlerts,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preferredCurrency.present) {
      map['preferred_currency'] = Variable<String>(preferredCurrency.value);
    }
    if (dietaryRestrictionsJson.present) {
      map['dietary_restrictions_json'] = Variable<String>(
        dietaryRestrictionsJson.value,
      );
    }
    if (allergenAlertsJson.present) {
      map['allergen_alerts_json'] = Variable<String>(allergenAlertsJson.value);
    }
    if (autoAddToList.present) {
      map['auto_add_to_list'] = Variable<bool>(autoAddToList.value);
    }
    if (defaultQuantity.present) {
      map['default_quantity'] = Variable<int>(defaultQuantity.value);
    }
    if (scanSound.present) {
      map['scan_sound'] = Variable<bool>(scanSound.value);
    }
    if (scanSoundId.present) {
      map['scan_sound_id'] = Variable<int>(scanSoundId.value);
    }
    if (hapticFeedback.present) {
      map['haptic_feedback'] = Variable<bool>(hapticFeedback.value);
    }
    if (selectedListId.present) {
      map['selected_list_id'] = Variable<String>(selectedListId.value);
    }
    if (dismissedHintsJson.present) {
      map['dismissed_hints_json'] = Variable<String>(dismissedHintsJson.value);
    }
    if (syncEnabled.present) {
      map['sync_enabled'] = Variable<bool>(syncEnabled.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (weeklyPlanCount.present) {
      map['weekly_plan_count'] = Variable<int>(weeklyPlanCount.value);
    }
    if (weeklyPlanResetDate.present) {
      map['weekly_plan_reset_date'] = Variable<DateTime>(
        weeklyPlanResetDate.value,
      );
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (subscriptionPlan.present) {
      map['subscription_plan'] = Variable<String>(subscriptionPlan.value);
    }
    if (subscriptionExpiresAt.present) {
      map['subscription_expires_at'] = Variable<DateTime>(
        subscriptionExpiresAt.value,
      );
    }
    if (voicePersona.present) {
      map['voice_persona'] = Variable<String>(voicePersona.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (sharedListId.present) {
      map['shared_list_id'] = Variable<String>(sharedListId.value);
    }
    if (sharedPantryId.present) {
      map['shared_pantry_id'] = Variable<String>(sharedPantryId.value);
    }
    if (enableNotifications.present) {
      map['enable_notifications'] = Variable<bool>(enableNotifications.value);
    }
    if (notifySharingEvents.present) {
      map['notify_sharing_events'] = Variable<bool>(notifySharingEvents.value);
    }
    if (notifyExpiryAlerts.present) {
      map['notify_expiry_alerts'] = Variable<bool>(notifyExpiryAlerts.value);
    }
    if (notifyReorderAlerts.present) {
      map['notify_reorder_alerts'] = Variable<bool>(notifyReorderAlerts.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('preferredCurrency: $preferredCurrency, ')
          ..write('dietaryRestrictionsJson: $dietaryRestrictionsJson, ')
          ..write('allergenAlertsJson: $allergenAlertsJson, ')
          ..write('autoAddToList: $autoAddToList, ')
          ..write('defaultQuantity: $defaultQuantity, ')
          ..write('scanSound: $scanSound, ')
          ..write('scanSoundId: $scanSoundId, ')
          ..write('hapticFeedback: $hapticFeedback, ')
          ..write('selectedListId: $selectedListId, ')
          ..write('dismissedHintsJson: $dismissedHintsJson, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('weeklyPlanCount: $weeklyPlanCount, ')
          ..write('weeklyPlanResetDate: $weeklyPlanResetDate, ')
          ..write('isPremium: $isPremium, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('subscriptionPlan: $subscriptionPlan, ')
          ..write('subscriptionExpiresAt: $subscriptionExpiresAt, ')
          ..write('voicePersona: $voicePersona, ')
          ..write('mealType: $mealType, ')
          ..write('sharedListId: $sharedListId, ')
          ..write('sharedPantryId: $sharedPantryId, ')
          ..write('enableNotifications: $enableNotifications, ')
          ..write('notifySharingEvents: $notifySharingEvents, ')
          ..write('notifyExpiryAlerts: $notifyExpiryAlerts, ')
          ..write('notifyReorderAlerts: $notifyReorderAlerts, ')
          ..write('theme: $theme, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }
}

class $PurchaseHistoriesTable extends PurchaseHistories
    with TableInfo<$PurchaseHistoriesTable, PurchaseHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateFirstPurchasedMeta =
      const VerificationMeta('dateFirstPurchased');
  @override
  late final GeneratedColumn<DateTime> dateFirstPurchased =
      GeneratedColumn<DateTime>(
        'date_first_purchased',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dateLastPurchasedMeta = const VerificationMeta(
    'dateLastPurchased',
  );
  @override
  late final GeneratedColumn<DateTime> dateLastPurchased =
      GeneratedColumn<DateTime>(
        'date_last_purchased',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    barcode,
    productName,
    brand,
    productId,
    dateFirstPurchased,
    dateLastPurchased,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('date_first_purchased')) {
      context.handle(
        _dateFirstPurchasedMeta,
        dateFirstPurchased.isAcceptableOrUnknown(
          data['date_first_purchased']!,
          _dateFirstPurchasedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateFirstPurchasedMeta);
    }
    if (data.containsKey('date_last_purchased')) {
      context.handle(
        _dateLastPurchasedMeta,
        dateLastPurchased.isAcceptableOrUnknown(
          data['date_last_purchased']!,
          _dateLastPurchasedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateLastPurchasedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      dateFirstPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_first_purchased'],
      )!,
      dateLastPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_last_purchased'],
      )!,
    );
  }

  @override
  $PurchaseHistoriesTable createAlias(String alias) {
    return $PurchaseHistoriesTable(attachedDatabase, alias);
  }
}

class PurchaseHistory extends DataClass implements Insertable<PurchaseHistory> {
  final String id;
  final String? barcode;
  final String productName;
  final String? brand;
  final String? productId;
  final DateTime dateFirstPurchased;
  final DateTime dateLastPurchased;
  const PurchaseHistory({
    required this.id,
    this.barcode,
    required this.productName,
    this.brand,
    this.productId,
    required this.dateFirstPurchased,
    required this.dateLastPurchased,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['date_first_purchased'] = Variable<DateTime>(dateFirstPurchased);
    map['date_last_purchased'] = Variable<DateTime>(dateLastPurchased);
    return map;
  }

  PurchaseHistoriesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseHistoriesCompanion(
      id: Value(id),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      productName: Value(productName),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      dateFirstPurchased: Value(dateFirstPurchased),
      dateLastPurchased: Value(dateLastPurchased),
    );
  }

  factory PurchaseHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseHistory(
      id: serializer.fromJson<String>(json['id']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      productName: serializer.fromJson<String>(json['productName']),
      brand: serializer.fromJson<String?>(json['brand']),
      productId: serializer.fromJson<String?>(json['productId']),
      dateFirstPurchased: serializer.fromJson<DateTime>(
        json['dateFirstPurchased'],
      ),
      dateLastPurchased: serializer.fromJson<DateTime>(
        json['dateLastPurchased'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'barcode': serializer.toJson<String?>(barcode),
      'productName': serializer.toJson<String>(productName),
      'brand': serializer.toJson<String?>(brand),
      'productId': serializer.toJson<String?>(productId),
      'dateFirstPurchased': serializer.toJson<DateTime>(dateFirstPurchased),
      'dateLastPurchased': serializer.toJson<DateTime>(dateLastPurchased),
    };
  }

  PurchaseHistory copyWith({
    String? id,
    Value<String?> barcode = const Value.absent(),
    String? productName,
    Value<String?> brand = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    DateTime? dateFirstPurchased,
    DateTime? dateLastPurchased,
  }) => PurchaseHistory(
    id: id ?? this.id,
    barcode: barcode.present ? barcode.value : this.barcode,
    productName: productName ?? this.productName,
    brand: brand.present ? brand.value : this.brand,
    productId: productId.present ? productId.value : this.productId,
    dateFirstPurchased: dateFirstPurchased ?? this.dateFirstPurchased,
    dateLastPurchased: dateLastPurchased ?? this.dateLastPurchased,
  );
  PurchaseHistory copyWithCompanion(PurchaseHistoriesCompanion data) {
    return PurchaseHistory(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      brand: data.brand.present ? data.brand.value : this.brand,
      productId: data.productId.present ? data.productId.value : this.productId,
      dateFirstPurchased: data.dateFirstPurchased.present
          ? data.dateFirstPurchased.value
          : this.dateFirstPurchased,
      dateLastPurchased: data.dateLastPurchased.present
          ? data.dateLastPurchased.value
          : this.dateLastPurchased,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHistory(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('productName: $productName, ')
          ..write('brand: $brand, ')
          ..write('productId: $productId, ')
          ..write('dateFirstPurchased: $dateFirstPurchased, ')
          ..write('dateLastPurchased: $dateLastPurchased')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    barcode,
    productName,
    brand,
    productId,
    dateFirstPurchased,
    dateLastPurchased,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseHistory &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.productName == this.productName &&
          other.brand == this.brand &&
          other.productId == this.productId &&
          other.dateFirstPurchased == this.dateFirstPurchased &&
          other.dateLastPurchased == this.dateLastPurchased);
}

class PurchaseHistoriesCompanion extends UpdateCompanion<PurchaseHistory> {
  final Value<String> id;
  final Value<String?> barcode;
  final Value<String> productName;
  final Value<String?> brand;
  final Value<String?> productId;
  final Value<DateTime> dateFirstPurchased;
  final Value<DateTime> dateLastPurchased;
  final Value<int> rowid;
  const PurchaseHistoriesCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.productName = const Value.absent(),
    this.brand = const Value.absent(),
    this.productId = const Value.absent(),
    this.dateFirstPurchased = const Value.absent(),
    this.dateLastPurchased = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseHistoriesCompanion.insert({
    required String id,
    this.barcode = const Value.absent(),
    required String productName,
    this.brand = const Value.absent(),
    this.productId = const Value.absent(),
    required DateTime dateFirstPurchased,
    required DateTime dateLastPurchased,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productName = Value(productName),
       dateFirstPurchased = Value(dateFirstPurchased),
       dateLastPurchased = Value(dateLastPurchased);
  static Insertable<PurchaseHistory> custom({
    Expression<String>? id,
    Expression<String>? barcode,
    Expression<String>? productName,
    Expression<String>? brand,
    Expression<String>? productId,
    Expression<DateTime>? dateFirstPurchased,
    Expression<DateTime>? dateLastPurchased,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (productName != null) 'product_name': productName,
      if (brand != null) 'brand': brand,
      if (productId != null) 'product_id': productId,
      if (dateFirstPurchased != null)
        'date_first_purchased': dateFirstPurchased,
      if (dateLastPurchased != null) 'date_last_purchased': dateLastPurchased,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseHistoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? barcode,
    Value<String>? productName,
    Value<String?>? brand,
    Value<String?>? productId,
    Value<DateTime>? dateFirstPurchased,
    Value<DateTime>? dateLastPurchased,
    Value<int>? rowid,
  }) {
    return PurchaseHistoriesCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      productId: productId ?? this.productId,
      dateFirstPurchased: dateFirstPurchased ?? this.dateFirstPurchased,
      dateLastPurchased: dateLastPurchased ?? this.dateLastPurchased,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (dateFirstPurchased.present) {
      map['date_first_purchased'] = Variable<DateTime>(
        dateFirstPurchased.value,
      );
    }
    if (dateLastPurchased.present) {
      map['date_last_purchased'] = Variable<DateTime>(dateLastPurchased.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('productName: $productName, ')
          ..write('brand: $brand, ')
          ..write('productId: $productId, ')
          ..write('dateFirstPurchased: $dateFirstPurchased, ')
          ..write('dateLastPurchased: $dateLastPurchased, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseRecordsTable extends PurchaseRecords
    with TableInfo<$PurchaseRecordsTable, PurchaseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _historyIdMeta = const VerificationMeta(
    'historyId',
  );
  @override
  late final GeneratedColumn<String> historyId = GeneratedColumn<String>(
    'history_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_histories (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _datePurchasedMeta = const VerificationMeta(
    'datePurchased',
  );
  @override
  late final GeneratedColumn<DateTime> datePurchased =
      GeneratedColumn<DateTime>(
        'date_purchased',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    historyId,
    quantity,
    price,
    datePurchased,
    storeName,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('history_id')) {
      context.handle(
        _historyIdMeta,
        historyId.isAcceptableOrUnknown(data['history_id']!, _historyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_historyIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('date_purchased')) {
      context.handle(
        _datePurchasedMeta,
        datePurchased.isAcceptableOrUnknown(
          data['date_purchased']!,
          _datePurchasedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datePurchasedMeta);
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      historyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}history_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      datePurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_purchased'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PurchaseRecordsTable createAlias(String alias) {
    return $PurchaseRecordsTable(attachedDatabase, alias);
  }
}

class PurchaseRecord extends DataClass implements Insertable<PurchaseRecord> {
  final String id;
  final String historyId;
  final double quantity;
  final double? price;
  final DateTime datePurchased;
  final String? storeName;
  final String? notes;
  const PurchaseRecord({
    required this.id,
    required this.historyId,
    required this.quantity,
    this.price,
    required this.datePurchased,
    this.storeName,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['history_id'] = Variable<String>(historyId);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    map['date_purchased'] = Variable<DateTime>(datePurchased);
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PurchaseRecordsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseRecordsCompanion(
      id: Value(id),
      historyId: Value(historyId),
      quantity: Value(quantity),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      datePurchased: Value(datePurchased),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PurchaseRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseRecord(
      id: serializer.fromJson<String>(json['id']),
      historyId: serializer.fromJson<String>(json['historyId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double?>(json['price']),
      datePurchased: serializer.fromJson<DateTime>(json['datePurchased']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'historyId': serializer.toJson<String>(historyId),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double?>(price),
      'datePurchased': serializer.toJson<DateTime>(datePurchased),
      'storeName': serializer.toJson<String?>(storeName),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PurchaseRecord copyWith({
    String? id,
    String? historyId,
    double? quantity,
    Value<double?> price = const Value.absent(),
    DateTime? datePurchased,
    Value<String?> storeName = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => PurchaseRecord(
    id: id ?? this.id,
    historyId: historyId ?? this.historyId,
    quantity: quantity ?? this.quantity,
    price: price.present ? price.value : this.price,
    datePurchased: datePurchased ?? this.datePurchased,
    storeName: storeName.present ? storeName.value : this.storeName,
    notes: notes.present ? notes.value : this.notes,
  );
  PurchaseRecord copyWithCompanion(PurchaseRecordsCompanion data) {
    return PurchaseRecord(
      id: data.id.present ? data.id.value : this.id,
      historyId: data.historyId.present ? data.historyId.value : this.historyId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      datePurchased: data.datePurchased.present
          ? data.datePurchased.value
          : this.datePurchased,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseRecord(')
          ..write('id: $id, ')
          ..write('historyId: $historyId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('datePurchased: $datePurchased, ')
          ..write('storeName: $storeName, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    historyId,
    quantity,
    price,
    datePurchased,
    storeName,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseRecord &&
          other.id == this.id &&
          other.historyId == this.historyId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.datePurchased == this.datePurchased &&
          other.storeName == this.storeName &&
          other.notes == this.notes);
}

class PurchaseRecordsCompanion extends UpdateCompanion<PurchaseRecord> {
  final Value<String> id;
  final Value<String> historyId;
  final Value<double> quantity;
  final Value<double?> price;
  final Value<DateTime> datePurchased;
  final Value<String?> storeName;
  final Value<String?> notes;
  final Value<int> rowid;
  const PurchaseRecordsCompanion({
    this.id = const Value.absent(),
    this.historyId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.datePurchased = const Value.absent(),
    this.storeName = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseRecordsCompanion.insert({
    required String id,
    required String historyId,
    required double quantity,
    this.price = const Value.absent(),
    required DateTime datePurchased,
    this.storeName = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       historyId = Value(historyId),
       quantity = Value(quantity),
       datePurchased = Value(datePurchased);
  static Insertable<PurchaseRecord> custom({
    Expression<String>? id,
    Expression<String>? historyId,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<DateTime>? datePurchased,
    Expression<String>? storeName,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (historyId != null) 'history_id': historyId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (datePurchased != null) 'date_purchased': datePurchased,
      if (storeName != null) 'store_name': storeName,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? historyId,
    Value<double>? quantity,
    Value<double?>? price,
    Value<DateTime>? datePurchased,
    Value<String?>? storeName,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return PurchaseRecordsCompanion(
      id: id ?? this.id,
      historyId: historyId ?? this.historyId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      datePurchased: datePurchased ?? this.datePurchased,
      storeName: storeName ?? this.storeName,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (historyId.present) {
      map['history_id'] = Variable<String>(historyId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (datePurchased.present) {
      map['date_purchased'] = Variable<DateTime>(datePurchased.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('historyId: $historyId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('datePurchased: $datePurchased, ')
          ..write('storeName: $storeName, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    period,
    amount,
    startDate,
    endDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String period;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  const Budget({
    required this.id,
    required this.period,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['period'] = Variable<String>(period);
    map['amount'] = Variable<double>(amount);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      period: Value(period),
      amount: Value(amount),
      startDate: Value(startDate),
      endDate: Value(endDate),
      createdAt: Value(createdAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      period: serializer.fromJson<String>(json['period']),
      amount: serializer.fromJson<double>(json['amount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'period': serializer.toJson<String>(period),
      'amount': serializer.toJson<double>(amount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Budget copyWith({
    String? id,
    String? period,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) => Budget(
    id: id ?? this.id,
    period: period ?? this.period,
    amount: amount ?? this.amount,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    createdAt: createdAt ?? this.createdAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      period: data.period.present ? data.period.value : this.period,
      amount: data.amount.present ? data.amount.value : this.amount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('period: $period, ')
          ..write('amount: $amount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, period, amount, startDate, endDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.period == this.period &&
          other.amount == this.amount &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> period;
  final Value<double> amount;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.period = const Value.absent(),
    this.amount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    this.period = const Value.absent(),
    required double amount,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       startDate = Value(startDate),
       endDate = Value(endDate),
       createdAt = Value(createdAt);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? period,
    Expression<double>? amount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (period != null) 'period': period,
      if (amount != null) 'amount': amount,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? period,
    Value<double>? amount,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      period: period ?? this.period,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('period: $period, ')
          ..write('amount: $amount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetEntriesTable extends BudgetEntries
    with TableInfo<$BudgetEntriesTable, BudgetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budgets (id)',
    ),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, listId, amount, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $BudgetEntriesTable createAlias(String alias) {
    return $BudgetEntriesTable(attachedDatabase, alias);
  }
}

class BudgetEntry extends DataClass implements Insertable<BudgetEntry> {
  final String id;
  final String budgetId;
  final String? listId;
  final double amount;
  final DateTime date;
  const BudgetEntry({
    required this.id,
    required this.budgetId,
    this.listId,
    required this.amount,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<String>(listId);
    }
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  BudgetEntriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetEntriesCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
      amount: Value(amount),
      date: Value(date),
    );
  }

  factory BudgetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntry(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      listId: serializer.fromJson<String?>(json['listId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'listId': serializer.toJson<String?>(listId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  BudgetEntry copyWith({
    String? id,
    String? budgetId,
    Value<String?> listId = const Value.absent(),
    double? amount,
    DateTime? date,
  }) => BudgetEntry(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    listId: listId.present ? listId.value : this.listId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
  );
  BudgetEntry copyWithCompanion(BudgetEntriesCompanion data) {
    return BudgetEntry(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      listId: data.listId.present ? data.listId.value : this.listId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntry(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('listId: $listId, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, listId, amount, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntry &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.listId == this.listId &&
          other.amount == this.amount &&
          other.date == this.date);
}

class BudgetEntriesCompanion extends UpdateCompanion<BudgetEntry> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String?> listId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<int> rowid;
  const BudgetEntriesCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.listId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetEntriesCompanion.insert({
    required String id,
    required String budgetId,
    this.listId = const Value.absent(),
    required double amount,
    required DateTime date,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<BudgetEntry> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? listId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (listId != null) 'list_id': listId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String?>? listId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<int>? rowid,
  }) {
    return BudgetEntriesCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      listId: listId ?? this.listId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('listId: $listId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoresTable extends Stores with TableInfo<$StoresTable, Store> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('grocery'),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _preferredCurrencyMeta = const VerificationMeta(
    'preferredCurrency',
  );
  @override
  late final GeneratedColumn<String> preferredCurrency =
      GeneratedColumn<String>(
        'preferred_currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('USD'),
      );
  static const VerificationMeta _supportsTaxExemptMeta = const VerificationMeta(
    'supportsTaxExempt',
  );
  @override
  late final GeneratedColumn<bool> supportsTaxExempt = GeneratedColumn<bool>(
    'supports_tax_exempt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_tax_exempt" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasDeliveryMeta = const VerificationMeta(
    'hasDelivery',
  );
  @override
  late final GeneratedColumn<bool> hasDelivery = GeneratedColumn<bool>(
    'has_delivery',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_delivery" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasPickupMeta = const VerificationMeta(
    'hasPickup',
  );
  @override
  late final GeneratedColumn<bool> hasPickup = GeneratedColumn<bool>(
    'has_pickup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_pickup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    address,
    phoneNumber,
    website,
    isActive,
    preferredCurrency,
    supportsTaxExempt,
    hasDelivery,
    hasPickup,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Store> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('preferred_currency')) {
      context.handle(
        _preferredCurrencyMeta,
        preferredCurrency.isAcceptableOrUnknown(
          data['preferred_currency']!,
          _preferredCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('supports_tax_exempt')) {
      context.handle(
        _supportsTaxExemptMeta,
        supportsTaxExempt.isAcceptableOrUnknown(
          data['supports_tax_exempt']!,
          _supportsTaxExemptMeta,
        ),
      );
    }
    if (data.containsKey('has_delivery')) {
      context.handle(
        _hasDeliveryMeta,
        hasDelivery.isAcceptableOrUnknown(
          data['has_delivery']!,
          _hasDeliveryMeta,
        ),
      );
    }
    if (data.containsKey('has_pickup')) {
      context.handle(
        _hasPickupMeta,
        hasPickup.isAcceptableOrUnknown(data['has_pickup']!, _hasPickupMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Store map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Store(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      preferredCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_currency'],
      )!,
      supportsTaxExempt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_tax_exempt'],
      )!,
      hasDelivery: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_delivery'],
      )!,
      hasPickup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_pickup'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(attachedDatabase, alias);
  }
}

class Store extends DataClass implements Insertable<Store> {
  final String id;
  final String name;
  final String type;
  final String? address;
  final String? phoneNumber;
  final String? website;
  final bool isActive;
  final String preferredCurrency;
  final bool supportsTaxExempt;
  final bool hasDelivery;
  final bool hasPickup;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Store({
    required this.id,
    required this.name,
    required this.type,
    this.address,
    this.phoneNumber,
    this.website,
    required this.isActive,
    required this.preferredCurrency,
    required this.supportsTaxExempt,
    required this.hasDelivery,
    required this.hasPickup,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['preferred_currency'] = Variable<String>(preferredCurrency);
    map['supports_tax_exempt'] = Variable<bool>(supportsTaxExempt);
    map['has_delivery'] = Variable<bool>(hasDelivery);
    map['has_pickup'] = Variable<bool>(hasPickup);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      isActive: Value(isActive),
      preferredCurrency: Value(preferredCurrency),
      supportsTaxExempt: Value(supportsTaxExempt),
      hasDelivery: Value(hasDelivery),
      hasPickup: Value(hasPickup),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Store.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Store(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      address: serializer.fromJson<String?>(json['address']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      website: serializer.fromJson<String?>(json['website']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      preferredCurrency: serializer.fromJson<String>(json['preferredCurrency']),
      supportsTaxExempt: serializer.fromJson<bool>(json['supportsTaxExempt']),
      hasDelivery: serializer.fromJson<bool>(json['hasDelivery']),
      hasPickup: serializer.fromJson<bool>(json['hasPickup']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'address': serializer.toJson<String?>(address),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'website': serializer.toJson<String?>(website),
      'isActive': serializer.toJson<bool>(isActive),
      'preferredCurrency': serializer.toJson<String>(preferredCurrency),
      'supportsTaxExempt': serializer.toJson<bool>(supportsTaxExempt),
      'hasDelivery': serializer.toJson<bool>(hasDelivery),
      'hasPickup': serializer.toJson<bool>(hasPickup),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Store copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> address = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> website = const Value.absent(),
    bool? isActive,
    String? preferredCurrency,
    bool? supportsTaxExempt,
    bool? hasDelivery,
    bool? hasPickup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Store(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    address: address.present ? address.value : this.address,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    website: website.present ? website.value : this.website,
    isActive: isActive ?? this.isActive,
    preferredCurrency: preferredCurrency ?? this.preferredCurrency,
    supportsTaxExempt: supportsTaxExempt ?? this.supportsTaxExempt,
    hasDelivery: hasDelivery ?? this.hasDelivery,
    hasPickup: hasPickup ?? this.hasPickup,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Store copyWithCompanion(StoresCompanion data) {
    return Store(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      address: data.address.present ? data.address.value : this.address,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      website: data.website.present ? data.website.value : this.website,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      preferredCurrency: data.preferredCurrency.present
          ? data.preferredCurrency.value
          : this.preferredCurrency,
      supportsTaxExempt: data.supportsTaxExempt.present
          ? data.supportsTaxExempt.value
          : this.supportsTaxExempt,
      hasDelivery: data.hasDelivery.present
          ? data.hasDelivery.value
          : this.hasDelivery,
      hasPickup: data.hasPickup.present ? data.hasPickup.value : this.hasPickup,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Store(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('website: $website, ')
          ..write('isActive: $isActive, ')
          ..write('preferredCurrency: $preferredCurrency, ')
          ..write('supportsTaxExempt: $supportsTaxExempt, ')
          ..write('hasDelivery: $hasDelivery, ')
          ..write('hasPickup: $hasPickup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    address,
    phoneNumber,
    website,
    isActive,
    preferredCurrency,
    supportsTaxExempt,
    hasDelivery,
    hasPickup,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.address == this.address &&
          other.phoneNumber == this.phoneNumber &&
          other.website == this.website &&
          other.isActive == this.isActive &&
          other.preferredCurrency == this.preferredCurrency &&
          other.supportsTaxExempt == this.supportsTaxExempt &&
          other.hasDelivery == this.hasDelivery &&
          other.hasPickup == this.hasPickup &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StoresCompanion extends UpdateCompanion<Store> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> address;
  final Value<String?> phoneNumber;
  final Value<String?> website;
  final Value<bool> isActive;
  final Value<String> preferredCurrency;
  final Value<bool> supportsTaxExempt;
  final Value<bool> hasDelivery;
  final Value<bool> hasPickup;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.website = const Value.absent(),
    this.isActive = const Value.absent(),
    this.preferredCurrency = const Value.absent(),
    this.supportsTaxExempt = const Value.absent(),
    this.hasDelivery = const Value.absent(),
    this.hasPickup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    required String name,
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.website = const Value.absent(),
    this.isActive = const Value.absent(),
    this.preferredCurrency = const Value.absent(),
    this.supportsTaxExempt = const Value.absent(),
    this.hasDelivery = const Value.absent(),
    this.hasPickup = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Store> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? address,
    Expression<String>? phoneNumber,
    Expression<String>? website,
    Expression<bool>? isActive,
    Expression<String>? preferredCurrency,
    Expression<bool>? supportsTaxExempt,
    Expression<bool>? hasDelivery,
    Expression<bool>? hasPickup,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (address != null) 'address': address,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (website != null) 'website': website,
      if (isActive != null) 'is_active': isActive,
      if (preferredCurrency != null) 'preferred_currency': preferredCurrency,
      if (supportsTaxExempt != null) 'supports_tax_exempt': supportsTaxExempt,
      if (hasDelivery != null) 'has_delivery': hasDelivery,
      if (hasPickup != null) 'has_pickup': hasPickup,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoresCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? address,
    Value<String?>? phoneNumber,
    Value<String?>? website,
    Value<bool>? isActive,
    Value<String>? preferredCurrency,
    Value<bool>? supportsTaxExempt,
    Value<bool>? hasDelivery,
    Value<bool>? hasPickup,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      isActive: isActive ?? this.isActive,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      supportsTaxExempt: supportsTaxExempt ?? this.supportsTaxExempt,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      hasPickup: hasPickup ?? this.hasPickup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (preferredCurrency.present) {
      map['preferred_currency'] = Variable<String>(preferredCurrency.value);
    }
    if (supportsTaxExempt.present) {
      map['supports_tax_exempt'] = Variable<bool>(supportsTaxExempt.value);
    }
    if (hasDelivery.present) {
      map['has_delivery'] = Variable<bool>(hasDelivery.value);
    }
    if (hasPickup.present) {
      map['has_pickup'] = Variable<bool>(hasPickup.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('website: $website, ')
          ..write('isActive: $isActive, ')
          ..write('preferredCurrency: $preferredCurrency, ')
          ..write('supportsTaxExempt: $supportsTaxExempt, ')
          ..write('hasDelivery: $hasDelivery, ')
          ..write('hasPickup: $hasPickup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoreAislesTable extends StoreAisles
    with TableInfo<$StoreAislesTable, StoreAisle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreAislesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stores (id)',
    ),
  );
  static const VerificationMeta _aisleNameMeta = const VerificationMeta(
    'aisleName',
  );
  @override
  late final GeneratedColumn<String> aisleName = GeneratedColumn<String>(
    'aisle_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aisleNumberMeta = const VerificationMeta(
    'aisleNumber',
  );
  @override
  late final GeneratedColumn<int> aisleNumber = GeneratedColumn<int>(
    'aisle_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriesJsonMeta = const VerificationMeta(
    'categoriesJson',
  );
  @override
  late final GeneratedColumn<String> categoriesJson = GeneratedColumn<String>(
    'categories_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    aisleName,
    aisleNumber,
    categoriesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_aisles';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreAisle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('aisle_name')) {
      context.handle(
        _aisleNameMeta,
        aisleName.isAcceptableOrUnknown(data['aisle_name']!, _aisleNameMeta),
      );
    } else if (isInserting) {
      context.missing(_aisleNameMeta);
    }
    if (data.containsKey('aisle_number')) {
      context.handle(
        _aisleNumberMeta,
        aisleNumber.isAcceptableOrUnknown(
          data['aisle_number']!,
          _aisleNumberMeta,
        ),
      );
    }
    if (data.containsKey('categories_json')) {
      context.handle(
        _categoriesJsonMeta,
        categoriesJson.isAcceptableOrUnknown(
          data['categories_json']!,
          _categoriesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreAisle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreAisle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      aisleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aisle_name'],
      )!,
      aisleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aisle_number'],
      ),
      categoriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categories_json'],
      )!,
    );
  }

  @override
  $StoreAislesTable createAlias(String alias) {
    return $StoreAislesTable(attachedDatabase, alias);
  }
}

class StoreAisle extends DataClass implements Insertable<StoreAisle> {
  final String id;
  final String storeId;
  final String aisleName;
  final int? aisleNumber;
  final String categoriesJson;
  const StoreAisle({
    required this.id,
    required this.storeId,
    required this.aisleName,
    this.aisleNumber,
    required this.categoriesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['aisle_name'] = Variable<String>(aisleName);
    if (!nullToAbsent || aisleNumber != null) {
      map['aisle_number'] = Variable<int>(aisleNumber);
    }
    map['categories_json'] = Variable<String>(categoriesJson);
    return map;
  }

  StoreAislesCompanion toCompanion(bool nullToAbsent) {
    return StoreAislesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      aisleName: Value(aisleName),
      aisleNumber: aisleNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(aisleNumber),
      categoriesJson: Value(categoriesJson),
    );
  }

  factory StoreAisle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreAisle(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      aisleName: serializer.fromJson<String>(json['aisleName']),
      aisleNumber: serializer.fromJson<int?>(json['aisleNumber']),
      categoriesJson: serializer.fromJson<String>(json['categoriesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'aisleName': serializer.toJson<String>(aisleName),
      'aisleNumber': serializer.toJson<int?>(aisleNumber),
      'categoriesJson': serializer.toJson<String>(categoriesJson),
    };
  }

  StoreAisle copyWith({
    String? id,
    String? storeId,
    String? aisleName,
    Value<int?> aisleNumber = const Value.absent(),
    String? categoriesJson,
  }) => StoreAisle(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    aisleName: aisleName ?? this.aisleName,
    aisleNumber: aisleNumber.present ? aisleNumber.value : this.aisleNumber,
    categoriesJson: categoriesJson ?? this.categoriesJson,
  );
  StoreAisle copyWithCompanion(StoreAislesCompanion data) {
    return StoreAisle(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      aisleName: data.aisleName.present ? data.aisleName.value : this.aisleName,
      aisleNumber: data.aisleNumber.present
          ? data.aisleNumber.value
          : this.aisleNumber,
      categoriesJson: data.categoriesJson.present
          ? data.categoriesJson.value
          : this.categoriesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreAisle(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('aisleName: $aisleName, ')
          ..write('aisleNumber: $aisleNumber, ')
          ..write('categoriesJson: $categoriesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storeId, aisleName, aisleNumber, categoriesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreAisle &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.aisleName == this.aisleName &&
          other.aisleNumber == this.aisleNumber &&
          other.categoriesJson == this.categoriesJson);
}

class StoreAislesCompanion extends UpdateCompanion<StoreAisle> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> aisleName;
  final Value<int?> aisleNumber;
  final Value<String> categoriesJson;
  final Value<int> rowid;
  const StoreAislesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.aisleName = const Value.absent(),
    this.aisleNumber = const Value.absent(),
    this.categoriesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoreAislesCompanion.insert({
    required String id,
    required String storeId,
    required String aisleName,
    this.aisleNumber = const Value.absent(),
    this.categoriesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       aisleName = Value(aisleName);
  static Insertable<StoreAisle> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? aisleName,
    Expression<int>? aisleNumber,
    Expression<String>? categoriesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (aisleName != null) 'aisle_name': aisleName,
      if (aisleNumber != null) 'aisle_number': aisleNumber,
      if (categoriesJson != null) 'categories_json': categoriesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoreAislesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? aisleName,
    Value<int?>? aisleNumber,
    Value<String>? categoriesJson,
    Value<int>? rowid,
  }) {
    return StoreAislesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      aisleName: aisleName ?? this.aisleName,
      aisleNumber: aisleNumber ?? this.aisleNumber,
      categoriesJson: categoriesJson ?? this.categoriesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (aisleName.present) {
      map['aisle_name'] = Variable<String>(aisleName.value);
    }
    if (aisleNumber.present) {
      map['aisle_number'] = Variable<int>(aisleNumber.value);
    }
    if (categoriesJson.present) {
      map['categories_json'] = Variable<String>(categoriesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreAislesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('aisleName: $aisleName, ')
          ..write('aisleNumber: $aisleNumber, ')
          ..write('categoriesJson: $categoriesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityEventsTable extends ActivityEvents
    with TableInfo<$ActivityEventsTable, ActivityEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorUidMeta = const VerificationMeta(
    'actorUid',
  );
  @override
  late final GeneratedColumn<String> actorUid = GeneratedColumn<String>(
    'actor_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorDisplayNameMeta = const VerificationMeta(
    'actorDisplayName',
  );
  @override
  late final GeneratedColumn<String> actorDisplayName = GeneratedColumn<String>(
    'actor_display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    sourceType,
    sourceId,
    sourceName,
    actorUid,
    actorDisplayName,
    itemName,
    detailsJson,
    timestamp,
    isRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('actor_uid')) {
      context.handle(
        _actorUidMeta,
        actorUid.isAcceptableOrUnknown(data['actor_uid']!, _actorUidMeta),
      );
    } else if (isInserting) {
      context.missing(_actorUidMeta);
    }
    if (data.containsKey('actor_display_name')) {
      context.handle(
        _actorDisplayNameMeta,
        actorDisplayName.isAcceptableOrUnknown(
          data['actor_display_name']!,
          _actorDisplayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actorDisplayNameMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      )!,
      actorUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_uid'],
      )!,
      actorDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_display_name'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      ),
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
    );
  }

  @override
  $ActivityEventsTable createAlias(String alias) {
    return $ActivityEventsTable(attachedDatabase, alias);
  }
}

class ActivityEvent extends DataClass implements Insertable<ActivityEvent> {
  final String id;
  final String type;
  final String sourceType;
  final String sourceId;
  final String sourceName;
  final String actorUid;
  final String actorDisplayName;
  final String? itemName;
  final String? detailsJson;
  final DateTime timestamp;
  final bool isRead;
  const ActivityEvent({
    required this.id,
    required this.type,
    required this.sourceType,
    required this.sourceId,
    required this.sourceName,
    required this.actorUid,
    required this.actorDisplayName,
    this.itemName,
    this.detailsJson,
    required this.timestamp,
    required this.isRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    map['source_name'] = Variable<String>(sourceName);
    map['actor_uid'] = Variable<String>(actorUid);
    map['actor_display_name'] = Variable<String>(actorDisplayName);
    if (!nullToAbsent || itemName != null) {
      map['item_name'] = Variable<String>(itemName);
    }
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  ActivityEventsCompanion toCompanion(bool nullToAbsent) {
    return ActivityEventsCompanion(
      id: Value(id),
      type: Value(type),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      sourceName: Value(sourceName),
      actorUid: Value(actorUid),
      actorDisplayName: Value(actorDisplayName),
      itemName: itemName == null && nullToAbsent
          ? const Value.absent()
          : Value(itemName),
      detailsJson: detailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsJson),
      timestamp: Value(timestamp),
      isRead: Value(isRead),
    );
  }

  factory ActivityEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEvent(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      actorUid: serializer.fromJson<String>(json['actorUid']),
      actorDisplayName: serializer.fromJson<String>(json['actorDisplayName']),
      itemName: serializer.fromJson<String?>(json['itemName']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'sourceName': serializer.toJson<String>(sourceName),
      'actorUid': serializer.toJson<String>(actorUid),
      'actorDisplayName': serializer.toJson<String>(actorDisplayName),
      'itemName': serializer.toJson<String?>(itemName),
      'detailsJson': serializer.toJson<String?>(detailsJson),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  ActivityEvent copyWith({
    String? id,
    String? type,
    String? sourceType,
    String? sourceId,
    String? sourceName,
    String? actorUid,
    String? actorDisplayName,
    Value<String?> itemName = const Value.absent(),
    Value<String?> detailsJson = const Value.absent(),
    DateTime? timestamp,
    bool? isRead,
  }) => ActivityEvent(
    id: id ?? this.id,
    type: type ?? this.type,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    sourceName: sourceName ?? this.sourceName,
    actorUid: actorUid ?? this.actorUid,
    actorDisplayName: actorDisplayName ?? this.actorDisplayName,
    itemName: itemName.present ? itemName.value : this.itemName,
    detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
    timestamp: timestamp ?? this.timestamp,
    isRead: isRead ?? this.isRead,
  );
  ActivityEvent copyWithCompanion(ActivityEventsCompanion data) {
    return ActivityEvent(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      actorUid: data.actorUid.present ? data.actorUid.value : this.actorUid,
      actorDisplayName: data.actorDisplayName.present
          ? data.actorDisplayName.value
          : this.actorDisplayName,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEvent(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceName: $sourceName, ')
          ..write('actorUid: $actorUid, ')
          ..write('actorDisplayName: $actorDisplayName, ')
          ..write('itemName: $itemName, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('timestamp: $timestamp, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    sourceType,
    sourceId,
    sourceName,
    actorUid,
    actorDisplayName,
    itemName,
    detailsJson,
    timestamp,
    isRead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEvent &&
          other.id == this.id &&
          other.type == this.type &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.sourceName == this.sourceName &&
          other.actorUid == this.actorUid &&
          other.actorDisplayName == this.actorDisplayName &&
          other.itemName == this.itemName &&
          other.detailsJson == this.detailsJson &&
          other.timestamp == this.timestamp &&
          other.isRead == this.isRead);
}

class ActivityEventsCompanion extends UpdateCompanion<ActivityEvent> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<String> sourceName;
  final Value<String> actorUid;
  final Value<String> actorDisplayName;
  final Value<String?> itemName;
  final Value<String?> detailsJson;
  final Value<DateTime> timestamp;
  final Value<bool> isRead;
  final Value<int> rowid;
  const ActivityEventsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.actorUid = const Value.absent(),
    this.actorDisplayName = const Value.absent(),
    this.itemName = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityEventsCompanion.insert({
    required String id,
    required String type,
    required String sourceType,
    required String sourceId,
    required String sourceName,
    required String actorUid,
    required String actorDisplayName,
    this.itemName = const Value.absent(),
    this.detailsJson = const Value.absent(),
    required DateTime timestamp,
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       sourceName = Value(sourceName),
       actorUid = Value(actorUid),
       actorDisplayName = Value(actorDisplayName),
       timestamp = Value(timestamp);
  static Insertable<ActivityEvent> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? sourceName,
    Expression<String>? actorUid,
    Expression<String>? actorDisplayName,
    Expression<String>? itemName,
    Expression<String>? detailsJson,
    Expression<DateTime>? timestamp,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceName != null) 'source_name': sourceName,
      if (actorUid != null) 'actor_uid': actorUid,
      if (actorDisplayName != null) 'actor_display_name': actorDisplayName,
      if (itemName != null) 'item_name': itemName,
      if (detailsJson != null) 'details_json': detailsJson,
      if (timestamp != null) 'timestamp': timestamp,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<String>? sourceName,
    Value<String>? actorUid,
    Value<String>? actorDisplayName,
    Value<String?>? itemName,
    Value<String?>? detailsJson,
    Value<DateTime>? timestamp,
    Value<bool>? isRead,
    Value<int>? rowid,
  }) {
    return ActivityEventsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      actorUid: actorUid ?? this.actorUid,
      actorDisplayName: actorDisplayName ?? this.actorDisplayName,
      itemName: itemName ?? this.itemName,
      detailsJson: detailsJson ?? this.detailsJson,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (actorUid.present) {
      map['actor_uid'] = Variable<String>(actorUid.value);
    }
    if (actorDisplayName.present) {
      map['actor_display_name'] = Variable<String>(actorDisplayName.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEventsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceName: $sourceName, ')
          ..write('actorUid: $actorUid, ')
          ..write('actorDisplayName: $actorDisplayName, ')
          ..write('itemName: $itemName, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('timestamp: $timestamp, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProduceTemplatesTable produceTemplates = $ProduceTemplatesTable(
    this,
  );
  late final $ScanHistoryEntriesTable scanHistoryEntries =
      $ScanHistoryEntriesTable(this);
  late final $PantryItemsTable pantryItems = $PantryItemsTable(this);
  late final $ShoppingListsTable shoppingLists = $ShoppingListsTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $MealPlansTable mealPlans = $MealPlansTable(this);
  late final $MealPlanDaysTable mealPlanDays = $MealPlanDaysTable(this);
  late final $RecipeFeedbackTable recipeFeedback = $RecipeFeedbackTable(this);
  late final $FamilyProfilesTable familyProfiles = $FamilyProfilesTable(this);
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  late final $PurchaseHistoriesTable purchaseHistories =
      $PurchaseHistoriesTable(this);
  late final $PurchaseRecordsTable purchaseRecords = $PurchaseRecordsTable(
    this,
  );
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetEntriesTable budgetEntries = $BudgetEntriesTable(this);
  late final $StoresTable stores = $StoresTable(this);
  late final $StoreAislesTable storeAisles = $StoreAislesTable(this);
  late final $ActivityEventsTable activityEvents = $ActivityEventsTable(this);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  late final PantryDao pantryDao = PantryDao(this as AppDatabase);
  late final ShoppingListDao shoppingListDao = ShoppingListDao(
    this as AppDatabase,
  );
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  late final MealPlanDao mealPlanDao = MealPlanDao(this as AppDatabase);
  late final FamilyProfileDao familyProfileDao = FamilyProfileDao(
    this as AppDatabase,
  );
  late final FeedbackDao feedbackDao = FeedbackDao(this as AppDatabase);
  late final PreferencesDao preferencesDao = PreferencesDao(
    this as AppDatabase,
  );
  late final PurchaseHistoryDao purchaseHistoryDao = PurchaseHistoryDao(
    this as AppDatabase,
  );
  late final StoreDao storeDao = StoreDao(this as AppDatabase);
  late final BudgetDao budgetDao = BudgetDao(this as AppDatabase);
  late final ScanHistoryDao scanHistoryDao = ScanHistoryDao(
    this as AppDatabase,
  );
  late final ActivityEventDao activityEventDao = ActivityEventDao(
    this as AppDatabase,
  );
  late final ProduceTemplateDao produceTemplateDao = ProduceTemplateDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    produceTemplates,
    scanHistoryEntries,
    pantryItems,
    shoppingLists,
    shoppingListItems,
    recipes,
    mealPlans,
    mealPlanDays,
    recipeFeedback,
    familyProfiles,
    userPreferencesTable,
    purchaseHistories,
    purchaseRecords,
    budgets,
    budgetEntries,
    stores,
    storeAisles,
    activityEvents,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      Value<String?> barcode,
      Value<String?> pluCode,
      Value<String> identifierType,
      required String name,
      Value<String?> brand,
      Value<String?> description,
      Value<double?> price,
      Value<String?> currency,
      Value<String> category,
      Value<String?> imageUrl,
      Value<String?> nutritionInfoJson,
      Value<String?> ingredientsJson,
      Value<String?> allergensJson,
      Value<bool> isWeightBased,
      Value<String> unitType,
      Value<double?> averageWeight,
      Value<String?> seasonalityJson,
      Value<String?> storageInstructions,
      Value<String?> ripenessIndicatorsJson,
      Value<bool> isOrganic,
      Value<bool> isGlutenFree,
      Value<bool> isVegan,
      Value<bool> isCustom,
      Value<bool> isFavorite,
      Value<String?> source,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> lastLookedUp,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String?> barcode,
      Value<String?> pluCode,
      Value<String> identifierType,
      Value<String> name,
      Value<String?> brand,
      Value<String?> description,
      Value<double?> price,
      Value<String?> currency,
      Value<String> category,
      Value<String?> imageUrl,
      Value<String?> nutritionInfoJson,
      Value<String?> ingredientsJson,
      Value<String?> allergensJson,
      Value<bool> isWeightBased,
      Value<String> unitType,
      Value<double?> averageWeight,
      Value<String?> seasonalityJson,
      Value<String?> storageInstructions,
      Value<String?> ripenessIndicatorsJson,
      Value<bool> isOrganic,
      Value<bool> isGlutenFree,
      Value<bool> isVegan,
      Value<bool> isCustom,
      Value<bool> isFavorite,
      Value<String?> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastLookedUp,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
  _shoppingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingListItems,
        aliasName: 'products__id__shopping_list_items__product_id',
      );

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
      $_db,
      $_db.shoppingListItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pluCode => $composableBuilder(
    column: $table.pluCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifierType => $composableBuilder(
    column: $table.identifierType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutritionInfoJson => $composableBuilder(
    column: $table.nutritionInfoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergensJson => $composableBuilder(
    column: $table.allergensJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWeightBased => $composableBuilder(
    column: $table.isWeightBased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageWeight => $composableBuilder(
    column: $table.averageWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seasonalityJson => $composableBuilder(
    column: $table.seasonalityJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageInstructions => $composableBuilder(
    column: $table.storageInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ripenessIndicatorsJson => $composableBuilder(
    column: $table.ripenessIndicatorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOrganic => $composableBuilder(
    column: $table.isOrganic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVegan => $composableBuilder(
    column: $table.isVegan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLookedUp => $composableBuilder(
    column: $table.lastLookedUp,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shoppingListItemsRefs(
    Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pluCode => $composableBuilder(
    column: $table.pluCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifierType => $composableBuilder(
    column: $table.identifierType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutritionInfoJson => $composableBuilder(
    column: $table.nutritionInfoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergensJson => $composableBuilder(
    column: $table.allergensJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWeightBased => $composableBuilder(
    column: $table.isWeightBased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageWeight => $composableBuilder(
    column: $table.averageWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seasonalityJson => $composableBuilder(
    column: $table.seasonalityJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageInstructions => $composableBuilder(
    column: $table.storageInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ripenessIndicatorsJson => $composableBuilder(
    column: $table.ripenessIndicatorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOrganic => $composableBuilder(
    column: $table.isOrganic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVegan => $composableBuilder(
    column: $table.isVegan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLookedUp => $composableBuilder(
    column: $table.lastLookedUp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get pluCode =>
      $composableBuilder(column: $table.pluCode, builder: (column) => column);

  GeneratedColumn<String> get identifierType => $composableBuilder(
    column: $table.identifierType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get nutritionInfoJson => $composableBuilder(
    column: $table.nutritionInfoJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergensJson => $composableBuilder(
    column: $table.allergensJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isWeightBased => $composableBuilder(
    column: $table.isWeightBased,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<double> get averageWeight => $composableBuilder(
    column: $table.averageWeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seasonalityJson => $composableBuilder(
    column: $table.seasonalityJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storageInstructions => $composableBuilder(
    column: $table.storageInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ripenessIndicatorsJson => $composableBuilder(
    column: $table.ripenessIndicatorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOrganic =>
      $composableBuilder(column: $table.isOrganic, builder: (column) => column);

  GeneratedColumn<bool> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVegan =>
      $composableBuilder(column: $table.isVegan, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLookedUp => $composableBuilder(
    column: $table.lastLookedUp,
    builder: (column) => column,
  );

  Expression<T> shoppingListItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool shoppingListItemsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> pluCode = const Value.absent(),
                Value<String> identifierType = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> nutritionInfoJson = const Value.absent(),
                Value<String?> ingredientsJson = const Value.absent(),
                Value<String?> allergensJson = const Value.absent(),
                Value<bool> isWeightBased = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<double?> averageWeight = const Value.absent(),
                Value<String?> seasonalityJson = const Value.absent(),
                Value<String?> storageInstructions = const Value.absent(),
                Value<String?> ripenessIndicatorsJson = const Value.absent(),
                Value<bool> isOrganic = const Value.absent(),
                Value<bool> isGlutenFree = const Value.absent(),
                Value<bool> isVegan = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastLookedUp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                barcode: barcode,
                pluCode: pluCode,
                identifierType: identifierType,
                name: name,
                brand: brand,
                description: description,
                price: price,
                currency: currency,
                category: category,
                imageUrl: imageUrl,
                nutritionInfoJson: nutritionInfoJson,
                ingredientsJson: ingredientsJson,
                allergensJson: allergensJson,
                isWeightBased: isWeightBased,
                unitType: unitType,
                averageWeight: averageWeight,
                seasonalityJson: seasonalityJson,
                storageInstructions: storageInstructions,
                ripenessIndicatorsJson: ripenessIndicatorsJson,
                isOrganic: isOrganic,
                isGlutenFree: isGlutenFree,
                isVegan: isVegan,
                isCustom: isCustom,
                isFavorite: isFavorite,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastLookedUp: lastLookedUp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> barcode = const Value.absent(),
                Value<String?> pluCode = const Value.absent(),
                Value<String> identifierType = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> nutritionInfoJson = const Value.absent(),
                Value<String?> ingredientsJson = const Value.absent(),
                Value<String?> allergensJson = const Value.absent(),
                Value<bool> isWeightBased = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<double?> averageWeight = const Value.absent(),
                Value<String?> seasonalityJson = const Value.absent(),
                Value<String?> storageInstructions = const Value.absent(),
                Value<String?> ripenessIndicatorsJson = const Value.absent(),
                Value<bool> isOrganic = const Value.absent(),
                Value<bool> isGlutenFree = const Value.absent(),
                Value<bool> isVegan = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> source = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastLookedUp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                barcode: barcode,
                pluCode: pluCode,
                identifierType: identifierType,
                name: name,
                brand: brand,
                description: description,
                price: price,
                currency: currency,
                category: category,
                imageUrl: imageUrl,
                nutritionInfoJson: nutritionInfoJson,
                ingredientsJson: ingredientsJson,
                allergensJson: allergensJson,
                isWeightBased: isWeightBased,
                unitType: unitType,
                averageWeight: averageWeight,
                seasonalityJson: seasonalityJson,
                storageInstructions: storageInstructions,
                ripenessIndicatorsJson: ripenessIndicatorsJson,
                isOrganic: isOrganic,
                isGlutenFree: isGlutenFree,
                isVegan: isVegan,
                isCustom: isCustom,
                isFavorite: isFavorite,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastLookedUp: lastLookedUp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingListItemsRefs) db.shoppingListItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      ShoppingListItem
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._shoppingListItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).shoppingListItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool shoppingListItemsRefs})
    >;
typedef $$ProduceTemplatesTableCreateCompanionBuilder =
    ProduceTemplatesCompanion Function({
      required String id,
      required String name,
      Value<String?> pluCode,
      Value<String> category,
      Value<String> unitType,
      Value<double?> averageWeight,
      Value<double?> avgPriceLow,
      Value<double?> avgPriceHigh,
      Value<String?> seasonalityJson,
      Value<String?> ripenessIndicatorsJson,
      Value<String?> storageInstructions,
      Value<bool> isOrganic,
      Value<bool> isBuiltIn,
      Value<int> rowid,
    });
typedef $$ProduceTemplatesTableUpdateCompanionBuilder =
    ProduceTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> pluCode,
      Value<String> category,
      Value<String> unitType,
      Value<double?> averageWeight,
      Value<double?> avgPriceLow,
      Value<double?> avgPriceHigh,
      Value<String?> seasonalityJson,
      Value<String?> ripenessIndicatorsJson,
      Value<String?> storageInstructions,
      Value<bool> isOrganic,
      Value<bool> isBuiltIn,
      Value<int> rowid,
    });

class $$ProduceTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ProduceTemplatesTable> {
  $$ProduceTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pluCode => $composableBuilder(
    column: $table.pluCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageWeight => $composableBuilder(
    column: $table.averageWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgPriceLow => $composableBuilder(
    column: $table.avgPriceLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgPriceHigh => $composableBuilder(
    column: $table.avgPriceHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seasonalityJson => $composableBuilder(
    column: $table.seasonalityJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ripenessIndicatorsJson => $composableBuilder(
    column: $table.ripenessIndicatorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageInstructions => $composableBuilder(
    column: $table.storageInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOrganic => $composableBuilder(
    column: $table.isOrganic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProduceTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProduceTemplatesTable> {
  $$ProduceTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pluCode => $composableBuilder(
    column: $table.pluCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageWeight => $composableBuilder(
    column: $table.averageWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgPriceLow => $composableBuilder(
    column: $table.avgPriceLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgPriceHigh => $composableBuilder(
    column: $table.avgPriceHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seasonalityJson => $composableBuilder(
    column: $table.seasonalityJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ripenessIndicatorsJson => $composableBuilder(
    column: $table.ripenessIndicatorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageInstructions => $composableBuilder(
    column: $table.storageInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOrganic => $composableBuilder(
    column: $table.isOrganic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProduceTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProduceTemplatesTable> {
  $$ProduceTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pluCode =>
      $composableBuilder(column: $table.pluCode, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<double> get averageWeight => $composableBuilder(
    column: $table.averageWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgPriceLow => $composableBuilder(
    column: $table.avgPriceLow,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgPriceHigh => $composableBuilder(
    column: $table.avgPriceHigh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seasonalityJson => $composableBuilder(
    column: $table.seasonalityJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ripenessIndicatorsJson => $composableBuilder(
    column: $table.ripenessIndicatorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storageInstructions => $composableBuilder(
    column: $table.storageInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOrganic =>
      $composableBuilder(column: $table.isOrganic, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);
}

class $$ProduceTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProduceTemplatesTable,
          ProduceTemplate,
          $$ProduceTemplatesTableFilterComposer,
          $$ProduceTemplatesTableOrderingComposer,
          $$ProduceTemplatesTableAnnotationComposer,
          $$ProduceTemplatesTableCreateCompanionBuilder,
          $$ProduceTemplatesTableUpdateCompanionBuilder,
          (
            ProduceTemplate,
            BaseReferences<
              _$AppDatabase,
              $ProduceTemplatesTable,
              ProduceTemplate
            >,
          ),
          ProduceTemplate,
          PrefetchHooks Function()
        > {
  $$ProduceTemplatesTableTableManager(
    _$AppDatabase db,
    $ProduceTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProduceTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProduceTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProduceTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> pluCode = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<double?> averageWeight = const Value.absent(),
                Value<double?> avgPriceLow = const Value.absent(),
                Value<double?> avgPriceHigh = const Value.absent(),
                Value<String?> seasonalityJson = const Value.absent(),
                Value<String?> ripenessIndicatorsJson = const Value.absent(),
                Value<String?> storageInstructions = const Value.absent(),
                Value<bool> isOrganic = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProduceTemplatesCompanion(
                id: id,
                name: name,
                pluCode: pluCode,
                category: category,
                unitType: unitType,
                averageWeight: averageWeight,
                avgPriceLow: avgPriceLow,
                avgPriceHigh: avgPriceHigh,
                seasonalityJson: seasonalityJson,
                ripenessIndicatorsJson: ripenessIndicatorsJson,
                storageInstructions: storageInstructions,
                isOrganic: isOrganic,
                isBuiltIn: isBuiltIn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> pluCode = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<double?> averageWeight = const Value.absent(),
                Value<double?> avgPriceLow = const Value.absent(),
                Value<double?> avgPriceHigh = const Value.absent(),
                Value<String?> seasonalityJson = const Value.absent(),
                Value<String?> ripenessIndicatorsJson = const Value.absent(),
                Value<String?> storageInstructions = const Value.absent(),
                Value<bool> isOrganic = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProduceTemplatesCompanion.insert(
                id: id,
                name: name,
                pluCode: pluCode,
                category: category,
                unitType: unitType,
                averageWeight: averageWeight,
                avgPriceLow: avgPriceLow,
                avgPriceHigh: avgPriceHigh,
                seasonalityJson: seasonalityJson,
                ripenessIndicatorsJson: ripenessIndicatorsJson,
                storageInstructions: storageInstructions,
                isOrganic: isOrganic,
                isBuiltIn: isBuiltIn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProduceTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProduceTemplatesTable,
      ProduceTemplate,
      $$ProduceTemplatesTableFilterComposer,
      $$ProduceTemplatesTableOrderingComposer,
      $$ProduceTemplatesTableAnnotationComposer,
      $$ProduceTemplatesTableCreateCompanionBuilder,
      $$ProduceTemplatesTableUpdateCompanionBuilder,
      (
        ProduceTemplate,
        BaseReferences<_$AppDatabase, $ProduceTemplatesTable, ProduceTemplate>,
      ),
      ProduceTemplate,
      PrefetchHooks Function()
    >;
typedef $$ScanHistoryEntriesTableCreateCompanionBuilder =
    ScanHistoryEntriesCompanion Function({
      required String id,
      required String barcode,
      required String scanType,
      required DateTime timestamp,
      Value<double?> confidence,
      Value<String?> productId,
      Value<String?> errorMessage,
      Value<int> rowid,
    });
typedef $$ScanHistoryEntriesTableUpdateCompanionBuilder =
    ScanHistoryEntriesCompanion Function({
      Value<String> id,
      Value<String> barcode,
      Value<String> scanType,
      Value<DateTime> timestamp,
      Value<double?> confidence,
      Value<String?> productId,
      Value<String?> errorMessage,
      Value<int> rowid,
    });

class $$ScanHistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScanHistoryEntriesTable> {
  $$ScanHistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scanType => $composableBuilder(
    column: $table.scanType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScanHistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanHistoryEntriesTable> {
  $$ScanHistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scanType => $composableBuilder(
    column: $table.scanType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScanHistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanHistoryEntriesTable> {
  $$ScanHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get scanType =>
      $composableBuilder(column: $table.scanType, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );
}

class $$ScanHistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanHistoryEntriesTable,
          ScanHistoryEntry,
          $$ScanHistoryEntriesTableFilterComposer,
          $$ScanHistoryEntriesTableOrderingComposer,
          $$ScanHistoryEntriesTableAnnotationComposer,
          $$ScanHistoryEntriesTableCreateCompanionBuilder,
          $$ScanHistoryEntriesTableUpdateCompanionBuilder,
          (
            ScanHistoryEntry,
            BaseReferences<
              _$AppDatabase,
              $ScanHistoryEntriesTable,
              ScanHistoryEntry
            >,
          ),
          ScanHistoryEntry,
          PrefetchHooks Function()
        > {
  $$ScanHistoryEntriesTableTableManager(
    _$AppDatabase db,
    $ScanHistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanHistoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanHistoryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanHistoryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> scanType = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanHistoryEntriesCompanion(
                id: id,
                barcode: barcode,
                scanType: scanType,
                timestamp: timestamp,
                confidence: confidence,
                productId: productId,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String barcode,
                required String scanType,
                required DateTime timestamp,
                Value<double?> confidence = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanHistoryEntriesCompanion.insert(
                id: id,
                barcode: barcode,
                scanType: scanType,
                timestamp: timestamp,
                confidence: confidence,
                productId: productId,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScanHistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanHistoryEntriesTable,
      ScanHistoryEntry,
      $$ScanHistoryEntriesTableFilterComposer,
      $$ScanHistoryEntriesTableOrderingComposer,
      $$ScanHistoryEntriesTableAnnotationComposer,
      $$ScanHistoryEntriesTableCreateCompanionBuilder,
      $$ScanHistoryEntriesTableUpdateCompanionBuilder,
      (
        ScanHistoryEntry,
        BaseReferences<
          _$AppDatabase,
          $ScanHistoryEntriesTable,
          ScanHistoryEntry
        >,
      ),
      ScanHistoryEntry,
      PrefetchHooks Function()
    >;
typedef $$PantryItemsTableCreateCompanionBuilder =
    PantryItemsCompanion Function({
      required String id,
      Value<String?> productId,
      required String name,
      Value<String> category,
      Value<double> quantity,
      Value<String> unitType,
      Value<DateTime?> purchasedAt,
      Value<DateTime?> expiresAt,
      Value<String> location,
      Value<String?> notes,
      Value<bool> isStaple,
      Value<int> reorderThreshold,
      Value<bool> isBulk,
      Value<double?> purchasePrice,
      Value<String> status,
      Value<String?> firestorePantryId,
      Value<String?> firestoreItemId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PantryItemsTableUpdateCompanionBuilder =
    PantryItemsCompanion Function({
      Value<String> id,
      Value<String?> productId,
      Value<String> name,
      Value<String> category,
      Value<double> quantity,
      Value<String> unitType,
      Value<DateTime?> purchasedAt,
      Value<DateTime?> expiresAt,
      Value<String> location,
      Value<String?> notes,
      Value<bool> isStaple,
      Value<int> reorderThreshold,
      Value<bool> isBulk,
      Value<double?> purchasePrice,
      Value<String> status,
      Value<String?> firestorePantryId,
      Value<String?> firestoreItemId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PantryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStaple => $composableBuilder(
    column: $table.isStaple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reorderThreshold => $composableBuilder(
    column: $table.reorderThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBulk => $composableBuilder(
    column: $table.isBulk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firestorePantryId => $composableBuilder(
    column: $table.firestorePantryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firestoreItemId => $composableBuilder(
    column: $table.firestoreItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PantryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStaple => $composableBuilder(
    column: $table.isStaple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reorderThreshold => $composableBuilder(
    column: $table.reorderThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBulk => $composableBuilder(
    column: $table.isBulk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firestorePantryId => $composableBuilder(
    column: $table.firestorePantryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firestoreItemId => $composableBuilder(
    column: $table.firestoreItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PantryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isStaple =>
      $composableBuilder(column: $table.isStaple, builder: (column) => column);

  GeneratedColumn<int> get reorderThreshold => $composableBuilder(
    column: $table.reorderThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBulk =>
      $composableBuilder(column: $table.isBulk, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get firestorePantryId => $composableBuilder(
    column: $table.firestorePantryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firestoreItemId => $composableBuilder(
    column: $table.firestoreItemId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PantryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PantryItemsTable,
          PantryItem,
          $$PantryItemsTableFilterComposer,
          $$PantryItemsTableOrderingComposer,
          $$PantryItemsTableAnnotationComposer,
          $$PantryItemsTableCreateCompanionBuilder,
          $$PantryItemsTableUpdateCompanionBuilder,
          (
            PantryItem,
            BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>,
          ),
          PantryItem,
          PrefetchHooks Function()
        > {
  $$PantryItemsTableTableManager(_$AppDatabase db, $PantryItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PantryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PantryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PantryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<DateTime?> purchasedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isStaple = const Value.absent(),
                Value<int> reorderThreshold = const Value.absent(),
                Value<bool> isBulk = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> firestorePantryId = const Value.absent(),
                Value<String?> firestoreItemId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PantryItemsCompanion(
                id: id,
                productId: productId,
                name: name,
                category: category,
                quantity: quantity,
                unitType: unitType,
                purchasedAt: purchasedAt,
                expiresAt: expiresAt,
                location: location,
                notes: notes,
                isStaple: isStaple,
                reorderThreshold: reorderThreshold,
                isBulk: isBulk,
                purchasePrice: purchasePrice,
                status: status,
                firestorePantryId: firestorePantryId,
                firestoreItemId: firestoreItemId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> productId = const Value.absent(),
                required String name,
                Value<String> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<DateTime?> purchasedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isStaple = const Value.absent(),
                Value<int> reorderThreshold = const Value.absent(),
                Value<bool> isBulk = const Value.absent(),
                Value<double?> purchasePrice = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> firestorePantryId = const Value.absent(),
                Value<String?> firestoreItemId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PantryItemsCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                category: category,
                quantity: quantity,
                unitType: unitType,
                purchasedAt: purchasedAt,
                expiresAt: expiresAt,
                location: location,
                notes: notes,
                isStaple: isStaple,
                reorderThreshold: reorderThreshold,
                isBulk: isBulk,
                purchasePrice: purchasePrice,
                status: status,
                firestorePantryId: firestorePantryId,
                firestoreItemId: firestoreItemId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PantryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PantryItemsTable,
      PantryItem,
      $$PantryItemsTableFilterComposer,
      $$PantryItemsTableOrderingComposer,
      $$PantryItemsTableAnnotationComposer,
      $$PantryItemsTableCreateCompanionBuilder,
      $$PantryItemsTableUpdateCompanionBuilder,
      (
        PantryItem,
        BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>,
      ),
      PantryItem,
      PrefetchHooks Function()
    >;
typedef $$ShoppingListsTableCreateCompanionBuilder =
    ShoppingListsCompanion Function({
      required String id,
      required String name,
      Value<String?> storeId,
      Value<String?> storeName,
      Value<String?> storeType,
      Value<String> source,
      Value<String?> mealPlanId,
      Value<bool> isCompleted,
      Value<bool> isActive,
      Value<bool> isArchived,
      Value<String?> firestoreId,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> dateShopped,
      Value<int> rowid,
    });
typedef $$ShoppingListsTableUpdateCompanionBuilder =
    ShoppingListsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> storeId,
      Value<String?> storeName,
      Value<String?> storeType,
      Value<String> source,
      Value<String?> mealPlanId,
      Value<bool> isCompleted,
      Value<bool> isActive,
      Value<bool> isArchived,
      Value<String?> firestoreId,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> dateShopped,
      Value<int> rowid,
    });

final class $$ShoppingListsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingListsTable, ShoppingList> {
  $$ShoppingListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ShoppingListItemsTable, List<ShoppingListItem>>
  _shoppingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingListItems,
        aliasName: 'shopping_lists__id__shopping_list_items__list_id',
      );

  $$ShoppingListItemsTableProcessedTableManager get shoppingListItemsRefs {
    final manager = $$ShoppingListItemsTableTableManager(
      $_db,
      $_db.shoppingListItems,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingListsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeType => $composableBuilder(
    column: $table.storeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealPlanId => $composableBuilder(
    column: $table.mealPlanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firestoreId => $composableBuilder(
    column: $table.firestoreId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateShopped => $composableBuilder(
    column: $table.dateShopped,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shoppingListItemsRefs(
    Expression<bool> Function($$ShoppingListItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingListItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeType => $composableBuilder(
    column: $table.storeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealPlanId => $composableBuilder(
    column: $table.mealPlanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firestoreId => $composableBuilder(
    column: $table.firestoreId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateShopped => $composableBuilder(
    column: $table.dateShopped,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListsTable> {
  $$ShoppingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get storeType =>
      $composableBuilder(column: $table.storeType, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get mealPlanId => $composableBuilder(
    column: $table.mealPlanId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firestoreId => $composableBuilder(
    column: $table.firestoreId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dateShopped => $composableBuilder(
    column: $table.dateShopped,
    builder: (column) => column,
  );

  Expression<T> shoppingListItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingListItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingListItems,
          getReferencedColumn: (t) => t.listId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShoppingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListsTable,
          ShoppingList,
          $$ShoppingListsTableFilterComposer,
          $$ShoppingListsTableOrderingComposer,
          $$ShoppingListsTableAnnotationComposer,
          $$ShoppingListsTableCreateCompanionBuilder,
          $$ShoppingListsTableUpdateCompanionBuilder,
          (ShoppingList, $$ShoppingListsTableReferences),
          ShoppingList,
          PrefetchHooks Function({bool shoppingListItemsRefs})
        > {
  $$ShoppingListsTableTableManager(_$AppDatabase db, $ShoppingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<String?> storeType = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> mealPlanId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> firestoreId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> dateShopped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion(
                id: id,
                name: name,
                storeId: storeId,
                storeName: storeName,
                storeType: storeType,
                source: source,
                mealPlanId: mealPlanId,
                isCompleted: isCompleted,
                isActive: isActive,
                isArchived: isArchived,
                firestoreId: firestoreId,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dateShopped: dateShopped,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> storeId = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<String?> storeType = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> mealPlanId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> firestoreId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> dateShopped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListsCompanion.insert(
                id: id,
                name: name,
                storeId: storeId,
                storeName: storeName,
                storeType: storeType,
                source: source,
                mealPlanId: mealPlanId,
                isCompleted: isCompleted,
                isActive: isActive,
                isArchived: isArchived,
                firestoreId: firestoreId,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dateShopped: dateShopped,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShoppingListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingListItemsRefs) db.shoppingListItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingListItemsRefs)
                    await $_getPrefetchedData<
                      ShoppingList,
                      $ShoppingListsTable,
                      ShoppingListItem
                    >(
                      currentTable: table,
                      referencedTable: $$ShoppingListsTableReferences
                          ._shoppingListItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ShoppingListsTableReferences(
                            db,
                            table,
                            p0,
                          ).shoppingListItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListsTable,
      ShoppingList,
      $$ShoppingListsTableFilterComposer,
      $$ShoppingListsTableOrderingComposer,
      $$ShoppingListsTableAnnotationComposer,
      $$ShoppingListsTableCreateCompanionBuilder,
      $$ShoppingListsTableUpdateCompanionBuilder,
      (ShoppingList, $$ShoppingListsTableReferences),
      ShoppingList,
      PrefetchHooks Function({bool shoppingListItemsRefs})
    >;
typedef $$ShoppingListItemsTableCreateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      required String id,
      required String listId,
      Value<String?> productId,
      required String name,
      Value<String?> brand,
      Value<String> category,
      Value<double> quantity,
      Value<String> unitType,
      Value<double?> estimatedPrice,
      Value<double?> actualPrice,
      Value<double?> salePrice,
      Value<bool> isOnSale,
      Value<bool> isCompleted,
      Value<String> priority,
      Value<String?> notes,
      Value<String?> recipeId,
      Value<String?> recipeName,
      Value<double> pantryQuantityAvailable,
      Value<int> sortOrder,
      required DateTime addedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ShoppingListItemsTableUpdateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<String> id,
      Value<String> listId,
      Value<String?> productId,
      Value<String> name,
      Value<String?> brand,
      Value<String> category,
      Value<double> quantity,
      Value<String> unitType,
      Value<double?> estimatedPrice,
      Value<double?> actualPrice,
      Value<double?> salePrice,
      Value<bool> isOnSale,
      Value<bool> isCompleted,
      Value<String> priority,
      Value<String?> notes,
      Value<String?> recipeId,
      Value<String?> recipeName,
      Value<double> pantryQuantityAvailable,
      Value<int> sortOrder,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ShoppingListItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem
        > {
  $$ShoppingListItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingListsTable _listIdTable(_$AppDatabase db) => db.shoppingLists
      .createAlias('shopping_list_items__list_id__shopping_lists__id');

  $$ShoppingListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<String>('list_id')!;

    final manager = $$ShoppingListsTableTableManager(
      $_db,
      $_db.shoppingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('shopping_list_items__product_id__products__id');

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<String>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedPrice => $composableBuilder(
    column: $table.estimatedPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualPrice => $composableBuilder(
    column: $table.actualPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnSale => $composableBuilder(
    column: $table.isOnSale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pantryQuantityAvailable => $composableBuilder(
    column: $table.pantryQuantityAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingListsTableFilterComposer get listId {
    final $$ShoppingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedPrice => $composableBuilder(
    column: $table.estimatedPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualPrice => $composableBuilder(
    column: $table.actualPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnSale => $composableBuilder(
    column: $table.isOnSale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pantryQuantityAvailable => $composableBuilder(
    column: $table.pantryQuantityAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingListsTableOrderingComposer get listId {
    final $$ShoppingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<double> get estimatedPrice => $composableBuilder(
    column: $table.estimatedPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualPrice => $composableBuilder(
    column: $table.actualPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<bool> get isOnSale =>
      $composableBuilder(column: $table.isOnSale, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pantryQuantityAvailable => $composableBuilder(
    column: $table.pantryQuantityAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ShoppingListsTableAnnotationComposer get listId {
    final $$ShoppingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.shoppingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem,
          $$ShoppingListItemsTableFilterComposer,
          $$ShoppingListItemsTableOrderingComposer,
          $$ShoppingListItemsTableAnnotationComposer,
          $$ShoppingListItemsTableCreateCompanionBuilder,
          $$ShoppingListItemsTableUpdateCompanionBuilder,
          (ShoppingListItem, $$ShoppingListItemsTableReferences),
          ShoppingListItem,
          PrefetchHooks Function({bool listId, bool productId})
        > {
  $$ShoppingListItemsTableTableManager(
    _$AppDatabase db,
    $ShoppingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<double?> estimatedPrice = const Value.absent(),
                Value<double?> actualPrice = const Value.absent(),
                Value<double?> salePrice = const Value.absent(),
                Value<bool> isOnSale = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<String?> recipeName = const Value.absent(),
                Value<double> pantryQuantityAvailable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion(
                id: id,
                listId: listId,
                productId: productId,
                name: name,
                brand: brand,
                category: category,
                quantity: quantity,
                unitType: unitType,
                estimatedPrice: estimatedPrice,
                actualPrice: actualPrice,
                salePrice: salePrice,
                isOnSale: isOnSale,
                isCompleted: isCompleted,
                priority: priority,
                notes: notes,
                recipeId: recipeId,
                recipeName: recipeName,
                pantryQuantityAvailable: pantryQuantityAvailable,
                sortOrder: sortOrder,
                addedAt: addedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listId,
                Value<String?> productId = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitType = const Value.absent(),
                Value<double?> estimatedPrice = const Value.absent(),
                Value<double?> actualPrice = const Value.absent(),
                Value<double?> salePrice = const Value.absent(),
                Value<bool> isOnSale = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<String?> recipeName = const Value.absent(),
                Value<double> pantryQuantityAvailable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime addedAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion.insert(
                id: id,
                listId: listId,
                productId: productId,
                name: name,
                brand: brand,
                category: category,
                quantity: quantity,
                unitType: unitType,
                estimatedPrice: estimatedPrice,
                actualPrice: actualPrice,
                salePrice: salePrice,
                isOnSale: isOnSale,
                isCompleted: isCompleted,
                priority: priority,
                notes: notes,
                recipeId: recipeId,
                recipeName: recipeName,
                pantryQuantityAvailable: pantryQuantityAvailable,
                sortOrder: sortOrder,
                addedAt: addedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShoppingListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable:
                                    $$ShoppingListItemsTableReferences
                                        ._listIdTable(db),
                                referencedColumn:
                                    $$ShoppingListItemsTableReferences
                                        ._listIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$ShoppingListItemsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$ShoppingListItemsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListItemsTable,
      ShoppingListItem,
      $$ShoppingListItemsTableFilterComposer,
      $$ShoppingListItemsTableOrderingComposer,
      $$ShoppingListItemsTableAnnotationComposer,
      $$ShoppingListItemsTableCreateCompanionBuilder,
      $$ShoppingListItemsTableUpdateCompanionBuilder,
      (ShoppingListItem, $$ShoppingListItemsTableReferences),
      ShoppingListItem,
      PrefetchHooks Function({bool listId, bool productId})
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      required String id,
      required String name,
      Value<String> description,
      Value<String> cuisine,
      Value<int> servings,
      Value<int> prepTimeMinutes,
      Value<int> cookTimeMinutes,
      Value<int> totalTimeMinutes,
      Value<String> difficulty,
      Value<String> tagsJson,
      Value<String> dietaryFlagsJson,
      Value<String> ingredientsJson,
      Value<String> instructionsJson,
      Value<String?> nutritionJson,
      Value<String?> imageUrl,
      Value<String> source,
      Value<String?> aiMetadataJson,
      Value<bool> isFavorite,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> cuisine,
      Value<int> servings,
      Value<int> prepTimeMinutes,
      Value<int> cookTimeMinutes,
      Value<int> totalTimeMinutes,
      Value<String> difficulty,
      Value<String> tagsJson,
      Value<String> dietaryFlagsJson,
      Value<String> ingredientsJson,
      Value<String> instructionsJson,
      Value<String?> nutritionJson,
      Value<String?> imageUrl,
      Value<String> source,
      Value<String?> aiMetadataJson,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealPlanDaysTable, List<MealPlanDay>>
  _mealPlanDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPlanDays,
    aliasName: 'recipes__id__meal_plan_days__recipe_id',
  );

  $$MealPlanDaysTableProcessedTableManager get mealPlanDaysRefs {
    final manager = $$MealPlanDaysTableTableManager(
      $_db,
      $_db.mealPlanDays,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealPlanDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeFeedbackTable, List<RecipeFeedbackData>>
  _recipeFeedbackRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeFeedback,
    aliasName: 'recipes__id__recipe_feedback__recipe_id',
  );

  $$RecipeFeedbackTableProcessedTableManager get recipeFeedbackRefs {
    final manager = $$RecipeFeedbackTableTableManager(
      $_db,
      $_db.recipeFeedback,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeFeedbackRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisine => $composableBuilder(
    column: $table.cuisine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTimeMinutes => $composableBuilder(
    column: $table.totalTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietaryFlagsJson => $composableBuilder(
    column: $table.dietaryFlagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructionsJson => $composableBuilder(
    column: $table.instructionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutritionJson => $composableBuilder(
    column: $table.nutritionJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiMetadataJson => $composableBuilder(
    column: $table.aiMetadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealPlanDaysRefs(
    Expression<bool> Function($$MealPlanDaysTableFilterComposer f) f,
  ) {
    final $$MealPlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPlanDays,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.mealPlanDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeFeedbackRefs(
    Expression<bool> Function($$RecipeFeedbackTableFilterComposer f) f,
  ) {
    final $$RecipeFeedbackTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeFeedback,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeFeedbackTableFilterComposer(
            $db: $db,
            $table: $db.recipeFeedback,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisine => $composableBuilder(
    column: $table.cuisine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTimeMinutes => $composableBuilder(
    column: $table.totalTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietaryFlagsJson => $composableBuilder(
    column: $table.dietaryFlagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructionsJson => $composableBuilder(
    column: $table.instructionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutritionJson => $composableBuilder(
    column: $table.nutritionJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiMetadataJson => $composableBuilder(
    column: $table.aiMetadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cuisine =>
      $composableBuilder(column: $table.cuisine, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTimeMinutes => $composableBuilder(
    column: $table.totalTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get dietaryFlagsJson => $composableBuilder(
    column: $table.dietaryFlagsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ingredientsJson => $composableBuilder(
    column: $table.ingredientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructionsJson => $composableBuilder(
    column: $table.instructionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nutritionJson => $composableBuilder(
    column: $table.nutritionJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get aiMetadataJson => $composableBuilder(
    column: $table.aiMetadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mealPlanDaysRefs<T extends Object>(
    Expression<T> Function($$MealPlanDaysTableAnnotationComposer a) f,
  ) {
    final $$MealPlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPlanDays,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPlanDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipeFeedbackRefs<T extends Object>(
    Expression<T> Function($$RecipeFeedbackTableAnnotationComposer a) f,
  ) {
    final $$RecipeFeedbackTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeFeedback,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeFeedbackTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeFeedback,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool mealPlanDaysRefs,
            bool recipeFeedbackRefs,
          })
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> cuisine = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<int> prepTimeMinutes = const Value.absent(),
                Value<int> cookTimeMinutes = const Value.absent(),
                Value<int> totalTimeMinutes = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> dietaryFlagsJson = const Value.absent(),
                Value<String> ingredientsJson = const Value.absent(),
                Value<String> instructionsJson = const Value.absent(),
                Value<String?> nutritionJson = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> aiMetadataJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                description: description,
                cuisine: cuisine,
                servings: servings,
                prepTimeMinutes: prepTimeMinutes,
                cookTimeMinutes: cookTimeMinutes,
                totalTimeMinutes: totalTimeMinutes,
                difficulty: difficulty,
                tagsJson: tagsJson,
                dietaryFlagsJson: dietaryFlagsJson,
                ingredientsJson: ingredientsJson,
                instructionsJson: instructionsJson,
                nutritionJson: nutritionJson,
                imageUrl: imageUrl,
                source: source,
                aiMetadataJson: aiMetadataJson,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                Value<String> cuisine = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<int> prepTimeMinutes = const Value.absent(),
                Value<int> cookTimeMinutes = const Value.absent(),
                Value<int> totalTimeMinutes = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> dietaryFlagsJson = const Value.absent(),
                Value<String> ingredientsJson = const Value.absent(),
                Value<String> instructionsJson = const Value.absent(),
                Value<String?> nutritionJson = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> aiMetadataJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                description: description,
                cuisine: cuisine,
                servings: servings,
                prepTimeMinutes: prepTimeMinutes,
                cookTimeMinutes: cookTimeMinutes,
                totalTimeMinutes: totalTimeMinutes,
                difficulty: difficulty,
                tagsJson: tagsJson,
                dietaryFlagsJson: dietaryFlagsJson,
                ingredientsJson: ingredientsJson,
                instructionsJson: instructionsJson,
                nutritionJson: nutritionJson,
                imageUrl: imageUrl,
                source: source,
                aiMetadataJson: aiMetadataJson,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mealPlanDaysRefs = false, recipeFeedbackRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealPlanDaysRefs) db.mealPlanDays,
                    if (recipeFeedbackRefs) db.recipeFeedback,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealPlanDaysRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          MealPlanDay
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._mealPlanDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).mealPlanDaysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeFeedbackRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeFeedbackData
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeFeedbackRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeFeedbackRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({bool mealPlanDaysRefs, bool recipeFeedbackRefs})
    >;
typedef $$MealPlansTableCreateCompanionBuilder =
    MealPlansCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime startDate,
      required DateTime endDate,
      Value<String> planType,
      Value<int> rowid,
    });
typedef $$MealPlansTableUpdateCompanionBuilder =
    MealPlansCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> planType,
      Value<int> rowid,
    });

final class $$MealPlansTableReferences
    extends BaseReferences<_$AppDatabase, $MealPlansTable, MealPlan> {
  $$MealPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealPlanDaysTable, List<MealPlanDay>>
  _mealPlanDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealPlanDays,
    aliasName: 'meal_plans__id__meal_plan_days__plan_id',
  );

  $$MealPlanDaysTableProcessedTableManager get mealPlanDaysRefs {
    final manager = $$MealPlanDaysTableTableManager(
      $_db,
      $_db.mealPlanDays,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealPlanDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealPlanDaysRefs(
    Expression<bool> Function($$MealPlanDaysTableFilterComposer f) f,
  ) {
    final $$MealPlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPlanDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.mealPlanDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  Expression<T> mealPlanDaysRefs<T extends Object>(
    Expression<T> Function($$MealPlanDaysTableAnnotationComposer a) f,
  ) {
    final $$MealPlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealPlanDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPlanDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPlansTable,
          MealPlan,
          $$MealPlansTableFilterComposer,
          $$MealPlansTableOrderingComposer,
          $$MealPlansTableAnnotationComposer,
          $$MealPlansTableCreateCompanionBuilder,
          $$MealPlansTableUpdateCompanionBuilder,
          (MealPlan, $$MealPlansTableReferences),
          MealPlan,
          PrefetchHooks Function({bool mealPlanDaysRefs})
        > {
  $$MealPlansTableTableManager(_$AppDatabase db, $MealPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> planType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlansCompanion(
                id: id,
                createdAt: createdAt,
                startDate: startDate,
                endDate: endDate,
                planType: planType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime startDate,
                required DateTime endDate,
                Value<String> planType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlansCompanion.insert(
                id: id,
                createdAt: createdAt,
                startDate: startDate,
                endDate: endDate,
                planType: planType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealPlanDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealPlanDaysRefs) db.mealPlanDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealPlanDaysRefs)
                    await $_getPrefetchedData<
                      MealPlan,
                      $MealPlansTable,
                      MealPlanDay
                    >(
                      currentTable: table,
                      referencedTable: $$MealPlansTableReferences
                          ._mealPlanDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MealPlansTableReferences(
                            db,
                            table,
                            p0,
                          ).mealPlanDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPlansTable,
      MealPlan,
      $$MealPlansTableFilterComposer,
      $$MealPlansTableOrderingComposer,
      $$MealPlansTableAnnotationComposer,
      $$MealPlansTableCreateCompanionBuilder,
      $$MealPlansTableUpdateCompanionBuilder,
      (MealPlan, $$MealPlansTableReferences),
      MealPlan,
      PrefetchHooks Function({bool mealPlanDaysRefs})
    >;
typedef $$MealPlanDaysTableCreateCompanionBuilder =
    MealPlanDaysCompanion Function({
      required String id,
      required String planId,
      required DateTime date,
      required String recipeId,
      Value<String?> recipeName,
      Value<bool> isCooked,
      Value<int> sortOrder,
      Value<String> mealType,
      Value<int> rowid,
    });
typedef $$MealPlanDaysTableUpdateCompanionBuilder =
    MealPlanDaysCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<DateTime> date,
      Value<String> recipeId,
      Value<String?> recipeName,
      Value<bool> isCooked,
      Value<int> sortOrder,
      Value<String> mealType,
      Value<int> rowid,
    });

final class $$MealPlanDaysTableReferences
    extends BaseReferences<_$AppDatabase, $MealPlanDaysTable, MealPlanDay> {
  $$MealPlanDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealPlansTable _planIdTable(_$AppDatabase db) =>
      db.mealPlans.createAlias('meal_plan_days__plan_id__meal_plans__id');

  $$MealPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$MealPlansTableTableManager(
      $_db,
      $_db.mealPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('meal_plan_days__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealPlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlanDaysTable> {
  $$MealPlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCooked => $composableBuilder(
    column: $table.isCooked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  $$MealPlansTableFilterComposer get planId {
    final $$MealPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableFilterComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlanDaysTable> {
  $$MealPlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCooked => $composableBuilder(
    column: $table.isCooked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealPlansTableOrderingComposer get planId {
    final $$MealPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableOrderingComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlanDaysTable> {
  $$MealPlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCooked =>
      $composableBuilder(column: $table.isCooked, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  $$MealPlansTableAnnotationComposer get planId {
    final $$MealPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealPlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPlanDaysTable,
          MealPlanDay,
          $$MealPlanDaysTableFilterComposer,
          $$MealPlanDaysTableOrderingComposer,
          $$MealPlanDaysTableAnnotationComposer,
          $$MealPlanDaysTableCreateCompanionBuilder,
          $$MealPlanDaysTableUpdateCompanionBuilder,
          (MealPlanDay, $$MealPlanDaysTableReferences),
          MealPlanDay,
          PrefetchHooks Function({bool planId, bool recipeId})
        > {
  $$MealPlanDaysTableTableManager(_$AppDatabase db, $MealPlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String?> recipeName = const Value.absent(),
                Value<bool> isCooked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlanDaysCompanion(
                id: id,
                planId: planId,
                date: date,
                recipeId: recipeId,
                recipeName: recipeName,
                isCooked: isCooked,
                sortOrder: sortOrder,
                mealType: mealType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required DateTime date,
                required String recipeId,
                Value<String?> recipeName = const Value.absent(),
                Value<bool> isCooked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlanDaysCompanion.insert(
                id: id,
                planId: planId,
                date: date,
                recipeId: recipeId,
                recipeName: recipeName,
                isCooked: isCooked,
                sortOrder: sortOrder,
                mealType: mealType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealPlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false, recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$MealPlanDaysTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$MealPlanDaysTableReferences
                                    ._planIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$MealPlanDaysTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$MealPlanDaysTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealPlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPlanDaysTable,
      MealPlanDay,
      $$MealPlanDaysTableFilterComposer,
      $$MealPlanDaysTableOrderingComposer,
      $$MealPlanDaysTableAnnotationComposer,
      $$MealPlanDaysTableCreateCompanionBuilder,
      $$MealPlanDaysTableUpdateCompanionBuilder,
      (MealPlanDay, $$MealPlanDaysTableReferences),
      MealPlanDay,
      PrefetchHooks Function({bool planId, bool recipeId})
    >;
typedef $$RecipeFeedbackTableCreateCompanionBuilder =
    RecipeFeedbackCompanion Function({
      required String id,
      required String recipeId,
      required String feedback,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RecipeFeedbackTableUpdateCompanionBuilder =
    RecipeFeedbackCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String> feedback,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RecipeFeedbackTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeFeedbackTable,
          RecipeFeedbackData
        > {
  $$RecipeFeedbackTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_feedback__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeFeedbackTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeFeedbackTable> {
  $$RecipeFeedbackTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeFeedbackTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeFeedbackTable> {
  $$RecipeFeedbackTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeFeedbackTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeFeedbackTable> {
  $$RecipeFeedbackTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get feedback =>
      $composableBuilder(column: $table.feedback, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeFeedbackTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeFeedbackTable,
          RecipeFeedbackData,
          $$RecipeFeedbackTableFilterComposer,
          $$RecipeFeedbackTableOrderingComposer,
          $$RecipeFeedbackTableAnnotationComposer,
          $$RecipeFeedbackTableCreateCompanionBuilder,
          $$RecipeFeedbackTableUpdateCompanionBuilder,
          (RecipeFeedbackData, $$RecipeFeedbackTableReferences),
          RecipeFeedbackData,
          PrefetchHooks Function({bool recipeId})
        > {
  $$RecipeFeedbackTableTableManager(
    _$AppDatabase db,
    $RecipeFeedbackTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeFeedbackTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeFeedbackTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeFeedbackTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String> feedback = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeFeedbackCompanion(
                id: id,
                recipeId: recipeId,
                feedback: feedback,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required String feedback,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipeFeedbackCompanion.insert(
                id: id,
                recipeId: recipeId,
                feedback: feedback,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeFeedbackTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$RecipeFeedbackTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn:
                                    $$RecipeFeedbackTableReferences
                                        ._recipeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeFeedbackTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeFeedbackTable,
      RecipeFeedbackData,
      $$RecipeFeedbackTableFilterComposer,
      $$RecipeFeedbackTableOrderingComposer,
      $$RecipeFeedbackTableAnnotationComposer,
      $$RecipeFeedbackTableCreateCompanionBuilder,
      $$RecipeFeedbackTableUpdateCompanionBuilder,
      (RecipeFeedbackData, $$RecipeFeedbackTableReferences),
      RecipeFeedbackData,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$FamilyProfilesTableCreateCompanionBuilder =
    FamilyProfilesCompanion Function({
      required String id,
      Value<int> adults,
      Value<int> kids,
      Value<String> kidAgeRangesJson,
      Value<String> dietaryRestrictionsJson,
      Value<String> cuisinePreferencesJson,
      Value<String?> otherDietaryNotes,
      Value<String> preferredCookTime,
      Value<String> budgetLevel,
      Value<String> pantryStaplesJson,
      Value<bool> onboardingCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FamilyProfilesTableUpdateCompanionBuilder =
    FamilyProfilesCompanion Function({
      Value<String> id,
      Value<int> adults,
      Value<int> kids,
      Value<String> kidAgeRangesJson,
      Value<String> dietaryRestrictionsJson,
      Value<String> cuisinePreferencesJson,
      Value<String?> otherDietaryNotes,
      Value<String> preferredCookTime,
      Value<String> budgetLevel,
      Value<String> pantryStaplesJson,
      Value<bool> onboardingCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FamilyProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyProfilesTable> {
  $$FamilyProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adults => $composableBuilder(
    column: $table.adults,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kids => $composableBuilder(
    column: $table.kids,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kidAgeRangesJson => $composableBuilder(
    column: $table.kidAgeRangesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietaryRestrictionsJson => $composableBuilder(
    column: $table.dietaryRestrictionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisinePreferencesJson => $composableBuilder(
    column: $table.cuisinePreferencesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherDietaryNotes => $composableBuilder(
    column: $table.otherDietaryNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredCookTime => $composableBuilder(
    column: $table.preferredCookTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetLevel => $composableBuilder(
    column: $table.budgetLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pantryStaplesJson => $composableBuilder(
    column: $table.pantryStaplesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyProfilesTable> {
  $$FamilyProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adults => $composableBuilder(
    column: $table.adults,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kids => $composableBuilder(
    column: $table.kids,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kidAgeRangesJson => $composableBuilder(
    column: $table.kidAgeRangesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietaryRestrictionsJson => $composableBuilder(
    column: $table.dietaryRestrictionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisinePreferencesJson => $composableBuilder(
    column: $table.cuisinePreferencesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherDietaryNotes => $composableBuilder(
    column: $table.otherDietaryNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredCookTime => $composableBuilder(
    column: $table.preferredCookTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetLevel => $composableBuilder(
    column: $table.budgetLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pantryStaplesJson => $composableBuilder(
    column: $table.pantryStaplesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyProfilesTable> {
  $$FamilyProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get adults =>
      $composableBuilder(column: $table.adults, builder: (column) => column);

  GeneratedColumn<int> get kids =>
      $composableBuilder(column: $table.kids, builder: (column) => column);

  GeneratedColumn<String> get kidAgeRangesJson => $composableBuilder(
    column: $table.kidAgeRangesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietaryRestrictionsJson => $composableBuilder(
    column: $table.dietaryRestrictionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cuisinePreferencesJson => $composableBuilder(
    column: $table.cuisinePreferencesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get otherDietaryNotes => $composableBuilder(
    column: $table.otherDietaryNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredCookTime => $composableBuilder(
    column: $table.preferredCookTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetLevel => $composableBuilder(
    column: $table.budgetLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pantryStaplesJson => $composableBuilder(
    column: $table.pantryStaplesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FamilyProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyProfilesTable,
          FamilyProfile,
          $$FamilyProfilesTableFilterComposer,
          $$FamilyProfilesTableOrderingComposer,
          $$FamilyProfilesTableAnnotationComposer,
          $$FamilyProfilesTableCreateCompanionBuilder,
          $$FamilyProfilesTableUpdateCompanionBuilder,
          (
            FamilyProfile,
            BaseReferences<_$AppDatabase, $FamilyProfilesTable, FamilyProfile>,
          ),
          FamilyProfile,
          PrefetchHooks Function()
        > {
  $$FamilyProfilesTableTableManager(
    _$AppDatabase db,
    $FamilyProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> adults = const Value.absent(),
                Value<int> kids = const Value.absent(),
                Value<String> kidAgeRangesJson = const Value.absent(),
                Value<String> dietaryRestrictionsJson = const Value.absent(),
                Value<String> cuisinePreferencesJson = const Value.absent(),
                Value<String?> otherDietaryNotes = const Value.absent(),
                Value<String> preferredCookTime = const Value.absent(),
                Value<String> budgetLevel = const Value.absent(),
                Value<String> pantryStaplesJson = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyProfilesCompanion(
                id: id,
                adults: adults,
                kids: kids,
                kidAgeRangesJson: kidAgeRangesJson,
                dietaryRestrictionsJson: dietaryRestrictionsJson,
                cuisinePreferencesJson: cuisinePreferencesJson,
                otherDietaryNotes: otherDietaryNotes,
                preferredCookTime: preferredCookTime,
                budgetLevel: budgetLevel,
                pantryStaplesJson: pantryStaplesJson,
                onboardingCompleted: onboardingCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> adults = const Value.absent(),
                Value<int> kids = const Value.absent(),
                Value<String> kidAgeRangesJson = const Value.absent(),
                Value<String> dietaryRestrictionsJson = const Value.absent(),
                Value<String> cuisinePreferencesJson = const Value.absent(),
                Value<String?> otherDietaryNotes = const Value.absent(),
                Value<String> preferredCookTime = const Value.absent(),
                Value<String> budgetLevel = const Value.absent(),
                Value<String> pantryStaplesJson = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FamilyProfilesCompanion.insert(
                id: id,
                adults: adults,
                kids: kids,
                kidAgeRangesJson: kidAgeRangesJson,
                dietaryRestrictionsJson: dietaryRestrictionsJson,
                cuisinePreferencesJson: cuisinePreferencesJson,
                otherDietaryNotes: otherDietaryNotes,
                preferredCookTime: preferredCookTime,
                budgetLevel: budgetLevel,
                pantryStaplesJson: pantryStaplesJson,
                onboardingCompleted: onboardingCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyProfilesTable,
      FamilyProfile,
      $$FamilyProfilesTableFilterComposer,
      $$FamilyProfilesTableOrderingComposer,
      $$FamilyProfilesTableAnnotationComposer,
      $$FamilyProfilesTableCreateCompanionBuilder,
      $$FamilyProfilesTableUpdateCompanionBuilder,
      (
        FamilyProfile,
        BaseReferences<_$AppDatabase, $FamilyProfilesTable, FamilyProfile>,
      ),
      FamilyProfile,
      PrefetchHooks Function()
    >;
typedef $$UserPreferencesTableTableCreateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<int> id,
      Value<String> preferredCurrency,
      Value<String> dietaryRestrictionsJson,
      Value<String> allergenAlertsJson,
      Value<bool> autoAddToList,
      Value<int> defaultQuantity,
      Value<bool> scanSound,
      Value<int> scanSoundId,
      Value<bool> hapticFeedback,
      Value<String?> selectedListId,
      Value<String> dismissedHintsJson,
      Value<bool> syncEnabled,
      Value<bool> onboardingCompleted,
      Value<int> weeklyPlanCount,
      Value<DateTime?> weeklyPlanResetDate,
      Value<bool> isPremium,
      Value<String?> subscriptionId,
      Value<String?> subscriptionPlan,
      Value<DateTime?> subscriptionExpiresAt,
      Value<String?> voicePersona,
      Value<String> mealType,
      Value<String?> sharedListId,
      Value<String?> sharedPantryId,
      Value<bool> enableNotifications,
      Value<bool> notifySharingEvents,
      Value<bool> notifyExpiryAlerts,
      Value<bool> notifyReorderAlerts,
      Value<String> theme,
      Value<String> language,
    });
typedef $$UserPreferencesTableTableUpdateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<int> id,
      Value<String> preferredCurrency,
      Value<String> dietaryRestrictionsJson,
      Value<String> allergenAlertsJson,
      Value<bool> autoAddToList,
      Value<int> defaultQuantity,
      Value<bool> scanSound,
      Value<int> scanSoundId,
      Value<bool> hapticFeedback,
      Value<String?> selectedListId,
      Value<String> dismissedHintsJson,
      Value<bool> syncEnabled,
      Value<bool> onboardingCompleted,
      Value<int> weeklyPlanCount,
      Value<DateTime?> weeklyPlanResetDate,
      Value<bool> isPremium,
      Value<String?> subscriptionId,
      Value<String?> subscriptionPlan,
      Value<DateTime?> subscriptionExpiresAt,
      Value<String?> voicePersona,
      Value<String> mealType,
      Value<String?> sharedListId,
      Value<String?> sharedPantryId,
      Value<bool> enableNotifications,
      Value<bool> notifySharingEvents,
      Value<bool> notifyExpiryAlerts,
      Value<bool> notifyReorderAlerts,
      Value<String> theme,
      Value<String> language,
    });

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietaryRestrictionsJson => $composableBuilder(
    column: $table.dietaryRestrictionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergenAlertsJson => $composableBuilder(
    column: $table.allergenAlertsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoAddToList => $composableBuilder(
    column: $table.autoAddToList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultQuantity => $composableBuilder(
    column: $table.defaultQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get scanSound => $composableBuilder(
    column: $table.scanSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scanSoundId => $composableBuilder(
    column: $table.scanSoundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticFeedback => $composableBuilder(
    column: $table.hapticFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedListId => $composableBuilder(
    column: $table.selectedListId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dismissedHintsJson => $composableBuilder(
    column: $table.dismissedHintsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyPlanCount => $composableBuilder(
    column: $table.weeklyPlanCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weeklyPlanResetDate => $composableBuilder(
    column: $table.weeklyPlanResetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionPlan => $composableBuilder(
    column: $table.subscriptionPlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get subscriptionExpiresAt => $composableBuilder(
    column: $table.subscriptionExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voicePersona => $composableBuilder(
    column: $table.voicePersona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedListId => $composableBuilder(
    column: $table.sharedListId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedPantryId => $composableBuilder(
    column: $table.sharedPantryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableNotifications => $composableBuilder(
    column: $table.enableNotifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifySharingEvents => $composableBuilder(
    column: $table.notifySharingEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyExpiryAlerts => $composableBuilder(
    column: $table.notifyExpiryAlerts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyReorderAlerts => $composableBuilder(
    column: $table.notifyReorderAlerts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietaryRestrictionsJson => $composableBuilder(
    column: $table.dietaryRestrictionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergenAlertsJson => $composableBuilder(
    column: $table.allergenAlertsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoAddToList => $composableBuilder(
    column: $table.autoAddToList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultQuantity => $composableBuilder(
    column: $table.defaultQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get scanSound => $composableBuilder(
    column: $table.scanSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scanSoundId => $composableBuilder(
    column: $table.scanSoundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticFeedback => $composableBuilder(
    column: $table.hapticFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedListId => $composableBuilder(
    column: $table.selectedListId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dismissedHintsJson => $composableBuilder(
    column: $table.dismissedHintsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyPlanCount => $composableBuilder(
    column: $table.weeklyPlanCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weeklyPlanResetDate => $composableBuilder(
    column: $table.weeklyPlanResetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionPlan => $composableBuilder(
    column: $table.subscriptionPlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get subscriptionExpiresAt => $composableBuilder(
    column: $table.subscriptionExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voicePersona => $composableBuilder(
    column: $table.voicePersona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedListId => $composableBuilder(
    column: $table.sharedListId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedPantryId => $composableBuilder(
    column: $table.sharedPantryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableNotifications => $composableBuilder(
    column: $table.enableNotifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifySharingEvents => $composableBuilder(
    column: $table.notifySharingEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyExpiryAlerts => $composableBuilder(
    column: $table.notifyExpiryAlerts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyReorderAlerts => $composableBuilder(
    column: $table.notifyReorderAlerts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietaryRestrictionsJson => $composableBuilder(
    column: $table.dietaryRestrictionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergenAlertsJson => $composableBuilder(
    column: $table.allergenAlertsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoAddToList => $composableBuilder(
    column: $table.autoAddToList,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultQuantity => $composableBuilder(
    column: $table.defaultQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get scanSound =>
      $composableBuilder(column: $table.scanSound, builder: (column) => column);

  GeneratedColumn<int> get scanSoundId => $composableBuilder(
    column: $table.scanSoundId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticFeedback => $composableBuilder(
    column: $table.hapticFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedListId => $composableBuilder(
    column: $table.selectedListId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dismissedHintsJson => $composableBuilder(
    column: $table.dismissedHintsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyPlanCount => $composableBuilder(
    column: $table.weeklyPlanCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get weeklyPlanResetDate => $composableBuilder(
    column: $table.weeklyPlanResetDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subscriptionPlan => $composableBuilder(
    column: $table.subscriptionPlan,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get subscriptionExpiresAt => $composableBuilder(
    column: $table.subscriptionExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voicePersona => $composableBuilder(
    column: $table.voicePersona,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get sharedListId => $composableBuilder(
    column: $table.sharedListId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sharedPantryId => $composableBuilder(
    column: $table.sharedPantryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableNotifications => $composableBuilder(
    column: $table.enableNotifications,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifySharingEvents => $composableBuilder(
    column: $table.notifySharingEvents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyExpiryAlerts => $composableBuilder(
    column: $table.notifyExpiryAlerts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyReorderAlerts => $composableBuilder(
    column: $table.notifyReorderAlerts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);
}

class $$UserPreferencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData,
          $$UserPreferencesTableTableFilterComposer,
          $$UserPreferencesTableTableOrderingComposer,
          $$UserPreferencesTableTableAnnotationComposer,
          $$UserPreferencesTableTableCreateCompanionBuilder,
          $$UserPreferencesTableTableUpdateCompanionBuilder,
          (
            UserPreferencesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTableTable,
              UserPreferencesTableData
            >,
          ),
          UserPreferencesTableData,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> preferredCurrency = const Value.absent(),
                Value<String> dietaryRestrictionsJson = const Value.absent(),
                Value<String> allergenAlertsJson = const Value.absent(),
                Value<bool> autoAddToList = const Value.absent(),
                Value<int> defaultQuantity = const Value.absent(),
                Value<bool> scanSound = const Value.absent(),
                Value<int> scanSoundId = const Value.absent(),
                Value<bool> hapticFeedback = const Value.absent(),
                Value<String?> selectedListId = const Value.absent(),
                Value<String> dismissedHintsJson = const Value.absent(),
                Value<bool> syncEnabled = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> weeklyPlanCount = const Value.absent(),
                Value<DateTime?> weeklyPlanResetDate = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<String?> subscriptionId = const Value.absent(),
                Value<String?> subscriptionPlan = const Value.absent(),
                Value<DateTime?> subscriptionExpiresAt = const Value.absent(),
                Value<String?> voicePersona = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String?> sharedListId = const Value.absent(),
                Value<String?> sharedPantryId = const Value.absent(),
                Value<bool> enableNotifications = const Value.absent(),
                Value<bool> notifySharingEvents = const Value.absent(),
                Value<bool> notifyExpiryAlerts = const Value.absent(),
                Value<bool> notifyReorderAlerts = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> language = const Value.absent(),
              }) => UserPreferencesTableCompanion(
                id: id,
                preferredCurrency: preferredCurrency,
                dietaryRestrictionsJson: dietaryRestrictionsJson,
                allergenAlertsJson: allergenAlertsJson,
                autoAddToList: autoAddToList,
                defaultQuantity: defaultQuantity,
                scanSound: scanSound,
                scanSoundId: scanSoundId,
                hapticFeedback: hapticFeedback,
                selectedListId: selectedListId,
                dismissedHintsJson: dismissedHintsJson,
                syncEnabled: syncEnabled,
                onboardingCompleted: onboardingCompleted,
                weeklyPlanCount: weeklyPlanCount,
                weeklyPlanResetDate: weeklyPlanResetDate,
                isPremium: isPremium,
                subscriptionId: subscriptionId,
                subscriptionPlan: subscriptionPlan,
                subscriptionExpiresAt: subscriptionExpiresAt,
                voicePersona: voicePersona,
                mealType: mealType,
                sharedListId: sharedListId,
                sharedPantryId: sharedPantryId,
                enableNotifications: enableNotifications,
                notifySharingEvents: notifySharingEvents,
                notifyExpiryAlerts: notifyExpiryAlerts,
                notifyReorderAlerts: notifyReorderAlerts,
                theme: theme,
                language: language,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> preferredCurrency = const Value.absent(),
                Value<String> dietaryRestrictionsJson = const Value.absent(),
                Value<String> allergenAlertsJson = const Value.absent(),
                Value<bool> autoAddToList = const Value.absent(),
                Value<int> defaultQuantity = const Value.absent(),
                Value<bool> scanSound = const Value.absent(),
                Value<int> scanSoundId = const Value.absent(),
                Value<bool> hapticFeedback = const Value.absent(),
                Value<String?> selectedListId = const Value.absent(),
                Value<String> dismissedHintsJson = const Value.absent(),
                Value<bool> syncEnabled = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> weeklyPlanCount = const Value.absent(),
                Value<DateTime?> weeklyPlanResetDate = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<String?> subscriptionId = const Value.absent(),
                Value<String?> subscriptionPlan = const Value.absent(),
                Value<DateTime?> subscriptionExpiresAt = const Value.absent(),
                Value<String?> voicePersona = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String?> sharedListId = const Value.absent(),
                Value<String?> sharedPantryId = const Value.absent(),
                Value<bool> enableNotifications = const Value.absent(),
                Value<bool> notifySharingEvents = const Value.absent(),
                Value<bool> notifyExpiryAlerts = const Value.absent(),
                Value<bool> notifyReorderAlerts = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<String> language = const Value.absent(),
              }) => UserPreferencesTableCompanion.insert(
                id: id,
                preferredCurrency: preferredCurrency,
                dietaryRestrictionsJson: dietaryRestrictionsJson,
                allergenAlertsJson: allergenAlertsJson,
                autoAddToList: autoAddToList,
                defaultQuantity: defaultQuantity,
                scanSound: scanSound,
                scanSoundId: scanSoundId,
                hapticFeedback: hapticFeedback,
                selectedListId: selectedListId,
                dismissedHintsJson: dismissedHintsJson,
                syncEnabled: syncEnabled,
                onboardingCompleted: onboardingCompleted,
                weeklyPlanCount: weeklyPlanCount,
                weeklyPlanResetDate: weeklyPlanResetDate,
                isPremium: isPremium,
                subscriptionId: subscriptionId,
                subscriptionPlan: subscriptionPlan,
                subscriptionExpiresAt: subscriptionExpiresAt,
                voicePersona: voicePersona,
                mealType: mealType,
                sharedListId: sharedListId,
                sharedPantryId: sharedPantryId,
                enableNotifications: enableNotifications,
                notifySharingEvents: notifySharingEvents,
                notifyExpiryAlerts: notifyExpiryAlerts,
                notifyReorderAlerts: notifyReorderAlerts,
                theme: theme,
                language: language,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTableTable,
      UserPreferencesTableData,
      $$UserPreferencesTableTableFilterComposer,
      $$UserPreferencesTableTableOrderingComposer,
      $$UserPreferencesTableTableAnnotationComposer,
      $$UserPreferencesTableTableCreateCompanionBuilder,
      $$UserPreferencesTableTableUpdateCompanionBuilder,
      (
        UserPreferencesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData
        >,
      ),
      UserPreferencesTableData,
      PrefetchHooks Function()
    >;
typedef $$PurchaseHistoriesTableCreateCompanionBuilder =
    PurchaseHistoriesCompanion Function({
      required String id,
      Value<String?> barcode,
      required String productName,
      Value<String?> brand,
      Value<String?> productId,
      required DateTime dateFirstPurchased,
      required DateTime dateLastPurchased,
      Value<int> rowid,
    });
typedef $$PurchaseHistoriesTableUpdateCompanionBuilder =
    PurchaseHistoriesCompanion Function({
      Value<String> id,
      Value<String?> barcode,
      Value<String> productName,
      Value<String?> brand,
      Value<String?> productId,
      Value<DateTime> dateFirstPurchased,
      Value<DateTime> dateLastPurchased,
      Value<int> rowid,
    });

final class $$PurchaseHistoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PurchaseHistoriesTable,
          PurchaseHistory
        > {
  $$PurchaseHistoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PurchaseRecordsTable, List<PurchaseRecord>>
  _purchaseRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseRecords,
    aliasName: 'purchase_histories__id__purchase_records__history_id',
  );

  $$PurchaseRecordsTableProcessedTableManager get purchaseRecordsRefs {
    final manager = $$PurchaseRecordsTableTableManager(
      $_db,
      $_db.purchaseRecords,
    ).filter((f) => f.historyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _purchaseRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchaseHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseHistoriesTable> {
  $$PurchaseHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateFirstPurchased => $composableBuilder(
    column: $table.dateFirstPurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateLastPurchased => $composableBuilder(
    column: $table.dateLastPurchased,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> purchaseRecordsRefs(
    Expression<bool> Function($$PurchaseRecordsTableFilterComposer f) f,
  ) {
    final $$PurchaseRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseRecords,
      getReferencedColumn: (t) => t.historyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseRecordsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseHistoriesTable> {
  $$PurchaseHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateFirstPurchased => $composableBuilder(
    column: $table.dateFirstPurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateLastPurchased => $composableBuilder(
    column: $table.dateLastPurchased,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseHistoriesTable> {
  $$PurchaseHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFirstPurchased => $composableBuilder(
    column: $table.dateFirstPurchased,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateLastPurchased => $composableBuilder(
    column: $table.dateLastPurchased,
    builder: (column) => column,
  );

  Expression<T> purchaseRecordsRefs<T extends Object>(
    Expression<T> Function($$PurchaseRecordsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseRecords,
      getReferencedColumn: (t) => t.historyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseHistoriesTable,
          PurchaseHistory,
          $$PurchaseHistoriesTableFilterComposer,
          $$PurchaseHistoriesTableOrderingComposer,
          $$PurchaseHistoriesTableAnnotationComposer,
          $$PurchaseHistoriesTableCreateCompanionBuilder,
          $$PurchaseHistoriesTableUpdateCompanionBuilder,
          (PurchaseHistory, $$PurchaseHistoriesTableReferences),
          PurchaseHistory,
          PrefetchHooks Function({bool purchaseRecordsRefs})
        > {
  $$PurchaseHistoriesTableTableManager(
    _$AppDatabase db,
    $PurchaseHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<DateTime> dateFirstPurchased = const Value.absent(),
                Value<DateTime> dateLastPurchased = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHistoriesCompanion(
                id: id,
                barcode: barcode,
                productName: productName,
                brand: brand,
                productId: productId,
                dateFirstPurchased: dateFirstPurchased,
                dateLastPurchased: dateLastPurchased,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> barcode = const Value.absent(),
                required String productName,
                Value<String?> brand = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                required DateTime dateFirstPurchased,
                required DateTime dateLastPurchased,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseHistoriesCompanion.insert(
                id: id,
                barcode: barcode,
                productName: productName,
                brand: brand,
                productId: productId,
                dateFirstPurchased: dateFirstPurchased,
                dateLastPurchased: dateLastPurchased,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseHistoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchaseRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseRecordsRefs) db.purchaseRecords,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseRecordsRefs)
                    await $_getPrefetchedData<
                      PurchaseHistory,
                      $PurchaseHistoriesTable,
                      PurchaseRecord
                    >(
                      currentTable: table,
                      referencedTable: $$PurchaseHistoriesTableReferences
                          ._purchaseRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PurchaseHistoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).purchaseRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.historyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseHistoriesTable,
      PurchaseHistory,
      $$PurchaseHistoriesTableFilterComposer,
      $$PurchaseHistoriesTableOrderingComposer,
      $$PurchaseHistoriesTableAnnotationComposer,
      $$PurchaseHistoriesTableCreateCompanionBuilder,
      $$PurchaseHistoriesTableUpdateCompanionBuilder,
      (PurchaseHistory, $$PurchaseHistoriesTableReferences),
      PurchaseHistory,
      PrefetchHooks Function({bool purchaseRecordsRefs})
    >;
typedef $$PurchaseRecordsTableCreateCompanionBuilder =
    PurchaseRecordsCompanion Function({
      required String id,
      required String historyId,
      required double quantity,
      Value<double?> price,
      required DateTime datePurchased,
      Value<String?> storeName,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$PurchaseRecordsTableUpdateCompanionBuilder =
    PurchaseRecordsCompanion Function({
      Value<String> id,
      Value<String> historyId,
      Value<double> quantity,
      Value<double?> price,
      Value<DateTime> datePurchased,
      Value<String?> storeName,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$PurchaseRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PurchaseRecordsTable, PurchaseRecord> {
  $$PurchaseRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchaseHistoriesTable _historyIdTable(_$AppDatabase db) => db
      .purchaseHistories
      .createAlias('purchase_records__history_id__purchase_histories__id');

  $$PurchaseHistoriesTableProcessedTableManager get historyId {
    final $_column = $_itemColumn<String>('history_id')!;

    final manager = $$PurchaseHistoriesTableTableManager(
      $_db,
      $_db.purchaseHistories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_historyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseRecordsTable> {
  $$PurchaseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datePurchased => $composableBuilder(
    column: $table.datePurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchaseHistoriesTableFilterComposer get historyId {
    final $$PurchaseHistoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.historyId,
      referencedTable: $db.purchaseHistories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseHistoriesTableFilterComposer(
            $db: $db,
            $table: $db.purchaseHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseRecordsTable> {
  $$PurchaseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePurchased => $composableBuilder(
    column: $table.datePurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchaseHistoriesTableOrderingComposer get historyId {
    final $$PurchaseHistoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.historyId,
      referencedTable: $db.purchaseHistories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseHistoriesTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseRecordsTable> {
  $$PurchaseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get datePurchased => $composableBuilder(
    column: $table.datePurchased,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PurchaseHistoriesTableAnnotationComposer get historyId {
    final $$PurchaseHistoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.historyId,
          referencedTable: $db.purchaseHistories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PurchaseHistoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.purchaseHistories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PurchaseRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseRecordsTable,
          PurchaseRecord,
          $$PurchaseRecordsTableFilterComposer,
          $$PurchaseRecordsTableOrderingComposer,
          $$PurchaseRecordsTableAnnotationComposer,
          $$PurchaseRecordsTableCreateCompanionBuilder,
          $$PurchaseRecordsTableUpdateCompanionBuilder,
          (PurchaseRecord, $$PurchaseRecordsTableReferences),
          PurchaseRecord,
          PrefetchHooks Function({bool historyId})
        > {
  $$PurchaseRecordsTableTableManager(
    _$AppDatabase db,
    $PurchaseRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> historyId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<DateTime> datePurchased = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseRecordsCompanion(
                id: id,
                historyId: historyId,
                quantity: quantity,
                price: price,
                datePurchased: datePurchased,
                storeName: storeName,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String historyId,
                required double quantity,
                Value<double?> price = const Value.absent(),
                required DateTime datePurchased,
                Value<String?> storeName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseRecordsCompanion.insert(
                id: id,
                historyId: historyId,
                quantity: quantity,
                price: price,
                datePurchased: datePurchased,
                storeName: storeName,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({historyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (historyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.historyId,
                                referencedTable:
                                    $$PurchaseRecordsTableReferences
                                        ._historyIdTable(db),
                                referencedColumn:
                                    $$PurchaseRecordsTableReferences
                                        ._historyIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseRecordsTable,
      PurchaseRecord,
      $$PurchaseRecordsTableFilterComposer,
      $$PurchaseRecordsTableOrderingComposer,
      $$PurchaseRecordsTableAnnotationComposer,
      $$PurchaseRecordsTableCreateCompanionBuilder,
      $$PurchaseRecordsTableUpdateCompanionBuilder,
      (PurchaseRecord, $$PurchaseRecordsTableReferences),
      PurchaseRecord,
      PrefetchHooks Function({bool historyId})
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      required String id,
      Value<String> period,
      required double amount,
      required DateTime startDate,
      required DateTime endDate,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<String> id,
      Value<String> period,
      Value<double> amount,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetEntriesTable, List<BudgetEntry>>
  _budgetEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetEntries,
    aliasName: 'budgets__id__budget_entries__budget_id',
  );

  $$BudgetEntriesTableProcessedTableManager get budgetEntriesRefs {
    final manager = $$BudgetEntriesTableTableManager(
      $_db,
      $_db.budgetEntries,
    ).filter((f) => f.budgetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> budgetEntriesRefs(
    Expression<bool> Function($$BudgetEntriesTableFilterComposer f) f,
  ) {
    final $$BudgetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.budgetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> budgetEntriesRefs<T extends Object>(
    Expression<T> Function($$BudgetEntriesTableAnnotationComposer a) f,
  ) {
    final $$BudgetEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetEntries,
      getReferencedColumn: (t) => t.budgetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, $$BudgetsTableReferences),
          Budget,
          PrefetchHooks Function({bool budgetEntriesRefs})
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                period: period,
                amount: amount,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> period = const Value.absent(),
                required double amount,
                required DateTime startDate,
                required DateTime endDate,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                period: period,
                amount: amount,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({budgetEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (budgetEntriesRefs) db.budgetEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (budgetEntriesRefs)
                    await $_getPrefetchedData<
                      Budget,
                      $BudgetsTable,
                      BudgetEntry
                    >(
                      currentTable: table,
                      referencedTable: $$BudgetsTableReferences
                          ._budgetEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$BudgetsTableReferences(
                        db,
                        table,
                        p0,
                      ).budgetEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.budgetId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, $$BudgetsTableReferences),
      Budget,
      PrefetchHooks Function({bool budgetEntriesRefs})
    >;
typedef $$BudgetEntriesTableCreateCompanionBuilder =
    BudgetEntriesCompanion Function({
      required String id,
      required String budgetId,
      Value<String?> listId,
      required double amount,
      required DateTime date,
      Value<int> rowid,
    });
typedef $$BudgetEntriesTableUpdateCompanionBuilder =
    BudgetEntriesCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String?> listId,
      Value<double> amount,
      Value<DateTime> date,
      Value<int> rowid,
    });

final class $$BudgetEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetEntriesTable, BudgetEntry> {
  $$BudgetEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BudgetsTable _budgetIdTable(_$AppDatabase db) =>
      db.budgets.createAlias('budget_entries__budget_id__budgets__id');

  $$BudgetsTableProcessedTableManager get budgetId {
    final $_column = $_itemColumn<String>('budget_id')!;

    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$BudgetsTableFilterComposer get budgetId {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$BudgetsTableOrderingComposer get budgetId {
    final $$BudgetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableOrderingComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetEntriesTable> {
  $$BudgetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$BudgetsTableAnnotationComposer get budgetId {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetEntriesTable,
          BudgetEntry,
          $$BudgetEntriesTableFilterComposer,
          $$BudgetEntriesTableOrderingComposer,
          $$BudgetEntriesTableAnnotationComposer,
          $$BudgetEntriesTableCreateCompanionBuilder,
          $$BudgetEntriesTableUpdateCompanionBuilder,
          (BudgetEntry, $$BudgetEntriesTableReferences),
          BudgetEntry,
          PrefetchHooks Function({bool budgetId})
        > {
  $$BudgetEntriesTableTableManager(_$AppDatabase db, $BudgetEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String?> listId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetEntriesCompanion(
                id: id,
                budgetId: budgetId,
                listId: listId,
                amount: amount,
                date: date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                Value<String?> listId = const Value.absent(),
                required double amount,
                required DateTime date,
                Value<int> rowid = const Value.absent(),
              }) => BudgetEntriesCompanion.insert(
                id: id,
                budgetId: budgetId,
                listId: listId,
                amount: amount,
                date: date,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({budgetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (budgetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.budgetId,
                                referencedTable: $$BudgetEntriesTableReferences
                                    ._budgetIdTable(db),
                                referencedColumn: $$BudgetEntriesTableReferences
                                    ._budgetIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetEntriesTable,
      BudgetEntry,
      $$BudgetEntriesTableFilterComposer,
      $$BudgetEntriesTableOrderingComposer,
      $$BudgetEntriesTableAnnotationComposer,
      $$BudgetEntriesTableCreateCompanionBuilder,
      $$BudgetEntriesTableUpdateCompanionBuilder,
      (BudgetEntry, $$BudgetEntriesTableReferences),
      BudgetEntry,
      PrefetchHooks Function({bool budgetId})
    >;
typedef $$StoresTableCreateCompanionBuilder =
    StoresCompanion Function({
      required String id,
      required String name,
      Value<String> type,
      Value<String?> address,
      Value<String?> phoneNumber,
      Value<String?> website,
      Value<bool> isActive,
      Value<String> preferredCurrency,
      Value<bool> supportsTaxExempt,
      Value<bool> hasDelivery,
      Value<bool> hasPickup,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StoresTableUpdateCompanionBuilder =
    StoresCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> address,
      Value<String?> phoneNumber,
      Value<String?> website,
      Value<bool> isActive,
      Value<String> preferredCurrency,
      Value<bool> supportsTaxExempt,
      Value<bool> hasDelivery,
      Value<bool> hasPickup,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StoresTableReferences
    extends BaseReferences<_$AppDatabase, $StoresTable, Store> {
  $$StoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StoreAislesTable, List<StoreAisle>>
  _storeAislesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storeAisles,
    aliasName: 'stores__id__store_aisles__store_id',
  );

  $$StoreAislesTableProcessedTableManager get storeAislesRefs {
    final manager = $$StoreAislesTableTableManager(
      $_db,
      $_db.storeAisles,
    ).filter((f) => f.storeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_storeAislesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoresTableFilterComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsTaxExempt => $composableBuilder(
    column: $table.supportsTaxExempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasDelivery => $composableBuilder(
    column: $table.hasDelivery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPickup => $composableBuilder(
    column: $table.hasPickup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storeAislesRefs(
    Expression<bool> Function($$StoreAislesTableFilterComposer f) f,
  ) {
    final $$StoreAislesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storeAisles,
      getReferencedColumn: (t) => t.storeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreAislesTableFilterComposer(
            $db: $db,
            $table: $db.storeAisles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoresTableOrderingComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsTaxExempt => $composableBuilder(
    column: $table.supportsTaxExempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasDelivery => $composableBuilder(
    column: $table.hasDelivery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPickup => $composableBuilder(
    column: $table.hasPickup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsTaxExempt => $composableBuilder(
    column: $table.supportsTaxExempt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasDelivery => $composableBuilder(
    column: $table.hasDelivery,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPickup =>
      $composableBuilder(column: $table.hasPickup, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> storeAislesRefs<T extends Object>(
    Expression<T> Function($$StoreAislesTableAnnotationComposer a) f,
  ) {
    final $$StoreAislesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storeAisles,
      getReferencedColumn: (t) => t.storeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoreAislesTableAnnotationComposer(
            $db: $db,
            $table: $db.storeAisles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoresTable,
          Store,
          $$StoresTableFilterComposer,
          $$StoresTableOrderingComposer,
          $$StoresTableAnnotationComposer,
          $$StoresTableCreateCompanionBuilder,
          $$StoresTableUpdateCompanionBuilder,
          (Store, $$StoresTableReferences),
          Store,
          PrefetchHooks Function({bool storeAislesRefs})
        > {
  $$StoresTableTableManager(_$AppDatabase db, $StoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> preferredCurrency = const Value.absent(),
                Value<bool> supportsTaxExempt = const Value.absent(),
                Value<bool> hasDelivery = const Value.absent(),
                Value<bool> hasPickup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                name: name,
                type: type,
                address: address,
                phoneNumber: phoneNumber,
                website: website,
                isActive: isActive,
                preferredCurrency: preferredCurrency,
                supportsTaxExempt: supportsTaxExempt,
                hasDelivery: hasDelivery,
                hasPickup: hasPickup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> type = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> preferredCurrency = const Value.absent(),
                Value<bool> supportsTaxExempt = const Value.absent(),
                Value<bool> hasDelivery = const Value.absent(),
                Value<bool> hasPickup = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                name: name,
                type: type,
                address: address,
                phoneNumber: phoneNumber,
                website: website,
                isActive: isActive,
                preferredCurrency: preferredCurrency,
                supportsTaxExempt: supportsTaxExempt,
                hasDelivery: hasDelivery,
                hasPickup: hasPickup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StoresTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({storeAislesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (storeAislesRefs) db.storeAisles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (storeAislesRefs)
                    await $_getPrefetchedData<Store, $StoresTable, StoreAisle>(
                      currentTable: table,
                      referencedTable: $$StoresTableReferences
                          ._storeAislesRefsTable(db),
                      managerFromTypedResult: (p0) => $$StoresTableReferences(
                        db,
                        table,
                        p0,
                      ).storeAislesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.storeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoresTable,
      Store,
      $$StoresTableFilterComposer,
      $$StoresTableOrderingComposer,
      $$StoresTableAnnotationComposer,
      $$StoresTableCreateCompanionBuilder,
      $$StoresTableUpdateCompanionBuilder,
      (Store, $$StoresTableReferences),
      Store,
      PrefetchHooks Function({bool storeAislesRefs})
    >;
typedef $$StoreAislesTableCreateCompanionBuilder =
    StoreAislesCompanion Function({
      required String id,
      required String storeId,
      required String aisleName,
      Value<int?> aisleNumber,
      Value<String> categoriesJson,
      Value<int> rowid,
    });
typedef $$StoreAislesTableUpdateCompanionBuilder =
    StoreAislesCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> aisleName,
      Value<int?> aisleNumber,
      Value<String> categoriesJson,
      Value<int> rowid,
    });

final class $$StoreAislesTableReferences
    extends BaseReferences<_$AppDatabase, $StoreAislesTable, StoreAisle> {
  $$StoreAislesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StoresTable _storeIdTable(_$AppDatabase db) =>
      db.stores.createAlias('store_aisles__store_id__stores__id');

  $$StoresTableProcessedTableManager get storeId {
    final $_column = $_itemColumn<String>('store_id')!;

    final manager = $$StoresTableTableManager(
      $_db,
      $_db.stores,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoreAislesTableFilterComposer
    extends Composer<_$AppDatabase, $StoreAislesTable> {
  $$StoreAislesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aisleName => $composableBuilder(
    column: $table.aisleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aisleNumber => $composableBuilder(
    column: $table.aisleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriesJson => $composableBuilder(
    column: $table.categoriesJson,
    builder: (column) => ColumnFilters(column),
  );

  $$StoresTableFilterComposer get storeId {
    final $$StoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storeId,
      referencedTable: $db.stores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoresTableFilterComposer(
            $db: $db,
            $table: $db.stores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoreAislesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoreAislesTable> {
  $$StoreAislesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aisleName => $composableBuilder(
    column: $table.aisleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aisleNumber => $composableBuilder(
    column: $table.aisleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriesJson => $composableBuilder(
    column: $table.categoriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoresTableOrderingComposer get storeId {
    final $$StoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storeId,
      referencedTable: $db.stores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoresTableOrderingComposer(
            $db: $db,
            $table: $db.stores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoreAislesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoreAislesTable> {
  $$StoreAislesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get aisleName =>
      $composableBuilder(column: $table.aisleName, builder: (column) => column);

  GeneratedColumn<int> get aisleNumber => $composableBuilder(
    column: $table.aisleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoriesJson => $composableBuilder(
    column: $table.categoriesJson,
    builder: (column) => column,
  );

  $$StoresTableAnnotationComposer get storeId {
    final $$StoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storeId,
      referencedTable: $db.stores,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoresTableAnnotationComposer(
            $db: $db,
            $table: $db.stores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoreAislesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoreAislesTable,
          StoreAisle,
          $$StoreAislesTableFilterComposer,
          $$StoreAislesTableOrderingComposer,
          $$StoreAislesTableAnnotationComposer,
          $$StoreAislesTableCreateCompanionBuilder,
          $$StoreAislesTableUpdateCompanionBuilder,
          (StoreAisle, $$StoreAislesTableReferences),
          StoreAisle,
          PrefetchHooks Function({bool storeId})
        > {
  $$StoreAislesTableTableManager(_$AppDatabase db, $StoreAislesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreAislesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoreAislesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoreAislesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> aisleName = const Value.absent(),
                Value<int?> aisleNumber = const Value.absent(),
                Value<String> categoriesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoreAislesCompanion(
                id: id,
                storeId: storeId,
                aisleName: aisleName,
                aisleNumber: aisleNumber,
                categoriesJson: categoriesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String aisleName,
                Value<int?> aisleNumber = const Value.absent(),
                Value<String> categoriesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoreAislesCompanion.insert(
                id: id,
                storeId: storeId,
                aisleName: aisleName,
                aisleNumber: aisleNumber,
                categoriesJson: categoriesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoreAislesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (storeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.storeId,
                                referencedTable: $$StoreAislesTableReferences
                                    ._storeIdTable(db),
                                referencedColumn: $$StoreAislesTableReferences
                                    ._storeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoreAislesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoreAislesTable,
      StoreAisle,
      $$StoreAislesTableFilterComposer,
      $$StoreAislesTableOrderingComposer,
      $$StoreAislesTableAnnotationComposer,
      $$StoreAislesTableCreateCompanionBuilder,
      $$StoreAislesTableUpdateCompanionBuilder,
      (StoreAisle, $$StoreAislesTableReferences),
      StoreAisle,
      PrefetchHooks Function({bool storeId})
    >;
typedef $$ActivityEventsTableCreateCompanionBuilder =
    ActivityEventsCompanion Function({
      required String id,
      required String type,
      required String sourceType,
      required String sourceId,
      required String sourceName,
      required String actorUid,
      required String actorDisplayName,
      Value<String?> itemName,
      Value<String?> detailsJson,
      required DateTime timestamp,
      Value<bool> isRead,
      Value<int> rowid,
    });
typedef $$ActivityEventsTableUpdateCompanionBuilder =
    ActivityEventsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> sourceType,
      Value<String> sourceId,
      Value<String> sourceName,
      Value<String> actorUid,
      Value<String> actorDisplayName,
      Value<String?> itemName,
      Value<String?> detailsJson,
      Value<DateTime> timestamp,
      Value<bool> isRead,
      Value<int> rowid,
    });

class $$ActivityEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityEventsTable> {
  $$ActivityEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorDisplayName => $composableBuilder(
    column: $table.actorDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityEventsTable> {
  $$ActivityEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorDisplayName => $composableBuilder(
    column: $table.actorDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityEventsTable> {
  $$ActivityEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actorUid =>
      $composableBuilder(column: $table.actorUid, builder: (column) => column);

  GeneratedColumn<String> get actorDisplayName => $composableBuilder(
    column: $table.actorDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$ActivityEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityEventsTable,
          ActivityEvent,
          $$ActivityEventsTableFilterComposer,
          $$ActivityEventsTableOrderingComposer,
          $$ActivityEventsTableAnnotationComposer,
          $$ActivityEventsTableCreateCompanionBuilder,
          $$ActivityEventsTableUpdateCompanionBuilder,
          (
            ActivityEvent,
            BaseReferences<_$AppDatabase, $ActivityEventsTable, ActivityEvent>,
          ),
          ActivityEvent,
          PrefetchHooks Function()
        > {
  $$ActivityEventsTableTableManager(
    _$AppDatabase db,
    $ActivityEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String> actorUid = const Value.absent(),
                Value<String> actorDisplayName = const Value.absent(),
                Value<String?> itemName = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEventsCompanion(
                id: id,
                type: type,
                sourceType: sourceType,
                sourceId: sourceId,
                sourceName: sourceName,
                actorUid: actorUid,
                actorDisplayName: actorDisplayName,
                itemName: itemName,
                detailsJson: detailsJson,
                timestamp: timestamp,
                isRead: isRead,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String sourceType,
                required String sourceId,
                required String sourceName,
                required String actorUid,
                required String actorDisplayName,
                Value<String?> itemName = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
                required DateTime timestamp,
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEventsCompanion.insert(
                id: id,
                type: type,
                sourceType: sourceType,
                sourceId: sourceId,
                sourceName: sourceName,
                actorUid: actorUid,
                actorDisplayName: actorDisplayName,
                itemName: itemName,
                detailsJson: detailsJson,
                timestamp: timestamp,
                isRead: isRead,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityEventsTable,
      ActivityEvent,
      $$ActivityEventsTableFilterComposer,
      $$ActivityEventsTableOrderingComposer,
      $$ActivityEventsTableAnnotationComposer,
      $$ActivityEventsTableCreateCompanionBuilder,
      $$ActivityEventsTableUpdateCompanionBuilder,
      (
        ActivityEvent,
        BaseReferences<_$AppDatabase, $ActivityEventsTable, ActivityEvent>,
      ),
      ActivityEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProduceTemplatesTableTableManager get produceTemplates =>
      $$ProduceTemplatesTableTableManager(_db, _db.produceTemplates);
  $$ScanHistoryEntriesTableTableManager get scanHistoryEntries =>
      $$ScanHistoryEntriesTableTableManager(_db, _db.scanHistoryEntries);
  $$PantryItemsTableTableManager get pantryItems =>
      $$PantryItemsTableTableManager(_db, _db.pantryItems);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db, _db.shoppingLists);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db, _db.mealPlans);
  $$MealPlanDaysTableTableManager get mealPlanDays =>
      $$MealPlanDaysTableTableManager(_db, _db.mealPlanDays);
  $$RecipeFeedbackTableTableManager get recipeFeedback =>
      $$RecipeFeedbackTableTableManager(_db, _db.recipeFeedback);
  $$FamilyProfilesTableTableManager get familyProfiles =>
      $$FamilyProfilesTableTableManager(_db, _db.familyProfiles);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
  $$PurchaseHistoriesTableTableManager get purchaseHistories =>
      $$PurchaseHistoriesTableTableManager(_db, _db.purchaseHistories);
  $$PurchaseRecordsTableTableManager get purchaseRecords =>
      $$PurchaseRecordsTableTableManager(_db, _db.purchaseRecords);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$BudgetEntriesTableTableManager get budgetEntries =>
      $$BudgetEntriesTableTableManager(_db, _db.budgetEntries);
  $$StoresTableTableManager get stores =>
      $$StoresTableTableManager(_db, _db.stores);
  $$StoreAislesTableTableManager get storeAisles =>
      $$StoreAislesTableTableManager(_db, _db.storeAisles);
  $$ActivityEventsTableTableManager get activityEvents =>
      $$ActivityEventsTableTableManager(_db, _db.activityEvents);
}
