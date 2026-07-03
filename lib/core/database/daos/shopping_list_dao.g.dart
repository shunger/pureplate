// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_dao.dart';

// ignore_for_file: type=lint
mixin _$ShoppingListDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShoppingListsTable get shoppingLists => attachedDatabase.shoppingLists;
  $ProductsTable get products => attachedDatabase.products;
  $ShoppingListItemsTable get shoppingListItems =>
      attachedDatabase.shoppingListItems;
  ShoppingListDaoManager get managers => ShoppingListDaoManager(this);
}

class ShoppingListDaoManager {
  final _$ShoppingListDaoMixin _db;
  ShoppingListDaoManager(this._db);
  $$ShoppingListsTableTableManager get shoppingLists =>
      $$ShoppingListsTableTableManager(_db.attachedDatabase, _db.shoppingLists);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db.attachedDatabase, _db.products);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(
        _db.attachedDatabase,
        _db.shoppingListItems,
      );
}
