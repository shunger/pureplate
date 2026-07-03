import 'package:freezed_annotation/freezed_annotation.dart';

part 'instruction_step.freezed.dart';
part 'instruction_step.g.dart';

@freezed
abstract class InstructionStep with _$InstructionStep {
  const factory InstructionStep({
    required int stepNumber,
    required String instruction,
    int? timeMinutes,
    String? tip,
  }) = _InstructionStep;

  factory InstructionStep.fromJson(Map<String, dynamic> json) =>
      _$InstructionStepFromJson(json);
}
