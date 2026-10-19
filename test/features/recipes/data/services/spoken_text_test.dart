import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/recipes/data/services/spoken_text.dart';
import 'package:pure_pantry/features/recipes/domain/models/ingredient.dart';

void main() {
  group('forSpeech', () {
    test('strips markdown', () {
      expect(
        SpokenText.forSpeech('**Yes!** You can:\n- use butter\n- use ghee'),
        'Yes! You can: use butter. use ghee',
      );
    });

    test('spells out measurements, temperatures, and ranges', () {
      expect(SpokenText.forSpeech('Add 2 tbsp oil and 1/2 tsp salt.'),
          'Add 2 tablespoons oil and half a teaspoon salt.');
      expect(SpokenText.forSpeech('Bake at 350°F for 25-30 min.'),
          'Bake at 350 degrees for 25 to 30 minutes.');
      expect(SpokenText.forSpeech('Stir in 1 1/2 cups broth'),
          'Stir in 1 and a half cups broth');
      expect(SpokenText.forSpeech('Use ¼ cup'), 'Use a quarter cup');
      expect(SpokenText.forSpeech('Add 1 tsp'), 'Add 1 teaspoon');
    });

    test('leaves ordinary words alone', () {
      expect(SpokenText.forSpeech('Add 2 large eggs and stir in 3 garlic cloves'),
          'Add 2 large eggs and stir in 3 garlic cloves');
      expect(SpokenText.forSpeech('salt and/or pepper'), 'salt or pepper');
    });
  });

  group('ingredient', () {
    test('reads like a person', () {
      expect(SpokenText.ingredient(const Ingredient(name: 'flour', quantity: '2', unit: 'cups')),
          '2 cups of flour');
      expect(SpokenText.ingredient(const Ingredient(name: 'olive oil', quantity: '1', unit: 'tbsp')),
          '1 tablespoon of olive oil');
      expect(SpokenText.ingredient(const Ingredient(name: 'milk', quantity: '0.5', unit: 'cup')),
          'half a cup of milk');
      expect(SpokenText.ingredient(const Ingredient(name: 'onion', quantity: '1/2')),
          'half an onion');
      expect(SpokenText.ingredient(const Ingredient(name: 'lemon', quantity: '0.25')),
          'a quarter of a lemon');
      expect(SpokenText.ingredient(const Ingredient(name: 'eggs', quantity: '3', unit: 'large')),
          '3 large eggs');
      expect(SpokenText.ingredient(const Ingredient(name: 'salt', quantity: 'to taste')),
          'salt, to taste');
      expect(SpokenText.ingredient(const Ingredient(name: 'salt', quantity: '2', unit: 'pinch')),
          '2 pinches of salt');
      expect(SpokenText.ingredient(const Ingredient(name: 'pepper')), 'pepper');
    });
  });

  test('joinNaturally', () {
    expect(SpokenText.joinNaturally(['a']), 'a');
    expect(SpokenText.joinNaturally(['a', 'b']), 'a and b');
    expect(SpokenText.joinNaturally(['a', 'b', 'c']), 'a, b, and c');
  });
}
