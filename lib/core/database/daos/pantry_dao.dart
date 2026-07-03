import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pantry_items_table.dart';

part 'pantry_dao.g.dart';

@DriftAccessor(tables: [PantryItems])
class PantryDao extends DatabaseAccessor<AppDatabase> with _$PantryDaoMixin {
  PantryDao(super.db);

  // ── Queries ─────────────────────────────────────────────

  Future<List<PantryItem>> getAllItems() =>
      (select(pantryItems)..orderBy([(i) => OrderingTerm.asc(i.expiresAt)]))
          .get();

  Stream<List<PantryItem>> watchAllItems() =>
      (select(pantryItems)..orderBy([(i) => OrderingTerm.asc(i.expiresAt)]))
          .watch();

  Stream<List<PantryItem>> watchItemsByLocation(String location) =>
      (select(pantryItems)
            ..where((i) => i.location.equals(location))
            ..orderBy([(i) => OrderingTerm.asc(i.expiresAt)]))
          .watch();

  Stream<List<PantryItem>> watchExpiringItems({int withinDays = 7}) {
    final cutoff = DateTime.now().add(Duration(days: withinDays));
    return (select(pantryItems)
          ..where((i) =>
              i.expiresAt.isSmallerOrEqualValue(cutoff) &
              i.expiresAt.isBiggerOrEqualValue(DateTime.now()))
          ..orderBy([(i) => OrderingTerm.asc(i.expiresAt)]))
        .watch();
  }

  Stream<List<PantryItem>> watchExpiredItems() =>
      (select(pantryItems)
            ..where((i) => i.expiresAt.isSmallerThanValue(DateTime.now()))
            ..orderBy([(i) => OrderingTerm.asc(i.expiresAt)]))
          .watch();

  Stream<List<PantryItem>> watchStapleItems() =>
      (select(pantryItems)
            ..where((i) => i.isStaple.equals(true))
            ..orderBy([(i) => OrderingTerm.asc(i.name)]))
          .watch();

  Future<PantryItem?> getItemById(String id) =>
      (select(pantryItems)..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<List<PantryItem>> findByProductId(String productId) =>
      (select(pantryItems)..where((i) => i.productId.equals(productId))).get();

  Future<PantryItem?> findByFirestoreItemId(String firestoreItemId) =>
      (select(pantryItems)
            ..where((i) => i.firestoreItemId.equals(firestoreItemId)))
          .getSingleOrNull();

  Stream<List<PantryItem>> watchItemsByFirestorePantryId(
          String firestorePantryId) =>
      (select(pantryItems)
            ..where((i) => i.firestorePantryId.equals(firestorePantryId)))
          .watch();

  Future<List<PantryItem>> getItemsByFirestorePantryId(
          String firestorePantryId) =>
      (select(pantryItems)
            ..where((i) => i.firestorePantryId.equals(firestorePantryId)))
          .get();

  // ── Mutations ───────────────────────────────────────────

  Future<void> insertItem(PantryItemsCompanion item) =>
      into(pantryItems).insertOnConflictUpdate(item);

  Future<void> updateItem(PantryItemsCompanion item) =>
      (update(pantryItems)..where((i) => i.id.equals(item.id.value)))
          .write(item);

  Future<void> deleteItem(String id) =>
      (delete(pantryItems)..where((i) => i.id.equals(id))).go();

  Future<void> updateQuantity(String id, double quantity) =>
      (update(pantryItems)..where((i) => i.id.equals(id))).write(
          PantryItemsCompanion(
              quantity: Value(quantity), updatedAt: Value(DateTime.now())));

  Future<void> updateStatus(String id, String status) =>
      (update(pantryItems)..where((i) => i.id.equals(id))).write(
          PantryItemsCompanion(
              status: Value(status), updatedAt: Value(DateTime.now())));

  Future<void> updateLocation(String id, String location) =>
      (update(pantryItems)..where((i) => i.id.equals(id))).write(
          PantryItemsCompanion(
              location: Value(location), updatedAt: Value(DateTime.now())));

  Future<void> updateFirestoreIds(
          String localId, String? firestorePantryId, String? firestoreItemId) =>
      (update(pantryItems)..where((i) => i.id.equals(localId))).write(
          PantryItemsCompanion(
              firestorePantryId: Value(firestorePantryId),
              firestoreItemId: Value(firestoreItemId),
              updatedAt: Value(DateTime.now())));

  Future<void> updateStapleSettings(
          String id, bool isStaple, int reorderThreshold, bool isBulk) =>
      (update(pantryItems)..where((i) => i.id.equals(id))).write(
          PantryItemsCompanion(
              isStaple: Value(isStaple),
              reorderThreshold: Value(reorderThreshold),
              isBulk: Value(isBulk),
              updatedAt: Value(DateTime.now())));

  /// Upsert by Firestore item ID — used during sync from shared pantry.
  Future<void> upsertByFirestoreItemId(PantryItemsCompanion item) async {
    final existing = await findByFirestoreItemId(
        item.firestoreItemId.value ?? '');
    if (existing != null) {
      await (update(pantryItems)..where((i) => i.id.equals(existing.id)))
          .write(item);
    } else {
      await into(pantryItems).insert(item);
    }
  }

  /// Remove items deleted by collaborators in a shared pantry.
  Future<void> deleteItemsNotInRemoteSet(
      String firestorePantryId, Set<String> remoteItemIds) async {
    final localItems = await getItemsByFirestorePantryId(firestorePantryId);
    for (final item in localItems) {
      if (item.firestoreItemId != null &&
          !remoteItemIds.contains(item.firestoreItemId)) {
        await deleteItem(item.id);
      }
    }
  }
}
