import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart' as db;
import 'package:pure_pantry/features/recipes/data/datasources/recipe_mapper.dart';
import 'package:pure_pantry/features/recipes/domain/models/ingredient.dart';
import 'package:pure_pantry/features/recipes/domain/models/instruction_step.dart';
import 'package:pure_pantry/features/recipes/domain/models/recipe.dart';

import '../../../../helpers/test_database.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late db.AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('RecipeMapper', () {
    group('fromDb', () {
      test('parses all fields from DB row', () async {
        final now = DateTime(2024, 1, 1);
        final ingredients = [
          const Ingredient(name: 'Flour', quantity: '2', unit: 'cups'),
        ];
        final instructions = [
          const InstructionStep(stepNumber: 1, instruction: 'Mix'),
        ];

        await database.into(database.recipes).insert(db.RecipesCompanion(
              id: const Value('r1'),
              name: const Value('Bread'),
              description: const Value('Homemade bread'),
              cuisine: const Value('American'),
              prepTimeMinutes: const Value(15),
              cookTimeMinutes: const Value(45),
              servings: const Value(8),
              difficulty: const Value('medium'),
              ingredientsJson: Value(
                  jsonEncode(ingredients.map((i) => i.toJson()).toList())),
              instructionsJson: Value(
                  jsonEncode(instructions.map((i) => i.toJson()).toList())),
              dietaryFlagsJson:
                  Value(jsonEncode(['vegetarian', 'dairy_free'])),
              source: const Value('ai_generated'),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        final row = await (database.select(database.recipes)
              ..where((r) => r.id.equals('r1')))
            .getSingle();

        final recipe = RecipeMapper.fromDb(row);

        expect(recipe.id, 'r1');
        expect(recipe.name, 'Bread');
        expect(recipe.description, 'Homemade bread');
        expect(recipe.cuisine, 'American');
        expect(recipe.prepTimeMinutes, 15);
        expect(recipe.cookTimeMinutes, 45);
        expect(recipe.servings, 8);
        expect(recipe.ingredients.length, 1);
        expect(recipe.ingredients.first.name, 'Flour');
        expect(recipe.instructions.length, 1);
        expect(recipe.isVegetarian, isTrue);
        expect(recipe.isDairyFree, isTrue);
        expect(recipe.isVegan, isFalse);
        expect(recipe.source, RecipeSource.aiGenerated);
      });

      test('empty description maps to null', () async {
        final now = DateTime(2024, 1, 1);
        await database.into(database.recipes).insert(db.RecipesCompanion(
              id: const Value('r2'),
              name: const Value('Salad'),
              description: const Value(''),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        final row = await (database.select(database.recipes)
              ..where((r) => r.id.equals('r2')))
            .getSingle();

        final recipe = RecipeMapper.fromDb(row);
        expect(recipe.description, isNull);
      });

      test('empty cuisine maps to null', () async {
        final now = DateTime(2024, 1, 1);
        await database.into(database.recipes).insert(db.RecipesCompanion(
              id: const Value('r3'),
              name: const Value('Soup'),
              cuisine: const Value(''),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        final row = await (database.select(database.recipes)
              ..where((r) => r.id.equals('r3')))
            .getSingle();

        final recipe = RecipeMapper.fromDb(row);
        expect(recipe.cuisine, isNull);
      });

      test('parses aiMetadata JSON', () async {
        final now = DateTime(2024, 1, 1);
        final metadata = {'plan_id': 'p1', 'day_index': 0};
        await database.into(database.recipes).insert(db.RecipesCompanion(
              id: const Value('r4'),
              name: const Value('Curry'),
              aiMetadataJson: Value(jsonEncode(metadata)),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        final row = await (database.select(database.recipes)
              ..where((r) => r.id.equals('r4')))
            .getSingle();

        final recipe = RecipeMapper.fromDb(row);
        expect(recipe.aiMetadata, isNotNull);
        expect(recipe.aiMetadata!['plan_id'], 'p1');
      });
    });

    group('toCompanion', () {
      test('serializes fields correctly', () {
        final recipe = makeRecipe(
          id: 'rc1',
          name: 'Test',
          prepTimeMinutes: 10,
          cookTimeMinutes: 20,
          ingredients: [
            const Ingredient(name: 'Salt', quantity: '1', unit: 'tsp'),
          ],
          instructions: [
            const InstructionStep(stepNumber: 1, instruction: 'Add salt'),
          ],
        );

        final companion = RecipeMapper.toCompanion(recipe);

        expect(companion.id.value, 'rc1');
        expect(companion.name.value, 'Test');
        expect(companion.prepTimeMinutes.value, 10);
        expect(companion.totalTimeMinutes.value, 30);

        // Verify JSON fields are valid JSON.
        expect(() => jsonDecode(companion.ingredientsJson.value), returnsNormally);
        expect(() => jsonDecode(companion.instructionsJson.value), returnsNormally);
      });

      test('serializes dietary flags', () {
        final recipe = Recipe(
          id: 'rc2',
          name: 'Vegan Bowl',
          isVegan: true,
          isGlutenFree: true,
          createdAt: DateTime(2024, 1, 1),
        );

        final companion = RecipeMapper.toCompanion(recipe);
        final flags =
            jsonDecode(companion.dietaryFlagsJson.value) as List<dynamic>;
        expect(flags, contains('vegan'));
        expect(flags, contains('gluten_free'));
        expect(flags, isNot(contains('vegetarian')));
      });
    });

    group('round-trip', () {
      test('domain to companion to DB to domain preserves fields', () async {
        final original = makeRecipe(
          id: 'rt-1',
          name: 'Round Trip Recipe',
          prepTimeMinutes: 10,
          cookTimeMinutes: 25,
          ingredients: [
            const Ingredient(name: 'Garlic', quantity: '3', unit: 'cloves'),
          ],
          instructions: [
            const InstructionStep(
                stepNumber: 1, instruction: 'Mince garlic'),
          ],
        );

        final companion = RecipeMapper.toCompanion(original);
        await database.into(database.recipes).insert(companion);

        final row = await (database.select(database.recipes)
              ..where((r) => r.id.equals('rt-1')))
            .getSingle();

        final restored = RecipeMapper.fromDb(row);
        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.prepTimeMinutes, original.prepTimeMinutes);
        expect(restored.cookTimeMinutes, original.cookTimeMinutes);
        expect(restored.ingredients.length, original.ingredients.length);
        expect(restored.ingredients.first.name,
            original.ingredients.first.name);
        expect(restored.instructions.length, original.instructions.length);
      });
    });
  });
}
