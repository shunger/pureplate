import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/meal_plan_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late MealPlanDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.mealPlanDao;
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> _insertRecipe(String id) async {
    final now = DateTime.now();
    await db.into(db.recipes).insert(RecipesCompanion(
          id: Value(id),
          name: Value('Recipe $id'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
  }

  MealPlansCompanion _makePlan({
    required String id,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final now = createdAt ?? DateTime.now();
    final start = startDate ?? DateTime(2024, 1, 8);
    return MealPlansCompanion(
      id: Value(id),
      createdAt: Value(now),
      startDate: Value(start),
      endDate: Value(endDate ?? start.add(const Duration(days: 6))),
    );
  }

  MealPlanDaysCompanion _makeDay({
    required String id,
    required String planId,
    required String recipeId,
    DateTime? date,
    bool isCooked = false,
    int sortOrder = 0,
  }) {
    return MealPlanDaysCompanion(
      id: Value(id),
      planId: Value(planId),
      recipeId: Value(recipeId),
      recipeName: Value('Recipe $recipeId'),
      date: Value(date ?? DateTime(2024, 1, 8)),
      isCooked: Value(isCooked),
      sortOrder: Value(sortOrder),
    );
  }

  group('MealPlanDao', () {
    group('Plan CRUD', () {
      test('insert and get plan', () async {
        await dao.insertPlan(_makePlan(id: 'p1'));
        final plans = await dao.getAllPlans();
        expect(plans.length, 1);
        expect(plans.first.id, 'p1');
      });

      test('delete plan cascades days', () async {
        await _insertRecipe('r1');
        await dao.insertPlan(_makePlan(id: 'p1'));
        await dao.insertPlanDays([
          _makeDay(id: 'd1', planId: 'p1', recipeId: 'r1'),
        ]);

        await dao.deletePlan('p1');

        final plans = await dao.getAllPlans();
        expect(plans, isEmpty);
        final days = await dao.getDaysForPlan('p1');
        expect(days, isEmpty);
      });
    });

    group('getTodaysMeal', () {
      test('returns today\'s meal when it exists', () async {
        await _insertRecipe('r1');
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        await dao.insertPlan(_makePlan(
          id: 'p1',
          startDate: today,
          endDate: today.add(const Duration(days: 6)),
        ));
        await dao.insertPlanDays([
          _makeDay(id: 'd1', planId: 'p1', recipeId: 'r1', date: today),
        ]);

        final meal = await dao.getTodaysMeal();
        expect(meal, isNotNull);
        expect(meal!.recipeId, 'r1');
      });

      test('returns null when no meal for today', () async {
        await _insertRecipe('r1');
        final yesterday =
            DateTime.now().subtract(const Duration(days: 2));

        await dao.insertPlan(_makePlan(
          id: 'p1',
          startDate: yesterday,
        ));
        await dao.insertPlanDays([
          _makeDay(
              id: 'd1',
              planId: 'p1',
              recipeId: 'r1',
              date: yesterday),
        ]);

        final meal = await dao.getTodaysMeal();
        expect(meal, isNull);
      });
    });

    group('getRecentMeals', () {
      test('returns cooked meals within N days', () async {
        await _insertRecipe('r1');
        await _insertRecipe('r2');
        final now = DateTime.now();

        await dao.insertPlan(_makePlan(
          id: 'p1',
          startDate: now.subtract(const Duration(days: 5)),
        ));
        await dao.insertPlanDays([
          _makeDay(
            id: 'd1',
            planId: 'p1',
            recipeId: 'r1',
            date: now.subtract(const Duration(days: 3)),
            isCooked: true,
          ),
          _makeDay(
            id: 'd2',
            planId: 'p1',
            recipeId: 'r2',
            date: now.subtract(const Duration(days: 1)),
            isCooked: false,
          ),
        ]);

        final recent = await dao.getRecentMeals(withinDays: 14);
        expect(recent.length, 1);
        expect(recent.first.isCooked, isTrue);
      });
    });

    group('markCooked', () {
      test('updates isCooked flag', () async {
        await _insertRecipe('r1');
        await dao.insertPlan(_makePlan(id: 'p1'));
        await dao.insertPlanDays([
          _makeDay(
              id: 'd1', planId: 'p1', recipeId: 'r1', isCooked: false),
        ]);

        await dao.markCooked('d1', true);

        final days = await dao.getDaysForPlan('p1');
        expect(days.first.isCooked, isTrue);
      });
    });

    group('updateDayRecipe', () {
      test('updates recipe ID and name', () async {
        await _insertRecipe('r1');
        await _insertRecipe('r2');
        await dao.insertPlan(_makePlan(id: 'p1'));
        await dao.insertPlanDays([
          _makeDay(id: 'd1', planId: 'p1', recipeId: 'r1'),
        ]);

        await dao.updateDayRecipe('d1', 'r2', 'New Recipe');

        final days = await dao.getDaysForPlan('p1');
        expect(days.first.recipeId, 'r2');
        expect(days.first.recipeName, 'New Recipe');
      });
    });

    group('swapDayDates', () {
      test('atomically swaps two days\' dates', () async {
        await _insertRecipe('r1');
        await _insertRecipe('r2');
        final date1 = DateTime(2024, 1, 8);
        final date2 = DateTime(2024, 1, 9);

        await dao.insertPlan(_makePlan(id: 'p1'));
        await dao.insertPlanDays([
          _makeDay(
              id: 'd1', planId: 'p1', recipeId: 'r1', date: date1),
          _makeDay(
              id: 'd2', planId: 'p1', recipeId: 'r2', date: date2),
        ]);

        await dao.swapDayDates('d1', 'd2');

        final days = await dao.getDaysForPlan('p1');
        final d1 = days.firstWhere((d) => d.id == 'd1');
        final d2 = days.firstWhere((d) => d.id == 'd2');
        expect(d1.date, date2);
        expect(d2.date, date1);
      });
    });
  });
}
