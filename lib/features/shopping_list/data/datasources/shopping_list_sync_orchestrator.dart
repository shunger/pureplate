import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/services/error_reporter.dart';
import '../../../../core/database/daos/shopping_list_dao.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart' show appDatabaseProvider;
import '../../../sharing/data/datasources/firestore_activity_service.dart';
import '../../../sharing/data/datasources/firestore_list_sharing_service.dart';
import '../../../sharing/data/datasources/listener_retry.dart';
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
/// - Individual user actions are logged as activity events (which notify
///   collaborators); bulk actions such as check-all are not.
class ShoppingListSyncOrchestrator {
  ShoppingListSyncOrchestrator({
    required this._dao,
    required this._sharingService,
    required this._activityService,
    String? clientId,
  }) : _tracker = SyncTracker(clientId: clientId, logTag: 'ListSync');

  final ShoppingListDao _dao;
  final FirestoreListSharingService _sharingService;
  final FirestoreActivityService _activityService;
  final SyncTracker _tracker;
  final _uuid = const Uuid();

  static const _anonymousName = 'Someone';

  String? _currentUid;
  String _displayName = _anonymousName;
  StreamSubscription<List<SharedListInfo>>? _listsSubscription;
  final Map<String, StreamSubscription<List<RemoteDoc>>> _itemListeners = {};
  final _retry = ListenerRetry();

  // Lists left or deleted this session; ignored if a stale snapshot lists them.
  final Set<String> _departedListIds = {};

  /// Lists checked for an empty same-name duplicate this session.
  final Set<String> _duplicateCheckedIds = {};

  String? get currentUid => _currentUid;

  // ── Lifecycle ─────────────────────────────────────────────

  /// Start syncing for [uid]. Calling again with the same user is a no-op
  /// apart from refreshing [displayName].
  void startSync(String uid, {String? displayName}) {
    _displayName = displayName ?? _anonymousName;
    if (_currentUid == uid) return;
    stopSync();
    _currentUid = uid;

    _listenToLists(uid);
  }

