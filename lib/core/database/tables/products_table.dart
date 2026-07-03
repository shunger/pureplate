import 'package:drift/drift.dart';

/// Products table — barcode-scanned or manually-created product catalog.
/// From SmartShoppingScanner, enhanced for unified app.
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get pluCode => text().nullable()();
  TextColumn get identifierType => text().withDefault(const Constant('barcode'))();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('other'))();
  TextColumn get imageUrl => text().nullable()();

  // Structured data stored as JSON strings.
  TextColumn get nutritionInfoJson => text().nullable()();
  TextColumn get ingredientsJson => text().nullable()();
  TextColumn get allergensJson => text().nullable()();

  // Weight-based produce fields.
  BoolColumn get isWeightBased => boolean().withDefault(const Constant(false))();
  TextColumn get unitType => text().withDefault(const Constant('each'))();
  RealColumn get averageWeight => real().nullable()();

  // Produce-specific fields.
  TextColumn get seasonalityJson => text().nullable()();
  TextColumn get storageInstructions => text().nullable()();
  TextColumn get ripenessIndicatorsJson => text().nullable()();

  // Dietary flags.
  BoolColumn get isOrganic => boolean().withDefault(const Constant(false))();
  BoolColumn get isGlutenFree => boolean().withDefault(const Constant(false))();
  BoolColumn get isVegan => boolean().withDefault(const Constant(false))();

  // User flags.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  TextColumn get source => text().nullable()();

  // Timestamps.
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastLookedUp => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
