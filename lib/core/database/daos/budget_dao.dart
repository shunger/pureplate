import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/budgets_table.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets, BudgetEntries])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  // ── Budget queries ──────────────────────────────────────

  Stream<List<Budget>> watchAllBudgets() =>
      (select(budgets)..orderBy([(b) => OrderingTerm.desc(b.startDate)]))
          .watch();

  Future<Budget?> getActiveBudget() {
    final now = DateTime.now();
    return (select(budgets)
          ..where((b) =>
              b.startDate.isSmallerOrEqualValue(now) &
              b.endDate.isBiggerOrEqualValue(now)))
        .getSingleOrNull();
  }

  Stream<Budget?> watchActiveBudget() {
    final now = DateTime.now();
    return (select(budgets)
          ..where((b) =>
              b.startDate.isSmallerOrEqualValue(now) &
              b.endDate.isBiggerOrEqualValue(now)))
        .watchSingleOrNull();
  }

  Future<void> insertBudget(BudgetsCompanion budget) =>
      into(budgets).insertOnConflictUpdate(budget);

  Future<void> updateBudget(BudgetsCompanion budget) =>
      (update(budgets)..where((b) => b.id.equals(budget.id.value)))
          .write(budget);

  Future<void> deleteBudget(String id) => transaction(() async {
        await (delete(budgetEntries)..where((e) => e.budgetId.equals(id)))
            .go();
        await (delete(budgets)..where((b) => b.id.equals(id))).go();
      });

  // ── Entry queries ───────────────────────────────────────

  Stream<List<BudgetEntry>> watchEntriesForBudget(String budgetId) =>
      (select(budgetEntries)
            ..where((e) => e.budgetId.equals(budgetId))
            ..orderBy([(e) => OrderingTerm.desc(e.date)]))
          .watch();

  Future<void> insertEntry(BudgetEntriesCompanion entry) =>
      into(budgetEntries).insertOnConflictUpdate(entry);

  Future<void> deleteEntry(String id) =>
      (delete(budgetEntries)..where((e) => e.id.equals(id))).go();
}
