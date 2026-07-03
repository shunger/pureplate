// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpenFoodFactsResponse {

 String get code; int get status;@JsonKey(name: 'status_verbose') String get statusVerbose; OpenFoodFactsProduct? get product;
/// Create a copy of OpenFoodFactsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenFoodFactsResponseCopyWith<OpenFoodFactsResponse> get copyWith => _$OpenFoodFactsResponseCopyWithImpl<OpenFoodFactsResponse>(this as OpenFoodFactsResponse, _$identity);

  /// Serializes this OpenFoodFactsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenFoodFactsResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusVerbose, statusVerbose) || other.statusVerbose == statusVerbose)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,status,statusVerbose,product);

@override
String toString() {
  return 'OpenFoodFactsResponse(code: $code, status: $status, statusVerbose: $statusVerbose, product: $product)';
}


}

/// @nodoc
abstract mixin class $OpenFoodFactsResponseCopyWith<$Res>  {
  factory $OpenFoodFactsResponseCopyWith(OpenFoodFactsResponse value, $Res Function(OpenFoodFactsResponse) _then) = _$OpenFoodFactsResponseCopyWithImpl;
@useResult
$Res call({
 String code, int status,@JsonKey(name: 'status_verbose') String statusVerbose, OpenFoodFactsProduct? product
});


$OpenFoodFactsProductCopyWith<$Res>? get product;

}
/// @nodoc
class _$OpenFoodFactsResponseCopyWithImpl<$Res>
    implements $OpenFoodFactsResponseCopyWith<$Res> {
  _$OpenFoodFactsResponseCopyWithImpl(this._self, this._then);

  final OpenFoodFactsResponse _self;
  final $Res Function(OpenFoodFactsResponse) _then;

/// Create a copy of OpenFoodFactsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? status = null,Object? statusVerbose = null,Object? product = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,statusVerbose: null == statusVerbose ? _self.statusVerbose : statusVerbose // ignore: cast_nullable_to_non_nullable
as String,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as OpenFoodFactsProduct?,
  ));
}
/// Create a copy of OpenFoodFactsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpenFoodFactsProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $OpenFoodFactsProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpenFoodFactsResponse].
extension OpenFoodFactsResponsePatterns on OpenFoodFactsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenFoodFactsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenFoodFactsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenFoodFactsResponse value)  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenFoodFactsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int status, @JsonKey(name: 'status_verbose')  String statusVerbose,  OpenFoodFactsProduct? product)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenFoodFactsResponse() when $default != null:
return $default(_that.code,_that.status,_that.statusVerbose,_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int status, @JsonKey(name: 'status_verbose')  String statusVerbose,  OpenFoodFactsProduct? product)  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsResponse():
return $default(_that.code,_that.status,_that.statusVerbose,_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int status, @JsonKey(name: 'status_verbose')  String statusVerbose,  OpenFoodFactsProduct? product)?  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsResponse() when $default != null:
return $default(_that.code,_that.status,_that.statusVerbose,_that.product);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenFoodFactsResponse implements OpenFoodFactsResponse {
  const _OpenFoodFactsResponse({required this.code, required this.status, @JsonKey(name: 'status_verbose') required this.statusVerbose, this.product});
  factory _OpenFoodFactsResponse.fromJson(Map<String, dynamic> json) => _$OpenFoodFactsResponseFromJson(json);

@override final  String code;
@override final  int status;
@override@JsonKey(name: 'status_verbose') final  String statusVerbose;
@override final  OpenFoodFactsProduct? product;

/// Create a copy of OpenFoodFactsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenFoodFactsResponseCopyWith<_OpenFoodFactsResponse> get copyWith => __$OpenFoodFactsResponseCopyWithImpl<_OpenFoodFactsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenFoodFactsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenFoodFactsResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusVerbose, statusVerbose) || other.statusVerbose == statusVerbose)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,status,statusVerbose,product);

@override
String toString() {
  return 'OpenFoodFactsResponse(code: $code, status: $status, statusVerbose: $statusVerbose, product: $product)';
}


}

/// @nodoc
abstract mixin class _$OpenFoodFactsResponseCopyWith<$Res> implements $OpenFoodFactsResponseCopyWith<$Res> {
  factory _$OpenFoodFactsResponseCopyWith(_OpenFoodFactsResponse value, $Res Function(_OpenFoodFactsResponse) _then) = __$OpenFoodFactsResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, int status,@JsonKey(name: 'status_verbose') String statusVerbose, OpenFoodFactsProduct? product
});


@override $OpenFoodFactsProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$OpenFoodFactsResponseCopyWithImpl<$Res>
    implements _$OpenFoodFactsResponseCopyWith<$Res> {
  __$OpenFoodFactsResponseCopyWithImpl(this._self, this._then);

  final _OpenFoodFactsResponse _self;
  final $Res Function(_OpenFoodFactsResponse) _then;

/// Create a copy of OpenFoodFactsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? status = null,Object? statusVerbose = null,Object? product = freezed,}) {
  return _then(_OpenFoodFactsResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,statusVerbose: null == statusVerbose ? _self.statusVerbose : statusVerbose // ignore: cast_nullable_to_non_nullable
as String,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as OpenFoodFactsProduct?,
  ));
}

/// Create a copy of OpenFoodFactsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpenFoodFactsProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $OpenFoodFactsProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$OpenFoodFactsProduct {

@JsonKey(name: '_id') String? get id;@JsonKey(name: 'product_name') String? get productName; String? get brands; String? get categories;@JsonKey(name: 'ingredients_text') String? get ingredientsText;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'image_front_url') String? get imageFrontUrl;@JsonKey(name: 'image_ingredients_url') String? get imageIngredientsUrl;@JsonKey(name: 'image_nutrition_url') String? get imageNutritionUrl; OpenFoodFactsNutriments? get nutriments; String? get allergens; String? get traces; String? get countries;@JsonKey(name: 'manufacturing_places') String? get manufacturingPlaces; String? get stores; String? get packaging;
/// Create a copy of OpenFoodFactsProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenFoodFactsProductCopyWith<OpenFoodFactsProduct> get copyWith => _$OpenFoodFactsProductCopyWithImpl<OpenFoodFactsProduct>(this as OpenFoodFactsProduct, _$identity);

  /// Serializes this OpenFoodFactsProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenFoodFactsProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brands, brands) || other.brands == brands)&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageFrontUrl, imageFrontUrl) || other.imageFrontUrl == imageFrontUrl)&&(identical(other.imageIngredientsUrl, imageIngredientsUrl) || other.imageIngredientsUrl == imageIngredientsUrl)&&(identical(other.imageNutritionUrl, imageNutritionUrl) || other.imageNutritionUrl == imageNutritionUrl)&&(identical(other.nutriments, nutriments) || other.nutriments == nutriments)&&(identical(other.allergens, allergens) || other.allergens == allergens)&&(identical(other.traces, traces) || other.traces == traces)&&(identical(other.countries, countries) || other.countries == countries)&&(identical(other.manufacturingPlaces, manufacturingPlaces) || other.manufacturingPlaces == manufacturingPlaces)&&(identical(other.stores, stores) || other.stores == stores)&&(identical(other.packaging, packaging) || other.packaging == packaging));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,brands,categories,ingredientsText,imageUrl,imageFrontUrl,imageIngredientsUrl,imageNutritionUrl,nutriments,allergens,traces,countries,manufacturingPlaces,stores,packaging);

