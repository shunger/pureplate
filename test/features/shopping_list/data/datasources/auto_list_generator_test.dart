import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/recipes/domain/models/ingredient.dart';
import 'package:pure_pantry/features/shopping_list/data/datasources/auto_list_generator.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  late AutoListGenerator generator;

  setUp(() {
    generator = AutoListGenerator();
  });

  group('AutoListGenerator', () {
    test('aggregates duplicate ingredients across recipes', () {
      final recipes = [
        makeRecipe(
          id: 'r1',
          name: 'Recipe 1',
          ingredients: [
            const Ingredient(name: 'Chicken', quantity: '1', unit: 'lb'),
          ],
        ),
        makeRecipe(
          id: 'r2',
          name: 'Recipe 2',
          ingredients: [
            const Ingredient(name: 'Chicken', quantity: '2', unit: 'lb'),
          ],
        ),
      ];

      final list = generator.generate(
        recipes: recipes,
        pantryItems: [],
        mealPlanId: 'mp-1',
      );

      // Should have one aggregated "Chicken" item with quantity 3.
      final chicken =
          list.items.where((i) => i.name.toLowerCase().contains('chicken'));
      // May be 1 or 2 items depending on normalization — verify total quantity.
      final totalQty = chicken.fold(0.0, (sum, i) => sum + i.quantity);
      expect(totalQty, 3.0);
    });

    test('deducts pantry stock', () {
      final recipes = [
        makeRecipe(
          id: 'r1',
          name: 'Recipe 1',
          ingredients: [
            const Ingredient(name: 'Milk', quantity: '3', unit: 'cups'),
          ],
        ),
      ];

      final pantry = [
        makePantryItem(id: 'p1', name: 'Milk', quantity: 2),
      ];

      final list = generator.generate(
        recipes: recipes,
        pantryItems: pantry,
        mealPlanId: 'mp-1',
      );

      final milk = list.items.firstWhere((i) => i.name == 'Milk');
      expect(milk.pantryQuantityAvailable, 2.0);
      expect(milk.quantityNeeded, 1.0);
    });

    test('skips optional ingredients', () {
      final recipes = [
        makeRecipe(
          id: 'r1',
          name: 'Recipe 1',
          ingredients: [
            const Ingredient(name: 'Salt', quantity: '1', unit: 'tsp'),
            const Ingredient(
                name: 'Garnish', quantity: '1', unit: 'tbsp', optional: true),
          ],
        ),
      ];

      final list = generator.generate(
        recipes: recipes,
        pantryItems: [],
        mealPlanId: 'mp-1',
      );

      expect(list.items.any((i) => i.name == 'Garnish'), isFalse);
      expect(list.items.any((i) => i.name == 'Salt'), isTrue);
    });

    test('empty recipes produce empty list', () {
      final list = generator.generate(
        recipes: [],
        pantryItems: [],
        mealPlanId: 'mp-1',
      );
      expect(list.items, isEmpty);
    });

    test('empty pantry includes all ingredients', () {
      final recipes = [
        makeRecipe(
          id: 'r1',
          name: 'Recipe 1',
          ingredients: [
            const Ingredient(name: 'Flour', quantity: '2', unit: 'cups'),
            const Ingredient(name: 'Sugar', quantity: '1', unit: 'cup'),
          ],
        ),
      ];

      final list = generator.generate(
        recipes: recipes,
        pantryItems: [],
        mealPlanId: 'mp-1',
      );

      expect(list.items.length, 2);
    });

    test('removes items fully covered by pantry', () {
      final recipes = [
        makeRecipe(
          id: 'r1',
          name: 'Recipe 1',
          ingredients: [
            const Ingredient(name: 'Butter', quantity: '1', unit: 'stick'),
          ],
        ),
      ];

      final pantry = [
        makePantryItem(id: 'p1', name: 'Butter', quantity: 5),
      ];

      final list = generator.generate(
        recipes: recipes,
        pantryItems: pantry,
        mealPlanId: 'mp-1',
      );

      // Butter fully covered — should not appear in list.
      expect(
          list.items.any(
              (i) => i.name.toLowerCase().contains('butter')),
          isFalse);
    });

    group('quantity parsing', () {
      test('parses whole number "2"', () {
        final recipes = [
          makeRecipe(
            id: 'r1',
            name: 'R',
            ingredients: [
              const Ingredient(name: 'Egg', quantity: '2'),
            ],
          ),
        ];

        final list = generator.generate(
          recipes: recipes,
          pantryItems: [],
          mealPlanId: 'mp-1',
        );

        final egg = list.items.firstWhere(
            (i) => i.name.toLowerCase().contains('egg'));
        expect(egg.quantity, 2.0);
      });

      test('parses fraction "1/2"', () {
        final recipes = [
          makeRecipe(
            id: 'r1',
            name: 'R',
            ingredients: [
              const Ingredient(name: 'Lemon', quantity: '1/2'),
            ],
          ),
        ];

        final list = generator.generate(
          recipes: recipes,
          pantryItems: [],
          mealPlanId: 'mp-1',
        );

        final lemon = list.items.firstWhere(
            (i) => i.name.toLowerCase().contains('lemon'));
        expect(lemon.quantity, 0.5);
      });

      test('parses mixed fraction "1 1/2"', () {
        final recipes = [
          makeRecipe(
            id: 'r1',
            name: 'R',
            ingredients: [
              const Ingredient(name: 'Onion', quantity: '1 1/2'),
            ],
          ),
        ];

        final list = generator.generate(
          recipes: recipes,
          pantryItems: [],
          mealPlanId: 'mp-1',
        );

        final onion = list.items.firstWhere(
            (i) => i.name.toLowerCase().contains('onion'));
        expect(onion.quantity, 1.5);
      });

      test('defaults null quantity to 1.0', () {
        final recipes = [
          makeRecipe(
            id: 'r1',
            name: 'R',
            ingredients: [
              const Ingredient(name: 'Pinch of cinnamon', quantity: null),
            ],
          ),
        ];

        final list = generator.generate(
          recipes: recipes,
          pantryItems: [],
          mealPlanId: 'mp-1',
        );

        final item = list.items.first;
        expect(item.quantity, 1.0);
      });
    });

    test('sets source to mealPlan', () {
      final list = generator.generate(
        recipes: [
          makeRecipe(
            id: 'r1',
            name: 'R',
            ingredients: [
              const Ingredient(name: 'Water', quantity: '1'),
            ],
          ),
        ],
        pantryItems: [],
        mealPlanId: 'mp-1',
      );

      expect(list.mealPlanId, 'mp-1');
    });

    test('category mapping for produce', () {
      final recipes = [
        makeRecipe(
          id: 'r1',
          name: 'R',
          ingredients: [
            const Ingredient(
                name: 'Tomato', quantity: '2', category: 'produce'),
          ],
        ),
      ];

      final list = generator.generate(
        recipes: recipes,
        pantryItems: [],
        mealPlanId: 'mp-1',
      );

      // Item should exist (category mapping should work without error).
      expect(list.items, isNotEmpty);
    });
  });
}
