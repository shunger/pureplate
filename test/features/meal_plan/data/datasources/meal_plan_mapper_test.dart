import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart' as db;
import 'package:pure_pantry/features/meal_plan/data/datasources/meal_plan_mapper.dart';
import 'package:pure_pantry/features/meal_plan/domain/models/meal_plan.dart';

import '../../../../helpers/test_database.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late db.AppDatabase database;

  setUp(() {
    database = createTestDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('MealPlanMapper', () {
    group('fromDbWithDays', () {
      test('maps all fields correctly', () async {
        final now = DateTime(2024, 1, 1);
        final start = DateTime(2024, 1, 8);
        final end = DateTime(2024, 1, 14);

        // Insert a recipe first (foreign key constraint).
        await database.into(database.recipes).insert(db.RecipesCompanion(
              id: const Value('r1'),
              name: const Value('Pasta'),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        // Insert the plan.
        await database.into(database.mealPlans).insert(db.MealPlansCompanion(
              id: const Value('plan-1'),
              createdAt: Value(now),
              startDate: Value(start),
              endDate: Value(end),
              planType: const Value('chat'),
            ));

        // Insert a day.
        await database
            .into(database.mealPlanDays)
            .insert(db.MealPlanDaysCompanion(
              id: const Value('day-1'),
              planId: const Value('plan-1'),
              date: Value(start),
              recipeId: const Value('r1'),
              recipeName: const Value('Pasta'),
              isCooked: const Value(true),
              sortOrder: const Value(0),
            ));

        final planRow = await (database.select(database.mealPlans)
              ..where((p) => p.id.equals('plan-1')))
            .getSingle();
        final dayRows = await (database.select(database.mealPlanDays)
              ..where((d) => d.planId.equals('plan-1')))
            .get();

        final plan = MealPlanMapper.fromDbWithDays(planRow, dayRows);

        expect(plan.id, 'plan-1');
        expect(plan.planType, PlanType.chat);
        expect(plan.startDate, start);
        expect(plan.endDate, end);
        expect(plan.days.length, 1);
        expect(plan.days.first.recipeName, 'Pasta');
        expect(plan.days.first.isCooked, isTrue);
      });

      test('handles empty days list', () async {
        final now = DateTime(2024, 1, 1);
        await database.into(database.mealPlans).insert(db.MealPlansCompanion(
              id: const Value('plan-2'),
              createdAt: Value(now),
              startDate: Value(now),
              endDate: Value(now),
            ));

        final planRow = await (database.select(database.mealPlans)
              ..where((p) => p.id.equals('plan-2')))
            .getSingle();

        final plan =
            MealPlanMapper.fromDbWithDays(planRow, <db.MealPlanDay>[]);
        expect(plan.days, isEmpty);
      });
    });

    group('dayFromDb', () {
      test('defaults null recipeName to empty string', () async {
        final now = DateTime(2024, 1, 1);

        await database.into(database.recipes).insert(db.RecipesCompanion(
              id: const Value('r1'),
              name: const Value('Pasta'),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        await database.into(database.mealPlans).insert(db.MealPlansCompanion(
              id: const Value('plan-1'),
              createdAt: Value(now),
              startDate: Value(now),
              endDate: Value(now),
            ));

        await database
            .into(database.mealPlanDays)
            .insert(db.MealPlanDaysCompanion(
              id: const Value('d1'),
              planId: const Value('plan-1'),
              date: Value(now),
              recipeId: const Value('r1'),
              // recipeName left as null
            ));

        final row = await (database.select(database.mealPlanDays)
              ..where((d) => d.id.equals('d1')))
            .getSingle();

        final day = MealPlanMapper.dayFromDb(row);
        expect(day.recipeName, '');
      });
    });

    group('planToCompanion', () {
      test('preserves planType', () {
        final plan = makeMealPlan(planType: PlanType.inventory);
        final companion = MealPlanMapper.planToCompanion(plan);
        expect(companion.planType.value, 'inventory');
      });

      test('quick planType maps correctly', () {
        final plan = makeMealPlan(planType: PlanType.quick);
        final companion = MealPlanMapper.planToCompanion(plan);
        expect(companion.planType.value, 'quick');
      });

      test('chat planType maps correctly', () {
        final plan = makeMealPlan(planType: PlanType.chat);
        final companion = MealPlanMapper.planToCompanion(plan);
        expect(companion.planType.value, 'chat');
      });
    });

    group('PlanType parsing', () {
      test('round-trip: domain to companion to DB to domain preserves fields',
          () async {
        final original = makeMealPlan(
          id: 'rt-1',
          planType: PlanType.chat,
          startDate: DateTime(2024, 2, 5),
          endDate: DateTime(2024, 2, 11),
        );

        final companion = MealPlanMapper.planToCompanion(original);
        await database.into(database.mealPlans).insert(companion);

        final row = await (database.select(database.mealPlans)
              ..where((p) => p.id.equals('rt-1')))
            .getSingle();

        final restored =
            MealPlanMapper.fromDbWithDays(row, <db.MealPlanDay>[]);
        expect(restored.id, original.id);
        expect(restored.planType, original.planType);
        expect(restored.startDate, original.startDate);
        expect(restored.endDate, original.endDate);
      });
    });
  });
}
