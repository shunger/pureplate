import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';

import '../../../helpers/test_database.dart';

/// DAO behaviour the Firestore sync orchestrators depend on.
void main() {
  late AppDatabase db;
  final created = DateTime(2026, 1, 1);

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  group('PantryDao sync helpers', () {
    PantryItemsCompanion item(String id, {double quantity = 1}) =>
        PantryItemsCompanion(
          id: Value(id),
          name: const Value('Milk'),
          quantity: Value(quantity),
          firestorePantryId: const Value('home'),
          firestoreItemId: const Value('fs-milk'),
          createdAt: Value(created),
          updatedAt: Value(created),
        );

    test('a remote update keeps the local id and createdAt', () async {
      await db.pantryDao.insertItem(item('local-milk'));

      await db.pantryDao.upsertByFirestoreItemId(
        item('fresh-uuid', quantity: 3).copyWith(
          createdAt: Value(DateTime(2026, 9, 14)),
          updatedAt: Value(DateTime(2026, 9, 14)),
        ),
      );

      final rows = await db.pantryDao.getAllItems();
      expect(rows, hasLength(1));
      expect(rows.single.id, 'local-milk');
      expect(rows.single.createdAt, created);
      expect(rows.single.quantity, 3);
    });

    test('unlinkItemsForPantry keeps the items but drops the links', () async {
      await db.pantryDao.insertItem(item('local-milk'));

      await db.pantryDao.unlinkItemsForPantry('home');

      final row = await db.pantryDao.getItemById('local-milk');
      expect(row, isNotNull);
      expect(row!.firestorePantryId, isNull);
      expect(row.firestoreItemId, isNull);
    });
  });

  group('ShoppingListDao sync helpers', () {
    setUp(() async {
      await db.shoppingListDao.insertList(ShoppingListsCompanion(
        id: const Value('list-1'),
        name: const Value('Groceries'),
        firestoreId: const Value('fs-list'),
        createdAt: Value(created),
        updatedAt: Value(created),
      ));
    });

    ShoppingListItemsCompanion item(String id, {bool completed = false}) =>
        ShoppingListItemsCompanion(
          id: Value(id),
          listId: const Value('list-1'),
          name: const Value('Eggs'),
          isCompleted: Value(completed),
          firestoreListId: const Value('fs-list'),
          firestoreItemId: const Value('fs-eggs'),
          addedAt: Value(created),
          updatedAt: Value(created),
        );

    test('a remote update keeps the local id and addedAt', () async {
      await db.shoppingListDao.insertItem(item('local-eggs'));

      await db.shoppingListDao.upsertByFirestoreItemId(
        item('fresh-uuid', completed: true)
            .copyWith(addedAt: Value(DateTime(2026, 9, 14))),
      );

      final rows = await db.shoppingListDao.getItemsForList('list-1');
      expect(rows, hasLength(1));
      expect(rows.single.id, 'local-eggs');
      expect(rows.single.addedAt, created);
      expect(rows.single.isCompleted, isTrue);
    });

    test('getListByFirestoreId finds the linked list', () async {
      final list = await db.shoppingListDao.getListByFirestoreId('fs-list');
      expect(list?.id, 'list-1');
      expect(await db.shoppingListDao.getListByFirestoreId('other'), isNull);
    });

    test('unlinkList keeps the list and items but drops the links', () async {
      await db.shoppingListDao.insertItem(item('local-eggs'));

      await db.shoppingListDao.unlinkList('list-1');

      final list = await db.shoppingListDao.getListById('list-1');
      final row = await db.shoppingListDao.getItemById('local-eggs');
      expect(list!.firestoreId, isNull);
      expect(row!.firestoreListId, isNull);
      expect(row.firestoreItemId, isNull);
    });
  });
}
