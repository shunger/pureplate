import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/features/pantry/presentation/providers/pantry_providers.dart';

void main() {
  /// Creates a Drift PantryItem (the DB data class, not the domain model).
  PantryItem makeDriftPantryItem({
    String id = 'p1',
    String? productId,
    String name = 'Test Item',
    String category = 'other',
    double quantity = 1,
    String unitType = 'count',
    DateTime? expiresAt,
    String location = 'pantry',
    bool isStaple = false,
    int reorderThreshold = 0,
    bool isBulk = false,
  }) {
    final now = DateTime(2024, 1, 1);
    return PantryItem(
      id: id,
      productId: productId,
      name: name,
      category: category,
      quantity: quantity,
      unitType: unitType,
      expiresAt: expiresAt,
      location: location,
      isStaple: isStaple,
      reorderThreshold: reorderThreshold,
      isBulk: isBulk,
      status: 'newItem',
      createdAt: now,
      updatedAt: now,
    );
  }

  group('PantryGroup', () {
    group('totalQuantity', () {
      test('sums batch quantities', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', quantity: 2),
            makeDriftPantryItem(id: 'b', quantity: 3),
          ],
        );
        expect(group.totalQuantity, 5);
      });

      test('returns 0 for empty batches', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [],
        );
        expect(group.totalQuantity, 0);
      });
    });

    group('soonestExpiry', () {
      test('returns earliest expiry date', () {
        final earlier = DateTime(2024, 3, 1);
        final later = DateTime(2024, 6, 1);
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', expiresAt: later),
            makeDriftPantryItem(id: 'b', expiresAt: earlier),
          ],
        );
        expect(group.soonestExpiry, earlier);
      });

      test('returns null when no dates', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', expiresAt: null),
          ],
        );
        expect(group.soonestExpiry, isNull);
      });

      test('ignores null dates', () {
        final date = DateTime(2024, 6, 1);
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', expiresAt: null),
            makeDriftPantryItem(id: 'b', expiresAt: date),
          ],
        );
        expect(group.soonestExpiry, date);
      });
    });

    group('expiryStatus', () {
      test('returns expired when any batch is expired', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(
              id: 'a',
              expiresAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
            makeDriftPantryItem(
              id: 'b',
              expiresAt: DateTime.now().add(const Duration(days: 10)),
            ),
          ],
        );
        expect(group.expiryStatus, 'expired');
      });

      test('returns expiring when within 3 days', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(
              id: 'a',
              expiresAt: DateTime.now().add(const Duration(days: 2)),
            ),
          ],
        );
        expect(group.expiryStatus, 'expiring');
      });

      test('returns null when no dates', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', expiresAt: null),
          ],
        );
        expect(group.expiryStatus, isNull);
      });

      test('returns null when all fresh', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(
              id: 'a',
              expiresAt: DateTime.now().add(const Duration(days: 30)),
            ),
          ],
        );
        expect(group.expiryStatus, isNull);
      });
    });

    group('isMultiBatch', () {
      test('returns true for 2+ batches', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a'),
            makeDriftPantryItem(id: 'b'),
          ],
        );
        expect(group.isMultiBatch, isTrue);
      });

      test('returns false for single batch', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [makeDriftPantryItem(id: 'a')],
        );
        expect(group.isMultiBatch, isFalse);
      });
    });

    group('isStaple', () {
      test('returns true if any batch is staple', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', isStaple: false),
            makeDriftPantryItem(id: 'b', isStaple: true),
          ],
        );
        expect(group.isStaple, isTrue);
      });

      test('returns false if no batch is staple', () {
        final group = PantryGroup(
          productId: 'p1',
          name: 'Milk',
          batches: [
            makeDriftPantryItem(id: 'a', isStaple: false),
          ],
        );
        expect(group.isStaple, isFalse);
      });
    });
  });
}
