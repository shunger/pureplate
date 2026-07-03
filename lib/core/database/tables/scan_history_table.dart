import 'package:drift/drift.dart';

/// ScanHistoryEntries — log of barcode scans for analytics and quick re-access.
/// From SmartShoppingScanner.
class ScanHistoryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get barcode => text()();
  TextColumn get scanType => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get confidence => real().nullable()();
  TextColumn get productId => text().nullable()();
  TextColumn get errorMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
