import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/recipes/data/services/voice_script_service.dart';
import 'package:pure_pantry/features/recipes/domain/models/ingredient.dart';
import 'package:pure_pantry/features/recipes/domain/models/instruction_step.dart';
import 'package:pure_pantry/features/recipes/domain/models/recipe.dart';

void main() {
  final recipe = Recipe(
    id: 'r1',
    name: 'Alfredo',
    createdAt: DateTime(2026),
    ingredients: const [
      Ingredient(name: 'heavy cream', quantity: '1', unit: 'cup'),
      Ingredient(name: 'parmesan', quantity: '1/2', unit: 'cup'),
      Ingredient(name: 'butter', quantity: '2', unit: 'tbsp'),
    ],
    instructions: const [
      InstructionStep(stepNumber: 1, instruction: 'Melt the butter in a pan.'),
      InstructionStep(
          stepNumber: 2,
          instruction: 'Pour in the cream. Stir in the parmesan until smooth.',
          tip: 'Keep the heat low'),
    ],
  );

  group('fallbackLines', () {
    test('one line per sentence, with the amounts spoken', () {
      expect(VoiceScriptService.fallbackLines(recipe, 0), [
        "Melt the butter in a pan. That's 2 tablespoons of butter.",
      ]);
      expect(VoiceScriptService.fallbackLines(recipe, 1), [
        "Pour in the cream. That's 1 cup of heavy cream.",
        "Stir in the parmesan until smooth. That's half a cup of parmesan.",
        'Quick tip: Keep the heat low',
      ]);
    });

    test("doesn't repeat amounts the step already gives", () {
      final r = recipe.copyWith(instructions: const [
        InstructionStep(stepNumber: 1, instruction: 'Add 1 cup cream.'),
      ]);
      expect(VoiceScriptService.fallbackLines(r, 0), ['Add 1 cup cream.']);
    });
  });

  group('assemble', () {
    test('uses server lines and fills missing steps locally', () {
      final lines = VoiceScriptService.assemble(recipe, {
        2: ['Add one cup of heavy cream.', '**Now** add 1/2 cup parmesan.'],
      });
      expect(lines.map((l) => (l.stepIndex, l.text)).toList(), [
        (0, "Melt the butter in a pan. That's 2 tablespoons of butter."),
        (1, 'Add one cup of heavy cream.'),
        (1, 'Now add half a cup parmesan.'),
      ]);
    });
  });
}