@override
String toString() {
  return 'OpenFoodFactsProduct(id: $id, productName: $productName, brands: $brands, categories: $categories, ingredientsText: $ingredientsText, imageUrl: $imageUrl, imageFrontUrl: $imageFrontUrl, imageIngredientsUrl: $imageIngredientsUrl, imageNutritionUrl: $imageNutritionUrl, nutriments: $nutriments, allergens: $allergens, traces: $traces, countries: $countries, manufacturingPlaces: $manufacturingPlaces, stores: $stores, packaging: $packaging)';
}


}

/// @nodoc
abstract mixin class $OpenFoodFactsProductCopyWith<$Res>  {
  factory $OpenFoodFactsProductCopyWith(OpenFoodFactsProduct value, $Res Function(OpenFoodFactsProduct) _then) = _$OpenFoodFactsProductCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String? id,@JsonKey(name: 'product_name') String? productName, String? brands, String? categories,@JsonKey(name: 'ingredients_text') String? ingredientsText,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_front_url') String? imageFrontUrl,@JsonKey(name: 'image_ingredients_url') String? imageIngredientsUrl,@JsonKey(name: 'image_nutrition_url') String? imageNutritionUrl, OpenFoodFactsNutriments? nutriments, String? allergens, String? traces, String? countries,@JsonKey(name: 'manufacturing_places') String? manufacturingPlaces, String? stores, String? packaging
});


$OpenFoodFactsNutrimentsCopyWith<$Res>? get nutriments;

}
/// @nodoc
class _$OpenFoodFactsProductCopyWithImpl<$Res>
    implements $OpenFoodFactsProductCopyWith<$Res> {
  _$OpenFoodFactsProductCopyWithImpl(this._self, this._then);

  final OpenFoodFactsProduct _self;
  final $Res Function(OpenFoodFactsProduct) _then;

/// Create a copy of OpenFoodFactsProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? productName = freezed,Object? brands = freezed,Object? categories = freezed,Object? ingredientsText = freezed,Object? imageUrl = freezed,Object? imageFrontUrl = freezed,Object? imageIngredientsUrl = freezed,Object? imageNutritionUrl = freezed,Object? nutriments = freezed,Object? allergens = freezed,Object? traces = freezed,Object? countries = freezed,Object? manufacturingPlaces = freezed,Object? stores = freezed,Object? packaging = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,brands: freezed == brands ? _self.brands : brands // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageFrontUrl: freezed == imageFrontUrl ? _self.imageFrontUrl : imageFrontUrl // ignore: cast_nullable_to_non_nullable
as String?,imageIngredientsUrl: freezed == imageIngredientsUrl ? _self.imageIngredientsUrl : imageIngredientsUrl // ignore: cast_nullable_to_non_nullable
as String?,imageNutritionUrl: freezed == imageNutritionUrl ? _self.imageNutritionUrl : imageNutritionUrl // ignore: cast_nullable_to_non_nullable
as String?,nutriments: freezed == nutriments ? _self.nutriments : nutriments // ignore: cast_nullable_to_non_nullable
as OpenFoodFactsNutriments?,allergens: freezed == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as String?,traces: freezed == traces ? _self.traces : traces // ignore: cast_nullable_to_non_nullable
as String?,countries: freezed == countries ? _self.countries : countries // ignore: cast_nullable_to_non_nullable
as String?,manufacturingPlaces: freezed == manufacturingPlaces ? _self.manufacturingPlaces : manufacturingPlaces // ignore: cast_nullable_to_non_nullable
as String?,stores: freezed == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as String?,packaging: freezed == packaging ? _self.packaging : packaging // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OpenFoodFactsProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpenFoodFactsNutrimentsCopyWith<$Res>? get nutriments {
    if (_self.nutriments == null) {
    return null;
  }

  return $OpenFoodFactsNutrimentsCopyWith<$Res>(_self.nutriments!, (value) {
    return _then(_self.copyWith(nutriments: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpenFoodFactsProduct].
extension OpenFoodFactsProductPatterns on OpenFoodFactsProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenFoodFactsProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenFoodFactsProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenFoodFactsProduct value)  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenFoodFactsProduct value)?  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id, @JsonKey(name: 'product_name')  String? productName,  String? brands,  String? categories, @JsonKey(name: 'ingredients_text')  String? ingredientsText, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_front_url')  String? imageFrontUrl, @JsonKey(name: 'image_ingredients_url')  String? imageIngredientsUrl, @JsonKey(name: 'image_nutrition_url')  String? imageNutritionUrl,  OpenFoodFactsNutriments? nutriments,  String? allergens,  String? traces,  String? countries, @JsonKey(name: 'manufacturing_places')  String? manufacturingPlaces,  String? stores,  String? packaging)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenFoodFactsProduct() when $default != null:
return $default(_that.id,_that.productName,_that.brands,_that.categories,_that.ingredientsText,_that.imageUrl,_that.imageFrontUrl,_that.imageIngredientsUrl,_that.imageNutritionUrl,_that.nutriments,_that.allergens,_that.traces,_that.countries,_that.manufacturingPlaces,_that.stores,_that.packaging);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id, @JsonKey(name: 'product_name')  String? productName,  String? brands,  String? categories, @JsonKey(name: 'ingredients_text')  String? ingredientsText, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_front_url')  String? imageFrontUrl, @JsonKey(name: 'image_ingredients_url')  String? imageIngredientsUrl, @JsonKey(name: 'image_nutrition_url')  String? imageNutritionUrl,  OpenFoodFactsNutriments? nutriments,  String? allergens,  String? traces,  String? countries, @JsonKey(name: 'manufacturing_places')  String? manufacturingPlaces,  String? stores,  String? packaging)  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsProduct():
return $default(_that.id,_that.productName,_that.brands,_that.categories,_that.ingredientsText,_that.imageUrl,_that.imageFrontUrl,_that.imageIngredientsUrl,_that.imageNutritionUrl,_that.nutriments,_that.allergens,_that.traces,_that.countries,_that.manufacturingPlaces,_that.stores,_that.packaging);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String? id, @JsonKey(name: 'product_name')  String? productName,  String? brands,  String? categories, @JsonKey(name: 'ingredients_text')  String? ingredientsText, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_front_url')  String? imageFrontUrl, @JsonKey(name: 'image_ingredients_url')  String? imageIngredientsUrl, @JsonKey(name: 'image_nutrition_url')  String? imageNutritionUrl,  OpenFoodFactsNutriments? nutriments,  String? allergens,  String? traces,  String? countries, @JsonKey(name: 'manufacturing_places')  String? manufacturingPlaces,  String? stores,  String? packaging)?  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsProduct() when $default != null:
return $default(_that.id,_that.productName,_that.brands,_that.categories,_that.ingredientsText,_that.imageUrl,_that.imageFrontUrl,_that.imageIngredientsUrl,_that.imageNutritionUrl,_that.nutriments,_that.allergens,_that.traces,_that.countries,_that.manufacturingPlaces,_that.stores,_that.packaging);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenFoodFactsProduct implements OpenFoodFactsProduct {
  const _OpenFoodFactsProduct({@JsonKey(name: '_id') this.id, @JsonKey(name: 'product_name') this.productName, this.brands, this.categories, @JsonKey(name: 'ingredients_text') this.ingredientsText, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'image_front_url') this.imageFrontUrl, @JsonKey(name: 'image_ingredients_url') this.imageIngredientsUrl, @JsonKey(name: 'image_nutrition_url') this.imageNutritionUrl, this.nutriments, this.allergens, this.traces, this.countries, @JsonKey(name: 'manufacturing_places') this.manufacturingPlaces, this.stores, this.packaging});
  factory _OpenFoodFactsProduct.fromJson(Map<String, dynamic> json) => _$OpenFoodFactsProductFromJson(json);

@override@JsonKey(name: '_id') final  String? id;
@override@JsonKey(name: 'product_name') final  String? productName;
@override final  String? brands;
@override final  String? categories;
@override@JsonKey(name: 'ingredients_text') final  String? ingredientsText;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'image_front_url') final  String? imageFrontUrl;
@override@JsonKey(name: 'image_ingredients_url') final  String? imageIngredientsUrl;
@override@JsonKey(name: 'image_nutrition_url') final  String? imageNutritionUrl;
@override final  OpenFoodFactsNutriments? nutriments;
@override final  String? allergens;
@override final  String? traces;
@override final  String? countries;
@override@JsonKey(name: 'manufacturing_places') final  String? manufacturingPlaces;
@override final  String? stores;
@override final  String? packaging;

/// Create a copy of OpenFoodFactsProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenFoodFactsProductCopyWith<_OpenFoodFactsProduct> get copyWith => __$OpenFoodFactsProductCopyWithImpl<_OpenFoodFactsProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenFoodFactsProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenFoodFactsProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.brands, brands) || other.brands == brands)&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.ingredientsText, ingredientsText) || other.ingredientsText == ingredientsText)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageFrontUrl, imageFrontUrl) || other.imageFrontUrl == imageFrontUrl)&&(identical(other.imageIngredientsUrl, imageIngredientsUrl) || other.imageIngredientsUrl == imageIngredientsUrl)&&(identical(other.imageNutritionUrl, imageNutritionUrl) || other.imageNutritionUrl == imageNutritionUrl)&&(identical(other.nutriments, nutriments) || other.nutriments == nutriments)&&(identical(other.allergens, allergens) || other.allergens == allergens)&&(identical(other.traces, traces) || other.traces == traces)&&(identical(other.countries, countries) || other.countries == countries)&&(identical(other.manufacturingPlaces, manufacturingPlaces) || other.manufacturingPlaces == manufacturingPlaces)&&(identical(other.stores, stores) || other.stores == stores)&&(identical(other.packaging, packaging) || other.packaging == packaging));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,brands,categories,ingredientsText,imageUrl,imageFrontUrl,imageIngredientsUrl,imageNutritionUrl,nutriments,allergens,traces,countries,manufacturingPlaces,stores,packaging);

@override
String toString() {
  return 'OpenFoodFactsProduct(id: $id, productName: $productName, brands: $brands, categories: $categories, ingredientsText: $ingredientsText, imageUrl: $imageUrl, imageFrontUrl: $imageFrontUrl, imageIngredientsUrl: $imageIngredientsUrl, imageNutritionUrl: $imageNutritionUrl, nutriments: $nutriments, allergens: $allergens, traces: $traces, countries: $countries, manufacturingPlaces: $manufacturingPlaces, stores: $stores, packaging: $packaging)';
}


}

