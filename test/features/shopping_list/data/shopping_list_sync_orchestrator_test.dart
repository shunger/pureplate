import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/providers/auth_providers.dart';
import 'package:pure_pantry/core/providers/database_providers.dart';
import 'package:pure_pantry/features/sharing/data/datasources/firestore_list_sharing_service.dart';
import 'package:pure_pantry/features/sharing/data/datasources/remote_doc.dart';
import 'package:pure_pantry/features/shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';

import '../../../helpers/test_database.dart';

class _MockSharingService extends Mock implements FirestoreListSharingService {}

class _MockUser extends Mock implements User {}

const _me = 'user-me';

SharedListInfo _list(String id, {required String owner}) => SharedListInfo(
      firestoreId: id,
      name: 'Shared groceries',
      ownerUid: owner,
      collaborators: {
        owner: ListCollaborator(uid: owner, role: 'owner', displayName: owner),
        _me: const ListCollaborator(uid: _me, role: 'editor', displayName: 'Me'),
      },
    );

void main() {
  late AppDatabase db;
  late _MockSharingService service;
  late StreamController<List<SharedListInfo>> lists;
  late Map<String, StreamController<List<RemoteDoc>>> itemStreams;
  late ShoppingListSyncOrchestrator orchestrator;

  Future<void> settle() => pumpEventQueue(times: 100);

  Future<void> insertList(String id, {String? firestoreId}) =>
      db.shoppingListDao.insertList(ShoppingListsCompanion(
        id: Value(id),
        name: const Value('Groceries'),
        firestoreId: Value(firestoreId),
        createdAt: Value(DateTime(2026)),
        updatedAt: Value(DateTime(2026)),
      ));

  Future<void> insertItem(String id,
          {String? firestoreItemId, bool completed = false}) =>
      db.shoppingListDao.insertItem(ShoppingListItemsCompanion(
        id: Value(id),
        listId: const Value('l1'),
        name: const Value('Milk'),
        isCompleted: Value(completed),
        firestoreListId: Value(firestoreItemId == null ? null : 'fs-l1'),
        firestoreItemId: Value(firestoreItemId),
        addedAt: Value(DateTime(2026)),
        updatedAt: Value(DateTime(2026)),
      ));

  setUp(() {
    db = createTestDatabase();
    service = _MockSharingService();
    lists = StreamController<List<SharedListInfo>>();
    itemStreams = {};

    when(() => service.watchSharedListsForUser(any()))
        .thenAnswer((_) => lists.stream);
    when(() => service.watchItemDocs(any())).thenAnswer((invocation) {
      final listId = invocation.positionalArguments.first as String;
      return itemStreams
          .putIfAbsent(listId, () => StreamController<List<RemoteDoc>>())
          .stream;
    });
    when(() => service.addItemsBatch(
          listId: any(named: 'listId'),
          uid: any(named: 'uid'),
          itemsByLocalId: any(named: 'itemsByLocalId'),
        )).thenAnswer((invocation) {
      final items = invocation.namedArguments[#itemsByLocalId]
          as Map<String, Map<String, dynamic>>;
      return {for (final localId in items.keys) localId: 'fs-$localId'};
    });
    when(() => service.deleteSharedList(any())).thenAnswer((_) async {});
    when(() => service.removeCollaborator(any(), any()))
        .thenAnswer((_) async {});

    orchestrator = ShoppingListSyncOrchestrator(
      dao: db.shoppingListDao,
      sharingService: service,
      clientId: 'client-under-test',
    );
  });

  tearDown(() async {
    orchestrator.stopSync();
    lists.close();
    for (final controller in itemStreams.values) {
      controller.close();
    }
    await db.close();
  });

  group('shareList', () {
    test('links the local list before creating the shared list', () async {
      await insertList('l1');
      await insertItem('i1');
      when(() => service.newListId()).thenReturn('fs-l1');
      String? linkedWhenShared;
      when(() => service.shareList(
            listId: any(named: 'listId'),
            uid: any(named: 'uid'),
            displayName: any(named: 'displayName'),
            name: any(named: 'name'),
            storeName: any(named: 'storeName'),
          )).thenAnswer((_) async {
        linkedWhenShared = (await db.shoppingListDao.getListById('l1'))?.firestoreId;
      });
      orchestrator.startSync(_me);

      final firestoreListId =
          await orchestrator.shareList(localListId: 'l1', displayName: 'Me');

      expect(firestoreListId, 'fs-l1');
      expect(linkedWhenShared, 'fs-l1');
      final item = await db.shoppingListDao.getItemById('i1');
      expect(item!.firestoreListId, 'fs-l1');
      expect(item.firestoreItemId, 'fs-i1');
    });

    test('fails clearly when nobody is signed in', () async {
      await insertList('l1');

      expect(
        () => orchestrator.shareList(localListId: 'l1', displayName: 'Me'),
        throwsA(isA<ListSharingException>()),
      );
    });
  });

  group('item changes on a shared list', () {
    setUp(() async {
      await insertList('l1', firestoreId: 'fs-l1');
      orchestrator.startSync(_me);
    });

    test('checking an item pushes isChecked', () async {
      await insertItem('i1', firestoreItemId: 'fs-i1');

      await orchestrator.toggleItemCompletion('i1', true);

      verify(() => service.updateItem(
            listId: 'fs-l1',
            itemId: 'fs-i1',
            uid: _me,
            fields: any(named: 'fields', that: containsPair('isChecked', true)),
          )).called(1);
    });

    test('check all pushes every linked item in one batch', () async {
      await insertItem('i1', firestoreItemId: 'fs-i1');
      await insertItem('i2', firestoreItemId: 'fs-i2');

      await orchestrator.setAllCompleted('l1', true);

      verify(() => service.updateItemsBatch(
            listId: 'fs-l1',
            uid: _me,
            fieldsByItemId: any(named: 'fieldsByItemId', that: hasLength(2)),
          )).called(1);
    });

    test('clearing completed items removes them remotely', () async {
      await insertItem('i1', firestoreItemId: 'fs-i1', completed: true);
      await insertItem('i2', firestoreItemId: 'fs-i2');

      await orchestrator.clearCompleted('l1');

      verify(() => service.removeItemsBatch(listId: 'fs-l1', itemIds: ['fs-i1']))
          .called(1);
      expect(await db.shoppingListDao.getItemById('i2'), isNotNull);
    });

    test('adding an item pushes it', () async {
      await orchestrator.insertItem(ShoppingListItemsCompanion(
        id: const Value('new'),
        listId: const Value('l1'),
        name: const Value('Bread'),
        addedAt: Value(DateTime(2026)),
        updatedAt: Value(DateTime(2026)),
      ));

      final row = await db.shoppingListDao.getItemById('new');
      expect(row!.firestoreItemId, 'fs-new');
    });
  });

  group('deleteList', () {
    setUp(() async {
      await insertList('l1', firestoreId: 'fs-l1');
      orchestrator.startSync(_me);
    });

    test('an owner deletes the shared list for everyone', () async {
      when(() => service.getList('fs-l1'))
          .thenAnswer((_) async => _list('fs-l1', owner: _me));

      await orchestrator.deleteList('l1');

      verify(() => service.deleteSharedList('fs-l1')).called(1);
      verifyNever(() => service.removeCollaborator(any(), any()));
      expect(await db.shoppingListDao.getListById('l1'), isNull);
    });

    test('a collaborator only leaves the shared list', () async {
      when(() => service.getList('fs-l1'))
          .thenAnswer((_) async => _list('fs-l1', owner: 'scanner-user'));

      await orchestrator.deleteList('l1');

      verify(() => service.removeCollaborator('fs-l1', _me)).called(1);
      verifyNever(() => service.deleteSharedList(any()));
      expect(await db.shoppingListDao.getListById('l1'), isNull);
    });
  });

  group('lists shared with the user', () {
    setUp(() => orchestrator.startSync(_me));

    test('are created locally once and receive items', () async {
      lists.add([_list('fs-shared', owner: 'scanner-user')]);
      await settle();
      itemStreams['fs-shared']!.add([
        const RemoteDoc('s1', {
          'productName': 'Oregano',
          'quantity': 2,
          'isChecked': false,
          'category': 'spicesAndHerbs',
          'updatedBy': 'scanner-user',
        }),
      ]);
      lists.add([_list('fs-shared', owner: 'scanner-user')]);
      await settle();

      final local = await db.shoppingListDao.watchActiveLists().first;
      expect(local.where((l) => l.firestoreId == 'fs-shared'), hasLength(1));
      final items =
          await db.shoppingListDao.getItemsByFirestoreListId('fs-shared');
      expect(items.single.name, 'Oregano');
      expect(items.single.category, 'spices');
    });

    test('are unlinked but kept when the user loses access', () async {
      lists.add([_list('fs-shared', owner: 'scanner-user')]);
      await settle();

      lists.add([]);
      await settle();

      final local = await db.shoppingListDao.watchActiveLists().first;
      expect(local, hasLength(1));
      expect(local.single.firestoreId, isNull);
    });
  });

  test('the provider starts syncing for a user who is already signed in',
      () async {
    final user = _MockUser();
    when(() => user.uid).thenReturn(_me);
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      firestoreListSharingServiceProvider.overrideWithValue(service),
      currentUserProvider.overrideWith((ref) => Stream.value(user)),
    ]);
    addTearDown(container.dispose);

    await container.read(currentUserProvider.future);
    container.read(shoppingListSyncOrchestratorProvider);

    verify(() => service.watchSharedListsForUser(_me)).called(1);
  });
}
