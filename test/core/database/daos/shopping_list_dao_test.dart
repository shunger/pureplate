import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/shopping_list_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ShoppingListDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.shoppingListDao;
  });

  tearDown(() async {
    await db.close();
  });

  ShoppingListsCompanion _makeList({
    required String id,
    String name = 'Test List',
    bool isArchived = false,
  }) {
    final now = DateTime.now();
    return ShoppingListsCompanion(
      id: Value(id),
      name: Value(name),
      isArchived: Value(isArchived),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  ShoppingListItemsCompanion _makeItem({
    required String id,
    required String listId,
    String name = 'Test Item',
    bool isCompleted = false,
  }) {
    final now = DateTime.now();
    return ShoppingListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      name: Value(name),
      isCompleted: Value(isCompleted),
      addedAt: Value(now),
      updatedAt: Value(now),
    );
  }

  group('ShoppingListDao', () {
    group('List CRUD', () {
      test('insert and get list', () async {
        await dao.insertList(_makeList(id: 'l1', name: 'Groceries'));
        final list = await dao.getListById('l1');
        expect(list, isNotNull);
        expect(list!.name, 'Groceries');
      });

      test('delete list cascades items', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(_makeItem(id: 'i1', listId: 'l1'));
        await dao.insertItem(_makeItem(id: 'i2', listId: 'l1'));

        await dao.deleteList('l1');

        final list = await dao.getListById('l1');
        expect(list, isNull);

        final items = await dao.getItemsForList('l1');
        expect(items, isEmpty);
      });
    });

    group('archiveList', () {
      test('sets isArchived and dateShopped', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.archiveList('l1');

        final list = await dao.getListById('l1');
        expect(list!.isArchived, isTrue);
        expect(list.dateShopped, isNotNull);
      });
    });

    group('watchActiveLists', () {
      test('returns only non-archived lists', () async {
        await dao.insertList(_makeList(id: 'l1', isArchived: false));
        await dao.insertList(_makeList(id: 'l2', isArchived: true));

        final active = await dao.watchActiveLists().first;
        expect(active.length, 1);
        expect(active.first.id, 'l1');
      });
    });

    group('watchArchivedLists', () {
      test('returns only archived lists', () async {
        await dao.insertList(_makeList(id: 'l1', isArchived: false));
        await dao.insertList(_makeList(id: 'l2', isArchived: true));

        final archived = await dao.watchArchivedLists().first;
        expect(archived.length, 1);
        expect(archived.first.id, 'l2');
      });
    });

    group('Item operations', () {
      test('insert and get items for list', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(_makeItem(id: 'i1', listId: 'l1', name: 'Eggs'));

        final items = await dao.getItemsForList('l1');
        expect(items.length, 1);
        expect(items.first.name, 'Eggs');
      });

      test('delete item', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(_makeItem(id: 'i1', listId: 'l1'));
        await dao.deleteItem('i1');

        final items = await dao.getItemsForList('l1');
        expect(items, isEmpty);
      });

      test('toggle item completion', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(
            _makeItem(id: 'i1', listId: 'l1', isCompleted: false));

        await dao.toggleItemCompletion('i1', true);

        final items = await dao.getItemsForList('l1');
        expect(items.first.isCompleted, isTrue);
      });
    });

    group('Batch operations', () {
      test('clearCompleted removes only completed items', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(
            _makeItem(id: 'i1', listId: 'l1', isCompleted: true));
        await dao.insertItem(
            _makeItem(id: 'i2', listId: 'l1', isCompleted: false));

        await dao.clearCompletedItems('l1');

        final items = await dao.getItemsForList('l1');
        expect(items.length, 1);
        expect(items.first.id, 'i2');
      });

      test('checkAll marks all items as completed', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(
            _makeItem(id: 'i1', listId: 'l1', isCompleted: false));
        await dao.insertItem(
            _makeItem(id: 'i2', listId: 'l1', isCompleted: false));

        await dao.checkAllItems('l1');

        final items = await dao.getItemsForList('l1');
        expect(items.every((i) => i.isCompleted), isTrue);
      });

      test('resetAll marks all items as not completed', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(
            _makeItem(id: 'i1', listId: 'l1', isCompleted: true));
        await dao.insertItem(
            _makeItem(id: 'i2', listId: 'l1', isCompleted: true));

        await dao.resetAllItems('l1');

        final items = await dao.getItemsForList('l1');
        expect(items.every((i) => !i.isCompleted), isTrue);
      });

      test('deleteAllForList removes all items', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertItem(_makeItem(id: 'i1', listId: 'l1'));
        await dao.insertItem(_makeItem(id: 'i2', listId: 'l1'));

        await dao.deleteAllItemsForList('l1');

        final items = await dao.getItemsForList('l1');
        expect(items, isEmpty);
      });
    });

    group('moveItems', () {
      test('transfers items to target list', () async {
        await dao.insertList(_makeList(id: 'l1'));
        await dao.insertList(_makeList(id: 'l2'));
        await dao.insertItem(_makeItem(id: 'i1', listId: 'l1'));
        await dao.insertItem(_makeItem(id: 'i2', listId: 'l1'));

        await dao.moveItems(['i1', 'i2'], 'l2');

        final l1Items = await dao.getItemsForList('l1');
        final l2Items = await dao.getItemsForList('l2');
        expect(l1Items, isEmpty);
        expect(l2Items.length, 2);
      });
    });
  });
}
