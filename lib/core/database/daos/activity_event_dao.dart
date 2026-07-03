import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/activity_events_table.dart';

part 'activity_event_dao.g.dart';

@DriftAccessor(tables: [ActivityEvents])
class ActivityEventDao extends DatabaseAccessor<AppDatabase>
    with _$ActivityEventDaoMixin {
  ActivityEventDao(super.db);

  Stream<List<ActivityEvent>> watchAllEvents({int limit = 50}) =>
      (select(activityEvents)
            ..orderBy([(e) => OrderingTerm.desc(e.timestamp)])
            ..limit(limit))
          .watch();

  Stream<List<ActivityEvent>> watchEventsForSource(
          String sourceType, String sourceId,
          {int limit = 20}) =>
      (select(activityEvents)
            ..where((e) =>
                e.sourceType.equals(sourceType) &
                e.sourceId.equals(sourceId))
            ..orderBy([(e) => OrderingTerm.desc(e.timestamp)])
            ..limit(limit))
          .watch();

  Future<void> upsertEvent(ActivityEventsCompanion event) =>
      into(activityEvents).insertOnConflictUpdate(event);

  Future<void> markAsRead(String id) =>
      (update(activityEvents)..where((e) => e.id.equals(id)))
          .write(const ActivityEventsCompanion(isRead: Value(true)));

  Future<void> markAllAsRead() =>
      update(activityEvents)
          .write(const ActivityEventsCompanion(isRead: Value(true)));

  Stream<int> watchUnreadCount() {
    final count = countAll();
    final query = selectOnly(activityEvents)
      ..addColumns([count])
      ..where(activityEvents.isRead.equals(false));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// Prune old events, keeping the most recent [keepCount].
  Future<void> pruneOldEvents({int keepCount = 200}) async {
    final allEvents = await (select(activityEvents)
          ..orderBy([(e) => OrderingTerm.desc(e.timestamp)]))
        .get();
    if (allEvents.length > keepCount) {
      final toDelete = allEvents.sublist(keepCount);
      for (final event in toDelete) {
        await (delete(activityEvents)..where((e) => e.id.equals(event.id)))
            .go();
      }
    }
  }
}
