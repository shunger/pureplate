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
}
