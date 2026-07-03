// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShoppingListItem {

 String get id; String get listId;/// Link to Product table if from barcode scan.
 String? get productId; String get name; String? get brand; ProductCategory get category; double get quantity; String get unitType;/// Pricing.
 double? get estimatedPrice; double? get actualPrice; double? get salePrice; bool get isOnSale;/// Status.
 bool get isCompleted; int get priority; String? get notes;/// AI meal plan link — which recipe needs this item.
 String? get recipeId; String? get recipeName;/// Whether pantry already has this (partial coverage).
 double get pantryQuantityAvailable;/// Timestamps.
 DateTime get addedAt; DateTime? get updatedAt; int get sortOrder;
/// Create a copy of ShoppingListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingListItemCopyWith<ShoppingListItem> get copyWith => _$ShoppingListItemCopyWithImpl<ShoppingListItem>(this as ShoppingListItem, _$identity);

  /// Serializes this ShoppingListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.actualPrice, actualPrice) || other.actualPrice == actualPrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.isOnSale, isOnSale) || other.isOnSale == isOnSale)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeName, recipeName) || other.recipeName == recipeName)&&(identical(other.pantryQuantityAvailable, pantryQuantityAvailable) || other.pantryQuantityAvailable == pantryQuantityAvailable)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,listId,productId,name,brand,category,quantity,unitType,estimatedPrice,actualPrice,salePrice,isOnSale,isCompleted,priority,notes,recipeId,recipeName,pantryQuantityAvailable,addedAt,updatedAt,sortOrder]);

