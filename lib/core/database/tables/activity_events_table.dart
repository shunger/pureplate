import 'package:drift/drift.dart';

/// ActivityEvents — sharing activity feed for collaborative lists and pantries.
/// From SmartShoppingScanner.
class ActivityEvents extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  // Source type: 'list', 'pantry'.
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text()();
  TextColumn get sourceName => text()();
  TextColumn get actorUid => text()();
  TextColumn get actorDisplayName => text()();
  TextColumn get itemName => text().nullable()();
  TextColumn get detailsJson => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
