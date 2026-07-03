import 'package:drift/drift.dart';

/// Budgets — spending budget tracking by period.
/// From SmartShoppingScanner.
class Budgets extends Table {
  TextColumn get id => text()();
  // Period: 'weekly', 'biweekly', 'monthly', 'yearly'.
  TextColumn get period => text().withDefault(const Constant('monthly'))();
  RealColumn get amount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// BudgetEntries — individual spending entries within a budget.
class BudgetEntries extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().references(Budgets, #id)();
  TextColumn get listId => text().nullable()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
