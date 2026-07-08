import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/shared/models/product_category.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  group('ShoppingListItem', () {
    group('quantityNeeded', () {
      test('returns quantity minus pantry', () {
        final item = makeShoppingListItem(
          quantity: 5,
          pantryQuantityAvailable: 2,
        );
        expect(item.quantityNeeded, 3);
      });

      test('clamps to 0 when pantry exceeds quantity', () {
        final item = makeShoppingListItem(
          quantity: 2,
          pantryQuantityAvailable: 5,
        );
        expect(item.quantityNeeded, 0);
      });

      test('returns full quantity when no pantry stock', () {
        final item = makeShoppingListItem(
          quantity: 3,
          pantryQuantityAvailable: 0,
        );
        expect(item.quantityNeeded, 3);
      });
    });
  });

  group('ShoppingList', () {
    group('totalEstimatedCost', () {
      test('sums price * quantity', () {
        final list = makeShoppingList(items: [
          makeShoppingListItem(
              id: 'i1', estimatedPrice: 3.0, quantity: 2),
          makeShoppingListItem(
              id: 'i2', estimatedPrice: 5.0, quantity: 1),
        ]);
        expect(list.totalEstimatedCost, 11.0);
      });

      test('treats null price as 0', () {
        final list = makeShoppingList(items: [
          makeShoppingListItem(id: 'i1', estimatedPrice: null, quantity: 3),
        ]);
        expect(list.totalEstimatedCost, 0.0);
      });
    });

    group('completionPercent', () {
      test('returns 0 when empty', () {
        final list = makeShoppingList(items: []);
        expect(list.completionPercent, 0);
      });

      test('returns 0.5 when half completed', () {
        final list = makeShoppingList(items: [
          makeShoppingListItem(id: 'i1', isCompleted: true),
          makeShoppingListItem(id: 'i2', isCompleted: false),
        ]);
        expect(list.completionPercent, 0.5);
      });

      test('returns 1.0 when all completed', () {
        final list = makeShoppingList(items: [
          makeShoppingListItem(id: 'i1', isCompleted: true),
          makeShoppingListItem(id: 'i2', isCompleted: true),
        ]);
        expect(list.completionPercent, 1.0);
      });
    });

    group('itemsByCategory', () {
      test('groups items by category', () {
        final list = makeShoppingList(items: [
          makeShoppingListItem(
              id: 'i1', category: ProductCategory.produce),
          makeShoppingListItem(
              id: 'i2', category: ProductCategory.dairy),
          makeShoppingListItem(
              id: 'i3', category: ProductCategory.produce),
        ]);
        final grouped = list.itemsByCategory;
        expect(grouped[ProductCategory.produce]!.length, 2);
        expect(grouped[ProductCategory.dairy]!.length, 1);
      });
    });
  });
}