/// @nodoc
abstract mixin class _$OpenFoodFactsProductCopyWith<$Res> implements $OpenFoodFactsProductCopyWith<$Res> {
  factory _$OpenFoodFactsProductCopyWith(_OpenFoodFactsProduct value, $Res Function(_OpenFoodFactsProduct) _then) = __$OpenFoodFactsProductCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String? id,@JsonKey(name: 'product_name') String? productName, String? brands, String? categories,@JsonKey(name: 'ingredients_text') String? ingredientsText,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_front_url') String? imageFrontUrl,@JsonKey(name: 'image_ingredients_url') String? imageIngredientsUrl,@JsonKey(name: 'image_nutrition_url') String? imageNutritionUrl, OpenFoodFactsNutriments? nutriments, String? allergens, String? traces, String? countries,@JsonKey(name: 'manufacturing_places') String? manufacturingPlaces, String? stores, String? packaging
});


@override $OpenFoodFactsNutrimentsCopyWith<$Res>? get nutriments;

}
/// @nodoc
class __$OpenFoodFactsProductCopyWithImpl<$Res>
    implements _$OpenFoodFactsProductCopyWith<$Res> {
  __$OpenFoodFactsProductCopyWithImpl(this._self, this._then);

  final _OpenFoodFactsProduct _self;
  final $Res Function(_OpenFoodFactsProduct) _then;

/// Create a copy of OpenFoodFactsProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? productName = freezed,Object? brands = freezed,Object? categories = freezed,Object? ingredientsText = freezed,Object? imageUrl = freezed,Object? imageFrontUrl = freezed,Object? imageIngredientsUrl = freezed,Object? imageNutritionUrl = freezed,Object? nutriments = freezed,Object? allergens = freezed,Object? traces = freezed,Object? countries = freezed,Object? manufacturingPlaces = freezed,Object? stores = freezed,Object? packaging = freezed,}) {
  return _then(_OpenFoodFactsProduct(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,brands: freezed == brands ? _self.brands : brands // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as String?,ingredientsText: freezed == ingredientsText ? _self.ingredientsText : ingredientsText // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageFrontUrl: freezed == imageFrontUrl ? _self.imageFrontUrl : imageFrontUrl // ignore: cast_nullable_to_non_nullable
as String?,imageIngredientsUrl: freezed == imageIngredientsUrl ? _self.imageIngredientsUrl : imageIngredientsUrl // ignore: cast_nullable_to_non_nullable
as String?,imageNutritionUrl: freezed == imageNutritionUrl ? _self.imageNutritionUrl : imageNutritionUrl // ignore: cast_nullable_to_non_nullable
as String?,nutriments: freezed == nutriments ? _self.nutriments : nutriments // ignore: cast_nullable_to_non_nullable
as OpenFoodFactsNutriments?,allergens: freezed == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as String?,traces: freezed == traces ? _self.traces : traces // ignore: cast_nullable_to_non_nullable
as String?,countries: freezed == countries ? _self.countries : countries // ignore: cast_nullable_to_non_nullable
as String?,manufacturingPlaces: freezed == manufacturingPlaces ? _self.manufacturingPlaces : manufacturingPlaces // ignore: cast_nullable_to_non_nullable
as String?,stores: freezed == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as String?,packaging: freezed == packaging ? _self.packaging : packaging // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OpenFoodFactsProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpenFoodFactsNutrimentsCopyWith<$Res>? get nutriments {
    if (_self.nutriments == null) {
    return null;
  }

  return $OpenFoodFactsNutrimentsCopyWith<$Res>(_self.nutriments!, (value) {
    return _then(_self.copyWith(nutriments: value));
  });
}
}


/// @nodoc
mixin _$OpenFoodFactsNutriments {

@JsonKey(name: 'energy-kj_100g') double? get energyKj;@JsonKey(name: 'energy-kcal_100g') double? get energyKcal;@JsonKey(name: 'fat_100g') double? get fat;@JsonKey(name: 'saturated-fat_100g') double? get saturatedFat;@JsonKey(name: 'carbohydrates_100g') double? get carbohydrates;@JsonKey(name: 'sugars_100g') double? get sugars;@JsonKey(name: 'fiber_100g') double? get fiber;@JsonKey(name: 'proteins_100g') double? get proteins;@JsonKey(name: 'salt_100g') double? get salt;@JsonKey(name: 'sodium_100g') double? get sodium;@JsonKey(name: 'vitamin-c_100g') double? get vitaminC;@JsonKey(name: 'calcium_100g') double? get calcium;@JsonKey(name: 'iron_100g') double? get iron;
/// Create a copy of OpenFoodFactsNutriments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenFoodFactsNutrimentsCopyWith<OpenFoodFactsNutriments> get copyWith => _$OpenFoodFactsNutrimentsCopyWithImpl<OpenFoodFactsNutriments>(this as OpenFoodFactsNutriments, _$identity);

  /// Serializes this OpenFoodFactsNutriments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenFoodFactsNutriments&&(identical(other.energyKj, energyKj) || other.energyKj == energyKj)&&(identical(other.energyKcal, energyKcal) || other.energyKcal == energyKcal)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.sugars, sugars) || other.sugars == sugars)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.proteins, proteins) || other.proteins == proteins)&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.vitaminC, vitaminC) || other.vitaminC == vitaminC)&&(identical(other.calcium, calcium) || other.calcium == calcium)&&(identical(other.iron, iron) || other.iron == iron));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,energyKj,energyKcal,fat,saturatedFat,carbohydrates,sugars,fiber,proteins,salt,sodium,vitaminC,calcium,iron);

@override
String toString() {
  return 'OpenFoodFactsNutriments(energyKj: $energyKj, energyKcal: $energyKcal, fat: $fat, saturatedFat: $saturatedFat, carbohydrates: $carbohydrates, sugars: $sugars, fiber: $fiber, proteins: $proteins, salt: $salt, sodium: $sodium, vitaminC: $vitaminC, calcium: $calcium, iron: $iron)';
}


}

/// @nodoc
abstract mixin class $OpenFoodFactsNutrimentsCopyWith<$Res>  {
  factory $OpenFoodFactsNutrimentsCopyWith(OpenFoodFactsNutriments value, $Res Function(OpenFoodFactsNutriments) _then) = _$OpenFoodFactsNutrimentsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'energy-kj_100g') double? energyKj,@JsonKey(name: 'energy-kcal_100g') double? energyKcal,@JsonKey(name: 'fat_100g') double? fat,@JsonKey(name: 'saturated-fat_100g') double? saturatedFat,@JsonKey(name: 'carbohydrates_100g') double? carbohydrates,@JsonKey(name: 'sugars_100g') double? sugars,@JsonKey(name: 'fiber_100g') double? fiber,@JsonKey(name: 'proteins_100g') double? proteins,@JsonKey(name: 'salt_100g') double? salt,@JsonKey(name: 'sodium_100g') double? sodium,@JsonKey(name: 'vitamin-c_100g') double? vitaminC,@JsonKey(name: 'calcium_100g') double? calcium,@JsonKey(name: 'iron_100g') double? iron
});




}
/// @nodoc
class _$OpenFoodFactsNutrimentsCopyWithImpl<$Res>
    implements $OpenFoodFactsNutrimentsCopyWith<$Res> {
  _$OpenFoodFactsNutrimentsCopyWithImpl(this._self, this._then);

  final OpenFoodFactsNutriments _self;
  final $Res Function(OpenFoodFactsNutriments) _then;

/// Create a copy of OpenFoodFactsNutriments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? energyKj = freezed,Object? energyKcal = freezed,Object? fat = freezed,Object? saturatedFat = freezed,Object? carbohydrates = freezed,Object? sugars = freezed,Object? fiber = freezed,Object? proteins = freezed,Object? salt = freezed,Object? sodium = freezed,Object? vitaminC = freezed,Object? calcium = freezed,Object? iron = freezed,}) {
  return _then(_self.copyWith(
energyKj: freezed == energyKj ? _self.energyKj : energyKj // ignore: cast_nullable_to_non_nullable
as double?,energyKcal: freezed == energyKcal ? _self.energyKcal : energyKcal // ignore: cast_nullable_to_non_nullable
as double?,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,sugars: freezed == sugars ? _self.sugars : sugars // ignore: cast_nullable_to_non_nullable
as double?,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,proteins: freezed == proteins ? _self.proteins : proteins // ignore: cast_nullable_to_non_nullable
as double?,salt: freezed == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,vitaminC: freezed == vitaminC ? _self.vitaminC : vitaminC // ignore: cast_nullable_to_non_nullable
as double?,calcium: freezed == calcium ? _self.calcium : calcium // ignore: cast_nullable_to_non_nullable
as double?,iron: freezed == iron ? _self.iron : iron // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenFoodFactsNutriments].
extension OpenFoodFactsNutrimentsPatterns on OpenFoodFactsNutriments {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenFoodFactsNutriments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenFoodFactsNutriments() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenFoodFactsNutriments value)  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsNutriments():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenFoodFactsNutriments value)?  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsNutriments() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'energy-kj_100g')  double? energyKj, @JsonKey(name: 'energy-kcal_100g')  double? energyKcal, @JsonKey(name: 'fat_100g')  double? fat, @JsonKey(name: 'saturated-fat_100g')  double? saturatedFat, @JsonKey(name: 'carbohydrates_100g')  double? carbohydrates, @JsonKey(name: 'sugars_100g')  double? sugars, @JsonKey(name: 'fiber_100g')  double? fiber, @JsonKey(name: 'proteins_100g')  double? proteins, @JsonKey(name: 'salt_100g')  double? salt, @JsonKey(name: 'sodium_100g')  double? sodium, @JsonKey(name: 'vitamin-c_100g')  double? vitaminC, @JsonKey(name: 'calcium_100g')  double? calcium, @JsonKey(name: 'iron_100g')  double? iron)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenFoodFactsNutriments() when $default != null:
return $default(_that.energyKj,_that.energyKcal,_that.fat,_that.saturatedFat,_that.carbohydrates,_that.sugars,_that.fiber,_that.proteins,_that.salt,_that.sodium,_that.vitaminC,_that.calcium,_that.iron);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'energy-kj_100g')  double? energyKj, @JsonKey(name: 'energy-kcal_100g')  double? energyKcal, @JsonKey(name: 'fat_100g')  double? fat, @JsonKey(name: 'saturated-fat_100g')  double? saturatedFat, @JsonKey(name: 'carbohydrates_100g')  double? carbohydrates, @JsonKey(name: 'sugars_100g')  double? sugars, @JsonKey(name: 'fiber_100g')  double? fiber, @JsonKey(name: 'proteins_100g')  double? proteins, @JsonKey(name: 'salt_100g')  double? salt, @JsonKey(name: 'sodium_100g')  double? sodium, @JsonKey(name: 'vitamin-c_100g')  double? vitaminC, @JsonKey(name: 'calcium_100g')  double? calcium, @JsonKey(name: 'iron_100g')  double? iron)  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsNutriments():
return $default(_that.energyKj,_that.energyKcal,_that.fat,_that.saturatedFat,_that.carbohydrates,_that.sugars,_that.fiber,_that.proteins,_that.salt,_that.sodium,_that.vitaminC,_that.calcium,_that.iron);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'energy-kj_100g')  double? energyKj, @JsonKey(name: 'energy-kcal_100g')  double? energyKcal, @JsonKey(name: 'fat_100g')  double? fat, @JsonKey(name: 'saturated-fat_100g')  double? saturatedFat, @JsonKey(name: 'carbohydrates_100g')  double? carbohydrates, @JsonKey(name: 'sugars_100g')  double? sugars, @JsonKey(name: 'fiber_100g')  double? fiber, @JsonKey(name: 'proteins_100g')  double? proteins, @JsonKey(name: 'salt_100g')  double? salt, @JsonKey(name: 'sodium_100g')  double? sodium, @JsonKey(name: 'vitamin-c_100g')  double? vitaminC, @JsonKey(name: 'calcium_100g')  double? calcium, @JsonKey(name: 'iron_100g')  double? iron)?  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsNutriments() when $default != null:
return $default(_that.energyKj,_that.energyKcal,_that.fat,_that.saturatedFat,_that.carbohydrates,_that.sugars,_that.fiber,_that.proteins,_that.salt,_that.sodium,_that.vitaminC,_that.calcium,_that.iron);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenFoodFactsNutriments implements OpenFoodFactsNutriments {
  const _OpenFoodFactsNutriments({@JsonKey(name: 'energy-kj_100g') this.energyKj, @JsonKey(name: 'energy-kcal_100g') this.energyKcal, @JsonKey(name: 'fat_100g') this.fat, @JsonKey(name: 'saturated-fat_100g') this.saturatedFat, @JsonKey(name: 'carbohydrates_100g') this.carbohydrates, @JsonKey(name: 'sugars_100g') this.sugars, @JsonKey(name: 'fiber_100g') this.fiber, @JsonKey(name: 'proteins_100g') this.proteins, @JsonKey(name: 'salt_100g') this.salt, @JsonKey(name: 'sodium_100g') this.sodium, @JsonKey(name: 'vitamin-c_100g') this.vitaminC, @JsonKey(name: 'calcium_100g') this.calcium, @JsonKey(name: 'iron_100g') this.iron});
  factory _OpenFoodFactsNutriments.fromJson(Map<String, dynamic> json) => _$OpenFoodFactsNutrimentsFromJson(json);

@override@JsonKey(name: 'energy-kj_100g') final  double? energyKj;
@override@JsonKey(name: 'energy-kcal_100g') final  double? energyKcal;
@override@JsonKey(name: 'fat_100g') final  double? fat;
@override@JsonKey(name: 'saturated-fat_100g') final  double? saturatedFat;
@override@JsonKey(name: 'carbohydrates_100g') final  double? carbohydrates;
@override@JsonKey(name: 'sugars_100g') final  double? sugars;
@override@JsonKey(name: 'fiber_100g') final  double? fiber;
@override@JsonKey(name: 'proteins_100g') final  double? proteins;
@override@JsonKey(name: 'salt_100g') final  double? salt;
@override@JsonKey(name: 'sodium_100g') final  double? sodium;
@override@JsonKey(name: 'vitamin-c_100g') final  double? vitaminC;
@override@JsonKey(name: 'calcium_100g') final  double? calcium;
@override@JsonKey(name: 'iron_100g') final  double? iron;

/// Create a copy of OpenFoodFactsNutriments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenFoodFactsNutrimentsCopyWith<_OpenFoodFactsNutriments> get copyWith => __$OpenFoodFactsNutrimentsCopyWithImpl<_OpenFoodFactsNutriments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenFoodFactsNutrimentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenFoodFactsNutriments&&(identical(other.energyKj, energyKj) || other.energyKj == energyKj)&&(identical(other.energyKcal, energyKcal) || other.energyKcal == energyKcal)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.carbohydrates, carbohydrates) || other.carbohydrates == carbohydrates)&&(identical(other.sugars, sugars) || other.sugars == sugars)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.proteins, proteins) || other.proteins == proteins)&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.vitaminC, vitaminC) || other.vitaminC == vitaminC)&&(identical(other.calcium, calcium) || other.calcium == calcium)&&(identical(other.iron, iron) || other.iron == iron));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,energyKj,energyKcal,fat,saturatedFat,carbohydrates,sugars,fiber,proteins,salt,sodium,vitaminC,calcium,iron);

@override
String toString() {
  return 'OpenFoodFactsNutriments(energyKj: $energyKj, energyKcal: $energyKcal, fat: $fat, saturatedFat: $saturatedFat, carbohydrates: $carbohydrates, sugars: $sugars, fiber: $fiber, proteins: $proteins, salt: $salt, sodium: $sodium, vitaminC: $vitaminC, calcium: $calcium, iron: $iron)';
}


}

