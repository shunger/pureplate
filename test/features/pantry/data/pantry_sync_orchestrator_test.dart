import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/providers/auth_providers.dart';
import 'package:pure_pantry/core/providers/database_providers.dart';
import 'package:pure_pantry/features/pantry/data/datasources/pantry_sync_orchestrator.dart';
import 'package:pure_pantry/features/sharing/data/datasources/firestore_pantry_sharing_service.dart';
import 'package:pure_pantry/features/sharing/data/datasources/remote_doc.dart';

import '../../../helpers/test_database.dart';

class _MockSharingService extends Mock
    implements FirestorePantrySharingService {}

class _MockUser extends Mock implements User {}

const _me = 'user-me';
const _client = 'client-under-test';

SharedPantryInfo _pantry(String id,
    {required String owner, List<String> members = const []}) {
  return SharedPantryInfo(
    firestoreId: id,
    name: id,
    ownerUid: owner,
    collaborators: {
      for (final uid in {owner, ...members})
        uid: PantryCollaborator(
          uid: uid,
          role: uid == owner ? 'owner' : 'editor',
          displayName: uid,
        ),
    },
  );
}

void main() {
  late AppDatabase db;
  late _MockSharingService service;
  late StreamController<List<SharedPantryInfo>> pantries;
  late Map<String, StreamController<List<RemoteDoc>>> itemStreams;
  late PantrySyncOrchestrator orchestrator;

  Future<void> settle() => pumpEventQueue(times: 100);

  Future<void> insertLocal(
    String id, {
    String name = 'Milk',
    double quantity = 1,
    String? pantryId,
    String? itemId,
    DateTime? expiresAt,
  }) {
    return db.pantryDao.insertItem(PantryItemsCompanion(
      id: Value(id),
      name: Value(name),
      quantity: Value(quantity),
      unitType: const Value('each'),
      location: const Value('fridge'),
      expiresAt: Value(expiresAt),
      firestorePantryId: Value(pantryId),
      firestoreItemId: Value(itemId),
      createdAt: Value(DateTime(2026)),
      updatedAt: Value(DateTime(2026)),
    ));
  }

  RemoteDoc milkDoc({required num quantity, String? updatedBy, String? client}) {
    return RemoteDoc('fs-milk', {
      'name': 'Milk',
      'quantity': quantity,
      'unitType': 'each',
      'location': 'fridge',
      'updatedBy': updatedBy,
      updatedByClientField: client,
    });
  }

  setUp(() {
    db = createTestDatabase();
    service = _MockSharingService();
    pantries = StreamController<List<SharedPantryInfo>>();
    itemStreams = {};

    when(() => service.watchSharedPantriesForUser(any()))
        .thenAnswer((_) => pantries.stream);
    when(() => service.watchItemDocs(any())).thenAnswer((invocation) {
      final pantryId = invocation.positionalArguments.first as String;
      return itemStreams
          .putIfAbsent(pantryId, () => StreamController<List<RemoteDoc>>())
          .stream;
    });
    when(() => service.addItemsBatch(
          pantryId: any(named: 'pantryId'),
          uid: any(named: 'uid'),
          itemsByLocalId: any(named: 'itemsByLocalId'),
        )).thenAnswer((invocation) {
      final items = invocation.namedArguments[#itemsByLocalId]
          as Map<String, Map<String, dynamic>>;
      return {for (final localId in items.keys) localId: 'fs-$localId'};
    });

    orchestrator = PantrySyncOrchestrator(
      pantryDao: db.pantryDao,
      preferencesDao: db.preferencesDao,
      sharingService: service,
      clientId: _client,
    );
  });

  tearDown(() async {
    orchestrator.stopSync();
    pantries.close();
    for (final controller in itemStreams.values) {
      controller.close();
    }
    await db.close();
  });

  Future<void> startWithHousehold() async {
    await db.preferencesDao.setSharedPantryId('home');
    orchestrator.startSync(_me);
    pantries.add([
      _pantry('home', owner: 'someone-else', members: [_me]),
      _pantry('personal', owner: _me),
    ]);
    await settle();
  }

  test('pushes new items only to the active pantry', () async {
    await startWithHousehold();

    await orchestrator.insertItem(PantryItemsCompanion(
      id: const Value('eggs'),
      name: const Value('Eggs'),
      createdAt: Value(DateTime(2026)),
      updatedAt: Value(DateTime(2026)),
    ));

    verify(() => service.addItemsBatch(
          pantryId: 'home',
          uid: _me,
          itemsByLocalId: any(named: 'itemsByLocalId'),
        )).called(1);
    verifyNever(() => service.addItemsBatch(
          pantryId: 'personal',
          uid: any(named: 'uid'),
          itemsByLocalId: any(named: 'itemsByLocalId'),
        ));
    final row = await db.pantryDao.getItemById('eggs');
    expect(row!.firestorePantryId, 'home');
    expect(row.firestoreItemId, 'fs-eggs');
  });

  test('adopts unsynced local items into the active pantry only', () async {
    await insertLocal('eggs', name: 'Eggs');

    await startWithHousehold();

    final pushed = verify(() => service.addItemsBatch(
          pantryId: captureAny(named: 'pantryId'),
          uid: _me,
          itemsByLocalId: captureAny(named: 'itemsByLocalId'),
        )).captured;
    expect(pushed, hasLength(2));
    expect(pushed[0], 'home');
    expect((pushed[1] as Map).keys, ['eggs']);
  });

  test('a collaborator update keeps the local item id', () async {
    await insertLocal('local-milk', pantryId: 'home', itemId: 'fs-milk');
    await startWithHousehold();

    itemStreams['home']!.add([milkDoc(quantity: 3, updatedBy: 'someone-else')]);
    await settle();

    final rows = await db.pantryDao.getAllItems();
    expect(rows, hasLength(1));
    expect(rows.single.id, 'local-milk');
    expect(rows.single.quantity, 3);
  });

  test('skips its own echoes but applies scanner edits to them', () async {
    await insertLocal('local-milk', pantryId: 'home', itemId: 'fs-milk');
    await startWithHousehold();

    itemStreams['home']!
        .add([milkDoc(quantity: 9, updatedBy: _me, client: _client)]);
    await settle();
    expect((await db.pantryDao.getItemById('local-milk'))!.quantity, 1);

    // The scanner doesn't write updatedByClient, so ours is left behind while
    // updatedBy changes to the scanner user.
    itemStreams['home']!
        .add([milkDoc(quantity: 7, updatedBy: 'scanner-user', client: _client)]);
    await settle();
    expect((await db.pantryDao.getItemById('local-milk'))!.quantity, 7);
  });

  test('applies changes the same user made on another device', () async {
    await insertLocal('local-milk', pantryId: 'home', itemId: 'fs-milk');
    await startWithHousehold();

    itemStreams['home']!
        .add([milkDoc(quantity: 5, updatedBy: _me, client: 'other-device')]);
    await settle();

    expect((await db.pantryDao.getItemById('local-milk'))!.quantity, 5);
  });

  test('a stale snapshot does not delete a just-created item', () async {
    await startWithHousehold();
    await orchestrator.insertItem(PantryItemsCompanion(
      id: const Value('eggs'),
      name: const Value('Eggs'),
      createdAt: Value(DateTime(2026)),
      updatedAt: Value(DateTime(2026)),
    ));

    itemStreams['home']!.add([]); // Taken before the write reached Firestore.
    await settle();
    expect(await db.pantryDao.getItemById('eggs'), isNotNull);

    itemStreams['home']!.add([
      RemoteDoc('fs-eggs', {
        'name': 'Eggs',
        'updatedBy': _me,
        updatedByClientField: _client,
      }),
    ]);
    itemStreams['home']!.add([]); // A collaborator then deletes it.
    await settle();
    expect(await db.pantryDao.getItemById('eggs'), isNull);
  });

  group('joinAndMerge', () {
    setUp(() async {
      await db.preferencesDao.setSharedPantryId('personal');
      await insertLocal('milk',
          quantity: 1,
          pantryId: 'personal',
          itemId: 'p-milk',
          expiresAt: DateTime(2026, 9, 20));
      await insertLocal('eggs',
          name: 'Eggs', quantity: 12, pantryId: 'personal', itemId: 'p-eggs');

      when(() => service.joinPantry(
            inviteCode: 'ABC234',
            uid: _me,
            displayName: 'Me',
          )).thenAnswer((_) async => 'home');
      when(() => service.getItemDocs('home')).thenAnswer((_) async => [
            RemoteDoc('h-milk', {
              'name': 'milk',
              'quantity': 2,
              'unitType': 'each',
              'location': 'fridge',
              'expiresAt': Timestamp.fromDate(DateTime(2026, 9, 25)),
              'updatedBy': 'someone-else',
            }),
          ]);
      when(() => service.deleteSharedPantry(any())).thenAnswer((_) async {});
      when(() => service.removeCollaborator(any(), any()))
          .thenAnswer((_) async {});

      orchestrator.startSync(_me);
    });

    test('merges matching items and adds the rest to the household', () async {
      when(() => service.getPantry('personal'))
          .thenAnswer((_) async => _pantry('personal', owner: _me));

      final householdId = await orchestrator.joinAndMerge(
          inviteCode: 'ABC234', displayName: 'Me');

      expect(householdId, 'home');
      final milk = await db.pantryDao.getItemById('milk');
      expect(milk!.quantity, 3);
      expect(milk.expiresAt, DateTime(2026, 9, 20));
      expect(milk.firestorePantryId, 'home');
      expect(milk.firestoreItemId, 'h-milk');
      verify(() => service.updateItem(
            pantryId: 'home',
            itemId: 'h-milk',
            uid: _me,
            fields: any(named: 'fields', that: containsPair('quantity', 3.0)),
          )).called(1);

      final eggs = await db.pantryDao.getItemById('eggs');
      expect(eggs!.firestorePantryId, 'home');
      expect(eggs.firestoreItemId, 'fs-eggs');

      expect((await db.preferencesDao.getPreferences()).sharedPantryId, 'home');
    });

    test('deletes the previous pantry when the user was its only member',
        () async {
      when(() => service.getPantry('personal'))
          .thenAnswer((_) async => _pantry('personal', owner: _me));

      await orchestrator.joinAndMerge(inviteCode: 'ABC234', displayName: 'Me');

      verify(() => service.deleteSharedPantry('personal')).called(1);
      verifyNever(() => service.removeCollaborator(any(), any()));
    });

    test('only leaves the previous pantry when others still use it', () async {
      when(() => service.getPantry('personal')).thenAnswer((_) async =>
          _pantry('personal', owner: _me, members: ['partner']));

      await orchestrator.joinAndMerge(inviteCode: 'ABC234', displayName: 'Me');

      verify(() => service.removeCollaborator('personal', _me)).called(1);
      verifyNever(() => service.deleteSharedPantry(any()));
    });
  });

  test('the provider starts syncing for a user who is already signed in',
      () async {
    final user = _MockUser();
    when(() => user.uid).thenReturn(_me);
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      firestorePantrySharingServiceProvider.overrideWithValue(service),
      currentUserProvider.overrideWith((ref) => Stream.value(user)),
    ]);
    addTearDown(container.dispose);

    await container.read(currentUserProvider.future);
    container.read(pantrySyncOrchestratorProvider);

    verify(() => service.watchSharedPantriesForUser(_me)).called(1);
  });
}
