import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  group('Recipe', () {
    group('totalTimeMinutes', () {
      test('sums prep and cook time', () {
        final recipe = makeRecipe(prepTimeMinutes: 15, cookTimeMinutes: 30);
        expect(recipe.totalTimeMinutes, 45);
      });

      test('returns 0 when both are 0', () {
        final recipe = makeRecipe(prepTimeMinutes: 0, cookTimeMinutes: 0);
        expect(recipe.totalTimeMinutes, 0);
      });
    });

    group('totalTimeDisplay', () {
      test('returns minutes only when under 60', () {
        final recipe = makeRecipe(prepTimeMinutes: 10, cookTimeMinutes: 20);
        expect(recipe.totalTimeDisplay, '30m');
      });

      test('returns hours only when exact multiple of 60', () {
        final recipe = makeRecipe(prepTimeMinutes: 30, cookTimeMinutes: 30);
        expect(recipe.totalTimeDisplay, '1h');
      });

      test('returns hours and minutes when over 60 with remainder', () {
        final recipe = makeRecipe(prepTimeMinutes: 30, cookTimeMinutes: 45);
        expect(recipe.totalTimeDisplay, '1h 15m');
      });

      test('returns 0m when total is zero', () {
        final recipe = makeRecipe(prepTimeMinutes: 0, cookTimeMinutes: 0);
        expect(recipe.totalTimeDisplay, '0m');
      });
    });
  });
}