/// @nodoc
abstract mixin class _$OpenFoodFactsNutrimentsCopyWith<$Res> implements $OpenFoodFactsNutrimentsCopyWith<$Res> {
  factory _$OpenFoodFactsNutrimentsCopyWith(_OpenFoodFactsNutriments value, $Res Function(_OpenFoodFactsNutriments) _then) = __$OpenFoodFactsNutrimentsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'energy-kj_100g') double? energyKj,@JsonKey(name: 'energy-kcal_100g') double? energyKcal,@JsonKey(name: 'fat_100g') double? fat,@JsonKey(name: 'saturated-fat_100g') double? saturatedFat,@JsonKey(name: 'carbohydrates_100g') double? carbohydrates,@JsonKey(name: 'sugars_100g') double? sugars,@JsonKey(name: 'fiber_100g') double? fiber,@JsonKey(name: 'proteins_100g') double? proteins,@JsonKey(name: 'salt_100g') double? salt,@JsonKey(name: 'sodium_100g') double? sodium,@JsonKey(name: 'vitamin-c_100g') double? vitaminC,@JsonKey(name: 'calcium_100g') double? calcium,@JsonKey(name: 'iron_100g') double? iron
});




}
/// @nodoc
class __$OpenFoodFactsNutrimentsCopyWithImpl<$Res>
    implements _$OpenFoodFactsNutrimentsCopyWith<$Res> {
  __$OpenFoodFactsNutrimentsCopyWithImpl(this._self, this._then);

  final _OpenFoodFactsNutriments _self;
  final $Res Function(_OpenFoodFactsNutriments) _then;

/// Create a copy of OpenFoodFactsNutriments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? energyKj = freezed,Object? energyKcal = freezed,Object? fat = freezed,Object? saturatedFat = freezed,Object? carbohydrates = freezed,Object? sugars = freezed,Object? fiber = freezed,Object? proteins = freezed,Object? salt = freezed,Object? sodium = freezed,Object? vitaminC = freezed,Object? calcium = freezed,Object? iron = freezed,}) {
  return _then(_OpenFoodFactsNutriments(
energyKj: freezed == energyKj ? _self.energyKj : energyKj // ignore: cast_nullable_to_non_nullable
as double?,energyKcal: freezed == energyKcal ? _self.energyKcal : energyKcal // ignore: cast_nullable_to_non_nullable
as double?,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as double?,carbohydrates: freezed == carbohydrates ? _self.carbohydrates : carbohydrates // ignore: cast_nullable_to_non_nullable
as double?,sugars: freezed == sugars ? _self.sugars : sugars // ignore: cast_nullable_to_non_nullable
as double?,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,proteins: freezed == proteins ? _self.proteins : proteins // ignore: cast_nullable_to_non_nullable
as double?,salt: freezed == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,vitaminC: freezed == vitaminC ? _self.vitaminC : vitaminC // ignore: cast_nullable_to_non_nullable
as double?,calcium: freezed == calcium ? _self.calcium : calcium // ignore: cast_nullable_to_non_nullable
as double?,iron: freezed == iron ? _self.iron : iron // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$OpenFoodFactsSearchResponse {

 int get count; int get page;@JsonKey(name: 'page_count') int get pageCount;@JsonKey(name: 'page_size') int get pageSize; List<OpenFoodFactsProduct> get products;
/// Create a copy of OpenFoodFactsSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenFoodFactsSearchResponseCopyWith<OpenFoodFactsSearchResponse> get copyWith => _$OpenFoodFactsSearchResponseCopyWithImpl<OpenFoodFactsSearchResponse>(this as OpenFoodFactsSearchResponse, _$identity);

  /// Serializes this OpenFoodFactsSearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenFoodFactsSearchResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&const DeepCollectionEquality().equals(other.products, products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,page,pageCount,pageSize,const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'OpenFoodFactsSearchResponse(count: $count, page: $page, pageCount: $pageCount, pageSize: $pageSize, products: $products)';
}


}

/// @nodoc
abstract mixin class $OpenFoodFactsSearchResponseCopyWith<$Res>  {
  factory $OpenFoodFactsSearchResponseCopyWith(OpenFoodFactsSearchResponse value, $Res Function(OpenFoodFactsSearchResponse) _then) = _$OpenFoodFactsSearchResponseCopyWithImpl;
@useResult
$Res call({
 int count, int page,@JsonKey(name: 'page_count') int pageCount,@JsonKey(name: 'page_size') int pageSize, List<OpenFoodFactsProduct> products
});




}
/// @nodoc
class _$OpenFoodFactsSearchResponseCopyWithImpl<$Res>
    implements $OpenFoodFactsSearchResponseCopyWith<$Res> {
  _$OpenFoodFactsSearchResponseCopyWithImpl(this._self, this._then);

  final OpenFoodFactsSearchResponse _self;
  final $Res Function(OpenFoodFactsSearchResponse) _then;

/// Create a copy of OpenFoodFactsSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? page = null,Object? pageCount = null,Object? pageSize = null,Object? products = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<OpenFoodFactsProduct>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenFoodFactsSearchResponse].
extension OpenFoodFactsSearchResponsePatterns on OpenFoodFactsSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenFoodFactsSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenFoodFactsSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenFoodFactsSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenFoodFactsSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OpenFoodFactsSearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  int page, @JsonKey(name: 'page_count')  int pageCount, @JsonKey(name: 'page_size')  int pageSize,  List<OpenFoodFactsProduct> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenFoodFactsSearchResponse() when $default != null:
return $default(_that.count,_that.page,_that.pageCount,_that.pageSize,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  int page, @JsonKey(name: 'page_count')  int pageCount, @JsonKey(name: 'page_size')  int pageSize,  List<OpenFoodFactsProduct> products)  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsSearchResponse():
return $default(_that.count,_that.page,_that.pageCount,_that.pageSize,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  int page, @JsonKey(name: 'page_count')  int pageCount, @JsonKey(name: 'page_size')  int pageSize,  List<OpenFoodFactsProduct> products)?  $default,) {final _that = this;
switch (_that) {
case _OpenFoodFactsSearchResponse() when $default != null:
return $default(_that.count,_that.page,_that.pageCount,_that.pageSize,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenFoodFactsSearchResponse implements OpenFoodFactsSearchResponse {
  const _OpenFoodFactsSearchResponse({required this.count, required this.page, @JsonKey(name: 'page_count') required this.pageCount, @JsonKey(name: 'page_size') required this.pageSize, final  List<OpenFoodFactsProduct> products = const []}): _products = products;
  factory _OpenFoodFactsSearchResponse.fromJson(Map<String, dynamic> json) => _$OpenFoodFactsSearchResponseFromJson(json);

@override final  int count;
@override final  int page;
@override@JsonKey(name: 'page_count') final  int pageCount;
@override@JsonKey(name: 'page_size') final  int pageSize;
 final  List<OpenFoodFactsProduct> _products;
@override@JsonKey() List<OpenFoodFactsProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of OpenFoodFactsSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenFoodFactsSearchResponseCopyWith<_OpenFoodFactsSearchResponse> get copyWith => __$OpenFoodFactsSearchResponseCopyWithImpl<_OpenFoodFactsSearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenFoodFactsSearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenFoodFactsSearchResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&const DeepCollectionEquality().equals(other._products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,page,pageCount,pageSize,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'OpenFoodFactsSearchResponse(count: $count, page: $page, pageCount: $pageCount, pageSize: $pageSize, products: $products)';
}


}

/// @nodoc
abstract mixin class _$OpenFoodFactsSearchResponseCopyWith<$Res> implements $OpenFoodFactsSearchResponseCopyWith<$Res> {
  factory _$OpenFoodFactsSearchResponseCopyWith(_OpenFoodFactsSearchResponse value, $Res Function(_OpenFoodFactsSearchResponse) _then) = __$OpenFoodFactsSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, int page,@JsonKey(name: 'page_count') int pageCount,@JsonKey(name: 'page_size') int pageSize, List<OpenFoodFactsProduct> products
});




}
/// @nodoc
class __$OpenFoodFactsSearchResponseCopyWithImpl<$Res>
    implements _$OpenFoodFactsSearchResponseCopyWith<$Res> {
  __$OpenFoodFactsSearchResponseCopyWithImpl(this._self, this._then);

  final _OpenFoodFactsSearchResponse _self;
  final $Res Function(_OpenFoodFactsSearchResponse) _then;

/// Create a copy of OpenFoodFactsSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? page = null,Object? pageCount = null,Object? pageSize = null,Object? products = null,}) {
  return _then(_OpenFoodFactsSearchResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<OpenFoodFactsProduct>,
  ));
}


}


