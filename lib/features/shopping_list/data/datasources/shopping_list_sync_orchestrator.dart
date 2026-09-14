import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/shopping_list_dao.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart' show appDatabaseProvider;
import '../../../sharing/data/datasources/firestore_list_sharing_service.dart';
import '../../../sharing/data/datasources/remote_doc.dart';
import '../../../sharing/data/datasources/sync_tracker.dart';
import 'shopping_list_wire_mapper.dart';

/// Orchestrates bidirectional sync between local Drift shopping lists and
/// Firestore shared lists (shared with Smart Shopping Scanner).
///
/// - Local Drift DB is the primary read/write source. Every item mutation on a
///   list that might be shared goes through this class.
/// - Per-list sharing: each list can be shared independently. Lists shared
///   with the user by others are created locally as they appear.
class ShoppingListSyncOrchestrator {
  ShoppingListSyncOrchestrator({
    required this._dao,
    required this._sharingService,
    String? clientId,
  }) : _tracker = SyncTracker(clientId: clientId, logTag: 'ListSync');

  final ShoppingListDao _dao;
  final FirestoreListSharingService _sharingService;
  final SyncTracker _tracker;
  final _uuid = const Uuid();

  String? _currentUid;
  StreamSubscription<List<SharedListInfo>>? _listsSubscription;
  final Map<String, StreamSubscription<List<RemoteDoc>>> _itemListeners = {};

  // Lists left or deleted this session; ignored if a stale snapshot lists them.
  final Set<String> _departedListIds = {};

  String? get currentUid => _currentUid;

  // ── Lifecycle ─────────────────────────────────────────────

  /// Start syncing for [uid]. Calling again with the same user is a no-op.
  void startSync(String uid) {
    if (_currentUid == uid) return;
    stopSync();
    _currentUid = uid;

    _listsSubscription = _sharingService.watchSharedListsForUser(uid).listen(
      (lists) => _tracker.run('reconcile lists', () => _reconcileLists(lists)),
      onError: (Object e) => debugPrint('[ListSync] lists stream: $e'),
    );
  }

  /// Stop all sync activity. Call on sign-out or dispose.
  void stopSync() {
    _listsSubscription?.cancel();
    _listsSubscription = null;
    for (final sub in _itemListeners.values) {
      sub.cancel();
    }
    _itemListeners.clear();
    _departedListIds.clear();
    _tracker.reset();
    _currentUid = null;
  }

  // ── List-level reconciliation ─────────────────────────────

  Future<void> _reconcileLists(List<SharedListInfo> remoteLists) async {
    final remote = {
      for (final list in remoteLists)
        if (!_departedListIds.contains(list.firestoreId)) list.firestoreId: list,
    };

    for (final list in remote.values) {
      if (_itemListeners.containsKey(list.firestoreId)) continue;
      await _ensureLocalList(list);
      _attachItemListener(list.firestoreId);
    }

    final removed =
        _itemListeners.keys.where((id) => !remote.containsKey(id)).toList();
    for (final firestoreListId in removed) {
      await _itemListeners.remove(firestoreListId)?.cancel();
      final local = await _dao.getListByFirestoreId(firestoreListId);
      if (local != null) await _dao.unlinkList(local.id);
    }
  }

