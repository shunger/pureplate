import 'package:drift/drift.dart';

/// ProduceTemplates — built-in PLU database for produce items.
/// From SmartShoppingScanner.
class ProduceTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get pluCode => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('produce'))();
  TextColumn get unitType => text().withDefault(const Constant('each'))();
  RealColumn get averageWeight => real().nullable()();
  RealColumn get avgPriceLow => real().nullable()();
  RealColumn get avgPriceHigh => real().nullable()();
  TextColumn get seasonalityJson => text().nullable()();
  TextColumn get ripenessIndicatorsJson => text().nullable()();
  TextColumn get storageInstructions => text().nullable()();
  BoolColumn get isOrganic => boolean().withDefault(const Constant(false))();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
