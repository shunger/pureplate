// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstructionStep _$InstructionStepFromJson(Map<String, dynamic> json) =>
    _InstructionStep(
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      timeMinutes: (json['timeMinutes'] as num?)?.toInt(),
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$InstructionStepToJson(_InstructionStep instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'timeMinutes': instance.timeMinutes,
      'tip': instance.tip,
    };
