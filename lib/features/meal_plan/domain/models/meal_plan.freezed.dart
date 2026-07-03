// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealPlanDay {

 String get id; String get planId; DateTime get date; String get recipeId; String get recipeName; bool get isCooked; int get sortOrder;
/// Create a copy of MealPlanDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealPlanDayCopyWith<MealPlanDay> get copyWith => _$MealPlanDayCopyWithImpl<MealPlanDay>(this as MealPlanDay, _$identity);

  /// Serializes this MealPlanDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealPlanDay&&(identical(other.id, id) || other.id == id)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.date, date) || other.date == date)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeName, recipeName) || other.recipeName == recipeName)&&(identical(other.isCooked, isCooked) || other.isCooked == isCooked)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,planId,date,recipeId,recipeName,isCooked,sortOrder);

@override
String toString() {
  return 'MealPlanDay(id: $id, planId: $planId, date: $date, recipeId: $recipeId, recipeName: $recipeName, isCooked: $isCooked, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MealPlanDayCopyWith<$Res>  {
  factory $MealPlanDayCopyWith(MealPlanDay value, $Res Function(MealPlanDay) _then) = _$MealPlanDayCopyWithImpl;
@useResult
$Res call({
 String id, String planId, DateTime date, String recipeId, String recipeName, bool isCooked, int sortOrder
});




}
/// @nodoc
class _$MealPlanDayCopyWithImpl<$Res>
    implements $MealPlanDayCopyWith<$Res> {
  _$MealPlanDayCopyWithImpl(this._self, this._then);

  final MealPlanDay _self;
  final $Res Function(MealPlanDay) _then;

/// Create a copy of MealPlanDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? planId = null,Object? date = null,Object? recipeId = null,Object? recipeName = null,Object? isCooked = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,recipeName: null == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String,isCooked: null == isCooked ? _self.isCooked : isCooked // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MealPlanDay].
extension MealPlanDayPatterns on MealPlanDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealPlanDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealPlanDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealPlanDay value)  $default,){
final _that = this;
switch (_that) {
case _MealPlanDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealPlanDay value)?  $default,){
final _that = this;
switch (_that) {
case _MealPlanDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String planId,  DateTime date,  String recipeId,  String recipeName,  bool isCooked,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealPlanDay() when $default != null:
return $default(_that.id,_that.planId,_that.date,_that.recipeId,_that.recipeName,_that.isCooked,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String planId,  DateTime date,  String recipeId,  String recipeName,  bool isCooked,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _MealPlanDay():
return $default(_that.id,_that.planId,_that.date,_that.recipeId,_that.recipeName,_that.isCooked,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String planId,  DateTime date,  String recipeId,  String recipeName,  bool isCooked,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _MealPlanDay() when $default != null:
return $default(_that.id,_that.planId,_that.date,_that.recipeId,_that.recipeName,_that.isCooked,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealPlanDay implements MealPlanDay {
  const _MealPlanDay({required this.id, required this.planId, required this.date, required this.recipeId, required this.recipeName, this.isCooked = false, this.sortOrder = 0});
  factory _MealPlanDay.fromJson(Map<String, dynamic> json) => _$MealPlanDayFromJson(json);

@override final  String id;
@override final  String planId;
@override final  DateTime date;
@override final  String recipeId;
@override final  String recipeName;
@override@JsonKey() final  bool isCooked;
@override@JsonKey() final  int sortOrder;

/// Create a copy of MealPlanDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealPlanDayCopyWith<_MealPlanDay> get copyWith => __$MealPlanDayCopyWithImpl<_MealPlanDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealPlanDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealPlanDay&&(identical(other.id, id) || other.id == id)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.date, date) || other.date == date)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.recipeName, recipeName) || other.recipeName == recipeName)&&(identical(other.isCooked, isCooked) || other.isCooked == isCooked)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,planId,date,recipeId,recipeName,isCooked,sortOrder);

@override
String toString() {
  return 'MealPlanDay(id: $id, planId: $planId, date: $date, recipeId: $recipeId, recipeName: $recipeName, isCooked: $isCooked, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$MealPlanDayCopyWith<$Res> implements $MealPlanDayCopyWith<$Res> {
  factory _$MealPlanDayCopyWith(_MealPlanDay value, $Res Function(_MealPlanDay) _then) = __$MealPlanDayCopyWithImpl;
@override @useResult
$Res call({
 String id, String planId, DateTime date, String recipeId, String recipeName, bool isCooked, int sortOrder
});




}
/// @nodoc
class __$MealPlanDayCopyWithImpl<$Res>
    implements _$MealPlanDayCopyWith<$Res> {
  __$MealPlanDayCopyWithImpl(this._self, this._then);

  final _MealPlanDay _self;
  final $Res Function(_MealPlanDay) _then;

/// Create a copy of MealPlanDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? planId = null,Object? date = null,Object? recipeId = null,Object? recipeName = null,Object? isCooked = null,Object? sortOrder = null,}) {
  return _then(_MealPlanDay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,recipeName: null == recipeName ? _self.recipeName : recipeName // ignore: cast_nullable_to_non_nullable
as String,isCooked: null == isCooked ? _self.isCooked : isCooked // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MealPlan {

 String get id; DateTime get createdAt; DateTime get startDate; DateTime get endDate; PlanType get planType; List<MealPlanDay> get days;
/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealPlanCopyWith<MealPlan> get copyWith => _$MealPlanCopyWithImpl<MealPlan>(this as MealPlan, _$identity);

  /// Serializes this MealPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.planType, planType) || other.planType == planType)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,startDate,endDate,planType,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'MealPlan(id: $id, createdAt: $createdAt, startDate: $startDate, endDate: $endDate, planType: $planType, days: $days)';
}


}

/// @nodoc
abstract mixin class $MealPlanCopyWith<$Res>  {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) _then) = _$MealPlanCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime startDate, DateTime endDate, PlanType planType, List<MealPlanDay> days
});




}
/// @nodoc
class _$MealPlanCopyWithImpl<$Res>
    implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._self, this._then);

  final MealPlan _self;
  final $Res Function(MealPlan) _then;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? startDate = null,Object? endDate = null,Object? planType = null,Object? days = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,planType: null == planType ? _self.planType : planType // ignore: cast_nullable_to_non_nullable
as PlanType,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<MealPlanDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [MealPlan].
extension MealPlanPatterns on MealPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealPlan value)  $default,){
final _that = this;
switch (_that) {
case _MealPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealPlan value)?  $default,){
final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime startDate,  DateTime endDate,  PlanType planType,  List<MealPlanDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that.id,_that.createdAt,_that.startDate,_that.endDate,_that.planType,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime startDate,  DateTime endDate,  PlanType planType,  List<MealPlanDay> days)  $default,) {final _that = this;
switch (_that) {
case _MealPlan():
return $default(_that.id,_that.createdAt,_that.startDate,_that.endDate,_that.planType,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime startDate,  DateTime endDate,  PlanType planType,  List<MealPlanDay> days)?  $default,) {final _that = this;
switch (_that) {
case _MealPlan() when $default != null:
return $default(_that.id,_that.createdAt,_that.startDate,_that.endDate,_that.planType,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealPlan extends MealPlan {
  const _MealPlan({required this.id, required this.createdAt, required this.startDate, required this.endDate, this.planType = PlanType.quick, final  List<MealPlanDay> days = const []}): _days = days,super._();
  factory _MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override@JsonKey() final  PlanType planType;
 final  List<MealPlanDay> _days;
@override@JsonKey() List<MealPlanDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealPlanCopyWith<_MealPlan> get copyWith => __$MealPlanCopyWithImpl<_MealPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.planType, planType) || other.planType == planType)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,startDate,endDate,planType,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'MealPlan(id: $id, createdAt: $createdAt, startDate: $startDate, endDate: $endDate, planType: $planType, days: $days)';
}


}

/// @nodoc
abstract mixin class _$MealPlanCopyWith<$Res> implements $MealPlanCopyWith<$Res> {
  factory _$MealPlanCopyWith(_MealPlan value, $Res Function(_MealPlan) _then) = __$MealPlanCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime startDate, DateTime endDate, PlanType planType, List<MealPlanDay> days
});




}
/// @nodoc
class __$MealPlanCopyWithImpl<$Res>
    implements _$MealPlanCopyWith<$Res> {
  __$MealPlanCopyWithImpl(this._self, this._then);

  final _MealPlan _self;
  final $Res Function(_MealPlan) _then;

/// Create a copy of MealPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? startDate = null,Object? endDate = null,Object? planType = null,Object? days = null,}) {
  return _then(_MealPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,planType: null == planType ? _self.planType : planType // ignore: cast_nullable_to_non_nullable
as PlanType,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<MealPlanDay>,
  ));
}


}

// dart format on
