// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NutritionValue {

 double get amount; String get unit; double? get dailyValuePercent;
/// Create a copy of NutritionValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<NutritionValue> get copyWith => _$NutritionValueCopyWithImpl<NutritionValue>(this as NutritionValue, _$identity);

  /// Serializes this NutritionValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NutritionValue&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.dailyValuePercent, dailyValuePercent) || other.dailyValuePercent == dailyValuePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,unit,dailyValuePercent);

@override
String toString() {
  return 'NutritionValue(amount: $amount, unit: $unit, dailyValuePercent: $dailyValuePercent)';
}


}

/// @nodoc
abstract mixin class $NutritionValueCopyWith<$Res>  {
  factory $NutritionValueCopyWith(NutritionValue value, $Res Function(NutritionValue) _then) = _$NutritionValueCopyWithImpl;
@useResult
$Res call({
 double amount, String unit, double? dailyValuePercent
});




}
/// @nodoc
class _$NutritionValueCopyWithImpl<$Res>
    implements $NutritionValueCopyWith<$Res> {
  _$NutritionValueCopyWithImpl(this._self, this._then);

  final NutritionValue _self;
  final $Res Function(NutritionValue) _then;

/// Create a copy of NutritionValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? unit = null,Object? dailyValuePercent = freezed,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,dailyValuePercent: freezed == dailyValuePercent ? _self.dailyValuePercent : dailyValuePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [NutritionValue].
extension NutritionValuePatterns on NutritionValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NutritionValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NutritionValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NutritionValue value)  $default,){
final _that = this;
switch (_that) {
case _NutritionValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NutritionValue value)?  $default,){
final _that = this;
switch (_that) {
case _NutritionValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double amount,  String unit,  double? dailyValuePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NutritionValue() when $default != null:
return $default(_that.amount,_that.unit,_that.dailyValuePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double amount,  String unit,  double? dailyValuePercent)  $default,) {final _that = this;
switch (_that) {
case _NutritionValue():
return $default(_that.amount,_that.unit,_that.dailyValuePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double amount,  String unit,  double? dailyValuePercent)?  $default,) {final _that = this;
switch (_that) {
case _NutritionValue() when $default != null:
return $default(_that.amount,_that.unit,_that.dailyValuePercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NutritionValue implements NutritionValue {
  const _NutritionValue({required this.amount, required this.unit, this.dailyValuePercent});
  factory _NutritionValue.fromJson(Map<String, dynamic> json) => _$NutritionValueFromJson(json);

@override final  double amount;
@override final  String unit;
@override final  double? dailyValuePercent;

/// Create a copy of NutritionValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NutritionValueCopyWith<_NutritionValue> get copyWith => __$NutritionValueCopyWithImpl<_NutritionValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NutritionValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NutritionValue&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.dailyValuePercent, dailyValuePercent) || other.dailyValuePercent == dailyValuePercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,unit,dailyValuePercent);

@override
String toString() {
  return 'NutritionValue(amount: $amount, unit: $unit, dailyValuePercent: $dailyValuePercent)';
}


}

/// @nodoc
abstract mixin class _$NutritionValueCopyWith<$Res> implements $NutritionValueCopyWith<$Res> {
  factory _$NutritionValueCopyWith(_NutritionValue value, $Res Function(_NutritionValue) _then) = __$NutritionValueCopyWithImpl;
@override @useResult
$Res call({
 double amount, String unit, double? dailyValuePercent
});




}
/// @nodoc
class __$NutritionValueCopyWithImpl<$Res>
    implements _$NutritionValueCopyWith<$Res> {
  __$NutritionValueCopyWithImpl(this._self, this._then);

  final _NutritionValue _self;
  final $Res Function(_NutritionValue) _then;

/// Create a copy of NutritionValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? unit = null,Object? dailyValuePercent = freezed,}) {
  return _then(_NutritionValue(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,dailyValuePercent: freezed == dailyValuePercent ? _self.dailyValuePercent : dailyValuePercent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$NutritionInfo {

 String? get servingSize; int? get servingsPerContainer; int? get calories; NutritionValue? get totalFat; NutritionValue? get saturatedFat; NutritionValue? get transFat; NutritionValue? get cholesterol; NutritionValue? get sodium; NutritionValue? get totalCarbohydrates; NutritionValue? get dietaryFiber; NutritionValue? get totalSugars; NutritionValue? get addedSugars; NutritionValue? get protein; NutritionValue? get vitaminD; NutritionValue? get calcium; NutritionValue? get iron; NutritionValue? get potassium; Map<String, NutritionValue>? get additionalNutrients;
/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NutritionInfoCopyWith<NutritionInfo> get copyWith => _$NutritionInfoCopyWithImpl<NutritionInfo>(this as NutritionInfo, _$identity);

  /// Serializes this NutritionInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NutritionInfo&&(identical(other.servingSize, servingSize) || other.servingSize == servingSize)&&(identical(other.servingsPerContainer, servingsPerContainer) || other.servingsPerContainer == servingsPerContainer)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.totalFat, totalFat) || other.totalFat == totalFat)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.transFat, transFat) || other.transFat == transFat)&&(identical(other.cholesterol, cholesterol) || other.cholesterol == cholesterol)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.totalCarbohydrates, totalCarbohydrates) || other.totalCarbohydrates == totalCarbohydrates)&&(identical(other.dietaryFiber, dietaryFiber) || other.dietaryFiber == dietaryFiber)&&(identical(other.totalSugars, totalSugars) || other.totalSugars == totalSugars)&&(identical(other.addedSugars, addedSugars) || other.addedSugars == addedSugars)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.vitaminD, vitaminD) || other.vitaminD == vitaminD)&&(identical(other.calcium, calcium) || other.calcium == calcium)&&(identical(other.iron, iron) || other.iron == iron)&&(identical(other.potassium, potassium) || other.potassium == potassium)&&const DeepCollectionEquality().equals(other.additionalNutrients, additionalNutrients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,servingSize,servingsPerContainer,calories,totalFat,saturatedFat,transFat,cholesterol,sodium,totalCarbohydrates,dietaryFiber,totalSugars,addedSugars,protein,vitaminD,calcium,iron,potassium,const DeepCollectionEquality().hash(additionalNutrients));

@override
String toString() {
  return 'NutritionInfo(servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, calories: $calories, totalFat: $totalFat, saturatedFat: $saturatedFat, transFat: $transFat, cholesterol: $cholesterol, sodium: $sodium, totalCarbohydrates: $totalCarbohydrates, dietaryFiber: $dietaryFiber, totalSugars: $totalSugars, addedSugars: $addedSugars, protein: $protein, vitaminD: $vitaminD, calcium: $calcium, iron: $iron, potassium: $potassium, additionalNutrients: $additionalNutrients)';
}


}

/// @nodoc
abstract mixin class $NutritionInfoCopyWith<$Res>  {
  factory $NutritionInfoCopyWith(NutritionInfo value, $Res Function(NutritionInfo) _then) = _$NutritionInfoCopyWithImpl;
@useResult
$Res call({
 String? servingSize, int? servingsPerContainer, int? calories, NutritionValue? totalFat, NutritionValue? saturatedFat, NutritionValue? transFat, NutritionValue? cholesterol, NutritionValue? sodium, NutritionValue? totalCarbohydrates, NutritionValue? dietaryFiber, NutritionValue? totalSugars, NutritionValue? addedSugars, NutritionValue? protein, NutritionValue? vitaminD, NutritionValue? calcium, NutritionValue? iron, NutritionValue? potassium, Map<String, NutritionValue>? additionalNutrients
});


$NutritionValueCopyWith<$Res>? get totalFat;$NutritionValueCopyWith<$Res>? get saturatedFat;$NutritionValueCopyWith<$Res>? get transFat;$NutritionValueCopyWith<$Res>? get cholesterol;$NutritionValueCopyWith<$Res>? get sodium;$NutritionValueCopyWith<$Res>? get totalCarbohydrates;$NutritionValueCopyWith<$Res>? get dietaryFiber;$NutritionValueCopyWith<$Res>? get totalSugars;$NutritionValueCopyWith<$Res>? get addedSugars;$NutritionValueCopyWith<$Res>? get protein;$NutritionValueCopyWith<$Res>? get vitaminD;$NutritionValueCopyWith<$Res>? get calcium;$NutritionValueCopyWith<$Res>? get iron;$NutritionValueCopyWith<$Res>? get potassium;

}
/// @nodoc
class _$NutritionInfoCopyWithImpl<$Res>
    implements $NutritionInfoCopyWith<$Res> {
  _$NutritionInfoCopyWithImpl(this._self, this._then);

  final NutritionInfo _self;
  final $Res Function(NutritionInfo) _then;

/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? servingSize = freezed,Object? servingsPerContainer = freezed,Object? calories = freezed,Object? totalFat = freezed,Object? saturatedFat = freezed,Object? transFat = freezed,Object? cholesterol = freezed,Object? sodium = freezed,Object? totalCarbohydrates = freezed,Object? dietaryFiber = freezed,Object? totalSugars = freezed,Object? addedSugars = freezed,Object? protein = freezed,Object? vitaminD = freezed,Object? calcium = freezed,Object? iron = freezed,Object? potassium = freezed,Object? additionalNutrients = freezed,}) {
  return _then(_self.copyWith(
servingSize: freezed == servingSize ? _self.servingSize : servingSize // ignore: cast_nullable_to_non_nullable
as String?,servingsPerContainer: freezed == servingsPerContainer ? _self.servingsPerContainer : servingsPerContainer // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,totalFat: freezed == totalFat ? _self.totalFat : totalFat // ignore: cast_nullable_to_non_nullable
as NutritionValue?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as NutritionValue?,transFat: freezed == transFat ? _self.transFat : transFat // ignore: cast_nullable_to_non_nullable
as NutritionValue?,cholesterol: freezed == cholesterol ? _self.cholesterol : cholesterol // ignore: cast_nullable_to_non_nullable
as NutritionValue?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as NutritionValue?,totalCarbohydrates: freezed == totalCarbohydrates ? _self.totalCarbohydrates : totalCarbohydrates // ignore: cast_nullable_to_non_nullable
as NutritionValue?,dietaryFiber: freezed == dietaryFiber ? _self.dietaryFiber : dietaryFiber // ignore: cast_nullable_to_non_nullable
as NutritionValue?,totalSugars: freezed == totalSugars ? _self.totalSugars : totalSugars // ignore: cast_nullable_to_non_nullable
as NutritionValue?,addedSugars: freezed == addedSugars ? _self.addedSugars : addedSugars // ignore: cast_nullable_to_non_nullable
as NutritionValue?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as NutritionValue?,vitaminD: freezed == vitaminD ? _self.vitaminD : vitaminD // ignore: cast_nullable_to_non_nullable
as NutritionValue?,calcium: freezed == calcium ? _self.calcium : calcium // ignore: cast_nullable_to_non_nullable
as NutritionValue?,iron: freezed == iron ? _self.iron : iron // ignore: cast_nullable_to_non_nullable
as NutritionValue?,potassium: freezed == potassium ? _self.potassium : potassium // ignore: cast_nullable_to_non_nullable
as NutritionValue?,additionalNutrients: freezed == additionalNutrients ? _self.additionalNutrients : additionalNutrients // ignore: cast_nullable_to_non_nullable
as Map<String, NutritionValue>?,
  ));
}
/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get totalFat {
    if (_self.totalFat == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.totalFat!, (value) {
    return _then(_self.copyWith(totalFat: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get saturatedFat {
    if (_self.saturatedFat == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.saturatedFat!, (value) {
    return _then(_self.copyWith(saturatedFat: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get transFat {
    if (_self.transFat == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.transFat!, (value) {
    return _then(_self.copyWith(transFat: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get cholesterol {
    if (_self.cholesterol == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.cholesterol!, (value) {
    return _then(_self.copyWith(cholesterol: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get sodium {
    if (_self.sodium == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.sodium!, (value) {
    return _then(_self.copyWith(sodium: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get totalCarbohydrates {
    if (_self.totalCarbohydrates == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.totalCarbohydrates!, (value) {
    return _then(_self.copyWith(totalCarbohydrates: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get dietaryFiber {
    if (_self.dietaryFiber == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.dietaryFiber!, (value) {
    return _then(_self.copyWith(dietaryFiber: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get totalSugars {
    if (_self.totalSugars == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.totalSugars!, (value) {
    return _then(_self.copyWith(totalSugars: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get addedSugars {
    if (_self.addedSugars == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.addedSugars!, (value) {
    return _then(_self.copyWith(addedSugars: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get protein {
    if (_self.protein == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.protein!, (value) {
    return _then(_self.copyWith(protein: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get vitaminD {
    if (_self.vitaminD == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.vitaminD!, (value) {
    return _then(_self.copyWith(vitaminD: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get calcium {
    if (_self.calcium == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.calcium!, (value) {
    return _then(_self.copyWith(calcium: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get iron {
    if (_self.iron == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.iron!, (value) {
    return _then(_self.copyWith(iron: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get potassium {
    if (_self.potassium == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.potassium!, (value) {
    return _then(_self.copyWith(potassium: value));
  });
}
}


/// Adds pattern-matching-related methods to [NutritionInfo].
extension NutritionInfoPatterns on NutritionInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NutritionInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NutritionInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NutritionInfo value)  $default,){
final _that = this;
switch (_that) {
case _NutritionInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NutritionInfo value)?  $default,){
final _that = this;
switch (_that) {
case _NutritionInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? servingSize,  int? servingsPerContainer,  int? calories,  NutritionValue? totalFat,  NutritionValue? saturatedFat,  NutritionValue? transFat,  NutritionValue? cholesterol,  NutritionValue? sodium,  NutritionValue? totalCarbohydrates,  NutritionValue? dietaryFiber,  NutritionValue? totalSugars,  NutritionValue? addedSugars,  NutritionValue? protein,  NutritionValue? vitaminD,  NutritionValue? calcium,  NutritionValue? iron,  NutritionValue? potassium,  Map<String, NutritionValue>? additionalNutrients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NutritionInfo() when $default != null:
return $default(_that.servingSize,_that.servingsPerContainer,_that.calories,_that.totalFat,_that.saturatedFat,_that.transFat,_that.cholesterol,_that.sodium,_that.totalCarbohydrates,_that.dietaryFiber,_that.totalSugars,_that.addedSugars,_that.protein,_that.vitaminD,_that.calcium,_that.iron,_that.potassium,_that.additionalNutrients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? servingSize,  int? servingsPerContainer,  int? calories,  NutritionValue? totalFat,  NutritionValue? saturatedFat,  NutritionValue? transFat,  NutritionValue? cholesterol,  NutritionValue? sodium,  NutritionValue? totalCarbohydrates,  NutritionValue? dietaryFiber,  NutritionValue? totalSugars,  NutritionValue? addedSugars,  NutritionValue? protein,  NutritionValue? vitaminD,  NutritionValue? calcium,  NutritionValue? iron,  NutritionValue? potassium,  Map<String, NutritionValue>? additionalNutrients)  $default,) {final _that = this;
switch (_that) {
case _NutritionInfo():
return $default(_that.servingSize,_that.servingsPerContainer,_that.calories,_that.totalFat,_that.saturatedFat,_that.transFat,_that.cholesterol,_that.sodium,_that.totalCarbohydrates,_that.dietaryFiber,_that.totalSugars,_that.addedSugars,_that.protein,_that.vitaminD,_that.calcium,_that.iron,_that.potassium,_that.additionalNutrients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? servingSize,  int? servingsPerContainer,  int? calories,  NutritionValue? totalFat,  NutritionValue? saturatedFat,  NutritionValue? transFat,  NutritionValue? cholesterol,  NutritionValue? sodium,  NutritionValue? totalCarbohydrates,  NutritionValue? dietaryFiber,  NutritionValue? totalSugars,  NutritionValue? addedSugars,  NutritionValue? protein,  NutritionValue? vitaminD,  NutritionValue? calcium,  NutritionValue? iron,  NutritionValue? potassium,  Map<String, NutritionValue>? additionalNutrients)?  $default,) {final _that = this;
switch (_that) {
case _NutritionInfo() when $default != null:
return $default(_that.servingSize,_that.servingsPerContainer,_that.calories,_that.totalFat,_that.saturatedFat,_that.transFat,_that.cholesterol,_that.sodium,_that.totalCarbohydrates,_that.dietaryFiber,_that.totalSugars,_that.addedSugars,_that.protein,_that.vitaminD,_that.calcium,_that.iron,_that.potassium,_that.additionalNutrients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NutritionInfo implements NutritionInfo {
  const _NutritionInfo({this.servingSize, this.servingsPerContainer, this.calories, this.totalFat, this.saturatedFat, this.transFat, this.cholesterol, this.sodium, this.totalCarbohydrates, this.dietaryFiber, this.totalSugars, this.addedSugars, this.protein, this.vitaminD, this.calcium, this.iron, this.potassium, final  Map<String, NutritionValue>? additionalNutrients}): _additionalNutrients = additionalNutrients;
  factory _NutritionInfo.fromJson(Map<String, dynamic> json) => _$NutritionInfoFromJson(json);

@override final  String? servingSize;
@override final  int? servingsPerContainer;
@override final  int? calories;
@override final  NutritionValue? totalFat;
@override final  NutritionValue? saturatedFat;
@override final  NutritionValue? transFat;
@override final  NutritionValue? cholesterol;
@override final  NutritionValue? sodium;
@override final  NutritionValue? totalCarbohydrates;
@override final  NutritionValue? dietaryFiber;
@override final  NutritionValue? totalSugars;
@override final  NutritionValue? addedSugars;
@override final  NutritionValue? protein;
@override final  NutritionValue? vitaminD;
@override final  NutritionValue? calcium;
@override final  NutritionValue? iron;
@override final  NutritionValue? potassium;
 final  Map<String, NutritionValue>? _additionalNutrients;
@override Map<String, NutritionValue>? get additionalNutrients {
  final value = _additionalNutrients;
  if (value == null) return null;
  if (_additionalNutrients is EqualUnmodifiableMapView) return _additionalNutrients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NutritionInfoCopyWith<_NutritionInfo> get copyWith => __$NutritionInfoCopyWithImpl<_NutritionInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NutritionInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NutritionInfo&&(identical(other.servingSize, servingSize) || other.servingSize == servingSize)&&(identical(other.servingsPerContainer, servingsPerContainer) || other.servingsPerContainer == servingsPerContainer)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.totalFat, totalFat) || other.totalFat == totalFat)&&(identical(other.saturatedFat, saturatedFat) || other.saturatedFat == saturatedFat)&&(identical(other.transFat, transFat) || other.transFat == transFat)&&(identical(other.cholesterol, cholesterol) || other.cholesterol == cholesterol)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.totalCarbohydrates, totalCarbohydrates) || other.totalCarbohydrates == totalCarbohydrates)&&(identical(other.dietaryFiber, dietaryFiber) || other.dietaryFiber == dietaryFiber)&&(identical(other.totalSugars, totalSugars) || other.totalSugars == totalSugars)&&(identical(other.addedSugars, addedSugars) || other.addedSugars == addedSugars)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.vitaminD, vitaminD) || other.vitaminD == vitaminD)&&(identical(other.calcium, calcium) || other.calcium == calcium)&&(identical(other.iron, iron) || other.iron == iron)&&(identical(other.potassium, potassium) || other.potassium == potassium)&&const DeepCollectionEquality().equals(other._additionalNutrients, _additionalNutrients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,servingSize,servingsPerContainer,calories,totalFat,saturatedFat,transFat,cholesterol,sodium,totalCarbohydrates,dietaryFiber,totalSugars,addedSugars,protein,vitaminD,calcium,iron,potassium,const DeepCollectionEquality().hash(_additionalNutrients));

@override
String toString() {
  return 'NutritionInfo(servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, calories: $calories, totalFat: $totalFat, saturatedFat: $saturatedFat, transFat: $transFat, cholesterol: $cholesterol, sodium: $sodium, totalCarbohydrates: $totalCarbohydrates, dietaryFiber: $dietaryFiber, totalSugars: $totalSugars, addedSugars: $addedSugars, protein: $protein, vitaminD: $vitaminD, calcium: $calcium, iron: $iron, potassium: $potassium, additionalNutrients: $additionalNutrients)';
}


}

/// @nodoc
abstract mixin class _$NutritionInfoCopyWith<$Res> implements $NutritionInfoCopyWith<$Res> {
  factory _$NutritionInfoCopyWith(_NutritionInfo value, $Res Function(_NutritionInfo) _then) = __$NutritionInfoCopyWithImpl;
@override @useResult
$Res call({
 String? servingSize, int? servingsPerContainer, int? calories, NutritionValue? totalFat, NutritionValue? saturatedFat, NutritionValue? transFat, NutritionValue? cholesterol, NutritionValue? sodium, NutritionValue? totalCarbohydrates, NutritionValue? dietaryFiber, NutritionValue? totalSugars, NutritionValue? addedSugars, NutritionValue? protein, NutritionValue? vitaminD, NutritionValue? calcium, NutritionValue? iron, NutritionValue? potassium, Map<String, NutritionValue>? additionalNutrients
});


@override $NutritionValueCopyWith<$Res>? get totalFat;@override $NutritionValueCopyWith<$Res>? get saturatedFat;@override $NutritionValueCopyWith<$Res>? get transFat;@override $NutritionValueCopyWith<$Res>? get cholesterol;@override $NutritionValueCopyWith<$Res>? get sodium;@override $NutritionValueCopyWith<$Res>? get totalCarbohydrates;@override $NutritionValueCopyWith<$Res>? get dietaryFiber;@override $NutritionValueCopyWith<$Res>? get totalSugars;@override $NutritionValueCopyWith<$Res>? get addedSugars;@override $NutritionValueCopyWith<$Res>? get protein;@override $NutritionValueCopyWith<$Res>? get vitaminD;@override $NutritionValueCopyWith<$Res>? get calcium;@override $NutritionValueCopyWith<$Res>? get iron;@override $NutritionValueCopyWith<$Res>? get potassium;

}
/// @nodoc
class __$NutritionInfoCopyWithImpl<$Res>
    implements _$NutritionInfoCopyWith<$Res> {
  __$NutritionInfoCopyWithImpl(this._self, this._then);

  final _NutritionInfo _self;
  final $Res Function(_NutritionInfo) _then;

/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? servingSize = freezed,Object? servingsPerContainer = freezed,Object? calories = freezed,Object? totalFat = freezed,Object? saturatedFat = freezed,Object? transFat = freezed,Object? cholesterol = freezed,Object? sodium = freezed,Object? totalCarbohydrates = freezed,Object? dietaryFiber = freezed,Object? totalSugars = freezed,Object? addedSugars = freezed,Object? protein = freezed,Object? vitaminD = freezed,Object? calcium = freezed,Object? iron = freezed,Object? potassium = freezed,Object? additionalNutrients = freezed,}) {
  return _then(_NutritionInfo(
servingSize: freezed == servingSize ? _self.servingSize : servingSize // ignore: cast_nullable_to_non_nullable
as String?,servingsPerContainer: freezed == servingsPerContainer ? _self.servingsPerContainer : servingsPerContainer // ignore: cast_nullable_to_non_nullable
as int?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,totalFat: freezed == totalFat ? _self.totalFat : totalFat // ignore: cast_nullable_to_non_nullable
as NutritionValue?,saturatedFat: freezed == saturatedFat ? _self.saturatedFat : saturatedFat // ignore: cast_nullable_to_non_nullable
as NutritionValue?,transFat: freezed == transFat ? _self.transFat : transFat // ignore: cast_nullable_to_non_nullable
as NutritionValue?,cholesterol: freezed == cholesterol ? _self.cholesterol : cholesterol // ignore: cast_nullable_to_non_nullable
as NutritionValue?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as NutritionValue?,totalCarbohydrates: freezed == totalCarbohydrates ? _self.totalCarbohydrates : totalCarbohydrates // ignore: cast_nullable_to_non_nullable
as NutritionValue?,dietaryFiber: freezed == dietaryFiber ? _self.dietaryFiber : dietaryFiber // ignore: cast_nullable_to_non_nullable
as NutritionValue?,totalSugars: freezed == totalSugars ? _self.totalSugars : totalSugars // ignore: cast_nullable_to_non_nullable
as NutritionValue?,addedSugars: freezed == addedSugars ? _self.addedSugars : addedSugars // ignore: cast_nullable_to_non_nullable
as NutritionValue?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as NutritionValue?,vitaminD: freezed == vitaminD ? _self.vitaminD : vitaminD // ignore: cast_nullable_to_non_nullable
as NutritionValue?,calcium: freezed == calcium ? _self.calcium : calcium // ignore: cast_nullable_to_non_nullable
as NutritionValue?,iron: freezed == iron ? _self.iron : iron // ignore: cast_nullable_to_non_nullable
as NutritionValue?,potassium: freezed == potassium ? _self.potassium : potassium // ignore: cast_nullable_to_non_nullable
as NutritionValue?,additionalNutrients: freezed == additionalNutrients ? _self._additionalNutrients : additionalNutrients // ignore: cast_nullable_to_non_nullable
as Map<String, NutritionValue>?,
  ));
}

/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get totalFat {
    if (_self.totalFat == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.totalFat!, (value) {
    return _then(_self.copyWith(totalFat: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get saturatedFat {
    if (_self.saturatedFat == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.saturatedFat!, (value) {
    return _then(_self.copyWith(saturatedFat: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get transFat {
    if (_self.transFat == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.transFat!, (value) {
    return _then(_self.copyWith(transFat: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get cholesterol {
    if (_self.cholesterol == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.cholesterol!, (value) {
    return _then(_self.copyWith(cholesterol: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get sodium {
    if (_self.sodium == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.sodium!, (value) {
    return _then(_self.copyWith(sodium: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get totalCarbohydrates {
    if (_self.totalCarbohydrates == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.totalCarbohydrates!, (value) {
    return _then(_self.copyWith(totalCarbohydrates: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get dietaryFiber {
    if (_self.dietaryFiber == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.dietaryFiber!, (value) {
    return _then(_self.copyWith(dietaryFiber: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get totalSugars {
    if (_self.totalSugars == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.totalSugars!, (value) {
    return _then(_self.copyWith(totalSugars: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get addedSugars {
    if (_self.addedSugars == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.addedSugars!, (value) {
    return _then(_self.copyWith(addedSugars: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get protein {
    if (_self.protein == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.protein!, (value) {
    return _then(_self.copyWith(protein: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get vitaminD {
    if (_self.vitaminD == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.vitaminD!, (value) {
    return _then(_self.copyWith(vitaminD: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get calcium {
    if (_self.calcium == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.calcium!, (value) {
    return _then(_self.copyWith(calcium: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get iron {
    if (_self.iron == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.iron!, (value) {
    return _then(_self.copyWith(iron: value));
  });
}/// Create a copy of NutritionInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionValueCopyWith<$Res>? get potassium {
    if (_self.potassium == null) {
    return null;
  }

  return $NutritionValueCopyWith<$Res>(_self.potassium!, (value) {
    return _then(_self.copyWith(potassium: value));
  });
}
}

// dart format on
