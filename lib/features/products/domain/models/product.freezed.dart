// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String? get barcode; String? get pluCode; IdentifierType get identifierType; String get name; String? get brand; String? get description; double? get price; String? get currency; ProductCategory get category; String? get imageUrl; NutritionInfo? get nutritionInfo; List<String>? get ingredients; List<Allergen>? get allergens; bool get isWeightBased; ProductUnit get unitType; double? get averageWeight; List<int>? get seasonality; String? get storageInstructions; List<String>? get ripenessIndicators; bool get isOrganic; bool get isGlutenFree; bool get isVegan; bool get isCustom; bool get isFavorite; String? get source; DateTime get createdAt; DateTime get updatedAt; DateTime? get lastLookedUp;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.pluCode, pluCode) || other.pluCode == pluCode)&&(identical(other.identifierType, identifierType) || other.identifierType == identifierType)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.nutritionInfo, nutritionInfo) || other.nutritionInfo == nutritionInfo)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&const DeepCollectionEquality().equals(other.allergens, allergens)&&(identical(other.isWeightBased, isWeightBased) || other.isWeightBased == isWeightBased)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.averageWeight, averageWeight) || other.averageWeight == averageWeight)&&const DeepCollectionEquality().equals(other.seasonality, seasonality)&&(identical(other.storageInstructions, storageInstructions) || other.storageInstructions == storageInstructions)&&const DeepCollectionEquality().equals(other.ripenessIndicators, ripenessIndicators)&&(identical(other.isOrganic, isOrganic) || other.isOrganic == isOrganic)&&(identical(other.isGlutenFree, isGlutenFree) || other.isGlutenFree == isGlutenFree)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastLookedUp, lastLookedUp) || other.lastLookedUp == lastLookedUp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,barcode,pluCode,identifierType,name,brand,description,price,currency,category,imageUrl,nutritionInfo,const DeepCollectionEquality().hash(ingredients),const DeepCollectionEquality().hash(allergens),isWeightBased,unitType,averageWeight,const DeepCollectionEquality().hash(seasonality),storageInstructions,const DeepCollectionEquality().hash(ripenessIndicators),isOrganic,isGlutenFree,isVegan,isCustom,isFavorite,source,createdAt,updatedAt,lastLookedUp]);

@override
String toString() {
  return 'Product(id: $id, barcode: $barcode, pluCode: $pluCode, identifierType: $identifierType, name: $name, brand: $brand, description: $description, price: $price, currency: $currency, category: $category, imageUrl: $imageUrl, nutritionInfo: $nutritionInfo, ingredients: $ingredients, allergens: $allergens, isWeightBased: $isWeightBased, unitType: $unitType, averageWeight: $averageWeight, seasonality: $seasonality, storageInstructions: $storageInstructions, ripenessIndicators: $ripenessIndicators, isOrganic: $isOrganic, isGlutenFree: $isGlutenFree, isVegan: $isVegan, isCustom: $isCustom, isFavorite: $isFavorite, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, lastLookedUp: $lastLookedUp)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String? barcode, String? pluCode, IdentifierType identifierType, String name, String? brand, String? description, double? price, String? currency, ProductCategory category, String? imageUrl, NutritionInfo? nutritionInfo, List<String>? ingredients, List<Allergen>? allergens, bool isWeightBased, ProductUnit unitType, double? averageWeight, List<int>? seasonality, String? storageInstructions, List<String>? ripenessIndicators, bool isOrganic, bool isGlutenFree, bool isVegan, bool isCustom, bool isFavorite, String? source, DateTime createdAt, DateTime updatedAt, DateTime? lastLookedUp
});


