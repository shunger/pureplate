// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyProfile {

 String get id; int get adults; int get kids; List<KidAgeRange> get kidAgeRanges; List<DietaryRestriction> get dietaryRestrictions; List<String> get cuisinePreferences; PreferredCookTime get preferredCookTime; BudgetLevel get budgetLevel; List<String> get pantryStaples; List<String> get dislikedIngredients;
/// Create a copy of FamilyProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyProfileCopyWith<FamilyProfile> get copyWith => _$FamilyProfileCopyWithImpl<FamilyProfile>(this as FamilyProfile, _$identity);

  /// Serializes this FamilyProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.kids, kids) || other.kids == kids)&&const DeepCollectionEquality().equals(other.kidAgeRanges, kidAgeRanges)&&const DeepCollectionEquality().equals(other.dietaryRestrictions, dietaryRestrictions)&&const DeepCollectionEquality().equals(other.cuisinePreferences, cuisinePreferences)&&(identical(other.preferredCookTime, preferredCookTime) || other.preferredCookTime == preferredCookTime)&&(identical(other.budgetLevel, budgetLevel) || other.budgetLevel == budgetLevel)&&const DeepCollectionEquality().equals(other.pantryStaples, pantryStaples)&&const DeepCollectionEquality().equals(other.dislikedIngredients, dislikedIngredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,adults,kids,const DeepCollectionEquality().hash(kidAgeRanges),const DeepCollectionEquality().hash(dietaryRestrictions),const DeepCollectionEquality().hash(cuisinePreferences),preferredCookTime,budgetLevel,const DeepCollectionEquality().hash(pantryStaples),const DeepCollectionEquality().hash(dislikedIngredients));

@override
String toString() {
  return 'FamilyProfile(id: $id, adults: $adults, kids: $kids, kidAgeRanges: $kidAgeRanges, dietaryRestrictions: $dietaryRestrictions, cuisinePreferences: $cuisinePreferences, preferredCookTime: $preferredCookTime, budgetLevel: $budgetLevel, pantryStaples: $pantryStaples, dislikedIngredients: $dislikedIngredients)';
}


}

