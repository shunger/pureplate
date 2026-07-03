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
}