$NutritionInfoCopyWith<$Res>? get nutritionInfo;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? barcode = freezed,Object? pluCode = freezed,Object? identifierType = null,Object? name = null,Object? brand = freezed,Object? description = freezed,Object? price = freezed,Object? currency = freezed,Object? category = null,Object? imageUrl = freezed,Object? nutritionInfo = freezed,Object? ingredients = freezed,Object? allergens = freezed,Object? isWeightBased = null,Object? unitType = null,Object? averageWeight = freezed,Object? seasonality = freezed,Object? storageInstructions = freezed,Object? ripenessIndicators = freezed,Object? isOrganic = null,Object? isGlutenFree = null,Object? isVegan = null,Object? isCustom = null,Object? isFavorite = null,Object? source = freezed,Object? createdAt = null,Object? updatedAt = null,Object? lastLookedUp = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,pluCode: freezed == pluCode ? _self.pluCode : pluCode // ignore: cast_nullable_to_non_nullable
as String?,identifierType: null == identifierType ? _self.identifierType : identifierType // ignore: cast_nullable_to_non_nullable
as IdentifierType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,nutritionInfo: freezed == nutritionInfo ? _self.nutritionInfo : nutritionInfo // ignore: cast_nullable_to_non_nullable
as NutritionInfo?,ingredients: freezed == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>?,allergens: freezed == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<Allergen>?,isWeightBased: null == isWeightBased ? _self.isWeightBased : isWeightBased // ignore: cast_nullable_to_non_nullable
as bool,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as ProductUnit,averageWeight: freezed == averageWeight ? _self.averageWeight : averageWeight // ignore: cast_nullable_to_non_nullable
as double?,seasonality: freezed == seasonality ? _self.seasonality : seasonality // ignore: cast_nullable_to_non_nullable
as List<int>?,storageInstructions: freezed == storageInstructions ? _self.storageInstructions : storageInstructions // ignore: cast_nullable_to_non_nullable
as String?,ripenessIndicators: freezed == ripenessIndicators ? _self.ripenessIndicators : ripenessIndicators // ignore: cast_nullable_to_non_nullable
as List<String>?,isOrganic: null == isOrganic ? _self.isOrganic : isOrganic // ignore: cast_nullable_to_non_nullable
as bool,isGlutenFree: null == isGlutenFree ? _self.isGlutenFree : isGlutenFree // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLookedUp: freezed == lastLookedUp ? _self.lastLookedUp : lastLookedUp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionInfoCopyWith<$Res>? get nutritionInfo {
    if (_self.nutritionInfo == null) {
    return null;
  }

  return $NutritionInfoCopyWith<$Res>(_self.nutritionInfo!, (value) {
    return _then(_self.copyWith(nutritionInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? barcode,  String? pluCode,  IdentifierType identifierType,  String name,  String? brand,  String? description,  double? price,  String? currency,  ProductCategory category,  String? imageUrl,  NutritionInfo? nutritionInfo,  List<String>? ingredients,  List<Allergen>? allergens,  bool isWeightBased,  ProductUnit unitType,  double? averageWeight,  List<int>? seasonality,  String? storageInstructions,  List<String>? ripenessIndicators,  bool isOrganic,  bool isGlutenFree,  bool isVegan,  bool isCustom,  bool isFavorite,  String? source,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastLookedUp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.barcode,_that.pluCode,_that.identifierType,_that.name,_that.brand,_that.description,_that.price,_that.currency,_that.category,_that.imageUrl,_that.nutritionInfo,_that.ingredients,_that.allergens,_that.isWeightBased,_that.unitType,_that.averageWeight,_that.seasonality,_that.storageInstructions,_that.ripenessIndicators,_that.isOrganic,_that.isGlutenFree,_that.isVegan,_that.isCustom,_that.isFavorite,_that.source,_that.createdAt,_that.updatedAt,_that.lastLookedUp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? barcode,  String? pluCode,  IdentifierType identifierType,  String name,  String? brand,  String? description,  double? price,  String? currency,  ProductCategory category,  String? imageUrl,  NutritionInfo? nutritionInfo,  List<String>? ingredients,  List<Allergen>? allergens,  bool isWeightBased,  ProductUnit unitType,  double? averageWeight,  List<int>? seasonality,  String? storageInstructions,  List<String>? ripenessIndicators,  bool isOrganic,  bool isGlutenFree,  bool isVegan,  bool isCustom,  bool isFavorite,  String? source,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastLookedUp)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.barcode,_that.pluCode,_that.identifierType,_that.name,_that.brand,_that.description,_that.price,_that.currency,_that.category,_that.imageUrl,_that.nutritionInfo,_that.ingredients,_that.allergens,_that.isWeightBased,_that.unitType,_that.averageWeight,_that.seasonality,_that.storageInstructions,_that.ripenessIndicators,_that.isOrganic,_that.isGlutenFree,_that.isVegan,_that.isCustom,_that.isFavorite,_that.source,_that.createdAt,_that.updatedAt,_that.lastLookedUp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? barcode,  String? pluCode,  IdentifierType identifierType,  String name,  String? brand,  String? description,  double? price,  String? currency,  ProductCategory category,  String? imageUrl,  NutritionInfo? nutritionInfo,  List<String>? ingredients,  List<Allergen>? allergens,  bool isWeightBased,  ProductUnit unitType,  double? averageWeight,  List<int>? seasonality,  String? storageInstructions,  List<String>? ripenessIndicators,  bool isOrganic,  bool isGlutenFree,  bool isVegan,  bool isCustom,  bool isFavorite,  String? source,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastLookedUp)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.barcode,_that.pluCode,_that.identifierType,_that.name,_that.brand,_that.description,_that.price,_that.currency,_that.category,_that.imageUrl,_that.nutritionInfo,_that.ingredients,_that.allergens,_that.isWeightBased,_that.unitType,_that.averageWeight,_that.seasonality,_that.storageInstructions,_that.ripenessIndicators,_that.isOrganic,_that.isGlutenFree,_that.isVegan,_that.isCustom,_that.isFavorite,_that.source,_that.createdAt,_that.updatedAt,_that.lastLookedUp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, this.barcode, this.pluCode, this.identifierType = IdentifierType.barcode, required this.name, this.brand, this.description, this.price, this.currency, this.category = ProductCategory.other, this.imageUrl, this.nutritionInfo, final  List<String>? ingredients, final  List<Allergen>? allergens, this.isWeightBased = false, this.unitType = ProductUnit.each, this.averageWeight, final  List<int>? seasonality, this.storageInstructions, final  List<String>? ripenessIndicators, this.isOrganic = false, this.isGlutenFree = false, this.isVegan = false, this.isCustom = false, this.isFavorite = false, this.source, required this.createdAt, required this.updatedAt, this.lastLookedUp}): _ingredients = ingredients,_allergens = allergens,_seasonality = seasonality,_ripenessIndicators = ripenessIndicators,super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String? barcode;
