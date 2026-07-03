// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Substitution {

 String get name; String? get quantity; String? get unit; String? get notes;
/// Create a copy of Substitution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubstitutionCopyWith<Substitution> get copyWith => _$SubstitutionCopyWithImpl<Substitution>(this as Substitution, _$identity);

  /// Serializes this Substitution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Substitution&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,unit,notes);

@override
String toString() {
  return 'Substitution(name: $name, quantity: $quantity, unit: $unit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $SubstitutionCopyWith<$Res>  {
  factory $SubstitutionCopyWith(Substitution value, $Res Function(Substitution) _then) = _$SubstitutionCopyWithImpl;
@useResult
$Res call({
 String name, String? quantity, String? unit, String? notes
});




}
/// @nodoc
class _$SubstitutionCopyWithImpl<$Res>
    implements $SubstitutionCopyWith<$Res> {
  _$SubstitutionCopyWithImpl(this._self, this._then);

  final Substitution _self;
  final $Res Function(Substitution) _then;

/// Create a copy of Substitution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = freezed,Object? unit = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Substitution].
extension SubstitutionPatterns on Substitution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Substitution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Substitution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Substitution value)  $default,){
final _that = this;
switch (_that) {
case _Substitution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Substitution value)?  $default,){
final _that = this;
switch (_that) {
case _Substitution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? quantity,  String? unit,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Substitution() when $default != null:
return $default(_that.name,_that.quantity,_that.unit,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? quantity,  String? unit,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Substitution():
return $default(_that.name,_that.quantity,_that.unit,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? quantity,  String? unit,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Substitution() when $default != null:
return $default(_that.name,_that.quantity,_that.unit,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Substitution implements Substitution {
  const _Substitution({required this.name, this.quantity, this.unit, this.notes});
  factory _Substitution.fromJson(Map<String, dynamic> json) => _$SubstitutionFromJson(json);

@override final  String name;
@override final  String? quantity;
@override final  String? unit;
@override final  String? notes;

/// Create a copy of Substitution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubstitutionCopyWith<_Substitution> get copyWith => __$SubstitutionCopyWithImpl<_Substitution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubstitutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Substitution&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,unit,notes);

@override
String toString() {
  return 'Substitution(name: $name, quantity: $quantity, unit: $unit, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SubstitutionCopyWith<$Res> implements $SubstitutionCopyWith<$Res> {
  factory _$SubstitutionCopyWith(_Substitution value, $Res Function(_Substitution) _then) = __$SubstitutionCopyWithImpl;
@override @useResult
$Res call({
 String name, String? quantity, String? unit, String? notes
});




}
/// @nodoc
class __$SubstitutionCopyWithImpl<$Res>
    implements _$SubstitutionCopyWith<$Res> {
  __$SubstitutionCopyWithImpl(this._self, this._then);

  final _Substitution _self;
  final $Res Function(_Substitution) _then;

/// Create a copy of Substitution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = freezed,Object? unit = freezed,Object? notes = freezed,}) {
  return _then(_Substitution(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Ingredient {

 String get name; String? get quantity; String? get unit;/// Category for shopping list grouping (produce, dairy, etc.)
 String? get category;/// Whether this ingredient is optional.
 bool get optional;/// Known substitutions.
 List<Substitution> get substitutions;
/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientCopyWith<Ingredient> get copyWith => _$IngredientCopyWithImpl<Ingredient>(this as Ingredient, _$identity);

  /// Serializes this Ingredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ingredient&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.optional, optional) || other.optional == optional)&&const DeepCollectionEquality().equals(other.substitutions, substitutions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,unit,category,optional,const DeepCollectionEquality().hash(substitutions));

@override
String toString() {
  return 'Ingredient(name: $name, quantity: $quantity, unit: $unit, category: $category, optional: $optional, substitutions: $substitutions)';
}


}

/// @nodoc
abstract mixin class $IngredientCopyWith<$Res>  {
  factory $IngredientCopyWith(Ingredient value, $Res Function(Ingredient) _then) = _$IngredientCopyWithImpl;
@useResult
$Res call({
 String name, String? quantity, String? unit, String? category, bool optional, List<Substitution> substitutions
});




}
/// @nodoc
class _$IngredientCopyWithImpl<$Res>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._self, this._then);

  final Ingredient _self;
  final $Res Function(Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = freezed,Object? unit = freezed,Object? category = freezed,Object? optional = null,Object? substitutions = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,optional: null == optional ? _self.optional : optional // ignore: cast_nullable_to_non_nullable
as bool,substitutions: null == substitutions ? _self.substitutions : substitutions // ignore: cast_nullable_to_non_nullable
as List<Substitution>,
  ));
}

}


/// Adds pattern-matching-related methods to [Ingredient].
extension IngredientPatterns on Ingredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ingredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ingredient value)  $default,){
final _that = this;
switch (_that) {
case _Ingredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ingredient value)?  $default,){
final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? quantity,  String? unit,  String? category,  bool optional,  List<Substitution> substitutions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.name,_that.quantity,_that.unit,_that.category,_that.optional,_that.substitutions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? quantity,  String? unit,  String? category,  bool optional,  List<Substitution> substitutions)  $default,) {final _that = this;
switch (_that) {
case _Ingredient():
return $default(_that.name,_that.quantity,_that.unit,_that.category,_that.optional,_that.substitutions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? quantity,  String? unit,  String? category,  bool optional,  List<Substitution> substitutions)?  $default,) {final _that = this;
switch (_that) {
case _Ingredient() when $default != null:
return $default(_that.name,_that.quantity,_that.unit,_that.category,_that.optional,_that.substitutions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ingredient implements Ingredient {
  const _Ingredient({required this.name, this.quantity, this.unit, this.category, this.optional = false, final  List<Substitution> substitutions = const []}): _substitutions = substitutions;
  factory _Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

@override final  String name;
@override final  String? quantity;
@override final  String? unit;
/// Category for shopping list grouping (produce, dairy, etc.)
@override final  String? category;
/// Whether this ingredient is optional.
@override@JsonKey() final  bool optional;
/// Known substitutions.
 final  List<Substitution> _substitutions;
/// Known substitutions.
@override@JsonKey() List<Substitution> get substitutions {
  if (_substitutions is EqualUnmodifiableListView) return _substitutions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_substitutions);
}


/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientCopyWith<_Ingredient> get copyWith => __$IngredientCopyWithImpl<_Ingredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ingredient&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.optional, optional) || other.optional == optional)&&const DeepCollectionEquality().equals(other._substitutions, _substitutions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,unit,category,optional,const DeepCollectionEquality().hash(_substitutions));

@override
String toString() {
  return 'Ingredient(name: $name, quantity: $quantity, unit: $unit, category: $category, optional: $optional, substitutions: $substitutions)';
}


}

/// @nodoc
abstract mixin class _$IngredientCopyWith<$Res> implements $IngredientCopyWith<$Res> {
  factory _$IngredientCopyWith(_Ingredient value, $Res Function(_Ingredient) _then) = __$IngredientCopyWithImpl;
@override @useResult
$Res call({
 String name, String? quantity, String? unit, String? category, bool optional, List<Substitution> substitutions
});




}
/// @nodoc
class __$IngredientCopyWithImpl<$Res>
    implements _$IngredientCopyWith<$Res> {
  __$IngredientCopyWithImpl(this._self, this._then);

  final _Ingredient _self;
  final $Res Function(_Ingredient) _then;

/// Create a copy of Ingredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = freezed,Object? unit = freezed,Object? category = freezed,Object? optional = null,Object? substitutions = null,}) {
  return _then(_Ingredient(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,optional: null == optional ? _self.optional : optional // ignore: cast_nullable_to_non_nullable
as bool,substitutions: null == substitutions ? _self._substitutions : substitutions // ignore: cast_nullable_to_non_nullable
as List<Substitution>,
  ));
}


}

// dart format on
