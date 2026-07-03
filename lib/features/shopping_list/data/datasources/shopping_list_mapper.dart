import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../shared/models/product_category.dart';
import '../../domain/models/item_priority.dart';
import '../../domain/models/shopping_list.dart';

/// Maps between Drift DB rows and domain Freezed models.
class ShoppingListMapper {
  ShoppingListMapper._();

  // ── DB → Domain ─────────────────────────────────────────

  /// Convert a DB [ShoppingList] row + its child item rows into a
  /// domain [ShoppingList] with nested items.
  static ShoppingList fromDbWithItems(
    db.ShoppingList dbList,
    List<db.ShoppingListItem> dbItems,
  ) {
    return ShoppingList(
      id: dbList.id,
      name: dbList.name,
      items: dbItems.map(itemFromDb).toList(),
      storeId: dbList.storeId,
      storeName: dbList.storeName,
      source: _sourceFromDb(dbList.source),
      mealPlanId: dbList.mealPlanId,
      isActive: dbList.isActive,
      isCompleted: dbList.isCompleted,
      isArchived: dbList.isArchived,
      firestoreId: dbList.firestoreId,
      createdAt: dbList.createdAt,
      dateShopped: dbList.dateShopped,
      sortOrder: dbList.sortOrder,
    );
  }

  /// Convert a single DB [ShoppingListItem] row to a domain model.
  static ShoppingListItem itemFromDb(db.ShoppingListItem dbRow) {
    return ShoppingListItem(
      id: dbRow.id,
      listId: dbRow.listId,
      productId: dbRow.productId,
      name: dbRow.name,
      brand: dbRow.brand,
      category: _categoryFromDb(dbRow.category),
      quantity: dbRow.quantity,
      unitType: dbRow.unitType,
      estimatedPrice: dbRow.estimatedPrice,
      actualPrice: dbRow.actualPrice,
      salePrice: dbRow.salePrice,
      isOnSale: dbRow.isOnSale,
      isCompleted: dbRow.isCompleted,
      priority: ItemPriority.fromDb(dbRow.priority).sortValue,
      notes: dbRow.notes,
      recipeId: dbRow.recipeId,
      recipeName: dbRow.recipeName,
      pantryQuantityAvailable: dbRow.pantryQuantityAvailable,
      addedAt: dbRow.addedAt,
      updatedAt: dbRow.updatedAt,
      sortOrder: dbRow.sortOrder,
    );
  }

  // ── Domain → DB ─────────────────────────────────────────

  /// Convert a domain [ShoppingList] to a Drift companion for insert/update.
  static db.ShoppingListsCompanion listToCompanion(ShoppingList list) {
    return db.ShoppingListsCompanion(
      id: Value(list.id),
      name: Value(list.name),
      storeId: Value(list.storeId),
      storeName: Value(list.storeName),
      source: Value(list.source == ShoppingListSource.mealPlan
          ? 'meal_plan'
          : 'manual'),
      mealPlanId: Value(list.mealPlanId),
      isActive: Value(list.isActive),
      isCompleted: Value(list.isCompleted),
      isArchived: Value(list.isArchived),
      firestoreId: Value(list.firestoreId),
      createdAt: Value(list.createdAt),
      updatedAt: Value(DateTime.now()),
      dateShopped: Value(list.dateShopped),
      sortOrder: Value(list.sortOrder),
    );
  }

  /// Convert a domain [ShoppingListItem] to a Drift companion.
  static db.ShoppingListItemsCompanion itemToCompanion(
      ShoppingListItem item) {
    return db.ShoppingListItemsCompanion(
      id: Value(item.id),
      listId: Value(item.listId),
      productId: Value(item.productId),
      name: Value(item.name),
      brand: Value(item.brand),
      category: Value(item.category.name),
      quantity: Value(item.quantity),
      unitType: Value(item.unitType),
      estimatedPrice: Value(item.estimatedPrice),
      actualPrice: Value(item.actualPrice),
      salePrice: Value(item.salePrice),
      isOnSale: Value(item.isOnSale),
      isCompleted: Value(item.isCompleted),
      priority: Value(ItemPriority.fromInt(item.priority).dbValue),
      notes: Value(item.notes),
      recipeId: Value(item.recipeId),
      recipeName: Value(item.recipeName),
      pantryQuantityAvailable: Value(item.pantryQuantityAvailable),
      addedAt: Value(item.addedAt),
      updatedAt: Value(DateTime.now()),
      sortOrder: Value(item.sortOrder),
    );
  }

  // ── Helpers ─────────────────────────────────────────────

  static ShoppingListSource _sourceFromDb(String source) {
    return source == 'meal_plan'
        ? ShoppingListSource.mealPlan
        : ShoppingListSource.manual;
  }

  static ProductCategory _categoryFromDb(String category) {
    return ProductCategory.values.asNameMap()[category] ??
        ProductCategory.other;
  }
}
