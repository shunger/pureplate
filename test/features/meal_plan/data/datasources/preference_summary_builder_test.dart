import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/meal_plan/data/datasources/preference_summary_builder.dart';
import 'package:pure_pantry/features/meal_plan/domain/models/family_profile.dart';
import 'package:pure_pantry/features/pantry/domain/models/pantry_item.dart';
import 'package:pure_pantry/shared/models/dietary_restriction.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  late PreferenceSummaryBuilder builder;

  setUp(() {
    builder = PreferenceSummaryBuilder();
  });

  group('PreferenceSummaryBuilder', () {
    test('family section includes adults and kids', () {
      final result = builder.build(
        profile: makeFamilyProfile(adults: 3, kids: 2),
        pantryItems: [],
      );
      final family = result['family'] as Map<String, dynamic>;
      expect(family['adults'], 3);
      expect(family['kids'], 2);
    });

    test('family section includes dietary restrictions', () {
      final result = builder.build(
        profile: makeFamilyProfile(
          dietaryRestrictions: [DietaryRestriction.vegetarian],
        ),
        pantryItems: [],
      );
      final family = result['family'] as Map<String, dynamic>;
      final restrictions = family['dietary_restrictions'] as List;
      expect(restrictions, contains('Vegetarian'));
    });

    test('family section includes cook time and budget', () {
      final result = builder.build(
        profile: makeFamilyProfile(
          preferredCookTime: PreferredCookTime.under30,
          budgetLevel: BudgetLevel.budget,
        ),
        pantryItems: [],
      );
      final family = result['family'] as Map<String, dynamic>;
      expect(family['preferred_cook_time'], 'under30');
      expect(family['budget_level'], 'budget');
    });

    test('family section includes kid age ranges when present', () {
      final result = builder.build(
        profile: makeFamilyProfile(
          kids: 1,
          kidAgeRanges: [KidAgeRange.toddler],
        ),
        pantryItems: [],
      );
      final family = result['family'] as Map<String, dynamic>;
      expect(family['kid_age_ranges'], ['1-3']);
    });

    test('limits pantry_items to 50', () {
      final items = List.generate(
        60,
        (i) => makePantryItem(id: 'p-$i', name: 'Item $i'),
      );
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: items,
      );
      final pantryItems = result['pantry_items'] as List;
      expect(pantryItems.length, 50);
    });

    test('expiring_soon filters by expiryStatus', () {
      final items = [
        makePantryItem(
          id: 'exp',
          name: 'Expiring Milk',
          expiresAt: DateTime.now().add(const Duration(days: 2)),
        ),
        makePantryItem(
          id: 'fresh',
          name: 'Fresh Eggs',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
      ];
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: items,
      );
      final expiring = result['expiring_soon'] as List;
      expect(expiring.length, 1);
      expect(expiring.first['name'], 'Expiring Milk');
    });

    test('staples_available lists staple names only', () {
      final items = [
        makePantryItem(id: 's1', name: 'Rice', isStaple: true),
        makePantryItem(id: 's2', name: 'Milk', isStaple: false),
      ];
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: items,
      );
      final staples = result['staples_available'] as List;
      expect(staples, ['Rice']);
    });

    test('merges profile and explicit dislikedIngredients', () {
      final result = builder.build(
        profile: makeFamilyProfile(dislikedIngredients: ['Cilantro']),
        pantryItems: [],
        dislikedIngredients: ['Olives'],
      );
      final disliked = result['disliked_ingredients'] as List;
      expect(disliked, containsAll(['Cilantro', 'Olives']));
    });

    test('deduplicates recent meals', () {
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: [],
        recentMeals: [
          makeMealPlanDay(id: 'm1', recipeName: 'Pasta'),
          makeMealPlanDay(id: 'm2', recipeName: 'Pasta'),
          makeMealPlanDay(id: 'm3', recipeName: 'Tacos'),
        ],
      );
      final recent = result['recent_meals_14d'] as List;
      expect(recent, hasLength(2));
      expect(recent, containsAll(['Pasta', 'Tacos']));
    });

    test('handles empty inputs gracefully', () {
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: [],
      );
      expect(result['pantry_items'], isEmpty);
      expect(result['expiring_soon'], isEmpty);
      expect(result['staples_available'], isEmpty);
      expect(result['loved_ingredients'], isEmpty);
      expect(result['disliked_ingredients'], isEmpty);
      expect(result['favorite_recipes'], isEmpty);
      expect(result['recent_meals_14d'], isEmpty);
    });

    test('includes cuisine affinities', () {
      final affinities = {'italian': 0.9, 'mexican': 0.7};
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: [],
        cuisineAffinities: affinities,
      );
      expect(result['cuisine_affinities'], affinities);
    });

    test('includes loved ingredients', () {
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: [],
        lovedIngredients: ['Garlic', 'Basil'],
      );
      expect(result['loved_ingredients'], ['Garlic', 'Basil']);
    });

    test('includes favorite recipes', () {
      final result = builder.build(
        profile: makeFamilyProfile(),
        pantryItems: [],
        favoriteRecipeNames: ['Spaghetti Bolognese'],
      );
      expect(result['favorite_recipes'], ['Spaghetti Bolognese']);
    });
  });
}
