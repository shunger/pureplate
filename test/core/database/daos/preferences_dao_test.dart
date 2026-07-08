import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/preferences_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PreferencesDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.preferencesDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('PreferencesDao', () {
    group('getPreferences', () {
      test('creates default row on first call', () async {
        final prefs = await dao.getPreferences();
        expect(prefs, isNotNull);
        expect(prefs.id, 1);
        expect(prefs.preferredCurrency, 'USD');
      });

      test('returns existing row on subsequent calls', () async {
        await dao.getPreferences(); // Create default.
        await dao.setCurrency('EUR');

        final prefs = await dao.getPreferences();
        expect(prefs.preferredCurrency, 'EUR');
      });
    });

    group('convenience setters', () {
      test('setOnboardingCompleted', () async {
        await dao.getPreferences();
        await dao.setOnboardingCompleted(true);

        final prefs = await dao.getPreferences();
        expect(prefs.onboardingCompleted, isTrue);
      });

      test('setCurrency', () async {
        await dao.getPreferences();
        await dao.setCurrency('GBP');

        final prefs = await dao.getPreferences();
        expect(prefs.preferredCurrency, 'GBP');
      });

      test('setTheme', () async {
        await dao.getPreferences();
        await dao.setTheme('dark');

        final prefs = await dao.getPreferences();
        expect(prefs.theme, 'dark');
      });

      test('setSyncEnabled', () async {
        await dao.getPreferences();
        await dao.setSyncEnabled(true);

        final prefs = await dao.getPreferences();
        expect(prefs.syncEnabled, isTrue);
      });
    });

    group('setSubscription', () {
      test('computes isPremium from future expiresAt', () async {
        await dao.getPreferences();
        await dao.setSubscription(
          subscriptionId: 'sub-1',
          plan: 'annual',
          expiresAt: DateTime.now().add(const Duration(days: 365)),
        );

        final prefs = await dao.getPreferences();
        expect(prefs.isPremium, isTrue);
        expect(prefs.subscriptionId, 'sub-1');
        expect(prefs.subscriptionPlan, 'annual');
      });

      test('computes isPremium as false when expiresAt is past', () async {
        await dao.getPreferences();
        await dao.setSubscription(
          subscriptionId: 'sub-1',
          plan: 'annual',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );

        final prefs = await dao.getPreferences();
        expect(prefs.isPremium, isFalse);
      });

      test('computes isPremium as false when expiresAt is null', () async {
        await dao.getPreferences();
        await dao.setSubscription(
          subscriptionId: null,
          plan: null,
          expiresAt: null,
        );

        final prefs = await dao.getPreferences();
        expect(prefs.isPremium, isFalse);
      });
    });

    group('incrementWeeklyPlanCount', () {
      test('increments count', () async {
        await dao.getPreferences();
        await dao.incrementWeeklyPlanCount();
        await dao.incrementWeeklyPlanCount();

        final prefs = await dao.getPreferences();
        expect(prefs.weeklyPlanCount, 2);
      });

      test('resets count past reset date', () async {
        await dao.getPreferences();
        // Set reset date in the past.
        await dao.updatePreferences(UserPreferencesTableCompanion(
          weeklyPlanCount: const Value(5),
          weeklyPlanResetDate: Value(
              DateTime.now().subtract(const Duration(days: 1))),
        ));

        await dao.incrementWeeklyPlanCount();

        final prefs = await dao.getPreferences();
        expect(prefs.weeklyPlanCount, 1);
      });
    });

    group('dismissHint', () {
      test('adds hint to JSON array', () async {
        await dao.getPreferences();
        await dao.dismissHint('welcome_tip');

        final prefs = await dao.getPreferences();
        expect(prefs.dismissedHintsJson, contains('welcome_tip'));
      });

      test('does not add duplicate hint', () async {
        await dao.getPreferences();
        await dao.dismissHint('welcome_tip');
        await dao.dismissHint('welcome_tip');

        final prefs = await dao.getPreferences();
        // Should only contain one instance.
        final count = 'welcome_tip'
            .allMatches(prefs.dismissedHintsJson)
            .length;
        expect(count, 1);
      });

      test('adds multiple different hints', () async {
        await dao.getPreferences();
        await dao.dismissHint('tip1');
        await dao.dismissHint('tip2');

        final prefs = await dao.getPreferences();
        expect(prefs.dismissedHintsJson, contains('tip1'));
        expect(prefs.dismissedHintsJson, contains('tip2'));
      });
    });
  });
}
