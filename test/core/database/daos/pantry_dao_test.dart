import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/pantry_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PantryDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.pantryDao;
  });

  tearDown(() async {
    await db.close();
  });

  PantryItemsCompanion _makeItem({
    required String id,
    String name = 'Test Item',
    double quantity = 1,
    DateTime? expiresAt,
    String location = 'pantry',
    bool isStaple = false,
    String? firestorePantryId,
    String? firestoreItemId,
  }) {
    final now = DateTime.now();
    return PantryItemsCompanion(
      id: Value(id),
      name: Value(name),
      quantity: Value(quantity),
      expiresAt: Value(expiresAt),
      location: Value(location),
      isStaple: Value(isStaple),
      firestorePantryId: Value(firestorePantryId),
      firestoreItemId: Value(firestoreItemId),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  group('PantryDao', () {
    group('CRUD', () {
      test('insert and get item', () async {
        await dao.insertItem(_makeItem(id: 'p1', name: 'Milk'));
        final item = await dao.getItemById('p1');
        expect(item, isNotNull);
        expect(item!.name, 'Milk');
      });

      test('update item', () async {
        await dao.insertItem(_makeItem(id: 'p1', name: 'Milk'));
        await dao.updateItem(PantryItemsCompanion(
          id: const Value('p1'),
          name: const Value('Almond Milk'),
          updatedAt: Value(DateTime.now()),
        ));
        final item = await dao.getItemById('p1');
        expect(item!.name, 'Almond Milk');
      });

      test('delete item', () async {
        await dao.insertItem(_makeItem(id: 'p1'));
        await dao.deleteItem('p1');
        final item = await dao.getItemById('p1');
        expect(item, isNull);
      });

      test('getAllItems returns inserted items', () async {
        await dao.insertItem(_makeItem(id: 'p1', name: 'A'));
        await dao.insertItem(_makeItem(id: 'p2', name: 'B'));
        final items = await dao.getAllItems();
        expect(items.length, 2);
      });
    });

    group('watchExpiringItems', () {
      test('returns items within N days', () async {
        await dao.insertItem(_makeItem(
          id: 'p1',
          name: 'Expiring',
          expiresAt: DateTime.now().add(const Duration(days: 3)),
        ));
        await dao.insertItem(_makeItem(
          id: 'p2',
          name: 'Fresh',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ));

        final items =
            await dao.watchExpiringItems(withinDays: 7).first;
        expect(items.any((i) => i.name == 'Expiring'), isTrue);
        expect(items.any((i) => i.name == 'Fresh'), isFalse);
      });

      test('excludes expired items', () async {
        await dao.insertItem(_makeItem(
          id: 'p1',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        ));

        final items =
            await dao.watchExpiringItems(withinDays: 7).first;
        expect(items, isEmpty);
      });

      test('excludes null expiresAt', () async {
        await dao.insertItem(_makeItem(id: 'p1', expiresAt: null));

        final items =
            await dao.watchExpiringItems(withinDays: 7).first;
        expect(items, isEmpty);
      });
    });

    group('watchExpiredItems', () {
      test('returns only past-expiry items', () async {
        await dao.insertItem(_makeItem(
          id: 'p1',
          name: 'Expired',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        ));
        await dao.insertItem(_makeItem(
          id: 'p2',
          name: 'Fresh',
          expiresAt: DateTime.now().add(const Duration(days: 10)),
        ));

        final items = await dao.watchExpiredItems().first;
        expect(items.length, 1);
        expect(items.first.name, 'Expired');
      });
    });

    group('watchItemsByLocation', () {
      test('filters by location', () async {
        await dao.insertItem(_makeItem(id: 'p1', location: 'fridge'));
        await dao.insertItem(_makeItem(id: 'p2', location: 'pantry'));

        final items = await dao.watchItemsByLocation('fridge').first;
        expect(items.length, 1);
        expect(items.first.location, 'fridge');
      });
    });

    group('watchStapleItems', () {
      test('returns only staple items', () async {
        await dao.insertItem(_makeItem(id: 'p1', isStaple: true));
        await dao.insertItem(_makeItem(id: 'p2', isStaple: false));

        final items = await dao.watchStapleItems().first;
        expect(items.length, 1);
        expect(items.first.isStaple, isTrue);
      });
    });

    group('upsertByFirestoreItemId', () {
      test('inserts new item', () async {
        await dao.upsertByFirestoreItemId(
            _makeItem(id: 'p1', name: 'New', firestoreItemId: 'fs-1'));
        final item = await dao.getItemById('p1');
        expect(item, isNotNull);
        expect(item!.name, 'New');
      });

      test('updates existing item with same firestoreItemId', () async {
        await dao.insertItem(
            _makeItem(id: 'p1', name: 'Old', firestoreItemId: 'fs-1'));

        await dao.upsertByFirestoreItemId(PantryItemsCompanion(
          id: const Value('p1'),
          name: const Value('Updated'),
          firestoreItemId: const Value('fs-1'),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));

        final item = await dao.getItemById('p1');
        expect(item, isNotNull);
        expect(item!.name, 'Updated');
      });
    });

    group('deleteItemsNotInRemoteSet', () {
      test('removes items not in remote set', () async {
        await dao.insertItem(_makeItem(
          id: 'p1',
          firestorePantryId: 'fp-1',
          firestoreItemId: 'fs-1',
        ));
        await dao.insertItem(_makeItem(
          id: 'p2',
          firestorePantryId: 'fp-1',
          firestoreItemId: 'fs-2',
        ));

        await dao.deleteItemsNotInRemoteSet('fp-1', {'fs-1'});

        final remaining = await dao.getAllItems();
        expect(remaining.length, 1);
        expect(remaining.first.firestoreItemId, 'fs-1');
      });

      test('keeps items present in remote set', () async {
        await dao.insertItem(_makeItem(
          id: 'p1',
          firestorePantryId: 'fp-1',
          firestoreItemId: 'fs-1',
        ));

        await dao.deleteItemsNotInRemoteSet('fp-1', {'fs-1'});

        final remaining = await dao.getAllItems();
        expect(remaining.length, 1);
      });

      test('ignores items with null firestoreItemId', () async {
        await dao.insertItem(_makeItem(
          id: 'p1',
          firestorePantryId: 'fp-1',
          firestoreItemId: null,
        ));

        await dao.deleteItemsNotInRemoteSet('fp-1', <String>{});

        final remaining = await dao.getAllItems();
        expect(remaining.length, 1);
      });
    });

    group('updateQuantity', () {
      test('updates quantity and timestamp', () async {
        await dao.insertItem(_makeItem(id: 'p1', quantity: 1));
        await dao.updateQuantity('p1', 5);

        final item = await dao.getItemById('p1');
        expect(item!.quantity, 5);
      });
    });

    group('updateLocation', () {
      test('updates location and timestamp', () async {
        await dao.insertItem(_makeItem(id: 'p1', location: 'pantry'));
        await dao.updateLocation('p1', 'freezer');

        final item = await dao.getItemById('p1');
        expect(item!.location, 'freezer');
      });
    });
  });
}