  Future<void> _ensureLocalList(SharedListInfo info) async {
    if (await _dao.getListByFirestoreId(info.firestoreId) != null) return;
    final now = DateTime.now();
    await _dao.insertList(ShoppingListsCompanion(
      id: Value(_uuid.v4()),
      name: Value(info.name),
      storeName: Value(info.storeName),
      firestoreId: Value(info.firestoreId),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  void _attachItemListener(String firestoreListId) {
    _itemListeners[firestoreListId] =
        _sharingService.watchItemDocs(firestoreListId).listen(
      (docs) => _tracker.run(
          'reconcile items', () => _reconcileItems(firestoreListId, docs)),
      onError: (Object e) => debugPrint('[ListSync] items stream: $e'),
    );
  }

  // ── Item-level reconciliation ─────────────────────────────

  Future<void> _reconcileItems(
      String firestoreListId, List<RemoteDoc> docs) async {
    if (!_itemListeners.containsKey(firestoreListId)) return;
    final local = await _dao.getListByFirestoreId(firestoreListId);
    if (local == null) return;

    final batch = _tracker.filter(docs, uid: _currentUid);
    final now = DateTime.now();
    for (final doc in batch.toApply) {
      await _dao.upsertByFirestoreItemId(ShoppingListWireMapper.toCompanion(
        newLocalId: _uuid.v4(),
        localListId: local.id,
        firestoreListId: firestoreListId,
        itemId: doc.id,
        data: doc.data,
        now: now,
      ));
    }
    await _dao.deleteItemsNotInRemoteSet(firestoreListId, batch.keepIds);
  }

  // ── Public mutation API ───────────────────────────────────

  /// Share an existing local list. Pushes the list and its items to Firestore
  /// and returns the shared list ID.
  Future<String> shareList({
    required String localListId,
    required String displayName,
  }) async {
    final uid = _currentUid;
    if (uid == null) throw const ListSharingException('Sign in to share lists.');
    final list = await _dao.getListById(localListId);
    if (list == null) throw const ListSharingException('List not found.');
    final existing = list.firestoreId;
    if (existing != null) return existing;

    // Link locally first so the shared list's snapshot finds this list instead
    // of creating a second local copy.
    final firestoreListId = _sharingService.newListId();
    await _dao.updateListFirestoreId(localListId, firestoreListId);
    try {
      await _sharingService.shareList(
        listId: firestoreListId,
        uid: uid,
        displayName: displayName,
        name: list.name,
        storeName: list.storeName,
      );
    } catch (_) {
      await _dao.updateListFirestoreId(localListId, null);
      rethrow;
    }

    await _pushNewItems(
        firestoreListId, uid, await _dao.getItemsForList(localListId));
    return firestoreListId;
  }

  /// Insert an item. Pushes it if the list is shared.
  Future<void> insertItem(ShoppingListItemsCompanion item) =>
      insertItems([item]);

  /// Insert items (possibly across lists). Pushes those on shared lists.
  Future<void> insertItems(List<ShoppingListItemsCompanion> items) async {
    if (items.isEmpty) return;
    await _dao.insertItems(items);

    final uid = _currentUid;
    if (uid == null) return;
    final idsByList = <String, List<String>>{};
    for (final item in items) {
      idsByList.putIfAbsent(item.listId.value, () => []).add(item.id.value);
    }
    for (final entry in idsByList.entries) {
      final firestoreListId = (await _dao.getListById(entry.key))?.firestoreId;
      if (firestoreListId == null) continue;
      final rows = <ShoppingListItem>[];
      for (final id in entry.value) {
        final row = await _dao.getItemById(id);
        if (row != null) rows.add(row);
      }
      await _pushNewItems(firestoreListId, uid, rows);
    }
  }

  /// Update an existing item. Pushes the changed fields.
  Future<void> updateItem(ShoppingListItemsCompanion item) async {
    await _dao.updateItem(item);
    await _pushFields(item.id.value, ShoppingListWireMapper.fromCompanion(item));
  }

  /// Delete an item locally and from its shared list.
  Future<void> deleteItem(String id) async {
    final row = await _dao.getItemById(id);
    await _dao.deleteItem(id);
    if (row != null) _removeRemote([row]);
  }

  /// Check or uncheck an item.
  Future<void> toggleItemCompletion(String id, bool isCompleted) async {
    await _dao.toggleItemCompletion(id, isCompleted);
    await _pushFields(id, {'isChecked': isCompleted});
  }

  /// Check or uncheck every item on a list.
  Future<void> setAllCompleted(String localListId, bool isCompleted) async {
    if (isCompleted) {
      await _dao.checkAllItems(localListId);
    } else {
      await _dao.resetAllItems(localListId);
    }

    final uid = _currentUid;
    if (uid == null) return;
    final linked = (await _dao.getItemsForList(localListId))
        .where((row) => row.firestoreListId != null && row.firestoreItemId != null);
    final byList = <String, Map<String, Map<String, dynamic>>>{};
    for (final row in linked) {
      byList.putIfAbsent(row.firestoreListId!, () => {})[row.firestoreItemId!] =
          _tracker.stamp({'isChecked': isCompleted});
    }
    for (final entry in byList.entries) {
      _sharingService.updateItemsBatch(
          listId: entry.key, uid: uid, fieldsByItemId: entry.value);
    }
  }

  /// Remove every checked item from a list.
  Future<void> clearCompleted(String localListId) async {
    final completed = (await _dao.getItemsForList(localListId))
        .where((row) => row.isCompleted)
        .toList();
    await _dao.clearCompletedItems(localListId);
    _removeRemote(completed);
  }

  /// Delete a list locally. If it's shared, the owner deletes the shared list
  /// for everyone; a collaborator just leaves it.
  Future<void> deleteList(String localListId) async {
    final list = await _dao.getListById(localListId);
    final firestoreListId = list?.firestoreId;
    final uid = _currentUid;
    if (firestoreListId != null && uid != null) {
      try {
        await _tracker.exclusive(() => _leaveOrDelete(firestoreListId, uid));
      } catch (e) {
        debugPrint('[ListSync] leaving shared list failed: $e');
      }
    }
    await _dao.deleteList(localListId);
  }

  /// Leave a shared list the user doesn't own. The local copy is kept, unlinked.
  Future<void> leaveList(String firestoreListId) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _tracker.exclusive(() async {
      await _detach(firestoreListId);
      await _sharingService.removeCollaborator(firestoreListId, uid);
    });
  }

  // ── Helpers ───────────────────────────────────────────────

  Future<void> _leaveOrDelete(String firestoreListId, String uid) async {
    await _detach(firestoreListId);
    final info = await _sharingService.getList(firestoreListId);
    if (info == null) return;
    if (info.ownerUid == uid) {
      await _sharingService.deleteSharedList(firestoreListId);
    } else {
      await _sharingService.removeCollaborator(firestoreListId, uid);
    }
  }

  Future<void> _detach(String firestoreListId) async {
    _departedListIds.add(firestoreListId);
    await _itemListeners.remove(firestoreListId)?.cancel();
    final local = await _dao.getListByFirestoreId(firestoreListId);
    if (local != null) await _dao.unlinkList(local.id);
  }

  Future<void> _pushNewItems(
      String firestoreListId, String uid, List<ShoppingListItem> rows) async {
    if (rows.isEmpty) return;
    final ids = _sharingService.addItemsBatch(
      listId: firestoreListId,
      uid: uid,
      itemsByLocalId: {
        for (final row in rows)
          row.id: _tracker.stamp(ShoppingListWireMapper.fromRow(row)),
      },
    );
    _tracker.markCreated(ids.values);
    for (final entry in ids.entries) {
      await _dao.updateFirestoreIds(entry.key, firestoreListId, entry.value);
    }
  }

  Future<void> _pushFields(String localId, Map<String, dynamic> fields) async {
    final uid = _currentUid;
    if (uid == null || fields.isEmpty) return;
    final row = await _dao.getItemById(localId);
    final firestoreListId = row?.firestoreListId;
    final itemId = row?.firestoreItemId;
    if (firestoreListId == null || itemId == null) return;
    _sharingService.updateItem(
      listId: firestoreListId,
      itemId: itemId,
      uid: uid,
      fields: _tracker.stamp(fields),
    );
  }

  void _removeRemote(List<ShoppingListItem> rows) {
    final byList = <String, List<String>>{};
    for (final row in rows) {
      final firestoreListId = row.firestoreListId;
      final itemId = row.firestoreItemId;
      if (firestoreListId == null || itemId == null) continue;
      byList.putIfAbsent(firestoreListId, () => []).add(itemId);
    }
    for (final entry in byList.entries) {
      _tracker.markDeleted(entry.value);
      _sharingService.removeItemsBatch(listId: entry.key, itemIds: entry.value);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────

final shoppingListSyncOrchestratorProvider =
    Provider<ShoppingListSyncOrchestrator>((ref) {
  final db = ref.watch(appDatabaseProvider);

  final orchestrator = ShoppingListSyncOrchestrator(
    dao: db.shoppingListDao,
    sharingService: ref.watch(firestoreListSharingServiceProvider),
  );

  // fireImmediately: the user is usually already signed in when this provider
  // is first read, and a plain listen only reports later changes.
  ref.listen(currentUserProvider, (_, next) {
    final uid = next.value?.uid;
    if (uid != null) {
      orchestrator.startSync(uid);
    } else {
      orchestrator.stopSync();
    }
  }, fireImmediately: true);

  ref.onDispose(orchestrator.stopSync);
  return orchestrator;
});
