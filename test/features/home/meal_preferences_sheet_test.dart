import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/home/presentation/widgets/meal_preferences_sheet.dart';

void main() {
  group('MealPreferences query param', () {
    test('round-trips every field including free text', () {
      const prefs = MealPreferences(
        cuisine: 'Thai | Lao',
        effort: 'Quick & easy',
        vibe: 'comfort food',
        pantryOnly: true,
        ingredients: 'chicken, rice',
        notes: 'feeds 6',
      );
      final back = MealPreferences.fromQueryParam(prefs.toQueryParam());
      expect(back.cuisine, 'Thai | Lao');
      expect(back.effort, 'Quick & easy');
      expect(back.vibe, 'comfort food');
      expect(back.pantryOnly, isTrue);
      expect(back.ingredients, 'chicken, rice');
      expect(back.notes, 'feeds 6');
      expect(back.isEmpty, isFalse);
    });

    test('decodes a legacy five-part param without ingredients', () {
      final back = MealPreferences.fromQueryParam('Italian||Healthy||');
      expect(back.cuisine, 'Italian');
      expect(back.vibe, 'Healthy');
      expect(back.ingredients, isNull);
      expect(back.notes, isNull);
    });
  });

  group('showMealPreferencesSheet', () {
    // iPhone 17 logical size with its status-bar and home-indicator insets.
    const phone = Size(402, 874);
    const topInset = 59.0;
    const bottomInset = 34.0;

    MealPreferences? result;

    Future<void> openSheet(WidgetTester tester) async {
      result = null;
      tester.view.physicalSize = phone * 3;
      tester.view.devicePixelRatio = 3;
      tester.view.padding = const FakeViewPadding(
        top: topInset * 3,
        bottom: bottomInset * 3,
      );
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    result = await showMealPreferencesSheet(context, 'dinner');
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('title sits below the status bar', (tester) async {
      await openSheet(tester);
      final titleTop = tester.getTopLeft(find.text('What sounds good?')).dy;
      expect(titleTop, greaterThanOrEqualTo(topInset));
    });

    testWidgets('default layout fits without scrolling', (tester) async {
      await openSheet(tester);
      // Text fields carry their own Scrollables; pick the section list's.
      final scrollable = find
          .descendant(
            of: find.byType(SingleChildScrollView),
            matching: find.byType(Scrollable),
          )
          .first;
      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.maxScrollExtent, 0,
          reason: 'sheet content should fit on an iPhone-sized screen');
      // Every section, the ingredients field, and both buttons are visible.
      for (final label in [
        'Cuisine style',
        'Cooking effort',
        'Mood',
        'Ingredients',
        'Anything else? e.g. pasta night, feeds 6',
        'Skip',
        'Suggest something',
      ]) {
        expect(find.text(label), findsOneWidget);
        final rect = tester.getRect(find.text(label));
        expect(rect.bottom, lessThanOrEqualTo(phone.height - bottomInset),
            reason: '$label should be on screen');
      }
    });

    testWidgets('Other chips reveal a text field whose value is returned',
        (tester) async {
      await openSheet(tester);
      expect(find.text('e.g. Thai, Indian, Cajun'), findsNothing);
      await tester.tap(find.text('Other…').first);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'e.g. Thai, Indian, Cajun'), 'Thai');
      await tester.enterText(
          find.widgetWithText(TextField, 'Must include, e.g. chicken'),
          'shrimp');
      await tester.tap(find.widgetWithText(FilledButton, 'Suggest something'));
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(result!.cuisine, 'Thai');
      expect(result!.ingredients, 'shrimp');
      expect(result!.vibe, isNull);
    });
  });
}
