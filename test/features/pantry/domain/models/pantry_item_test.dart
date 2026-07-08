import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/pantry/domain/models/pantry_item.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  group('PantryItem', () {
    group('daysUntilExpiry', () {
      test('returns null when expiresAt is null', () {
        final item = makePantryItem(expiresAt: null);
        expect(item.daysUntilExpiry, isNull);
      });

      test('returns positive for future expiry', () {
        final item = makePantryItem(
          expiresAt: DateTime.now().add(const Duration(days: 10)),
        );
        expect(item.daysUntilExpiry, greaterThanOrEqualTo(9));
      });

      test('returns 0 for today', () {
        // expiresAt set to right now — inDays truncates towards zero
        final item = makePantryItem(expiresAt: DateTime.now());
        expect(item.daysUntilExpiry, 0);
      });

      test('returns negative for past expiry', () {
        final item = makePantryItem(
          expiresAt: DateTime.now().subtract(const Duration(days: 5)),
        );
        expect(item.daysUntilExpiry, lessThan(0));
      });
    });

    group('expiryStatus', () {
      test('returns unknown when expiresAt is null', () {
        final item = makePantryItem(expiresAt: null);
        expect(item.expiryStatus, ExpiryStatus.unknown);
      });

      test('returns expired for past expiry', () {
        final item = makePantryItem(
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(item.expiryStatus, ExpiryStatus.expired);
      });

      test('returns expiringSoon for today', () {
        final item = makePantryItem(expiresAt: DateTime.now());
        expect(item.expiryStatus, ExpiryStatus.expiringSoon);
      });

      test('returns expiringSoon for 3 days out', () {
        final item = makePantryItem(
          expiresAt: DateTime.now().add(const Duration(days: 3)),
        );
        expect(item.expiryStatus, ExpiryStatus.expiringSoon);
      });

      test('returns fresh for 5 days out', () {
        final item = makePantryItem(
          expiresAt: DateTime.now().add(const Duration(days: 5)),
        );
        expect(item.expiryStatus, ExpiryStatus.fresh);
      });
    });

    group('needsReorder', () {
      test('returns true when staple is at threshold', () {
        final item = makePantryItem(
          isStaple: true,
          quantity: 2,
          reorderThreshold: 2,
        );
        expect(item.needsReorder, isTrue);
      });

      test('returns false when staple is above threshold', () {
        final item = makePantryItem(
          isStaple: true,
          quantity: 5,
          reorderThreshold: 2,
        );
        expect(item.needsReorder, isFalse);
      });

      test('returns false when not a staple', () {
        final item = makePantryItem(
          isStaple: false,
          quantity: 0,
          reorderThreshold: 2,
        );
        expect(item.needsReorder, isFalse);
      });
    });

    group('toAiContext', () {
      test('includes name, quantity, unit, and category', () {
        final item = makePantryItem(
          name: 'Eggs',
          quantity: 12,
          unitType: 'count',
        );
        final ctx = item.toAiContext();
        expect(ctx['name'], 'Eggs');
        expect(ctx['quantity'], 12);
        expect(ctx['unit'], 'count');
        expect(ctx['category'], isNotNull);
      });

      test('includes expires_in_days when expiresAt is set', () {
        final item = makePantryItem(
          expiresAt: DateTime.now().add(const Duration(days: 5)),
        );
        final ctx = item.toAiContext();
        expect(ctx.containsKey('expires_in_days'), isTrue);
      });

      test('excludes expires_in_days when expiresAt is null', () {
        final item = makePantryItem(expiresAt: null);
        final ctx = item.toAiContext();
        expect(ctx.containsKey('expires_in_days'), isFalse);
      });

      test('includes is_staple when true', () {
        final item = makePantryItem(isStaple: true);
        final ctx = item.toAiContext();
        expect(ctx['is_staple'], isTrue);
      });

      test('excludes is_staple when false', () {
        final item = makePantryItem(isStaple: false);
        final ctx = item.toAiContext();
        expect(ctx.containsKey('is_staple'), isFalse);
      });
    });
  });
}