/// @nodoc
abstract mixin class $FamilyProfileCopyWith<$Res>  {
  factory $FamilyProfileCopyWith(FamilyProfile value, $Res Function(FamilyProfile) _then) = _$FamilyProfileCopyWithImpl;
@useResult
$Res call({
 String id, int adults, int kids, List<KidAgeRange> kidAgeRanges, List<DietaryRestriction> dietaryRestrictions, List<String> cuisinePreferences, PreferredCookTime preferredCookTime, BudgetLevel budgetLevel, List<String> pantryStaples, List<String> dislikedIngredients
});




}
/// @nodoc
class _$FamilyProfileCopyWithImpl<$Res>
    implements $FamilyProfileCopyWith<$Res> {
  _$FamilyProfileCopyWithImpl(this._self, this._then);

  final FamilyProfile _self;
  final $Res Function(FamilyProfile) _then;

/// Create a copy of FamilyProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? adults = null,Object? kids = null,Object? kidAgeRanges = null,Object? dietaryRestrictions = null,Object? cuisinePreferences = null,Object? preferredCookTime = null,Object? budgetLevel = null,Object? pantryStaples = null,Object? dislikedIngredients = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,adults: null == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int,kids: null == kids ? _self.kids : kids // ignore: cast_nullable_to_non_nullable
as int,kidAgeRanges: null == kidAgeRanges ? _self.kidAgeRanges : kidAgeRanges // ignore: cast_nullable_to_non_nullable
as List<KidAgeRange>,dietaryRestrictions: null == dietaryRestrictions ? _self.dietaryRestrictions : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
as List<DietaryRestriction>,cuisinePreferences: null == cuisinePreferences ? _self.cuisinePreferences : cuisinePreferences // ignore: cast_nullable_to_non_nullable
as List<String>,preferredCookTime: null == preferredCookTime ? _self.preferredCookTime : preferredCookTime // ignore: cast_nullable_to_non_nullable
as PreferredCookTime,budgetLevel: null == budgetLevel ? _self.budgetLevel : budgetLevel // ignore: cast_nullable_to_non_nullable
as BudgetLevel,pantryStaples: null == pantryStaples ? _self.pantryStaples : pantryStaples // ignore: cast_nullable_to_non_nullable
as List<String>,dislikedIngredients: null == dislikedIngredients ? _self.dislikedIngredients : dislikedIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyProfile].
extension FamilyProfilePatterns on FamilyProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyProfile value)  $default,){
final _that = this;
switch (_that) {
case _FamilyProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyProfile value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int adults,  int kids,  List<KidAgeRange> kidAgeRanges,  List<DietaryRestriction> dietaryRestrictions,  List<String> cuisinePreferences,  PreferredCookTime preferredCookTime,  BudgetLevel budgetLevel,  List<String> pantryStaples,  List<String> dislikedIngredients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyProfile() when $default != null:
return $default(_that.id,_that.adults,_that.kids,_that.kidAgeRanges,_that.dietaryRestrictions,_that.cuisinePreferences,_that.preferredCookTime,_that.budgetLevel,_that.pantryStaples,_that.dislikedIngredients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int adults,  int kids,  List<KidAgeRange> kidAgeRanges,  List<DietaryRestriction> dietaryRestrictions,  List<String> cuisinePreferences,  PreferredCookTime preferredCookTime,  BudgetLevel budgetLevel,  List<String> pantryStaples,  List<String> dislikedIngredients)  $default,) {final _that = this;
switch (_that) {
case _FamilyProfile():
return $default(_that.id,_that.adults,_that.kids,_that.kidAgeRanges,_that.dietaryRestrictions,_that.cuisinePreferences,_that.preferredCookTime,_that.budgetLevel,_that.pantryStaples,_that.dislikedIngredients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int adults,  int kids,  List<KidAgeRange> kidAgeRanges,  List<DietaryRestriction> dietaryRestrictions,  List<String> cuisinePreferences,  PreferredCookTime preferredCookTime,  BudgetLevel budgetLevel,  List<String> pantryStaples,  List<String> dislikedIngredients)?  $default,) {final _that = this;
switch (_that) {
case _FamilyProfile() when $default != null:
return $default(_that.id,_that.adults,_that.kids,_that.kidAgeRanges,_that.dietaryRestrictions,_that.cuisinePreferences,_that.preferredCookTime,_that.budgetLevel,_that.pantryStaples,_that.dislikedIngredients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyProfile implements FamilyProfile {
  const _FamilyProfile({required this.id, this.adults = 2, this.kids = 0, final  List<KidAgeRange> kidAgeRanges = const [], final  List<DietaryRestriction> dietaryRestrictions = const [], final  List<String> cuisinePreferences = const [], this.preferredCookTime = PreferredCookTime.under45, this.budgetLevel = BudgetLevel.moderate, final  List<String> pantryStaples = const [], final  List<String> dislikedIngredients = const []}): _kidAgeRanges = kidAgeRanges,_dietaryRestrictions = dietaryRestrictions,_cuisinePreferences = cuisinePreferences,_pantryStaples = pantryStaples,_dislikedIngredients = dislikedIngredients;
  factory _FamilyProfile.fromJson(Map<String, dynamic> json) => _$FamilyProfileFromJson(json);

@override final  String id;
@override@JsonKey() final  int adults;
@override@JsonKey() final  int kids;
 final  List<KidAgeRange> _kidAgeRanges;
@override@JsonKey() List<KidAgeRange> get kidAgeRanges {
  if (_kidAgeRanges is EqualUnmodifiableListView) return _kidAgeRanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kidAgeRanges);
}

 final  List<DietaryRestriction> _dietaryRestrictions;
@override@JsonKey() List<DietaryRestriction> get dietaryRestrictions {
  if (_dietaryRestrictions is EqualUnmodifiableListView) return _dietaryRestrictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dietaryRestrictions);
}

 final  List<String> _cuisinePreferences;
@override@JsonKey() List<String> get cuisinePreferences {
  if (_cuisinePreferences is EqualUnmodifiableListView) return _cuisinePreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cuisinePreferences);
}

@override@JsonKey() final  PreferredCookTime preferredCookTime;
@override@JsonKey() final  BudgetLevel budgetLevel;
 final  List<String> _pantryStaples;
@override@JsonKey() List<String> get pantryStaples {
  if (_pantryStaples is EqualUnmodifiableListView) return _pantryStaples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pantryStaples);
}

 final  List<String> _dislikedIngredients;
@override@JsonKey() List<String> get dislikedIngredients {
  if (_dislikedIngredients is EqualUnmodifiableListView) return _dislikedIngredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dislikedIngredients);
}


/// Create a copy of FamilyProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyProfileCopyWith<_FamilyProfile> get copyWith => __$FamilyProfileCopyWithImpl<_FamilyProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.kids, kids) || other.kids == kids)&&const DeepCollectionEquality().equals(other._kidAgeRanges, _kidAgeRanges)&&const DeepCollectionEquality().equals(other._dietaryRestrictions, _dietaryRestrictions)&&const DeepCollectionEquality().equals(other._cuisinePreferences, _cuisinePreferences)&&(identical(other.preferredCookTime, preferredCookTime) || other.preferredCookTime == preferredCookTime)&&(identical(other.budgetLevel, budgetLevel) || other.budgetLevel == budgetLevel)&&const DeepCollectionEquality().equals(other._pantryStaples, _pantryStaples)&&const DeepCollectionEquality().equals(other._dislikedIngredients, _dislikedIngredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,adults,kids,const DeepCollectionEquality().hash(_kidAgeRanges),const DeepCollectionEquality().hash(_dietaryRestrictions),const DeepCollectionEquality().hash(_cuisinePreferences),preferredCookTime,budgetLevel,const DeepCollectionEquality().hash(_pantryStaples),const DeepCollectionEquality().hash(_dislikedIngredients));

@override
String toString() {
  return 'FamilyProfile(id: $id, adults: $adults, kids: $kids, kidAgeRanges: $kidAgeRanges, dietaryRestrictions: $dietaryRestrictions, cuisinePreferences: $cuisinePreferences, preferredCookTime: $preferredCookTime, budgetLevel: $budgetLevel, pantryStaples: $pantryStaples, dislikedIngredients: $dislikedIngredients)';
}


}

