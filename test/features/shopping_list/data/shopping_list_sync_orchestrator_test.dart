import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/providers/auth_providers.dart';
import 'package:pure_pantry/core/providers/database_providers.dart';
import 'package:pure_pantry/features/sharing/data/datasources/firestore_activity_service.dart';
import 'package:pure_pantry/features/sharing/data/datasources/firestore_list_sharing_service.dart';
import 'package:pure_pantry/features/sharing/data/datasources/remote_doc.dart';
import 'package:pure_pantry/features/shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';

import '../../../helpers/test_database.dart';

class _MockSharingService extends Mock implements FirestoreListSharingService {}

class _MockUser extends Mock implements User {}

class _MockActivityService extends Mock implements FirestoreActivityService {}

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
  late _MockActivityService activity;
  late ShoppingListSyncOrchestrator orchestrator;

  Future<void> settle() => pumpEventQueue(times: 100);

  Future<void> insertList(String id, {String? firestoreId}) =>
      db.shoppingListDao.insertList(
        ShoppingListsCompanion(
          id: Value(id),
          name: const Value('Groceries'),
          firestoreId: Value(firestoreId),
          createdAt: Value(DateTime(2026)),
          updatedAt: Value(DateTime(2026)),
        ),
      );

  Future<void> insertItem(
    String id, {
    String? firestoreItemId,
    bool completed = false,
  }) => db.shoppingListDao.insertItem(
    ShoppingListItemsCompanion(
      id: Value(id),
      listId: const Value('l1'),
      name: const Value('Milk'),
      isCompleted: Value(completed),
      firestoreListId: Value(firestoreItemId == null ? null : 'fs-l1'),
      firestoreItemId: Value(firestoreItemId),
      addedAt: Value(DateTime(2026)),
      updatedAt: Value(DateTime(2026)),
    ),
  );

  setUp(() {
    db = createTestDatabase();
    service = _MockSharingService();
    lists = StreamController<List<SharedListInfo>>();
    itemStreams = {};

    when(
      () => service.watchSharedListsForUser(any()),
    ).thenAnswer((_) => lists.stream);
    when(() => service.watchItemDocs(any())).thenAnswer((invocation) {
      final listId = invocation.positionalArguments.first as String;
      return itemStreams
          .putIfAbsent(listId, () => StreamController<List<RemoteDoc>>())
          .stream;
    });
    when(
      () => service.addItemsBatch(
        listId: any(named: 'listId'),
        uid: any(named: 'uid'),
        itemsByLocalId: any(named: 'itemsByLocalId'),
      ),
    ).thenAnswer((invocation) {
      final items =
          invocation.namedArguments[#itemsByLocalId]
              as Map<String, Map<String, dynamic>>;
      return {for (final localId in items.keys) localId: 'fs-$localId'};
    });
    when(() => service.deleteSharedList(any())).thenAnswer((_) async {});
    when(
      () => service.removeCollaborator(any(), any()),
    ).thenAnswer((_) async {});

    activity = _MockActivityService();
    orchestrator = ShoppingListSyncOrchestrator(
      dao: db.shoppingListDao,
      sharingService: service,
      activityService: activity,
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
      when(
        () => service.shareList(
          listId: any(named: 'listId'),
          displayName: any(named: 'displayName'),
          name: any(named: 'name'),
          storeName: any(named: 'storeName'),
        ),
      ).thenAnswer((_) async {
        linkedWhenShared = (await db.shoppingListDao.getListById(
          'l1',
        ))?.firestoreId;
      });
      orchestrator.startSync(_me);

      final firestoreListId = await orchestrator.shareList(
        localListId: 'l1',
        displayName: 'Me',
      );

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

      verify(
        () => service.updateItem(
          listId: 'fs-l1',
          itemId: 'fs-i1',
          uid: _me,
          fields: any(named: 'fields', that: containsPair('isChecked', true)),
        ),
      ).called(1);
    });

    test('check all pushes every linked item in one batch', () async {
      await insertItem('i1', firestoreItemId: 'fs-i1');
      await insertItem('i2', firestoreItemId: 'fs-i2');

      await orchestrator.setAllCompleted('l1', true);

      verify(
        () => service.updateItemsBatch(
          listId: 'fs-l1',
          uid: _me,
          fieldsByItemId: any(named: 'fieldsByItemId', that: hasLength(2)),
        ),
      ).called(1);
    });

    test('clearing completed items removes them remotely', () async {
      await insertItem('i1', firestoreItemId: 'fs-i1', completed: true);
      await insertItem('i2', firestoreItemId: 'fs-i2');

      await orchestrator.clearCompleted('l1');

      verify(
        () => service.removeItemsBatch(listId: 'fs-l1', itemIds: ['fs-i1']),
      ).called(1);
      expect(await db.shoppingListDao.getItemById('i2'), isNotNull);
    });

    test(
      'checking an item is logged for collaborators; check all is not',
      () async {
        await insertItem('i1', firestoreItemId: 'fs-i1');

        await orchestrator.toggleItemCompletion('i1', true);
        await orchestrator.setAllCompleted('l1', false);

        verify(
          () => activity.logListActivity(
            'fs-l1',
            type: 'itemChecked',
            actorUid: _me,
            actorDisplayName: any(named: 'actorDisplayName'),
            itemName: 'Milk',
            details: any(named: 'details'),
          ),
        ).called(1);
        verifyNoMoreInteractions(activity);
      },
    );

    test('adding an item pushes it', () async {
      await orchestrator.insertItem(
        ShoppingListItemsCompanion(
          id: const Value('new'),
          listId: const Value('l1'),
          name: const Value('Bread'),
          addedAt: Value(DateTime(2026)),
          updatedAt: Value(DateTime(2026)),
        ),
      );

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
      when(
        () => service.getList('fs-l1'),
      ).thenAnswer((_) async => _list('fs-l1', owner: _me));

      await orchestrator.deleteList('l1');

      verify(() => service.deleteSharedList('fs-l1')).called(1);
      verifyNever(() => service.removeCollaborator(any(), any()));
      expect(await db.shoppingListDao.getListById('l1'), isNull);
    });

    test('a collaborator only leaves the shared list', () async {
      when(
        () => service.getList('fs-l1'),
      ).thenAnswer((_) async => _list('fs-l1', owner: 'scanner-user'));

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
      final items = await db.shoppingListDao.getItemsByFirestoreListId(
        'fs-shared',
      );
      expect(items.single.name, 'Oregano');
      expect(items.single.category, 'spices');
    });

    const oregano = RemoteDoc('s1', {
      'productName': 'Oregano',
      'quantity': 2,
      'isChecked': false,
      'updatedBy': 'scanner-user',
    });

    test('are unlinked but kept, with their items, when access is lost',
        () async {
      lists.add([_list('fs-shared', owner: 'scanner-user')]);
      await settle();
      itemStreams['fs-shared']!.add([oregano]);
      await settle();

      lists.add([]);
      await settle();

      final local = await db.shoppingListDao.watchActiveLists().first;
      expect(local, hasLength(1));
      expect(local.single.firestoreId, isNull);
    });

    test('are deleted when access is lost and they are empty', () async {
      lists.add([_list('fs-shared', owner: 'scanner-user')]);
      await settle();
      itemStreams['fs-shared']!.add([]);
      await settle();

      lists.add([]);
      await settle();

      expect(await db.shoppingListDao.watchActiveLists().first, isEmpty);
    });

    SharedListInfo groceries(String id) => SharedListInfo(
          firestoreId: id,
          name: 'groceries ',
          ownerUid: 'scanner-user',
          collaborators: {
            _me: const ListCollaborator(
                uid: _me, role: 'editor', displayName: 'Me'),
          },
        );

    test('replace an empty list with the same name', () async {
      await insertList('l1'); // "Groceries", no items

      lists.add([groceries('fs-shared')]);
      await settle();
      itemStreams['fs-shared']!.add([oregano]);
      await settle();

      final local = await db.shoppingListDao.watchActiveLists().first;
      expect(local.map((l) => l.firestoreId), ['fs-shared']);
    });

    test('are left when empty and a same-name list has items', () async {
      await insertList('l1');
      await insertItem('milk'); // "Groceries" has Milk
      when(() => service.getList('fs-shared'))
          .thenAnswer((_) async => groceries('fs-shared'));

      lists.add([groceries('fs-shared')]);
      await settle();
      itemStreams['fs-shared']!.add([]);
      await settle();

      final local = await db.shoppingListDao.watchActiveLists().first;
      expect(local.map((l) => l.id), ['l1']);
      verify(() => service.removeCollaborator('fs-shared', _me)).called(1);
    });
  });

  test('joinList creates the local list and logs the join', () async {
    when(
      () => service.joinList(inviteCode: 'ABC234', uid: _me, displayName: 'Me'),
    ).thenAnswer((_) async => 'fs-joined');
    when(
      () => service.getList('fs-joined'),
    ).thenAnswer((_) async => _list('fs-joined', owner: 'scanner-user'));
    orchestrator.startSync(_me);

    await orchestrator.joinList(inviteCode: 'ABC234', displayName: 'Me');

    expect(
      await db.shoppingListDao.getListByFirestoreId('fs-joined'),
      isNotNull,
    );
    verify(
      () => activity.logListActivity(
        'fs-joined',
        type: 'collaboratorJoined',
        actorUid: _me,
        actorDisplayName: 'Me',
        itemName: any(named: 'itemName'),
        details: any(named: 'details'),
      ),
    ).called(1);
  });

  group('mergeSameNameList', () {
    Future<void> insertNamed(String id, String name) =>
        db.shoppingListDao.insertItem(
          ShoppingListItemsCompanion(
            id: Value(id),
            listId: const Value('l1'),
            name: Value(name),
            addedAt: Value(DateTime(2026)),
            updatedAt: Value(DateTime(2026)),
          ),
        );

    setUp(() async {
      // This phone's own, unshared "Groceries" with Milk and Eggs.
      await insertList('l1');
      await insertNamed('milk', 'Milk');
      await insertNamed('eggs', 'Eggs');
      // The scanner's list has the same name (other case and spacing) and
      // already has milk.
      when(() => service.getList('fs-joined')).thenAnswer(
        (_) async => SharedListInfo(
          firestoreId: 'fs-joined',
          name: ' groceries ',
          ownerUid: 'scanner-user',
        ),
      );
      when(() => service.getItemDocs('fs-joined')).thenAnswer(
        (_) async => [
          RemoteDoc('r-milk', {'name': 'milk'}),
        ],
      );
      orchestrator.startSync(_me);
    });

    test(
      'moves the own list into the joined copy, skipping duplicates',
      () async {
        await db.shoppingListDao.insertList(
          ShoppingListsCompanion(
            id: const Value('joined'),
            name: const Value(' groceries '),
            firestoreId: const Value('fs-joined'),
            createdAt: Value(DateTime(2026)),
            updatedAt: Value(DateTime(2026)),
          ),
        );

        expect(await orchestrator.mergeSameNameList('fs-joined'), isTrue);

        expect(await db.shoppingListDao.getListById('l1'), isNull);
        final items = await db.shoppingListDao.getItemsForList('joined');
        expect(items.map((i) => i.name), ['Eggs']);
        expect(items.single.firestoreItemId, 'fs-eggs');
        verify(
          () => service.addItemsBatch(
            listId: 'fs-joined',
            uid: _me,
            itemsByLocalId: any(
              named: 'itemsByLocalId',
              that: predicate<Map>(
                (m) => m.keys.toSet().containsAll(['eggs']) && m.length == 1,
              ),
            ),
          ),
        ).called(1);
      },
    );

    test('links the own list when there is no local copy yet', () async {
      expect(await orchestrator.mergeSameNameList('fs-joined'), isTrue);

      final linked = await db.shoppingListDao.getListById('l1');
      expect(linked!.firestoreId, 'fs-joined');
      final items = await db.shoppingListDao.getItemsForList('l1');
      expect(items.map((i) => i.name), ['Eggs']);
    });

    test('leaves lists that are already shared alone', () async {
      await db.shoppingListDao.updateListFirestoreId('l1', 'fs-other');

      expect(await orchestrator.mergeSameNameList('fs-joined'), isFalse);
      expect(await db.shoppingListDao.getItemsForList('l1'), hasLength(2));
    });
  });

  test(
    'the provider starts syncing for a user who is already signed in',
    () async {
      final user = _MockUser();
      when(() => user.uid).thenReturn(_me);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          firestoreListSharingServiceProvider.overrideWithValue(service),
          firestoreActivityServiceProvider.overrideWithValue(activity),
          currentUserProvider.overrideWith((ref) => Stream.value(user)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(currentUserProvider.future);
      container.read(shoppingListSyncOrchestratorProvider);

      verify(() => service.watchSharedListsForUser(_me)).called(1);
    },
  );
}
