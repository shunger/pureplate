import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_fixtures.dart';

void main() {
  group('MealPlan', () {
    group('totalDays', () {
      test('returns number of days', () {
        final plan = makeMealPlan(days: [
          makeMealPlanDay(id: 'd1'),
          makeMealPlanDay(id: 'd2'),
          makeMealPlanDay(id: 'd3'),
        ]);
        expect(plan.totalDays, 3);
      });

      test('returns 0 for empty days', () {
        final plan = makeMealPlan(days: []);
        expect(plan.totalDays, 0);
      });
    });

    group('cookedCount', () {
      test('counts cooked days', () {
        final plan = makeMealPlan(days: [
          makeMealPlanDay(id: 'd1', isCooked: true),
          makeMealPlanDay(id: 'd2', isCooked: false),
          makeMealPlanDay(id: 'd3', isCooked: true),
        ]);
        expect(plan.cookedCount, 2);
      });
    });

    group('completionPercent', () {
      test('returns 0.5 when half are cooked', () {
        final plan = makeMealPlan(days: [
          makeMealPlanDay(id: 'd1', isCooked: true),
          makeMealPlanDay(id: 'd2', isCooked: false),
        ]);
        expect(plan.completionPercent, 0.5);
      });

      test('returns 0.0 when empty', () {
        final plan = makeMealPlan(days: []);
        expect(plan.completionPercent, 0);
      });

      test('returns 1.0 when all cooked', () {
        final plan = makeMealPlan(days: [
          makeMealPlanDay(id: 'd1', isCooked: true),
          makeMealPlanDay(id: 'd2', isCooked: true),
        ]);
        expect(plan.completionPercent, 1.0);
      });
    });
  });
}
