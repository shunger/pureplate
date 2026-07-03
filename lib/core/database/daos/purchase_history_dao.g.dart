// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_history_dao.dart';

// ignore_for_file: type=lint
mixin _$PurchaseHistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $PurchaseHistoriesTable get purchaseHistories =>
      attachedDatabase.purchaseHistories;
  $PurchaseRecordsTable get purchaseRecords => attachedDatabase.purchaseRecords;
  PurchaseHistoryDaoManager get managers => PurchaseHistoryDaoManager(this);
}

class PurchaseHistoryDaoManager {
  final _$PurchaseHistoryDaoMixin _db;
  PurchaseHistoryDaoManager(this._db);
  $$PurchaseHistoriesTableTableManager get purchaseHistories =>
      $$PurchaseHistoriesTableTableManager(
        _db.attachedDatabase,
        _db.purchaseHistories,
      );
  $$PurchaseRecordsTableTableManager get purchaseRecords =>
      $$PurchaseRecordsTableTableManager(
        _db.attachedDatabase,
        _db.purchaseRecords,
      );
}
