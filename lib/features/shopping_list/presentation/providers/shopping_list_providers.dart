import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';
import '../../data/datasources/shopping_list_mapper.dart';
import '../../domain/models/shopping_list.dart';

// Re-export core providers for convenience.
// shoppingListDaoProvider — from database_providers.dart
// activeShoppingListsProvider — from database_providers.dart (raw DB rows)

/// Active shopping lists mapped to domain models with item counts.
final activeShoppingListsDomainProvider =
    StreamProvider<List<ShoppingList>>((ref) {
  final dao = ref.watch(shoppingListDaoProvider);
  return dao.watchActiveLists().asyncMap((dbLists) async {
    final result = <ShoppingList>[];
    for (final dbList in dbLists) {
      final dbItems = await dao.getItemsForList(dbList.id);
      result.add(ShoppingListMapper.fromDbWithItems(dbList, dbItems));
    }
    return result;
  });
});

/// Archived shopping lists mapped to domain models.
final archivedShoppingListsProvider =
    StreamProvider<List<ShoppingList>>((ref) {
  final dao = ref.watch(shoppingListDaoProvider);
  return dao.watchArchivedLists().asyncMap((dbLists) async {
    final result = <ShoppingList>[];
    for (final dbList in dbLists) {
      final dbItems = await dao.getItemsForList(dbList.id);
      result.add(ShoppingListMapper.fromDbWithItems(dbList, dbItems));
    }
    return result;
  });
});

/// Single shopping list detail with items — used on the detail screen.
final shoppingListDetailProvider =
    StreamProvider.family<ShoppingList?, String>((ref, id) {
  final dao = ref.watch(shoppingListDaoProvider);
  return dao.watchListById(id).asyncMap((dbList) async {
    if (dbList == null) return null;
    final dbItems = await dao.getItemsForList(dbList.id);
    return ShoppingListMapper.fromDbWithItems(dbList, dbItems);
  });
});

/// Items for a specific list, mapped to domain models.
final shoppingListItemsProvider =
    StreamProvider.family<List<ShoppingListItem>, String>((ref, listId) {
  final dao = ref.watch(shoppingListDaoProvider);
  return dao.watchItemsForList(listId).map(
    (dbItems) => dbItems.map(ShoppingListMapper.itemFromDb).toList(),
  );
});