  void _listenToLists(String uid) {
    _listsSubscription = _sharingService.watchSharedListsForUser(uid).listen(
      (lists) => _tracker.run('reconcile lists', () => _reconcileLists(lists)),
      onError: (Object e, StackTrace stack) {
        debugPrint('[ListSync] lists stream: $e');
        ErrorReporter.nonFatal(e, stack, 'Shared lists stream failed');
      },
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
    _retry.cancelAll();
    _departedListIds.clear();
    _duplicateCheckedIds.clear();
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
      await _removeItemListener(firestoreListId);
      final local = await _dao.getListByFirestoreId(firestoreListId);
      if (local == null) continue;
      // An empty leftover would just be a duplicate-looking blank list.
      if ((await _dao.getItemsForList(local.id)).isEmpty) {
        await _dao.deleteList(local.id);
      } else {
        await _dao.unlinkList(local.id);
      }
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
    late final StreamSubscription<List<RemoteDoc>> subscription;
    subscription = _sharingService.watchItemDocs(firestoreListId).listen(
      (docs) {
        _retry.succeeded(firestoreListId);
        _tracker.run(
            'reconcile items', () => _reconcileItems(firestoreListId, docs));
      },
      onError: (Object e, StackTrace stack) {
        debugPrint('[ListSync] items stream: $e');
        // Firestore ends a listener after an error; start it again unless
        // it was replaced or removed meanwhile (see ListenerRetry).
        final retrying = _retry.schedule(firestoreListId, () {
          if (!identical(_itemListeners[firestoreListId], subscription)) {
            return;
          }
          subscription.cancel();
          _attachItemListener(firestoreListId);
        });
        if (retrying) {
          debugPrint('[ListSync] retrying items listener');
        } else {
          ErrorReporter.nonFatal(e, stack, 'List items listener gave up');
        }
      },
    );
    _itemListeners[firestoreListId] = subscription;
  }

  Future<void> _removeItemListener(String firestoreListId) async {
    _retry.cancel(firestoreListId);
    await _itemListeners.remove(firestoreListId)?.cancel();
  }

  /// Starts every listener again, for pull to refresh. The lists snapshot
  /// that follows re-attaches each list's items listener.
  Future<void> refresh() async {
    final uid = _currentUid;
    if (uid == null) return;
    await _listsSubscription?.cancel();
    for (final id in _itemListeners.keys.toList()) {
      await _removeItemListener(id);
    }
    _listenToLists(uid);
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
    if (_duplicateCheckedIds.add(firestoreListId)) {
      // After this snapshot is applied, so item counts are current. Not
      // awaited: removing a list waits for this reconcile to finish.
      unawaited(_dropEmptyDuplicate(firestoreListId));
    }
  }

  /// Lists being removed as duplicates. Two lists' checks can run at once
  /// and pick the same empty list; it's removed once.
  final Set<String> _removingIds = {};

  Future<void> _removeDuplicate(String localListId) async {
    if (!_removingIds.add(localListId)) return;
    debugPrint('[ListSync] removing an empty duplicate list');
    await deleteList(localListId);
  }

  /// When a shared list arrives and another active list has the same name
  /// (ignoring case and spacing), the empty one goes: the other list if it's
  /// empty, otherwise this one if it is. Lists that both have items stay.
  ///
  /// Only a list no one else uses is removed (see [_onlyMine]): an empty
  /// shared list may just be between shopping trips for the other members.
  Future<void> _dropEmptyDuplicate(String firestoreListId) async {
    try {
      final list = await _dao.getListByFirestoreId(firestoreListId);
      if (list == null) return;
      final key = _listKey(list.name);
      final others = (await _dao.watchActiveLists().first)
          .where((l) => l.id != list.id && _listKey(l.name) == key)
          .toList();
      if (others.isEmpty) return;
      final isEmpty = (await _dao.getItemsForList(list.id)).isEmpty;
      for (final other in others) {
        if ((await _dao.getItemsForList(other.id)).isEmpty &&
            await _onlyMine(other.firestoreId)) {
          await _removeDuplicate(other.id);
        } else if (isEmpty && await _onlyMine(list.firestoreId)) {
          await _removeDuplicate(list.id);
          return;
        }
      }
    } catch (e, stack) {
      debugPrint('[ListSync] duplicate check failed: $e');
      ErrorReporter.nonFatal(e, stack, 'Duplicate list check failed');
    }
  }

  /// Whether removing a list affects only this user: it isn't shared, or the
  /// user owns it and no one else is a member. If that can't be checked
  /// (offline), the list stays.
  Future<bool> _onlyMine(String? firestoreListId) async {
    if (firestoreListId == null) return true;
    final uid = _currentUid;
    if (uid == null) return false;
    try {
      final info = await _sharingService
          .getList(firestoreListId)
          .timeout(const Duration(seconds: 15));
      if (info == null) return true;
      return info.ownerUid == uid &&
          info.collaborators.keys.every((member) => member == uid);
    } catch (e) {
      debugPrint('[ListSync] could not check list members: $e');
      return false;
    }
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

  /// Join a shared list by invite code. The local copy is created right away
  /// and filled in as the list's items arrive. Returns the shared list ID.
  Future<String> joinList({
    required String inviteCode,
    required String displayName,
  }) async {
    final uid = _currentUid;
    if (uid == null) {
      throw const ListSharingException('Sign in to join a shared list.');
    }
    final firestoreListId = await _sharingService.joinList(
      inviteCode: inviteCode,
      uid: uid,
      displayName: displayName,
    );
    _departedListIds.remove(firestoreListId);
    _activityService.logListActivity(
      firestoreListId,
      type: 'collaboratorJoined',
      actorUid: uid,
      actorDisplayName: displayName,
    );
    final info = await _sharingService.getList(firestoreListId);
    if (info != null) await _tracker.exclusive(() => _ensureLocalList(info));
    return firestoreListId;
  }

  /// This phone's own list with the same name as [name] (ignoring case and
  /// spaces), if there's one that isn't shared.
  Future<ShoppingList?> sameNameLocalList(String name) async {
    final key = _listKey(name);
    final lists = await _dao.watchActiveLists().first;
    return lists
        .where((l) => l.firestoreId == null && _listKey(l.name) == key)
        .firstOrNull;
  }

  /// Merges this phone's unshared list with the same name into the shared
  /// list [firestoreListId], which the user has joined: its items move over
  /// and are pushed, except ones already on the shared list, and it's
  /// removed. For connecting the same person's lists in two apps, never for
  /// someone else's invite. Returns whether a list was merged.
  Future<bool> mergeSameNameList(String firestoreListId) async {
    final uid = _currentUid;
    if (uid == null) return false;
    final info = await _sharingService.getList(firestoreListId);
    if (info == null) return false;
    return _tracker.exclusive(() async {
      final own = await sameNameLocalList(info.name);
      if (own == null) return false;

      final onShared = {
        for (final doc in await _sharingService.getItemDocs(firestoreListId))
          _listKey(doc.data['name'] as String? ?? ''),
      };
      final items = await _dao.getItemsForList(own.id);
      final duplicates =
          items.where((i) => onShared.contains(_listKey(i.name))).toList();
      final moving =
          items.where((i) => !onShared.contains(_listKey(i.name))).toList();

      final linked = await _dao.getListByFirestoreId(firestoreListId);
      if (linked == null) {
        // No local copy of the shared list yet: this list becomes it.
        await _dao.updateListFirestoreId(own.id, firestoreListId);
        for (final item in duplicates) {
          await _dao.deleteItem(item.id);
        }
        await _pushNewItems(firestoreListId, uid, moving);
      } else {
        await _dao.moveItems([for (final i in moving) i.id], linked.id);
        final moved = <ShoppingListItem>[];
        for (final item in moving) {
          final row = await _dao.getItemById(item.id);
          if (row != null) moved.add(row);
        }
        await _pushNewItems(firestoreListId, uid, moved);
        await _dao.deleteList(own.id);
      }
      return true;
    });
  }

  static String _listKey(String name) =>
      name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

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
      for (final row in rows) {
        _logActivity(firestoreListId, 'itemAdded', itemName: row.name);
      }
    }
  }

