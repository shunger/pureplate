// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_event_dao.dart';

// ignore_for_file: type=lint
mixin _$ActivityEventDaoMixin on DatabaseAccessor<AppDatabase> {
  $ActivityEventsTable get activityEvents => attachedDatabase.activityEvents;
  ActivityEventDaoManager get managers => ActivityEventDaoManager(this);
}

class ActivityEventDaoManager {
  final _$ActivityEventDaoMixin _db;
  ActivityEventDaoManager(this._db);
  $$ActivityEventsTableTableManager get activityEvents =>
      $$ActivityEventsTableTableManager(
        _db.attachedDatabase,
        _db.activityEvents,
      );
}
