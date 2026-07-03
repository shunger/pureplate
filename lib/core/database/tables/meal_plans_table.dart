import 'package:drift/drift.dart';

/// MealPlans table — generated meal plans spanning multiple days.
/// From MealPlannerAI.
class MealPlans extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();

  // Plan type: 'quick', 'chat', 'inventory'.
  TextColumn get planType => text().withDefault(const Constant('quick'))();

  @override
  Set<Column> get primaryKey => {id};
}
