import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/routing/last_location.dart';

void main() {
  group('LastLocation.restorePlan', () {
    test('nothing saved goes Home', () {
      expect(LastLocation.restorePlan(null), ['/home']);
      expect(LastLocation.restorePlan('/'), ['/home']);
    });

    test('recipe detail rebuilds the browser beneath it', () {
      expect(LastLocation.restorePlan('/recipes/abc'),
          ['/home', '/recipes', '/recipes/abc']);
      expect(LastLocation.restorePlan('/recipes'), ['/home', '/recipes']);
    });

    test('recipe chat and cooking screens come back as the recipe', () {
      for (final saved in [
        '/recipes/abc/chat',
        '/cooking/abc',
        '/voice-cooking/abc',
      ]) {
        expect(LastLocation.restorePlan(saved),
            ['/home', '/recipes', '/recipes/abc'],
            reason: saved);
      }
    });

    test('tabs and their details are gone to directly', () {
      expect(LastLocation.restorePlan('/lists/42'), ['/lists/42']);
      expect(LastLocation.restorePlan('/pantry/item/7'), ['/pantry/item/7']);
      expect(LastLocation.restorePlan('/chat'), ['/chat']);
      expect(LastLocation.restorePlan('/planner/generate'), ['/planner']);
    });

    test('other screens go Home', () {
      for (final saved in ['/settings', '/premium', '/scanner', '/activity']) {
        expect(LastLocation.restorePlan(saved), ['/home'], reason: saved);
      }
    });
  });

  group('shouldStartOver', () {
    const recipe = '/recipes/r1';

    test('a short break stays put', () {
      expect(
          LastLocation.shouldStartOver(
              away: const Duration(hours: 1), leftFrom: recipe, current: recipe),
          isFalse);
    });

    test('coming back the next day goes Home', () {
      expect(
          LastLocation.shouldStartOver(
              away: const Duration(hours: 20), leftFrom: recipe, current: recipe),
          isTrue);
      expect(
          LastLocation.shouldStartOver(
              away: LastLocation.maxAge, leftFrom: '/chat', current: '/chat'),
          isTrue);
    });

    test('a link that opened the app is not overridden', () {
      expect(
          LastLocation.shouldStartOver(
              away: const Duration(days: 1),
              leftFrom: recipe,
              current: '/lists'),
          isFalse);
    });

    test('Home, the splash and onboarding are left alone', () {
      for (final place in ['/home', '/', '/onboarding/family']) {
        expect(
            LastLocation.shouldStartOver(
                away: const Duration(days: 1), leftFrom: place, current: place),
            isFalse,
            reason: place);
      }
    });
  });
}
