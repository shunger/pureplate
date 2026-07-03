import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/stores_table.dart';

part 'store_dao.g.dart';

@DriftAccessor(tables: [Stores, StoreAisles])
class StoreDao extends DatabaseAccessor<AppDatabase> with _$StoreDaoMixin {
  StoreDao(super.db);

  // ── Store queries ───────────────────────────────────────

  Stream<List<Store>> watchAllStores() =>
      (select(stores)
            ..where((s) => s.isActive.equals(true))
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .watch();

  Future<Store?> getStoreById(String id) =>
      (select(stores)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> insertStore(StoresCompanion store) =>
      into(stores).insertOnConflictUpdate(store);

  Future<void> updateStore(StoresCompanion store) =>
      (update(stores)..where((s) => s.id.equals(store.id.value))).write(store);

  Future<void> deleteStore(String id) => transaction(() async {
        await (delete(storeAisles)..where((a) => a.storeId.equals(id))).go();
        await (delete(stores)..where((s) => s.id.equals(id))).go();
      });

  // ── Aisle queries ───────────────────────────────────────

  Stream<List<StoreAisle>> watchAislesForStore(String storeId) =>
      (select(storeAisles)
            ..where((a) => a.storeId.equals(storeId))
            ..orderBy([(a) => OrderingTerm.asc(a.aisleNumber)]))
          .watch();

  Future<void> insertAisle(StoreAislesCompanion aisle) =>
      into(storeAisles).insertOnConflictUpdate(aisle);

  Future<void> updateAisle(StoreAislesCompanion aisle) =>
      (update(storeAisles)..where((a) => a.id.equals(aisle.id.value)))
          .write(aisle);

  Future<void> deleteAisle(String id) =>
      (delete(storeAisles)..where((a) => a.id.equals(id))).go();
}