/// @nodoc
mixin _$UPCDatabaseResponse {

 String get code; int get total; int get offset; List<UPCDatabaseItem> get items;
/// Create a copy of UPCDatabaseResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UPCDatabaseResponseCopyWith<UPCDatabaseResponse> get copyWith => _$UPCDatabaseResponseCopyWithImpl<UPCDatabaseResponse>(this as UPCDatabaseResponse, _$identity);

  /// Serializes this UPCDatabaseResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UPCDatabaseResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,total,offset,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'UPCDatabaseResponse(code: $code, total: $total, offset: $offset, items: $items)';
}


}

/// @nodoc
abstract mixin class $UPCDatabaseResponseCopyWith<$Res>  {
  factory $UPCDatabaseResponseCopyWith(UPCDatabaseResponse value, $Res Function(UPCDatabaseResponse) _then) = _$UPCDatabaseResponseCopyWithImpl;
@useResult
$Res call({
 String code, int total, int offset, List<UPCDatabaseItem> items
});




}
/// @nodoc
class _$UPCDatabaseResponseCopyWithImpl<$Res>
    implements $UPCDatabaseResponseCopyWith<$Res> {
  _$UPCDatabaseResponseCopyWithImpl(this._self, this._then);

  final UPCDatabaseResponse _self;
  final $Res Function(UPCDatabaseResponse) _then;

/// Create a copy of UPCDatabaseResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? total = null,Object? offset = null,Object? items = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<UPCDatabaseItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [UPCDatabaseResponse].
extension UPCDatabaseResponsePatterns on UPCDatabaseResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UPCDatabaseResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UPCDatabaseResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UPCDatabaseResponse value)  $default,){
final _that = this;
switch (_that) {
case _UPCDatabaseResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UPCDatabaseResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UPCDatabaseResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int total,  int offset,  List<UPCDatabaseItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UPCDatabaseResponse() when $default != null:
return $default(_that.code,_that.total,_that.offset,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int total,  int offset,  List<UPCDatabaseItem> items)  $default,) {final _that = this;
switch (_that) {
case _UPCDatabaseResponse():
return $default(_that.code,_that.total,_that.offset,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int total,  int offset,  List<UPCDatabaseItem> items)?  $default,) {final _that = this;
switch (_that) {
case _UPCDatabaseResponse() when $default != null:
return $default(_that.code,_that.total,_that.offset,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UPCDatabaseResponse implements UPCDatabaseResponse {
  const _UPCDatabaseResponse({required this.code, required this.total, required this.offset, final  List<UPCDatabaseItem> items = const []}): _items = items;
  factory _UPCDatabaseResponse.fromJson(Map<String, dynamic> json) => _$UPCDatabaseResponseFromJson(json);

@override final  String code;
@override final  int total;
@override final  int offset;
 final  List<UPCDatabaseItem> _items;
@override@JsonKey() List<UPCDatabaseItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of UPCDatabaseResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UPCDatabaseResponseCopyWith<_UPCDatabaseResponse> get copyWith => __$UPCDatabaseResponseCopyWithImpl<_UPCDatabaseResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UPCDatabaseResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UPCDatabaseResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.total, total) || other.total == total)&&(identical(other.offset, offset) || other.offset == offset)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,total,offset,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'UPCDatabaseResponse(code: $code, total: $total, offset: $offset, items: $items)';
}


}

/// @nodoc
abstract mixin class _$UPCDatabaseResponseCopyWith<$Res> implements $UPCDatabaseResponseCopyWith<$Res> {
  factory _$UPCDatabaseResponseCopyWith(_UPCDatabaseResponse value, $Res Function(_UPCDatabaseResponse) _then) = __$UPCDatabaseResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, int total, int offset, List<UPCDatabaseItem> items
});




}
/// @nodoc
class __$UPCDatabaseResponseCopyWithImpl<$Res>
    implements _$UPCDatabaseResponseCopyWith<$Res> {
  __$UPCDatabaseResponseCopyWithImpl(this._self, this._then);

  final _UPCDatabaseResponse _self;
  final $Res Function(_UPCDatabaseResponse) _then;

/// Create a copy of UPCDatabaseResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? total = null,Object? offset = null,Object? items = null,}) {
  return _then(_UPCDatabaseResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<UPCDatabaseItem>,
  ));
}


}


