import 'package:drift/drift.dart';

/// ShoppingLists table — manual or AI-auto-generated shopping lists.
/// Enhanced from SmartShoppingScanner with meal plan linkage.
class ShoppingLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  // Store association.
  TextColumn get storeId => text().nullable()();
  TextColumn get storeName => text().nullable()();
  TextColumn get storeType => text().nullable()();

  // Source tracking: 'manual' or 'meal_plan'.
  TextColumn get source => text().withDefault(const Constant('manual'))();

  // If auto-generated, which meal plan produced this.
  TextColumn get mealPlanId => text().nullable()();

  // Status.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  // Firestore sharing.
  TextColumn get firestoreId => text().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // Timestamps.
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get dateShopped => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