  /// Update an existing item. Pushes the changed fields.
  Future<void> updateItem(ShoppingListItemsCompanion item) async {
    await _dao.updateItem(item);
    final row = await _pushFields(
        item.id.value, ShoppingListWireMapper.fromCompanion(item));
    if (row != null && item.quantity.present) {
      _logActivity(row.firestoreListId!, 'quantityChanged',
          itemName: row.name, details: {'quantity': item.quantity.value});
    }
  }

  /// Delete an item locally and from its shared list.
  Future<void> deleteItem(String id) async {
    final row = await _dao.getItemById(id);
    await _dao.deleteItem(id);
    if (row == null) return;
    _removeRemote([row]);
    final firestoreListId = row.firestoreListId;
    if (firestoreListId != null) {
      _logActivity(firestoreListId, 'itemRemoved', itemName: row.name);
    }
  }

  /// Check or uncheck an item.
  Future<void> toggleItemCompletion(String id, bool isCompleted) async {
    await _dao.toggleItemCompletion(id, isCompleted);
    final row = await _pushFields(id, {'isChecked': isCompleted});
    if (row != null) {
      _logActivity(row.firestoreListId!,
          isCompleted ? 'itemChecked' : 'itemUnchecked',
          itemName: row.name);
    }
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
      } catch (e, stack) {
        debugPrint('[ListSync] leaving shared list failed: $e');
        ErrorReporter.nonFatal(e, stack, 'Leaving a shared list failed');
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
    await _removeItemListener(firestoreListId);
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

  /// Pushes [fields] for a linked item. Returns the item's row if it was
  /// pushed, or null if it isn't on a shared list.
  Future<ShoppingListItem?> _pushFields(
      String localId, Map<String, dynamic> fields) async {
    final uid = _currentUid;
    if (uid == null || fields.isEmpty) return null;
    final row = await _dao.getItemById(localId);
    final firestoreListId = row?.firestoreListId;
    final itemId = row?.firestoreItemId;
    if (firestoreListId == null || itemId == null) return null;
    _sharingService.updateItem(
      listId: firestoreListId,
      itemId: itemId,
      uid: uid,
      fields: _tracker.stamp(fields),
    );
    return row;
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

  void _logActivity(String firestoreListId, String type,
      {String? itemName, Map<String, dynamic>? details}) {
    final uid = _currentUid;
    if (uid == null) return;
    _activityService.logListActivity(
      firestoreListId,
      type: type,
      actorUid: uid,
      actorDisplayName: _displayName,
      itemName: itemName,
      details: details,
    );
  }
}

// ── Provider ──────────────────────────────────────────────────

final shoppingListSyncOrchestratorProvider =
    Provider<ShoppingListSyncOrchestrator>((ref) {
  final db = ref.watch(appDatabaseProvider);

  final orchestrator = ShoppingListSyncOrchestrator(
    dao: db.shoppingListDao,
    sharingService: ref.watch(firestoreListSharingServiceProvider),
    activityService: ref.watch(firestoreActivityServiceProvider),
  );

  // fireImmediately: the user is usually already signed in when this provider
  // is first read, and a plain listen only reports later changes.
  ref.listen(currentUserProvider, (_, next) {
    final user = next.value;
    if (user != null) {
      orchestrator.startSync(user.uid, displayName: user.displayName);
    } else {
      orchestrator.stopSync();
    }
  }, fireImmediately: true);

  ref.onDispose(orchestrator.stopSync);
  return orchestrator;
});
