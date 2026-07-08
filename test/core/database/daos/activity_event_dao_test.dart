import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/activity_event_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ActivityEventDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.activityEventDao;
  });

  tearDown(() async {
    await db.close();
  });

  ActivityEventsCompanion _makeEvent({
    required String id,
    String type = 'item_added',
    String sourceType = 'list',
    String sourceId = 's1',
    String sourceName = 'Test List',
    String actorUid = 'user1',
    String actorDisplayName = 'Alice',
    bool isRead = false,
    DateTime? timestamp,
  }) {
    return ActivityEventsCompanion(
      id: Value(id),
      type: Value(type),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      sourceName: Value(sourceName),
      actorUid: Value(actorUid),
      actorDisplayName: Value(actorDisplayName),
      isRead: Value(isRead),
      timestamp: Value(timestamp ?? DateTime.now()),
    );
  }

  group('ActivityEventDao', () {
    group('upsertEvent', () {
      test('inserts new event', () async {
        await dao.upsertEvent(_makeEvent(id: 'e1'));
        final events = await dao.watchAllEvents().first;
        expect(events.length, 1);
        expect(events.first.id, 'e1');
      });

      test('updates existing event', () async {
        await dao.upsertEvent(
            _makeEvent(id: 'e1', actorDisplayName: 'Alice'));
        await dao.upsertEvent(
            _makeEvent(id: 'e1', actorDisplayName: 'Bob'));

        final events = await dao.watchAllEvents().first;
        expect(events.length, 1);
        expect(events.first.actorDisplayName, 'Bob');
      });
    });

    group('watchAllEvents', () {
      test('respects limit', () async {
        for (int i = 0; i < 5; i++) {
          await dao.upsertEvent(_makeEvent(
            id: 'e$i',
            timestamp:
                DateTime.now().add(Duration(seconds: i)),
          ));
        }

        final events = await dao.watchAllEvents(limit: 3).first;
        expect(events.length, 3);
      });
    });

    group('watchUnreadCount', () {
      test('counts unread events', () async {
        await dao.upsertEvent(_makeEvent(id: 'e1', isRead: false));
        await dao.upsertEvent(_makeEvent(id: 'e2', isRead: false));
        await dao.upsertEvent(_makeEvent(id: 'e3', isRead: true));

        final count = await dao.watchUnreadCount().first;
        expect(count, 2);
      });
    });

    group('markAsRead', () {
      test('marks single event as read', () async {
        await dao.upsertEvent(_makeEvent(id: 'e1', isRead: false));
        await dao.markAsRead('e1');

        final events = await dao.watchAllEvents().first;
        expect(events.first.isRead, isTrue);
      });
    });

    group('markAllAsRead', () {
      test('marks all events as read', () async {
        await dao.upsertEvent(_makeEvent(id: 'e1', isRead: false));
        await dao.upsertEvent(_makeEvent(id: 'e2', isRead: false));

        await dao.markAllAsRead();

        final count = await dao.watchUnreadCount().first;
        expect(count, 0);
      });
    });

    group('pruneOldEvents', () {
      test('keeps N most recent, deletes rest', () async {
        for (int i = 0; i < 10; i++) {
          await dao.upsertEvent(_makeEvent(
            id: 'e$i',
            timestamp: DateTime(2024, 1, 1 + i),
          ));
        }

        await dao.pruneOldEvents(keepCount: 5);

        final events = await dao.watchAllEvents(limit: 100).first;
        expect(events.length, 5);
      });

      test('does nothing when count <= keepCount', () async {
        await dao.upsertEvent(_makeEvent(id: 'e1'));
        await dao.upsertEvent(_makeEvent(id: 'e2'));

        await dao.pruneOldEvents(keepCount: 5);

        final events = await dao.watchAllEvents(limit: 100).first;
        expect(events.length, 2);
      });
    });
  });
}
