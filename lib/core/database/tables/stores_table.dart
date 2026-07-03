import 'package:drift/drift.dart';

/// Stores — grocery store directory with location and service info.
/// From SmartShoppingScanner.
class Stores extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('grocery'))();
  TextColumn get address => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get website => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get preferredCurrency => text().withDefault(const Constant('USD'))();
  BoolColumn get supportsTaxExempt => boolean().withDefault(const Constant(false))();
  BoolColumn get hasDelivery => boolean().withDefault(const Constant(false))();
  BoolColumn get hasPickup => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// StoreAisles — aisle-to-category mappings for efficient shopping.
class StoreAisles extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text().references(Stores, #id)();
  TextColumn get aisleName => text()();
  IntColumn get aisleNumber => integer().nullable()();
  TextColumn get categoriesJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}