/// @nodoc
mixin _$UPCDatabaseItem {

 String get ean; String get title; String? get description;@JsonKey(name: 'upc_code') String? get upcCode; String? get gtin; String? get elid; String? get brand; String? get model; String? get color; String? get size; String? get dimension; String? get weight; String? get category; String? get currency;@JsonKey(name: 'lowest_recorded_price') double? get lowestRecordedPrice;@JsonKey(name: 'highest_recorded_price') double? get highestRecordedPrice; List<String>? get images;
/// Create a copy of UPCDatabaseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UPCDatabaseItemCopyWith<UPCDatabaseItem> get copyWith => _$UPCDatabaseItemCopyWithImpl<UPCDatabaseItem>(this as UPCDatabaseItem, _$identity);

  /// Serializes this UPCDatabaseItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UPCDatabaseItem&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.upcCode, upcCode) || other.upcCode == upcCode)&&(identical(other.gtin, gtin) || other.gtin == gtin)&&(identical(other.elid, elid) || other.elid == elid)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.color, color) || other.color == color)&&(identical(other.size, size) || other.size == size)&&(identical(other.dimension, dimension) || other.dimension == dimension)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.category, category) || other.category == category)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.lowestRecordedPrice, lowestRecordedPrice) || other.lowestRecordedPrice == lowestRecordedPrice)&&(identical(other.highestRecordedPrice, highestRecordedPrice) || other.highestRecordedPrice == highestRecordedPrice)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ean,title,description,upcCode,gtin,elid,brand,model,color,size,dimension,weight,category,currency,lowestRecordedPrice,highestRecordedPrice,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'UPCDatabaseItem(ean: $ean, title: $title, description: $description, upcCode: $upcCode, gtin: $gtin, elid: $elid, brand: $brand, model: $model, color: $color, size: $size, dimension: $dimension, weight: $weight, category: $category, currency: $currency, lowestRecordedPrice: $lowestRecordedPrice, highestRecordedPrice: $highestRecordedPrice, images: $images)';
}


}

