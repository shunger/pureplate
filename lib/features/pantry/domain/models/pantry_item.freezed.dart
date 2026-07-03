// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pantry_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PantryItem {

 String get id;/// Foreign key to Product table (nullable for manually-added items).
 String? get productId; String get name; String? get brand; ProductCategory get category;/// Quantity and unit (e.g., 2 lbs, 3 count).
 double get quantity; String get unitType;/// Location in the home.
 PantryLocation get location;/// Dates.
 DateTime? get purchasedAt; DateTime? get expiresAt;/// Smart inventory flags.
 bool get isStaple; double get reorderThreshold; bool get isBulk; double? get purchasePrice;/// User notes.
 String? get notes; String? get imageUrl;/// Sharing / sync fields.
 String? get firestorePantryId; String? get firestoreItemId;/// Timestamps.
 DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of PantryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PantryItemCopyWith<PantryItem> get copyWith => _$PantryItemCopyWithImpl<PantryItem>(this as PantryItem, _$identity);

  /// Serializes this PantryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PantryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.location, location) || other.location == location)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isStaple, isStaple) || other.isStaple == isStaple)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.isBulk, isBulk) || other.isBulk == isBulk)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.firestorePantryId, firestorePantryId) || other.firestorePantryId == firestorePantryId)&&(identical(other.firestoreItemId, firestoreItemId) || other.firestoreItemId == firestoreItemId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,productId,name,brand,category,quantity,unitType,location,purchasedAt,expiresAt,isStaple,reorderThreshold,isBulk,purchasePrice,notes,imageUrl,firestorePantryId,firestoreItemId,createdAt,updatedAt]);

@override
String toString() {
  return 'PantryItem(id: $id, productId: $productId, name: $name, brand: $brand, category: $category, quantity: $quantity, unitType: $unitType, location: $location, purchasedAt: $purchasedAt, expiresAt: $expiresAt, isStaple: $isStaple, reorderThreshold: $reorderThreshold, isBulk: $isBulk, purchasePrice: $purchasePrice, notes: $notes, imageUrl: $imageUrl, firestorePantryId: $firestorePantryId, firestoreItemId: $firestoreItemId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PantryItemCopyWith<$Res>  {
  factory $PantryItemCopyWith(PantryItem value, $Res Function(PantryItem) _then) = _$PantryItemCopyWithImpl;
@useResult
$Res call({
 String id, String? productId, String name, String? brand, ProductCategory category, double quantity, String unitType, PantryLocation location, DateTime? purchasedAt, DateTime? expiresAt, bool isStaple, double reorderThreshold, bool isBulk, double? purchasePrice, String? notes, String? imageUrl, String? firestorePantryId, String? firestoreItemId, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$PantryItemCopyWithImpl<$Res>
    implements $PantryItemCopyWith<$Res> {
  _$PantryItemCopyWithImpl(this._self, this._then);

  final PantryItem _self;
  final $Res Function(PantryItem) _then;

/// Create a copy of PantryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? name = null,Object? brand = freezed,Object? category = null,Object? quantity = null,Object? unitType = null,Object? location = null,Object? purchasedAt = freezed,Object? expiresAt = freezed,Object? isStaple = null,Object? reorderThreshold = null,Object? isBulk = null,Object? purchasePrice = freezed,Object? notes = freezed,Object? imageUrl = freezed,Object? firestorePantryId = freezed,Object? firestoreItemId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as PantryLocation,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isStaple: null == isStaple ? _self.isStaple : isStaple // ignore: cast_nullable_to_non_nullable
as bool,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double,isBulk: null == isBulk ? _self.isBulk : isBulk // ignore: cast_nullable_to_non_nullable
as bool,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,firestorePantryId: freezed == firestorePantryId ? _self.firestorePantryId : firestorePantryId // ignore: cast_nullable_to_non_nullable
as String?,firestoreItemId: freezed == firestoreItemId ? _self.firestoreItemId : firestoreItemId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PantryItem].
extension PantryItemPatterns on PantryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PantryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PantryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PantryItem value)  $default,){
final _that = this;
switch (_that) {
case _PantryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PantryItem value)?  $default,){
final _that = this;
switch (_that) {
case _PantryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? productId,  String name,  String? brand,  ProductCategory category,  double quantity,  String unitType,  PantryLocation location,  DateTime? purchasedAt,  DateTime? expiresAt,  bool isStaple,  double reorderThreshold,  bool isBulk,  double? purchasePrice,  String? notes,  String? imageUrl,  String? firestorePantryId,  String? firestoreItemId,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PantryItem() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.brand,_that.category,_that.quantity,_that.unitType,_that.location,_that.purchasedAt,_that.expiresAt,_that.isStaple,_that.reorderThreshold,_that.isBulk,_that.purchasePrice,_that.notes,_that.imageUrl,_that.firestorePantryId,_that.firestoreItemId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? productId,  String name,  String? brand,  ProductCategory category,  double quantity,  String unitType,  PantryLocation location,  DateTime? purchasedAt,  DateTime? expiresAt,  bool isStaple,  double reorderThreshold,  bool isBulk,  double? purchasePrice,  String? notes,  String? imageUrl,  String? firestorePantryId,  String? firestoreItemId,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PantryItem():
return $default(_that.id,_that.productId,_that.name,_that.brand,_that.category,_that.quantity,_that.unitType,_that.location,_that.purchasedAt,_that.expiresAt,_that.isStaple,_that.reorderThreshold,_that.isBulk,_that.purchasePrice,_that.notes,_that.imageUrl,_that.firestorePantryId,_that.firestoreItemId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? productId,  String name,  String? brand,  ProductCategory category,  double quantity,  String unitType,  PantryLocation location,  DateTime? purchasedAt,  DateTime? expiresAt,  bool isStaple,  double reorderThreshold,  bool isBulk,  double? purchasePrice,  String? notes,  String? imageUrl,  String? firestorePantryId,  String? firestoreItemId,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PantryItem() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.brand,_that.category,_that.quantity,_that.unitType,_that.location,_that.purchasedAt,_that.expiresAt,_that.isStaple,_that.reorderThreshold,_that.isBulk,_that.purchasePrice,_that.notes,_that.imageUrl,_that.firestorePantryId,_that.firestoreItemId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PantryItem extends PantryItem {
  const _PantryItem({required this.id, this.productId, required this.name, this.brand, this.category = ProductCategory.other, this.quantity = 1, this.unitType = 'count', this.location = PantryLocation.pantry, this.purchasedAt, this.expiresAt, this.isStaple = false, this.reorderThreshold = 0, this.isBulk = false, this.purchasePrice, this.notes, this.imageUrl, this.firestorePantryId, this.firestoreItemId, required this.createdAt, this.updatedAt}): super._();
  factory _PantryItem.fromJson(Map<String, dynamic> json) => _$PantryItemFromJson(json);

@override final  String id;
/// Foreign key to Product table (nullable for manually-added items).
@override final  String? productId;
@override final  String name;
@override final  String? brand;
@override@JsonKey() final  ProductCategory category;
/// Quantity and unit (e.g., 2 lbs, 3 count).
@override@JsonKey() final  double quantity;
@override@JsonKey() final  String unitType;
/// Location in the home.
@override@JsonKey() final  PantryLocation location;
/// Dates.
@override final  DateTime? purchasedAt;
@override final  DateTime? expiresAt;
/// Smart inventory flags.
@override@JsonKey() final  bool isStaple;
@override@JsonKey() final  double reorderThreshold;
@override@JsonKey() final  bool isBulk;
@override final  double? purchasePrice;
/// User notes.
@override final  String? notes;
@override final  String? imageUrl;
/// Sharing / sync fields.
@override final  String? firestorePantryId;
@override final  String? firestoreItemId;
/// Timestamps.
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of PantryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PantryItemCopyWith<_PantryItem> get copyWith => __$PantryItemCopyWithImpl<_PantryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PantryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PantryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.location, location) || other.location == location)&&(identical(other.purchasedAt, purchasedAt) || other.purchasedAt == purchasedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isStaple, isStaple) || other.isStaple == isStaple)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.isBulk, isBulk) || other.isBulk == isBulk)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.firestorePantryId, firestorePantryId) || other.firestorePantryId == firestorePantryId)&&(identical(other.firestoreItemId, firestoreItemId) || other.firestoreItemId == firestoreItemId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,productId,name,brand,category,quantity,unitType,location,purchasedAt,expiresAt,isStaple,reorderThreshold,isBulk,purchasePrice,notes,imageUrl,firestorePantryId,firestoreItemId,createdAt,updatedAt]);