@override final  String? pluCode;
@override@JsonKey() final  IdentifierType identifierType;
@override final  String name;
@override final  String? brand;
@override final  String? description;
@override final  double? price;
@override final  String? currency;
@override@JsonKey() final  ProductCategory category;
@override final  String? imageUrl;
@override final  NutritionInfo? nutritionInfo;
 final  List<String>? _ingredients;
@override List<String>? get ingredients {
  final value = _ingredients;
  if (value == null) return null;
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Allergen>? _allergens;
@override List<Allergen>? get allergens {
  final value = _allergens;
  if (value == null) return null;
  if (_allergens is EqualUnmodifiableListView) return _allergens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isWeightBased;
@override@JsonKey() final  ProductUnit unitType;
@override final  double? averageWeight;
 final  List<int>? _seasonality;
@override List<int>? get seasonality {
  final value = _seasonality;
  if (value == null) return null;
  if (_seasonality is EqualUnmodifiableListView) return _seasonality;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? storageInstructions;
 final  List<String>? _ripenessIndicators;
@override List<String>? get ripenessIndicators {
  final value = _ripenessIndicators;
  if (value == null) return null;
  if (_ripenessIndicators is EqualUnmodifiableListView) return _ripenessIndicators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isOrganic;
@override@JsonKey() final  bool isGlutenFree;
@override@JsonKey() final  bool isVegan;
@override@JsonKey() final  bool isCustom;
@override@JsonKey() final  bool isFavorite;
@override final  String? source;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? lastLookedUp;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.pluCode, pluCode) || other.pluCode == pluCode)&&(identical(other.identifierType, identifierType) || other.identifierType == identifierType)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.nutritionInfo, nutritionInfo) || other.nutritionInfo == nutritionInfo)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&const DeepCollectionEquality().equals(other._allergens, _allergens)&&(identical(other.isWeightBased, isWeightBased) || other.isWeightBased == isWeightBased)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.averageWeight, averageWeight) || other.averageWeight == averageWeight)&&const DeepCollectionEquality().equals(other._seasonality, _seasonality)&&(identical(other.storageInstructions, storageInstructions) || other.storageInstructions == storageInstructions)&&const DeepCollectionEquality().equals(other._ripenessIndicators, _ripenessIndicators)&&(identical(other.isOrganic, isOrganic) || other.isOrganic == isOrganic)&&(identical(other.isGlutenFree, isGlutenFree) || other.isGlutenFree == isGlutenFree)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastLookedUp, lastLookedUp) || other.lastLookedUp == lastLookedUp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,barcode,pluCode,identifierType,name,brand,description,price,currency,category,imageUrl,nutritionInfo,const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_allergens),isWeightBased,unitType,averageWeight,const DeepCollectionEquality().hash(_seasonality),storageInstructions,const DeepCollectionEquality().hash(_ripenessIndicators),isOrganic,isGlutenFree,isVegan,isCustom,isFavorite,source,createdAt,updatedAt,lastLookedUp]);