/// @nodoc
abstract mixin class _$FamilyProfileCopyWith<$Res> implements $FamilyProfileCopyWith<$Res> {
  factory _$FamilyProfileCopyWith(_FamilyProfile value, $Res Function(_FamilyProfile) _then) = __$FamilyProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, int adults, int kids, List<KidAgeRange> kidAgeRanges, List<DietaryRestriction> dietaryRestrictions, List<String> cuisinePreferences, PreferredCookTime preferredCookTime, BudgetLevel budgetLevel, List<String> pantryStaples, List<String> dislikedIngredients
});




}
/// @nodoc
class __$FamilyProfileCopyWithImpl<$Res>
    implements _$FamilyProfileCopyWith<$Res> {
  __$FamilyProfileCopyWithImpl(this._self, this._then);

  final _FamilyProfile _self;
  final $Res Function(_FamilyProfile) _then;

/// Create a copy of FamilyProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? adults = null,Object? kids = null,Object? kidAgeRanges = null,Object? dietaryRestrictions = null,Object? cuisinePreferences = null,Object? preferredCookTime = null,Object? budgetLevel = null,Object? pantryStaples = null,Object? dislikedIngredients = null,}) {
  return _then(_FamilyProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,adults: null == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int,kids: null == kids ? _self.kids : kids // ignore: cast_nullable_to_non_nullable
as int,kidAgeRanges: null == kidAgeRanges ? _self._kidAgeRanges : kidAgeRanges // ignore: cast_nullable_to_non_nullable
as List<KidAgeRange>,dietaryRestrictions: null == dietaryRestrictions ? _self._dietaryRestrictions : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
as List<DietaryRestriction>,cuisinePreferences: null == cuisinePreferences ? _self._cuisinePreferences : cuisinePreferences // ignore: cast_nullable_to_non_nullable
as List<String>,preferredCookTime: null == preferredCookTime ? _self.preferredCookTime : preferredCookTime // ignore: cast_nullable_to_non_nullable
as PreferredCookTime,budgetLevel: null == budgetLevel ? _self.budgetLevel : budgetLevel // ignore: cast_nullable_to_non_nullable
as BudgetLevel,pantryStaples: null == pantryStaples ? _self._pantryStaples : pantryStaples // ignore: cast_nullable_to_non_nullable
as List<String>,dislikedIngredients: null == dislikedIngredients ? _self._dislikedIngredients : dislikedIngredients // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
