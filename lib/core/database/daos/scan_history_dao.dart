import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/scan_history_table.dart';

part 'scan_history_dao.g.dart';

@DriftAccessor(tables: [ScanHistoryEntries])
class ScanHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$ScanHistoryDaoMixin {
  ScanHistoryDao(super.db);

  Stream<List<ScanHistoryEntry>> watchAllEntries() =>
      (select(scanHistoryEntries)
            ..orderBy([(e) => OrderingTerm.desc(e.timestamp)]))
          .watch();

  Future<List<ScanHistoryEntry>> getRecentEntries({int limit = 20}) =>
      (select(scanHistoryEntries)
            ..orderBy([(e) => OrderingTerm.desc(e.timestamp)])
            ..limit(limit))
          .get();

  Future<void> insertEntry(ScanHistoryEntriesCompanion entry) =>
      into(scanHistoryEntries).insertOnConflictUpdate(entry);

  Future<void> deleteEntry(String id) =>
      (delete(scanHistoryEntries)..where((e) => e.id.equals(id))).go();

  Future<void> clearAll() => delete(scanHistoryEntries).go();
}
