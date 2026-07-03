// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instruction_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstructionStep {

 int get stepNumber; String get instruction; int? get timeMinutes; String? get tip;
/// Create a copy of InstructionStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructionStepCopyWith<InstructionStep> get copyWith => _$InstructionStepCopyWithImpl<InstructionStep>(this as InstructionStep, _$identity);

  /// Serializes this InstructionStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstructionStep&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.timeMinutes, timeMinutes) || other.timeMinutes == timeMinutes)&&(identical(other.tip, tip) || other.tip == tip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,instruction,timeMinutes,tip);

@override
String toString() {
  return 'InstructionStep(stepNumber: $stepNumber, instruction: $instruction, timeMinutes: $timeMinutes, tip: $tip)';
}


}

/// @nodoc
abstract mixin class $InstructionStepCopyWith<$Res>  {
  factory $InstructionStepCopyWith(InstructionStep value, $Res Function(InstructionStep) _then) = _$InstructionStepCopyWithImpl;
@useResult
$Res call({
 int stepNumber, String instruction, int? timeMinutes, String? tip
});




}
/// @nodoc
class _$InstructionStepCopyWithImpl<$Res>
    implements $InstructionStepCopyWith<$Res> {
  _$InstructionStepCopyWithImpl(this._self, this._then);

  final InstructionStep _self;
  final $Res Function(InstructionStep) _then;

/// Create a copy of InstructionStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepNumber = null,Object? instruction = null,Object? timeMinutes = freezed,Object? tip = freezed,}) {
  return _then(_self.copyWith(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,timeMinutes: freezed == timeMinutes ? _self.timeMinutes : timeMinutes // ignore: cast_nullable_to_non_nullable
as int?,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstructionStep].
extension InstructionStepPatterns on InstructionStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstructionStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstructionStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstructionStep value)  $default,){
final _that = this;
switch (_that) {
case _InstructionStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstructionStep value)?  $default,){
final _that = this;
switch (_that) {
case _InstructionStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepNumber,  String instruction,  int? timeMinutes,  String? tip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstructionStep() when $default != null:
return $default(_that.stepNumber,_that.instruction,_that.timeMinutes,_that.tip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepNumber,  String instruction,  int? timeMinutes,  String? tip)  $default,) {final _that = this;
switch (_that) {
case _InstructionStep():
return $default(_that.stepNumber,_that.instruction,_that.timeMinutes,_that.tip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepNumber,  String instruction,  int? timeMinutes,  String? tip)?  $default,) {final _that = this;
switch (_that) {
case _InstructionStep() when $default != null:
return $default(_that.stepNumber,_that.instruction,_that.timeMinutes,_that.tip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstructionStep implements InstructionStep {
  const _InstructionStep({required this.stepNumber, required this.instruction, this.timeMinutes, this.tip});
  factory _InstructionStep.fromJson(Map<String, dynamic> json) => _$InstructionStepFromJson(json);

@override final  int stepNumber;
@override final  String instruction;
@override final  int? timeMinutes;
@override final  String? tip;

/// Create a copy of InstructionStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstructionStepCopyWith<_InstructionStep> get copyWith => __$InstructionStepCopyWithImpl<_InstructionStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstructionStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructionStep&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.timeMinutes, timeMinutes) || other.timeMinutes == timeMinutes)&&(identical(other.tip, tip) || other.tip == tip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,instruction,timeMinutes,tip);

@override
String toString() {
  return 'InstructionStep(stepNumber: $stepNumber, instruction: $instruction, timeMinutes: $timeMinutes, tip: $tip)';
}


}

/// @nodoc
abstract mixin class _$InstructionStepCopyWith<$Res> implements $InstructionStepCopyWith<$Res> {
  factory _$InstructionStepCopyWith(_InstructionStep value, $Res Function(_InstructionStep) _then) = __$InstructionStepCopyWithImpl;
@override @useResult
$Res call({
 int stepNumber, String instruction, int? timeMinutes, String? tip
});




}
/// @nodoc
class __$InstructionStepCopyWithImpl<$Res>
    implements _$InstructionStepCopyWith<$Res> {
  __$InstructionStepCopyWithImpl(this._self, this._then);

  final _InstructionStep _self;
  final $Res Function(_InstructionStep) _then;

/// Create a copy of InstructionStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepNumber = null,Object? instruction = null,Object? timeMinutes = freezed,Object? tip = freezed,}) {
  return _then(_InstructionStep(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,timeMinutes: freezed == timeMinutes ? _self.timeMinutes : timeMinutes // ignore: cast_nullable_to_non_nullable
as int?,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
