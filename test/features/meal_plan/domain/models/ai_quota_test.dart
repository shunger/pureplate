import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/meal_plan/domain/models/ai_quota.dart';

void main() {
  group('AiQuotaStatus', () {
    final resetAt = DateTime.now().add(const Duration(days: 3));

    Map<String, dynamic> payload({
      bool unlimited = false,
      int used = 1,
      int limit = 2,
      int remaining = 1,
      int? trialEndsAt,
    }) =>
        {
          'unlimited': unlimited,
          'used': used,
          'limit': limit,
          'remaining': remaining,
          'resetAt': resetAt.millisecondsSinceEpoch,
          'trialEndsAt': trialEndsAt,
        };

    test('parses a backend payload', () {
      final quota = AiQuotaStatus.fromJson(payload())!;

      expect(quota.unlimited, isFalse);
      expect(quota.used, 1);
      expect(quota.limit, 2);
      expect(quota.remaining, 1);
      expect(quota.resetAt.millisecondsSinceEpoch,
          resetAt.millisecondsSinceEpoch);
      expect(quota.trialEndsAt, isNull);
    });

    test('returns null when the backend reported no quota', () {
      expect(AiQuotaStatus.fromJson(null), isNull);
    });

    test('returns null without a reset time, which it cannot age out', () {
      expect(AiQuotaStatus.fromJson({'used': 1, 'limit': 2}), isNull);
    });

    test('parses the trial end date', () {
      final trialEnd = DateTime.now().add(const Duration(days: 9));
      final quota = AiQuotaStatus.fromJson(
        payload(unlimited: true, trialEndsAt: trialEnd.millisecondsSinceEpoch),
      )!;

      expect(quota.unlimited, isTrue);
      expect(quota.trialEndsAt!.millisecondsSinceEpoch,
          trialEnd.millisecondsSinceEpoch);
    });

    test('is not stale inside the current week', () {
      expect(AiQuotaStatus.fromJson(payload())!.isStale, isFalse);
    });

    test('is stale once the week it describes has ended', () {
      final past = DateTime.now().subtract(const Duration(days: 1));
      final quota = AiQuotaStatus.fromJson({
        ...payload(),
        'resetAt': past.millisecondsSinceEpoch,
      })!;

      expect(quota.isStale, isTrue);
    });

    test('survives an encode/decode round trip', () {
      final original = AiQuotaStatus.fromJson(payload(
        unlimited: true,
        used: 4,
        remaining: -1,
        trialEndsAt: resetAt.millisecondsSinceEpoch,
      ))!;

      final restored = AiQuotaStatus.decode(original.encode())!;

      expect(restored.unlimited, original.unlimited);
      expect(restored.used, original.used);
      expect(restored.limit, original.limit);
      expect(restored.remaining, original.remaining);
      expect(restored.resetAt, original.resetAt);
      expect(restored.trialEndsAt, original.trialEndsAt);
    });

    test('decodes malformed cache entries to null instead of throwing', () {
      expect(AiQuotaStatus.decode('not json'), isNull);
      expect(AiQuotaStatus.decode(null), isNull);
    });
  });
}
