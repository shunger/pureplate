import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/sharing/data/mappers/firestore_vocab.dart';
import 'package:pure_pantry/shared/models/product_category.dart';

void main() {
  group('FirestoreVocab categories', () {
    test('every Pure Pantry category survives a round trip', () {
      for (final category in ProductCategory.values) {
        final encoded = FirestoreVocab.encodeCategory(category.name);
        expect(FirestoreVocab.decodeCategory(encoded), category.name,
            reason: '${category.name} → $encoded');
      }
    });

    test('names with a one-to-one scanner equivalent need no detail', () {
      expect(FirestoreVocab.encodeCategory('produce'),
          {'category': 'produce', 'categoryDetail': null});
      expect(FirestoreVocab.encodeCategory('spices'),
          {'category': 'spicesAndHerbs', 'categoryDetail': null});
      expect(FirestoreVocab.encodeCategory('healthBeauty'),
          {'category': 'health', 'categoryDetail': null});
      // The scanner's `pantry` decodes to pantryStaple by default.
      expect(FirestoreVocab.encodeCategory('pantryStaple'),
          {'category': 'pantry', 'categoryDetail': null});
    });

    test('names the scanner lumps together are sent with detail', () {
      for (final name in ['canned', 'condiments']) {
        expect(FirestoreVocab.encodeCategory(name),
            {'category': 'pantry', 'categoryDetail': name});
      }
    });

    test('a scanner user changing the category wins over a stale detail', () {
      expect(
        FirestoreVocab.decodeCategory(
            {'category': 'snacks', 'categoryDetail': 'condiments'}),
        'snacks',
      );
    });

    test('scanner-only and unknown categories map sensibly', () {
      expect(FirestoreVocab.decodeCategory({'category': 'seafood'}), 'meat');
      expect(FirestoreVocab.decodeCategory({'category': 'pantry'}),
          'pantryStaple');
      expect(FirestoreVocab.decodeCategory({'category': 'bogus'}), 'other');
      expect(FirestoreVocab.decodeCategory({}), 'other');
    });

    test('Pure Pantry names written by older builds are kept', () {
      expect(FirestoreVocab.decodeCategory({'category': 'condiments'}),
          'condiments');
    });
  });

  group('FirestoreVocab locations', () {
    test('spices travels as pantry with detail and comes back', () {
      final encoded = FirestoreVocab.encodeLocation('spices');
      expect(encoded, {'location': 'pantry', 'locationDetail': 'spices'});
      expect(FirestoreVocab.decodeLocation(encoded), 'spices');
    });

    test('scanner locations pass through; missing defaults to pantry', () {
      expect(FirestoreVocab.decodeLocation({'location': 'freezer'}), 'freezer');
      expect(FirestoreVocab.decodeLocation({'location': null}), 'pantry');
    });
  });

  group('FirestoreVocab units', () {
    test('Pure Pantry units map to scanner units and back', () {
      expect(FirestoreVocab.encodeUnit('lbs'),
          {'unitType': 'pound', 'unitTypeDetail': null});
      expect(FirestoreVocab.decodeUnit({'unitType': 'pound'}), 'lbs');
      expect(FirestoreVocab.decodeUnit({'unitType': 'package'}), 'packs');
    });

    test('units the scanner lacks travel as each with detail', () {
      for (final unit in ['L', 'mL', 'cups', 'count']) {
        final encoded = FirestoreVocab.encodeUnit(unit);
        expect(encoded['unitType'], 'each', reason: unit);
        expect(FirestoreVocab.decodeUnit(encoded), unit);
      }
    });

    test('scanner-only units are kept verbatim', () {
      expect(FirestoreVocab.encodeUnit('bunch'),
          {'unitType': 'bunch', 'unitTypeDetail': null});
      expect(FirestoreVocab.decodeUnit({'unitType': 'bottle'}), 'bottle');
    });
  });
}
