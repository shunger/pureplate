import 'package:drift/drift.dart';

/// PurchaseHistories — tracks purchase frequency and price trends per product.
/// From SmartShoppingScanner.
class PurchaseHistories extends Table {
  TextColumn get id => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get productName => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get productId => text().nullable()();
  DateTimeColumn get dateFirstPurchased => dateTime()();
  DateTimeColumn get dateLastPurchased => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// PurchaseRecords — individual purchase events linked to a history.
class PurchaseRecords extends Table {
  TextColumn get id => text()();
  TextColumn get historyId => text().references(PurchaseHistories, #id)();
  RealColumn get quantity => real()();
  RealColumn get price => real().nullable()();
  DateTimeColumn get datePurchased => dateTime()();
  TextColumn get storeName => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