@override
String toString() {
  return 'PantryItem(id: $id, productId: $productId, name: $name, brand: $brand, category: $category, quantity: $quantity, unitType: $unitType, location: $location, purchasedAt: $purchasedAt, expiresAt: $expiresAt, isStaple: $isStaple, reorderThreshold: $reorderThreshold, isBulk: $isBulk, purchasePrice: $purchasePrice, notes: $notes, imageUrl: $imageUrl, firestorePantryId: $firestorePantryId, firestoreItemId: $firestoreItemId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PantryItemCopyWith<$Res> implements $PantryItemCopyWith<$Res> {
  factory _$PantryItemCopyWith(_PantryItem value, $Res Function(_PantryItem) _then) = __$PantryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String? productId, String name, String? brand, ProductCategory category, double quantity, String unitType, PantryLocation location, DateTime? purchasedAt, DateTime? expiresAt, bool isStaple, double reorderThreshold, bool isBulk, double? purchasePrice, String? notes, String? imageUrl, String? firestorePantryId, String? firestoreItemId, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$PantryItemCopyWithImpl<$Res>
    implements _$PantryItemCopyWith<$Res> {
  __$PantryItemCopyWithImpl(this._self, this._then);

  final _PantryItem _self;
  final $Res Function(_PantryItem) _then;

/// Create a copy of PantryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? name = null,Object? brand = freezed,Object? category = null,Object? quantity = null,Object? unitType = null,Object? location = null,Object? purchasedAt = freezed,Object? expiresAt = freezed,Object? isStaple = null,Object? reorderThreshold = null,Object? isBulk = null,Object? purchasePrice = freezed,Object? notes = freezed,Object? imageUrl = freezed,Object? firestorePantryId = freezed,Object? firestoreItemId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_PantryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as PantryLocation,purchasedAt: freezed == purchasedAt ? _self.purchasedAt : purchasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isStaple: null == isStaple ? _self.isStaple : isStaple // ignore: cast_nullable_to_non_nullable
as bool,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double,isBulk: null == isBulk ? _self.isBulk : isBulk // ignore: cast_nullable_to_non_nullable
as bool,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,firestorePantryId: freezed == firestorePantryId ? _self.firestorePantryId : firestorePantryId // ignore: cast_nullable_to_non_nullable
as String?,firestoreItemId: freezed == firestoreItemId ? _self.firestoreItemId : firestoreItemId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