/// @nodoc
abstract mixin class $UPCDatabaseItemCopyWith<$Res>  {
  factory $UPCDatabaseItemCopyWith(UPCDatabaseItem value, $Res Function(UPCDatabaseItem) _then) = _$UPCDatabaseItemCopyWithImpl;
@useResult
$Res call({
 String ean, String title, String? description,@JsonKey(name: 'upc_code') String? upcCode, String? gtin, String? elid, String? brand, String? model, String? color, String? size, String? dimension, String? weight, String? category, String? currency,@JsonKey(name: 'lowest_recorded_price') double? lowestRecordedPrice,@JsonKey(name: 'highest_recorded_price') double? highestRecordedPrice, List<String>? images
});




}
/// @nodoc
class _$UPCDatabaseItemCopyWithImpl<$Res>
    implements $UPCDatabaseItemCopyWith<$Res> {
  _$UPCDatabaseItemCopyWithImpl(this._self, this._then);

  final UPCDatabaseItem _self;
  final $Res Function(UPCDatabaseItem) _then;

/// Create a copy of UPCDatabaseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ean = null,Object? title = null,Object? description = freezed,Object? upcCode = freezed,Object? gtin = freezed,Object? elid = freezed,Object? brand = freezed,Object? model = freezed,Object? color = freezed,Object? size = freezed,Object? dimension = freezed,Object? weight = freezed,Object? category = freezed,Object? currency = freezed,Object? lowestRecordedPrice = freezed,Object? highestRecordedPrice = freezed,Object? images = freezed,}) {
  return _then(_self.copyWith(
ean: null == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,upcCode: freezed == upcCode ? _self.upcCode : upcCode // ignore: cast_nullable_to_non_nullable
as String?,gtin: freezed == gtin ? _self.gtin : gtin // ignore: cast_nullable_to_non_nullable
as String?,elid: freezed == elid ? _self.elid : elid // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,dimension: freezed == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as String?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,lowestRecordedPrice: freezed == lowestRecordedPrice ? _self.lowestRecordedPrice : lowestRecordedPrice // ignore: cast_nullable_to_non_nullable
as double?,highestRecordedPrice: freezed == highestRecordedPrice ? _self.highestRecordedPrice : highestRecordedPrice // ignore: cast_nullable_to_non_nullable
as double?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UPCDatabaseItem].
extension UPCDatabaseItemPatterns on UPCDatabaseItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UPCDatabaseItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UPCDatabaseItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UPCDatabaseItem value)  $default,){
final _that = this;
switch (_that) {
case _UPCDatabaseItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UPCDatabaseItem value)?  $default,){
final _that = this;
switch (_that) {
case _UPCDatabaseItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ean,  String title,  String? description, @JsonKey(name: 'upc_code')  String? upcCode,  String? gtin,  String? elid,  String? brand,  String? model,  String? color,  String? size,  String? dimension,  String? weight,  String? category,  String? currency, @JsonKey(name: 'lowest_recorded_price')  double? lowestRecordedPrice, @JsonKey(name: 'highest_recorded_price')  double? highestRecordedPrice,  List<String>? images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UPCDatabaseItem() when $default != null:
return $default(_that.ean,_that.title,_that.description,_that.upcCode,_that.gtin,_that.elid,_that.brand,_that.model,_that.color,_that.size,_that.dimension,_that.weight,_that.category,_that.currency,_that.lowestRecordedPrice,_that.highestRecordedPrice,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ean,  String title,  String? description, @JsonKey(name: 'upc_code')  String? upcCode,  String? gtin,  String? elid,  String? brand,  String? model,  String? color,  String? size,  String? dimension,  String? weight,  String? category,  String? currency, @JsonKey(name: 'lowest_recorded_price')  double? lowestRecordedPrice, @JsonKey(name: 'highest_recorded_price')  double? highestRecordedPrice,  List<String>? images)  $default,) {final _that = this;
switch (_that) {
case _UPCDatabaseItem():
return $default(_that.ean,_that.title,_that.description,_that.upcCode,_that.gtin,_that.elid,_that.brand,_that.model,_that.color,_that.size,_that.dimension,_that.weight,_that.category,_that.currency,_that.lowestRecordedPrice,_that.highestRecordedPrice,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ean,  String title,  String? description, @JsonKey(name: 'upc_code')  String? upcCode,  String? gtin,  String? elid,  String? brand,  String? model,  String? color,  String? size,  String? dimension,  String? weight,  String? category,  String? currency, @JsonKey(name: 'lowest_recorded_price')  double? lowestRecordedPrice, @JsonKey(name: 'highest_recorded_price')  double? highestRecordedPrice,  List<String>? images)?  $default,) {final _that = this;
switch (_that) {
case _UPCDatabaseItem() when $default != null:
return $default(_that.ean,_that.title,_that.description,_that.upcCode,_that.gtin,_that.elid,_that.brand,_that.model,_that.color,_that.size,_that.dimension,_that.weight,_that.category,_that.currency,_that.lowestRecordedPrice,_that.highestRecordedPrice,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UPCDatabaseItem implements UPCDatabaseItem {
  const _UPCDatabaseItem({required this.ean, required this.title, this.description, @JsonKey(name: 'upc_code') this.upcCode, this.gtin, this.elid, this.brand, this.model, this.color, this.size, this.dimension, this.weight, this.category, this.currency, @JsonKey(name: 'lowest_recorded_price') this.lowestRecordedPrice, @JsonKey(name: 'highest_recorded_price') this.highestRecordedPrice, final  List<String>? images}): _images = images;
  factory _UPCDatabaseItem.fromJson(Map<String, dynamic> json) => _$UPCDatabaseItemFromJson(json);

@override final  String ean;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'upc_code') final  String? upcCode;
@override final  String? gtin;
@override final  String? elid;
@override final  String? brand;
@override final  String? model;
@override final  String? color;
@override final  String? size;
@override final  String? dimension;
@override final  String? weight;
@override final  String? category;
@override final  String? currency;
@override@JsonKey(name: 'lowest_recorded_price') final  double? lowestRecordedPrice;
@override@JsonKey(name: 'highest_recorded_price') final  double? highestRecordedPrice;
 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UPCDatabaseItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UPCDatabaseItemCopyWith<_UPCDatabaseItem> get copyWith => __$UPCDatabaseItemCopyWithImpl<_UPCDatabaseItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UPCDatabaseItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UPCDatabaseItem&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.upcCode, upcCode) || other.upcCode == upcCode)&&(identical(other.gtin, gtin) || other.gtin == gtin)&&(identical(other.elid, elid) || other.elid == elid)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.color, color) || other.color == color)&&(identical(other.size, size) || other.size == size)&&(identical(other.dimension, dimension) || other.dimension == dimension)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.category, category) || other.category == category)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.lowestRecordedPrice, lowestRecordedPrice) || other.lowestRecordedPrice == lowestRecordedPrice)&&(identical(other.highestRecordedPrice, highestRecordedPrice) || other.highestRecordedPrice == highestRecordedPrice)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ean,title,description,upcCode,gtin,elid,brand,model,color,size,dimension,weight,category,currency,lowestRecordedPrice,highestRecordedPrice,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'UPCDatabaseItem(ean: $ean, title: $title, description: $description, upcCode: $upcCode, gtin: $gtin, elid: $elid, brand: $brand, model: $model, color: $color, size: $size, dimension: $dimension, weight: $weight, category: $category, currency: $currency, lowestRecordedPrice: $lowestRecordedPrice, highestRecordedPrice: $highestRecordedPrice, images: $images)';
}


}

