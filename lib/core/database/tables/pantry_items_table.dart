import 'package:drift/drift.dart';

/// PantryItems table — the unified inventory tracking what's in the house.
/// Central to both shopping intelligence and AI meal planning.
/// From SmartShoppingScanner.
class PantryItems extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant('other'))();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  TextColumn get unitType => text().withDefault(const Constant('each'))();

  // Dates.
  DateTimeColumn get purchasedAt => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  // Location: pantry, fridge, freezer.
  TextColumn get location => text().withDefault(const Constant('pantry'))();

  TextColumn get notes => text().nullable()();

  // Smart inventory flags.
  BoolColumn get isStaple => boolean().withDefault(const Constant(false))();
  IntColumn get reorderThreshold => integer().withDefault(const Constant(0))();
  BoolColumn get isBulk => boolean().withDefault(const Constant(false))();
  RealColumn get purchasePrice => real().nullable()();

  // Sync status: newItem, notified, etc.
  TextColumn get status => text().withDefault(const Constant('newItem'))();

  // Firestore sharing fields.
  TextColumn get firestorePantryId => text().nullable()();
  TextColumn get firestoreItemId => text().nullable()();

  // Timestamps.
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
