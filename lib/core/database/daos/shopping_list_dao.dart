import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shopping_lists_table.dart';
import '../tables/shopping_list_items_table.dart';
import '../tables/products_table.dart';

part 'shopping_list_dao.g.dart';

@DriftAccessor(tables: [ShoppingLists, ShoppingListItems, Products])
class ShoppingListDao extends DatabaseAccessor<AppDatabase>
    with _$ShoppingListDaoMixin {
  ShoppingListDao(super.db);

  // ── List queries ────────────────────────────────────────

  Stream<List<ShoppingList>> watchActiveLists() =>
      (select(shoppingLists)
            ..where((l) => l.isArchived.equals(false))
            ..orderBy([(l) => OrderingTerm.desc(l.updatedAt)]))
          .watch();

  Stream<List<ShoppingList>> watchArchivedLists() =>
      (select(shoppingLists)
            ..where((l) => l.isArchived.equals(true))
            ..orderBy([(l) => OrderingTerm.desc(l.dateShopped)]))
          .watch();

  Future<ShoppingList?> getListById(String id) =>
      (select(shoppingLists)..where((l) => l.id.equals(id)))
          .getSingleOrNull();

  Stream<ShoppingList?> watchListById(String id) =>
      (select(shoppingLists)..where((l) => l.id.equals(id)))
          .watchSingleOrNull();

  // ── List mutations ──────────────────────────────────────

  Future<void> insertList(ShoppingListsCompanion list) =>
      into(shoppingLists).insertOnConflictUpdate(list);

  Future<void> updateList(ShoppingListsCompanion list) =>
      (update(shoppingLists)..where((l) => l.id.equals(list.id.value)))
          .write(list);

  Future<void> deleteList(String id) => transaction(() async {
        await (delete(shoppingListItems)..where((i) => i.listId.equals(id)))
            .go();
        await (delete(shoppingLists)..where((l) => l.id.equals(id))).go();
      });

  Future<void> archiveList(String id) =>
      (update(shoppingLists)..where((l) => l.id.equals(id))).write(
          ShoppingListsCompanion(
              isArchived: const Value(true),
              dateShopped: Value(DateTime.now()),
              updatedAt: Value(DateTime.now())));

  // ── Item queries ────────────────────────────────────────

  Stream<List<ShoppingListItem>> watchItemsForList(String listId) =>
      (select(shoppingListItems)
            ..where((i) => i.listId.equals(listId))
            ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
          .watch();

  Future<List<ShoppingListItem>> getItemsForList(String listId) =>
      (select(shoppingListItems)
            ..where((i) => i.listId.equals(listId))
            ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
          .get();

  /// Get items with joined product details.
  Stream<List<TypedResult>> watchItemsWithProducts(String listId) {
    final query = select(shoppingListItems).join([
      leftOuterJoin(
          products, products.id.equalsExp(shoppingListItems.productId)),
    ])
      ..where(shoppingListItems.listId.equals(listId))
      ..orderBy([OrderingTerm.asc(shoppingListItems.sortOrder)]);
    return query.watch();
  }

  Future<ShoppingListItem?> getItemById(String id) =>
      (select(shoppingListItems)..where((i) => i.id.equals(id)))
          .getSingleOrNull();

  // ── Item mutations ──────────────────────────────────────

  Future<void> insertItem(ShoppingListItemsCompanion item) =>
      into(shoppingListItems).insertOnConflictUpdate(item);

  Future<void> insertItems(List<ShoppingListItemsCompanion> items) =>
      batch((b) => b.insertAllOnConflictUpdate(shoppingListItems, items));

  Future<void> updateItem(ShoppingListItemsCompanion item) =>
      (update(shoppingListItems)..where((i) => i.id.equals(item.id.value)))
          .write(item);

  Future<void> deleteItem(String id) =>
      (delete(shoppingListItems)..where((i) => i.id.equals(id))).go();

  Future<void> toggleItemCompletion(String id, bool isCompleted) =>
      (update(shoppingListItems)..where((i) => i.id.equals(id))).write(
          ShoppingListItemsCompanion(
              isCompleted: Value(isCompleted),
              updatedAt: Value(DateTime.now())));

  Future<void> clearCompletedItems(String listId) =>
      (delete(shoppingListItems)
            ..where(
                (i) => i.listId.equals(listId) & i.isCompleted.equals(true)))
          .go();

  Future<void> checkAllItems(String listId) =>
      (update(shoppingListItems)..where((i) => i.listId.equals(listId)))
          .write(ShoppingListItemsCompanion(
              isCompleted: const Value(true),
              updatedAt: Value(DateTime.now())));

  Future<void> resetAllItems(String listId) =>
      (update(shoppingListItems)..where((i) => i.listId.equals(listId)))
          .write(ShoppingListItemsCompanion(
              isCompleted: const Value(false),
              updatedAt: Value(DateTime.now())));

  Future<void> deleteAllItemsForList(String listId) =>
      (delete(shoppingListItems)..where((i) => i.listId.equals(listId))).go();

  Future<void> moveItems(List<String> itemIds, String targetListId) =>
      (update(shoppingListItems)..where((i) => i.id.isIn(itemIds))).write(
          ShoppingListItemsCompanion(
              listId: Value(targetListId),
              updatedAt: Value(DateTime.now())));

  /// Delete items for a specific meal plan (when regenerating).
  Future<void> deleteItemsForPlan(String planId) async {
    // Find the auto-generated list for this plan, then clear its items.
    final list = await (select(shoppingLists)
          ..where((l) => l.mealPlanId.equals(planId)))
        .getSingleOrNull();
    if (list != null) {
      await deleteAllItemsForList(list.id);
    }
  }

  // ── Firestore sync methods ────────────────────────────────

  /// Find a local item by its Firestore item document ID.
  Future<ShoppingListItem?> findItemByFirestoreItemId(
          String firestoreItemId) =>
      (select(shoppingListItems)
            ..where((i) => i.firestoreItemId.equals(firestoreItemId)))
          .getSingleOrNull();

  /// Upsert by Firestore item ID — used during sync from shared list.
  ///
  /// An existing row keeps its local `id` and `addedAt`, so screens holding
  /// the id stay valid across remote updates.
  Future<void> upsertByFirestoreItemId(
      ShoppingListItemsCompanion item) async {
    final existing = await findItemByFirestoreItemId(
        item.firestoreItemId.value ?? '');
    if (existing != null) {
      await (update(shoppingListItems)
            ..where((i) => i.id.equals(existing.id)))
          .write(item.copyWith(
              id: const Value.absent(), addedAt: const Value.absent()));
    } else {
      await into(shoppingListItems).insert(item);
    }
  }

  /// Find the local list linked to a Firestore shared list.
  Future<ShoppingList?> getListByFirestoreId(String firestoreId) =>
      (select(shoppingLists)
            ..where((l) => l.firestoreId.equals(firestoreId))
            ..limit(1))
          .getSingleOrNull();

  /// Detach a local list and its items from a shared list (after leaving it or
  /// when it was deleted remotely). The local list and items are kept.
  Future<void> unlinkList(String localListId) => transaction(() async {
        await (update(shoppingLists)..where((l) => l.id.equals(localListId)))
            .write(ShoppingListsCompanion(
                firestoreId: const Value(null),
                updatedAt: Value(DateTime.now())));
        await (update(shoppingListItems)
              ..where((i) => i.listId.equals(localListId)))
            .write(const ShoppingListItemsCompanion(
                firestoreListId: Value(null), firestoreItemId: Value(null)));
      });

  /// Link/unlink a local item to a Firestore shared list and item doc.
  Future<void> updateFirestoreIds(
          String localId, String? firestoreListId, String? firestoreItemId) =>
      (update(shoppingListItems)..where((i) => i.id.equals(localId))).write(
          ShoppingListItemsCompanion(
              firestoreListId: Value(firestoreListId),
              firestoreItemId: Value(firestoreItemId),
              updatedAt: Value(DateTime.now())));

  /// Remove items that were deleted remotely from a shared list.
  Future<void> deleteItemsNotInRemoteSet(
      String firestoreListId, Set<String> remoteItemIds) async {
    final localItems = await getItemsByFirestoreListId(firestoreListId);
    for (final item in localItems) {
      if (item.firestoreItemId != null &&
          !remoteItemIds.contains(item.firestoreItemId)) {
        await deleteItem(item.id);
      }
    }
  }

  /// Get all items linked to a specific Firestore shared list.
  Future<List<ShoppingListItem>> getItemsByFirestoreListId(
          String firestoreListId) =>
      (select(shoppingListItems)
            ..where((i) => i.firestoreListId.equals(firestoreListId)))
          .get();

  /// Set the firestoreId on a shopping list record.
  Future<void> updateListFirestoreId(
          String localListId, String? firestoreId) =>
      (update(shoppingLists)..where((l) => l.id.equals(localListId))).write(
          ShoppingListsCompanion(
              firestoreId: Value(firestoreId),
              updatedAt: Value(DateTime.now())));
}