/// @nodoc
abstract mixin class _$UPCDatabaseItemCopyWith<$Res> implements $UPCDatabaseItemCopyWith<$Res> {
  factory _$UPCDatabaseItemCopyWith(_UPCDatabaseItem value, $Res Function(_UPCDatabaseItem) _then) = __$UPCDatabaseItemCopyWithImpl;
@override @useResult
$Res call({
 String ean, String title, String? description,@JsonKey(name: 'upc_code') String? upcCode, String? gtin, String? elid, String? brand, String? model, String? color, String? size, String? dimension, String? weight, String? category, String? currency,@JsonKey(name: 'lowest_recorded_price') double? lowestRecordedPrice,@JsonKey(name: 'highest_recorded_price') double? highestRecordedPrice, List<String>? images
});




}
/// @nodoc
class __$UPCDatabaseItemCopyWithImpl<$Res>
    implements _$UPCDatabaseItemCopyWith<$Res> {
  __$UPCDatabaseItemCopyWithImpl(this._self, this._then);

  final _UPCDatabaseItem _self;
  final $Res Function(_UPCDatabaseItem) _then;

/// Create a copy of UPCDatabaseItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ean = null,Object? title = null,Object? description = freezed,Object? upcCode = freezed,Object? gtin = freezed,Object? elid = freezed,Object? brand = freezed,Object? model = freezed,Object? color = freezed,Object? size = freezed,Object? dimension = freezed,Object? weight = freezed,Object? category = freezed,Object? currency = freezed,Object? lowestRecordedPrice = freezed,Object? highestRecordedPrice = freezed,Object? images = freezed,}) {
  return _then(_UPCDatabaseItem(
ean: null == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,upcCode: freezed == upcCode ? _self.upcCode : upcCode // ignore: cast_nullable_to_non_nullable
as String?,gtin: freezed == gtin ? _self.gtin : gtin // ignore: cast_nullable_to_non_nullable
as String?,elid: freezed == elid ? _self.elid : elid // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,dimension: freezed == dimension ? _self.dimension : dimension // ignore: cast_nullable_to_non_nullable
as String?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,lowestRecordedPrice: freezed == lowestRecordedPrice ? _self.lowestRecordedPrice : lowestRecordedPrice // ignore: cast_nullable_to_non_nullable
as double?,highestRecordedPrice: freezed == highestRecordedPrice ? _self.highestRecordedPrice : highestRecordedPrice // ignore: cast_nullable_to_non_nullable
as double?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
