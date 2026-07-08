import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/budget_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late BudgetDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.budgetDao;
  });

  tearDown(() async {
    await db.close();
  });

  BudgetsCompanion _makeBudget({
    required String id,
    double amount = 500,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 15));
    final end = endDate ?? DateTime.now().add(const Duration(days: 15));
    return BudgetsCompanion(
      id: Value(id),
      amount: Value(amount),
      startDate: Value(start),
      endDate: Value(end),
      createdAt: Value(DateTime.now()),
    );
  }

  BudgetEntriesCompanion _makeEntry({
    required String id,
    required String budgetId,
    double amount = 25.0,
    DateTime? date,
  }) {
    return BudgetEntriesCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      amount: Value(amount),
      date: Value(date ?? DateTime.now()),
    );
  }

  group('BudgetDao', () {
    group('getActiveBudget', () {
      test('returns budget covering today', () async {
        await dao.insertBudget(_makeBudget(id: 'b1'));
        final budget = await dao.getActiveBudget();
        expect(budget, isNotNull);
        expect(budget!.id, 'b1');
      });

      test('returns null when no budget covers today', () async {
        await dao.insertBudget(_makeBudget(
          id: 'b1',
          startDate: DateTime.now().add(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 60)),
        ));
        final budget = await dao.getActiveBudget();
        expect(budget, isNull);
      });
    });

    group('cascading delete', () {
      test('deleting budget removes its entries', () async {
        await dao.insertBudget(_makeBudget(id: 'b1'));
        await dao.insertEntry(_makeEntry(id: 'e1', budgetId: 'b1'));
        await dao.insertEntry(_makeEntry(id: 'e2', budgetId: 'b1'));

        await dao.deleteBudget('b1');

        final budgets = await (db.select(db.budgets)).get();
        expect(budgets, isEmpty);

        final entries = await (db.select(db.budgetEntries)).get();
        expect(entries, isEmpty);
      });
    });

    group('Entry CRUD', () {
      test('insert and retrieve entries', () async {
        await dao.insertBudget(_makeBudget(id: 'b1'));
        await dao.insertEntry(
            _makeEntry(id: 'e1', budgetId: 'b1', amount: 50));
        await dao.insertEntry(
            _makeEntry(id: 'e2', budgetId: 'b1', amount: 30));

        final entries =
            await dao.watchEntriesForBudget('b1').first;
        expect(entries.length, 2);
      });

      test('delete entry', () async {
        await dao.insertBudget(_makeBudget(id: 'b1'));
        await dao.insertEntry(_makeEntry(id: 'e1', budgetId: 'b1'));
        await dao.deleteEntry('e1');

        final entries =
            await dao.watchEntriesForBudget('b1').first;
        expect(entries, isEmpty);
      });
    });
  });
}