@override
String toString() {
  return 'Product(id: $id, barcode: $barcode, pluCode: $pluCode, identifierType: $identifierType, name: $name, brand: $brand, description: $description, price: $price, currency: $currency, category: $category, imageUrl: $imageUrl, nutritionInfo: $nutritionInfo, ingredients: $ingredients, allergens: $allergens, isWeightBased: $isWeightBased, unitType: $unitType, averageWeight: $averageWeight, seasonality: $seasonality, storageInstructions: $storageInstructions, ripenessIndicators: $ripenessIndicators, isOrganic: $isOrganic, isGlutenFree: $isGlutenFree, isVegan: $isVegan, isCustom: $isCustom, isFavorite: $isFavorite, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, lastLookedUp: $lastLookedUp)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String? barcode, String? pluCode, IdentifierType identifierType, String name, String? brand, String? description, double? price, String? currency, ProductCategory category, String? imageUrl, NutritionInfo? nutritionInfo, List<String>? ingredients, List<Allergen>? allergens, bool isWeightBased, ProductUnit unitType, double? averageWeight, List<int>? seasonality, String? storageInstructions, List<String>? ripenessIndicators, bool isOrganic, bool isGlutenFree, bool isVegan, bool isCustom, bool isFavorite, String? source, DateTime createdAt, DateTime updatedAt, DateTime? lastLookedUp
});


@override $NutritionInfoCopyWith<$Res>? get nutritionInfo;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? barcode = freezed,Object? pluCode = freezed,Object? identifierType = null,Object? name = null,Object? brand = freezed,Object? description = freezed,Object? price = freezed,Object? currency = freezed,Object? category = null,Object? imageUrl = freezed,Object? nutritionInfo = freezed,Object? ingredients = freezed,Object? allergens = freezed,Object? isWeightBased = null,Object? unitType = null,Object? averageWeight = freezed,Object? seasonality = freezed,Object? storageInstructions = freezed,Object? ripenessIndicators = freezed,Object? isOrganic = null,Object? isGlutenFree = null,Object? isVegan = null,Object? isCustom = null,Object? isFavorite = null,Object? source = freezed,Object? createdAt = null,Object? updatedAt = null,Object? lastLookedUp = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,pluCode: freezed == pluCode ? _self.pluCode : pluCode // ignore: cast_nullable_to_non_nullable
as String?,identifierType: null == identifierType ? _self.identifierType : identifierType // ignore: cast_nullable_to_non_nullable
as IdentifierType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,nutritionInfo: freezed == nutritionInfo ? _self.nutritionInfo : nutritionInfo // ignore: cast_nullable_to_non_nullable
as NutritionInfo?,ingredients: freezed == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>?,allergens: freezed == allergens ? _self._allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<Allergen>?,isWeightBased: null == isWeightBased ? _self.isWeightBased : isWeightBased // ignore: cast_nullable_to_non_nullable
as bool,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as ProductUnit,averageWeight: freezed == averageWeight ? _self.averageWeight : averageWeight // ignore: cast_nullable_to_non_nullable
as double?,seasonality: freezed == seasonality ? _self._seasonality : seasonality // ignore: cast_nullable_to_non_nullable
as List<int>?,storageInstructions: freezed == storageInstructions ? _self.storageInstructions : storageInstructions // ignore: cast_nullable_to_non_nullable
as String?,ripenessIndicators: freezed == ripenessIndicators ? _self._ripenessIndicators : ripenessIndicators // ignore: cast_nullable_to_non_nullable
as List<String>?,isOrganic: null == isOrganic ? _self.isOrganic : isOrganic // ignore: cast_nullable_to_non_nullable
as bool,isGlutenFree: null == isGlutenFree ? _self.isGlutenFree : isGlutenFree // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLookedUp: freezed == lastLookedUp ? _self.lastLookedUp : lastLookedUp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionInfoCopyWith<$Res>? get nutritionInfo {
    if (_self.nutritionInfo == null) {
    return null;
  }

  return $NutritionInfoCopyWith<$Res>(_self.nutritionInfo!, (value) {
    return _then(_self.copyWith(nutritionInfo: value));
  });
}
}

// dart format on