@override
String toString() {
  return 'ShoppingListItem(id: $id, listId: $listId, productId: $productId, name: $name, brand: $brand, category: $category, quantity: $quantity, unitType: $unitType, estimatedPrice: $estimatedPrice, actualPrice: $actualPrice, salePrice: $salePrice, isOnSale: $isOnSale, isCompleted: $isCompleted, priority: $priority, notes: $notes, recipeId: $recipeId, recipeName: $recipeName, pantryQuantityAvailable: $pantryQuantityAvailable, addedAt: $addedAt, updatedAt: $updatedAt, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ShoppingListItemCopyWith<$Res>  {
  factory $ShoppingListItemCopyWith(ShoppingListItem value, $Res Function(ShoppingListItem) _then) = _$ShoppingListItemCopyWithImpl;
@useResult
$Res call({
 String id, String listId, String? productId, String name, String? brand, ProductCategory category, double quantity, String unitType, double? estimatedPrice, double? actualPrice, double? salePrice, bool isOnSale, bool isCompleted, int priority, String? notes, String? recipeId, String? recipeName, double pantryQuantityAvailable, DateTime addedAt, DateTime? updatedAt, int sortOrder
});




}
/// @nodoc
class _$ShoppingListItemCopyWithImpl<$Res>
    implements $ShoppingListItemCopyWith<$Res> {
  _$ShoppingListItemCopyWithImpl(this._self, this._then);

  final ShoppingListItem _self;
  final $Res Function(ShoppingListItem) _then;

/// Create a copy of ShoppingListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? listId = null,Object? productId = freezed,Object? name = null,Object? brand = freezed,Object? category = null,Object? quantity = null,Object? unitType = null,Object? estimatedPrice = freezed,Object? actualPrice = freezed,Object? salePrice = freezed,Object? isOnSale = null,Object? isCompleted = null,Object? priority = null,Object? notes = freezed,Object? recipeId = freezed,Object? recipeName = freezed,Object? pantryQuantityAvailable = null,Object? addedAt = null,Object? updatedAt = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as double?,actualPrice: freezed == actualPrice ? _self.actualPrice : actualPrice // ignore: cast_nullable_to_non_nullable
as double?,salePrice: freezed == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double?,isOnSale: null == isOnSale ? _self.isOnSale : isOnSale // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recipeId: freezed == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String?,recipeName: freezed == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String?,pantryQuantityAvailable: null == pantryQuantityAvailable ? _self.pantryQuantityAvailable : pantryQuantityAvailable // ignore: cast_nullable_to_non_nullable
as double,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoppingListItem].
extension ShoppingListItemPatterns on ShoppingListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingListItem value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingListItem value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String listId,  String? productId,  String name,  String? brand,  ProductCategory category,  double quantity,  String unitType,  double? estimatedPrice,  double? actualPrice,  double? salePrice,  bool isOnSale,  bool isCompleted,  int priority,  String? notes,  String? recipeId,  String? recipeName,  double pantryQuantityAvailable,  DateTime addedAt,  DateTime? updatedAt,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingListItem() when $default != null:
return $default(_that.id,_that.listId,_that.productId,_that.name,_that.brand,_that.category,_that.quantity,_that.unitType,_that.estimatedPrice,_that.actualPrice,_that.salePrice,_that.isOnSale,_that.isCompleted,_that.priority,_that.notes,_that.recipeId,_that.recipeName,_that.pantryQuantityAvailable,_that.addedAt,_that.updatedAt,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String listId,  String? productId,  String name,  String? brand,  ProductCategory category,  double quantity,  String unitType,  double? estimatedPrice,  double? actualPrice,  double? salePrice,  bool isOnSale,  bool isCompleted,  int priority,  String? notes,  String? recipeId,  String? recipeName,  double pantryQuantityAvailable,  DateTime addedAt,  DateTime? updatedAt,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ShoppingListItem():
return $default(_that.id,_that.listId,_that.productId,_that.name,_that.brand,_that.category,_that.quantity,_that.unitType,_that.estimatedPrice,_that.actualPrice,_that.salePrice,_that.isOnSale,_that.isCompleted,_that.priority,_that.notes,_that.recipeId,_that.recipeName,_that.pantryQuantityAvailable,_that.addedAt,_that.updatedAt,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String listId,  String? productId,  String name,  String? brand,  ProductCategory category,  double quantity,  String unitType,  double? estimatedPrice,  double? actualPrice,  double? salePrice,  bool isOnSale,  bool isCompleted,  int priority,  String? notes,  String? recipeId,  String? recipeName,  double pantryQuantityAvailable,  DateTime addedAt,  DateTime? updatedAt,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingListItem() when $default != null:
return $default(_that.id,_that.listId,_that.productId,_that.name,_that.brand,_that.category,_that.quantity,_that.unitType,_that.estimatedPrice,_that.actualPrice,_that.salePrice,_that.isOnSale,_that.isCompleted,_that.priority,_that.notes,_that.recipeId,_that.recipeName,_that.pantryQuantityAvailable,_that.addedAt,_that.updatedAt,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShoppingListItem extends ShoppingListItem {
  const _ShoppingListItem({required this.id, required this.listId, this.productId, required this.name, this.brand, this.category = ProductCategory.other, this.quantity = 1, this.unitType = 'count', this.estimatedPrice, this.actualPrice, this.salePrice, this.isOnSale = false, this.isCompleted = false, this.priority = 0, this.notes, this.recipeId, this.recipeName, this.pantryQuantityAvailable = 0, required this.addedAt, this.updatedAt, this.sortOrder = 0}): super._();
  factory _ShoppingListItem.fromJson(Map<String, dynamic> json) => _$ShoppingListItemFromJson(json);

@override final  String id;
@override final  String listId;
/// Link to Product table if from barcode scan.
@override final  String? productId;
@override final  String name;
@override final  String? brand;
@override@JsonKey() final  ProductCategory category;
@override@JsonKey() final  double quantity;
@override@JsonKey() final  String unitType;
/// Pricing.
@override final  double? estimatedPrice;
@override final  double? actualPrice;
@override final  double? salePrice;
@override@JsonKey() final  bool isOnSale;
/// Status.
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  int priority;
@override final  String? notes;
/// AI meal plan link — which recipe needs this item.
@override final  String? recipeId;
@override final  String? recipeName;
/// Whether pantry already has this (partial coverage).
@override@JsonKey() final  double pantryQuantityAvailable;
/// Timestamps.
@override final  DateTime addedAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int sortOrder;

/// Create a copy of ShoppingListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingListItemCopyWith<_ShoppingListItem> get copyWith => __$ShoppingListItemCopyWithImpl<_ShoppingListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShoppingListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.estimatedPrice, estimatedPrice) || other.estimatedPrice == estimatedPrice)&&(identical(other.actualPrice, actualPrice) || other.actualPrice == actualPrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.isOnSale, isOnSale) || other.isOnSale == isOnSale)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeName, recipeName) || other.recipeName == recipeName)&&(identical(other.pantryQuantityAvailable, pantryQuantityAvailable) || other.pantryQuantityAvailable == pantryQuantityAvailable)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,listId,productId,name,brand,category,quantity,unitType,estimatedPrice,actualPrice,salePrice,isOnSale,isCompleted,priority,notes,recipeId,recipeName,pantryQuantityAvailable,addedAt,updatedAt,sortOrder]);

@override
String toString() {
  return 'ShoppingListItem(id: $id, listId: $listId, productId: $productId, name: $name, brand: $brand, category: $category, quantity: $quantity, unitType: $unitType, estimatedPrice: $estimatedPrice, actualPrice: $actualPrice, salePrice: $salePrice, isOnSale: $isOnSale, isCompleted: $isCompleted, priority: $priority, notes: $notes, recipeId: $recipeId, recipeName: $recipeName, pantryQuantityAvailable: $pantryQuantityAvailable, addedAt: $addedAt, updatedAt: $updatedAt, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ShoppingListItemCopyWith<$Res> implements $ShoppingListItemCopyWith<$Res> {
  factory _$ShoppingListItemCopyWith(_ShoppingListItem value, $Res Function(_ShoppingListItem) _then) = __$ShoppingListItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String listId, String? productId, String name, String? brand, ProductCategory category, double quantity, String unitType, double? estimatedPrice, double? actualPrice, double? salePrice, bool isOnSale, bool isCompleted, int priority, String? notes, String? recipeId, String? recipeName, double pantryQuantityAvailable, DateTime addedAt, DateTime? updatedAt, int sortOrder
});




}
/// @nodoc
class __$ShoppingListItemCopyWithImpl<$Res>
    implements _$ShoppingListItemCopyWith<$Res> {
  __$ShoppingListItemCopyWithImpl(this._self, this._then);

  final _ShoppingListItem _self;
  final $Res Function(_ShoppingListItem) _then;

/// Create a copy of ShoppingListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? listId = null,Object? productId = freezed,Object? name = null,Object? brand = freezed,Object? category = null,Object? quantity = null,Object? unitType = null,Object? estimatedPrice = freezed,Object? actualPrice = freezed,Object? salePrice = freezed,Object? isOnSale = null,Object? isCompleted = null,Object? priority = null,Object? notes = freezed,Object? recipeId = freezed,Object? recipeName = freezed,Object? pantryQuantityAvailable = null,Object? addedAt = null,Object? updatedAt = freezed,Object? sortOrder = null,}) {
  return _then(_ShoppingListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,estimatedPrice: freezed == estimatedPrice ? _self.estimatedPrice : estimatedPrice // ignore: cast_nullable_to_non_nullable
as double?,actualPrice: freezed == actualPrice ? _self.actualPrice : actualPrice // ignore: cast_nullable_to_non_nullable
as double?,salePrice: freezed == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double?,isOnSale: null == isOnSale ? _self.isOnSale : isOnSale // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recipeId: freezed == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String?,recipeName: freezed == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String?,pantryQuantityAvailable: null == pantryQuantityAvailable ? _self.pantryQuantityAvailable : pantryQuantityAvailable // ignore: cast_nullable_to_non_nullable
as double,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ShoppingList {

 String get id; String get name; List<ShoppingListItem> get items;/// Store association.
 String? get storeId; String? get storeName;/// Source tracking.
 ShoppingListSource get source;/// If auto-generated, which meal plan produced this.
 String? get mealPlanId;/// Status.
 bool get isActive; bool get isCompleted; bool get isArchived;/// Sharing.
 String? get firestoreId;/// Timestamps.
 DateTime get createdAt; DateTime? get dateShopped; int get sortOrder;
/// Create a copy of ShoppingList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingListCopyWith<ShoppingList> get copyWith => _$ShoppingListCopyWithImpl<ShoppingList>(this as ShoppingList, _$identity);

  /// Serializes this ShoppingList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingList&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.source, source) || other.source == source)&&(identical(other.mealPlanId, mealPlanId) || other.mealPlanId == mealPlanId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.firestoreId, firestoreId) || other.firestoreId == firestoreId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dateShopped, dateShopped) || other.dateShopped == dateShopped)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(items),storeId,storeName,source,mealPlanId,isActive,isCompleted,isArchived,firestoreId,createdAt,dateShopped,sortOrder);

@override
String toString() {
  return 'ShoppingList(id: $id, name: $name, items: $items, storeId: $storeId, storeName: $storeName, source: $source, mealPlanId: $mealPlanId, isActive: $isActive, isCompleted: $isCompleted, isArchived: $isArchived, firestoreId: $firestoreId, createdAt: $createdAt, dateShopped: $dateShopped, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ShoppingListCopyWith<$Res>  {
  factory $ShoppingListCopyWith(ShoppingList value, $Res Function(ShoppingList) _then) = _$ShoppingListCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<ShoppingListItem> items, String? storeId, String? storeName, ShoppingListSource source, String? mealPlanId, bool isActive, bool isCompleted, bool isArchived, String? firestoreId, DateTime createdAt, DateTime? dateShopped, int sortOrder
});




}
/// @nodoc
class _$ShoppingListCopyWithImpl<$Res>
    implements $ShoppingListCopyWith<$Res> {
  _$ShoppingListCopyWithImpl(this._self, this._then);

  final ShoppingList _self;
  final $Res Function(ShoppingList) _then;

/// Create a copy of ShoppingList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? items = null,Object? storeId = freezed,Object? storeName = freezed,Object? source = null,Object? mealPlanId = freezed,Object? isActive = null,Object? isCompleted = null,Object? isArchived = null,Object? firestoreId = freezed,Object? createdAt = null,Object? dateShopped = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ShoppingListItem>,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ShoppingListSource,mealPlanId: freezed == mealPlanId ? _self.mealPlanId : mealPlanId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,firestoreId: freezed == firestoreId ? _self.firestoreId : firestoreId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dateShopped: freezed == dateShopped ? _self.dateShopped : dateShopped // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoppingList].
extension ShoppingListPatterns on ShoppingList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingList value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingList value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<ShoppingListItem> items,  String? storeId,  String? storeName,  ShoppingListSource source,  String? mealPlanId,  bool isActive,  bool isCompleted,  bool isArchived,  String? firestoreId,  DateTime createdAt,  DateTime? dateShopped,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingList() when $default != null:
return $default(_that.id,_that.name,_that.items,_that.storeId,_that.storeName,_that.source,_that.mealPlanId,_that.isActive,_that.isCompleted,_that.isArchived,_that.firestoreId,_that.createdAt,_that.dateShopped,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<ShoppingListItem> items,  String? storeId,  String? storeName,  ShoppingListSource source,  String? mealPlanId,  bool isActive,  bool isCompleted,  bool isArchived,  String? firestoreId,  DateTime createdAt,  DateTime? dateShopped,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ShoppingList():
return $default(_that.id,_that.name,_that.items,_that.storeId,_that.storeName,_that.source,_that.mealPlanId,_that.isActive,_that.isCompleted,_that.isArchived,_that.firestoreId,_that.createdAt,_that.dateShopped,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<ShoppingListItem> items,  String? storeId,  String? storeName,  ShoppingListSource source,  String? mealPlanId,  bool isActive,  bool isCompleted,  bool isArchived,  String? firestoreId,  DateTime createdAt,  DateTime? dateShopped,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingList() when $default != null:
return $default(_that.id,_that.name,_that.items,_that.storeId,_that.storeName,_that.source,_that.mealPlanId,_that.isActive,_that.isCompleted,_that.isArchived,_that.firestoreId,_that.createdAt,_that.dateShopped,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShoppingList extends ShoppingList {
  const _ShoppingList({required this.id, required this.name, final  List<ShoppingListItem> items = const [], this.storeId, this.storeName, this.source = ShoppingListSource.manual, this.mealPlanId, this.isActive = true, this.isCompleted = false, this.isArchived = false, this.firestoreId, required this.createdAt, this.dateShopped, this.sortOrder = 0}): _items = items,super._();
  factory _ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);

@override final  String id;
@override final  String name;
 final  List<ShoppingListItem> _items;
@override@JsonKey() List<ShoppingListItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Store association.
@override final  String? storeId;
@override final  String? storeName;
/// Source tracking.
@override@JsonKey() final  ShoppingListSource source;
/// If auto-generated, which meal plan produced this.
@override final  String? mealPlanId;
/// Status.
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  bool isArchived;
/// Sharing.
@override final  String? firestoreId;
/// Timestamps.
@override final  DateTime createdAt;
@override final  DateTime? dateShopped;
@override@JsonKey() final  int sortOrder;

/// Create a copy of ShoppingList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingListCopyWith<_ShoppingList> get copyWith => __$ShoppingListCopyWithImpl<_ShoppingList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShoppingListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingList&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.source, source) || other.source == source)&&(identical(other.mealPlanId, mealPlanId) || other.mealPlanId == mealPlanId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.firestoreId, firestoreId) || other.firestoreId == firestoreId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dateShopped, dateShopped) || other.dateShopped == dateShopped)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_items),storeId,storeName,source,mealPlanId,isActive,isCompleted,isArchived,firestoreId,createdAt,dateShopped,sortOrder);

@override
String toString() {
  return 'ShoppingList(id: $id, name: $name, items: $items, storeId: $storeId, storeName: $storeName, source: $source, mealPlanId: $mealPlanId, isActive: $isActive, isCompleted: $isCompleted, isArchived: $isArchived, firestoreId: $firestoreId, createdAt: $createdAt, dateShopped: $dateShopped, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ShoppingListCopyWith<$Res> implements $ShoppingListCopyWith<$Res> {
  factory _$ShoppingListCopyWith(_ShoppingList value, $Res Function(_ShoppingList) _then) = __$ShoppingListCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<ShoppingListItem> items, String? storeId, String? storeName, ShoppingListSource source, String? mealPlanId, bool isActive, bool isCompleted, bool isArchived, String? firestoreId, DateTime createdAt, DateTime? dateShopped, int sortOrder
});




}
/// @nodoc
class __$ShoppingListCopyWithImpl<$Res>
    implements _$ShoppingListCopyWith<$Res> {
  __$ShoppingListCopyWithImpl(this._self, this._then);

  final _ShoppingList _self;
  final $Res Function(_ShoppingList) _then;

/// Create a copy of ShoppingList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? items = null,Object? storeId = freezed,Object? storeName = freezed,Object? source = null,Object? mealPlanId = freezed,Object? isActive = null,Object? isCompleted = null,Object? isArchived = null,Object? firestoreId = freezed,Object? createdAt = null,Object? dateShopped = freezed,Object? sortOrder = null,}) {
  return _then(_ShoppingList(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ShoppingListItem>,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ShoppingListSource,mealPlanId: freezed == mealPlanId ? _self.mealPlanId : mealPlanId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,firestoreId: freezed == firestoreId ? _self.firestoreId : firestoreId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dateShopped: freezed == dateShopped ? _self.dateShopped : dateShopped // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
