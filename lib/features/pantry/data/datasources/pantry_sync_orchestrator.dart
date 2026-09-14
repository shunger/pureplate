import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/database/daos/preferences_dao.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart' show appDatabaseProvider;
import '../../../sharing/data/datasources/firestore_activity_service.dart';
import '../../../sharing/data/datasources/firestore_pantry_sharing_service.dart';
import '../../../sharing/data/datasources/remote_doc.dart';
import '../../../sharing/data/datasources/sync_tracker.dart';
import '../../../sharing/data/mappers/firestore_vocab.dart';
import 'pantry_wire_mapper.dart';

/// Orchestrates bidirectional sync between the local Drift pantry and
/// Firestore shared pantries (shared with Smart Shopping Scanner).
///
/// - Local Drift DB is the primary read/write source. Every pantry mutation in
///   the app goes through this class so it reaches collaborators.
/// - The user syncs to one pantry at a time: the active pantry stored in
///   preferences (`sharedPantryId`). New items are pushed only there, while
///   items from every pantry the user belongs to are still received.
/// - Individual user actions are logged as activity events (which notify
///   collaborators); bulk sync work such as adopting or merging items is not.
class PantrySyncOrchestrator {
  PantrySyncOrchestrator({
    required this._pantryDao,
    required this._preferencesDao,
    required this._sharingService,
    required this._activityService,
    String? clientId,
  }) : _tracker = SyncTracker(clientId: clientId, logTag: 'PantrySync');

  final PantryDao _pantryDao;
  final PreferencesDao _preferencesDao;
  final FirestorePantrySharingService _sharingService;
  final FirestoreActivityService _activityService;
  final SyncTracker _tracker;
  final _uuid = const Uuid();

  static const _anonymousName = 'Someone';

  String? _currentUid;
  String _displayName = _anonymousName;
  StreamSubscription<List<SharedPantryInfo>>? _pantriesSubscription;
  final Map<String, StreamSubscription<List<RemoteDoc>>> _itemListeners = {};

  // Pantries left this session; ignored if a stale snapshot still lists them.
  final Set<String> _departedPantryIds = {};

  String? get currentUid => _currentUid;

  // ── Lifecycle ───────────────────────────────────────────

  /// Start syncing for [uid]. Calling again with the same user is a no-op
  /// apart from refreshing [displayName].
  void startSync(String uid, {String? displayName}) {
    _displayName = displayName ?? _anonymousName;
    if (_currentUid == uid) return;
    stopSync();
    _currentUid = uid;

    _pantriesSubscription =
        _sharingService.watchSharedPantriesForUser(uid).listen(
      (pantries) =>
          _tracker.run('reconcile pantries', () => _reconcilePantries(pantries)),
      onError: (Object e) => debugPrint('[PantrySync] pantries stream: $e'),
    );
  }

  /// Stop all sync activity. Call on sign-out or dispose.
  void stopSync() {
    _pantriesSubscription?.cancel();
    _pantriesSubscription = null;
    for (final sub in _itemListeners.values) {
      sub.cancel();
    }
    _itemListeners.clear();
    _departedPantryIds.clear();
    _tracker.reset();
    _currentUid = null;
  }

  /// Prefers a pantry someone else owns — a household the user joined — over
  /// the user's own personal pantry.
  static SharedPantryInfo preferredPantry(
          Iterable<SharedPantryInfo> pantries, String uid) =>
      pantries.firstWhere((p) => p.ownerUid != uid,
          orElse: () => pantries.first);

  Future<String?> _activePantryId() async =>
      (await _preferencesDao.getPreferences()).sharedPantryId;

  // ── Pantry-level reconciliation ─────────────────────────

  Future<void> _reconcilePantries(List<SharedPantryInfo> remotePantries) async {
    final uid = _currentUid;
    if (uid == null) return;

    final remote = [
      for (final p in remotePantries)
        if (!_departedPantryIds.contains(p.firestoreId)) p,
    ];
    final remoteIds = {for (final p in remote) p.firestoreId};

    var activeId = await _activePantryId();
    if (activeId == null && remote.isNotEmpty) {
      activeId = preferredPantry(remote, uid).firestoreId;
      await _preferencesDao.setSharedPantryId(activeId);
    }

    for (final pantryId in remoteIds) {
      if (_itemListeners.containsKey(pantryId)) continue;
      if (pantryId == activeId) await _adoptUnlinkedItems(pantryId, uid);
      _attachItemListener(pantryId);
    }

    final removed =
        _itemListeners.keys.where((id) => !remoteIds.contains(id)).toList();
    for (final pantryId in removed) {
      await _itemListeners.remove(pantryId)?.cancel();
      await _pantryDao.unlinkItemsForPantry(pantryId);
    }
  }

  void _attachItemListener(String pantryId) {
    _itemListeners[pantryId] = _sharingService.watchItemDocs(pantryId).listen(
      (docs) =>
          _tracker.run('reconcile items', () => _reconcileItems(pantryId, docs)),
      onError: (Object e) => debugPrint('[PantrySync] items stream: $e'),
    );
  }

  /// Push local items that aren't in any shared pantry to [pantryId].
  Future<void> _adoptUnlinkedItems(String pantryId, String uid) async {
    final unlinked = (await _pantryDao.getAllItems())
        .where((item) => item.firestoreItemId == null)
        .toList();
    await _pushNewItems(pantryId, uid, unlinked);
  }

  // ── Item-level reconciliation ───────────────────────────

  Future<void> _reconcileItems(String pantryId, List<RemoteDoc> docs) async {
    if (!_itemListeners.containsKey(pantryId)) return; // Detached meanwhile.

    final batch = _tracker.filter(docs, uid: _currentUid);
    final now = DateTime.now();
    for (final doc in batch.toApply) {
      await _pantryDao.upsertByFirestoreItemId(PantryWireMapper.toCompanion(
        newLocalId: _uuid.v4(),
        pantryId: pantryId,
        itemId: doc.id,
        data: doc.data,
        now: now,
      ));
    }
    await _pantryDao.deleteItemsNotInRemoteSet(pantryId, batch.keepIds);
  }

  // ── Public mutation API ─────────────────────────────────

  /// Insert a new pantry item and push it to the active shared pantry.
  Future<void> insertItem(PantryItemsCompanion item) async {
    await _pantryDao.insertItem(item);

    final uid = _currentUid;
    final pantryId = await _activePantryId();
    final row = await _pantryDao.getItemById(item.id.value);
    if (uid == null || pantryId == null || row == null) return;
    await _pushNewItems(pantryId, uid, [row]);
    _logActivity(pantryId, 'itemAdded', itemName: row.name);
  }

  /// Update an existing pantry item. Pushes the changed fields.
  Future<void> updateItem(PantryItemsCompanion item) async {
    await _pantryDao.updateItem(item);
    await _pushFields(item.id.value, PantryWireMapper.fromCompanion(item));
  }

  /// Delete a pantry item locally and from its shared pantry. Pass [depleted]
  /// when the item was used up rather than removed.
  Future<void> deleteItem(String id, {bool depleted = false}) async {
    final row = await _pantryDao.getItemById(id);
    await _pantryDao.deleteItem(id);

    final pantryId = row?.firestorePantryId;
    final itemId = row?.firestoreItemId;
    if (row == null || pantryId == null || itemId == null) return;
    _tracker.markDeleted([itemId]);
    _sharingService.removeItem(pantryId: pantryId, itemId: itemId);
    _logActivity(pantryId, depleted ? 'itemDepleted' : 'itemRemoved',
        itemName: row.name);
  }

  Future<void> updateQuantity(String id, double quantity) async {
    await _pantryDao.updateQuantity(id, quantity);
    final row = await _pushFields(id, {'quantity': quantity});
    if (row != null && quantity <= 0) {
      _logActivity(row.firestorePantryId!, 'itemDepleted', itemName: row.name);
    }
  }

  Future<void> updateStatus(String id, String status) async {
    await _pantryDao.updateStatus(id, status);
    final row = await _pushFields(id, {'status': status});
    if (row != null) {
      _logActivity(row.firestorePantryId!, 'statusChanged',
          itemName: row.name, details: {'status': status});
    }
  }

  Future<void> updateLocation(String id, String location) async {
    await _pantryDao.updateLocation(id, location);
    await _pushFields(id, FirestoreVocab.encodeLocation(location));
  }

  Future<void> updateStapleSettings(
      String id, bool isStaple, int reorderThreshold, bool isBulk) async {
    await _pantryDao.updateStapleSettings(
        id, isStaple, reorderThreshold, isBulk);
    await _pushFields(id, {
      'isStaple': isStaple,
      'reorderThreshold': reorderThreshold,
      'isBulk': isBulk,
    });
  }

  /// Join the household pantry for [inviteCode] and make it the only pantry
  /// this user syncs with:
  ///
  /// 1. Local items are merged into the household. An item matching a
  ///    household item by name, unit and location adds its quantity (keeping
  ///    the earlier expiry); anything else is added as a new item.
  /// 2. The user leaves their previous active pantry, deleting it if they
  ///    were its only member.
  /// 3. The household becomes the active pantry.
  ///
  /// Returns the household pantry ID.
  Future<String> joinAndMerge({
    required String inviteCode,
    required String displayName,
  }) async {
    final uid = _currentUid;
    if (uid == null) {
      throw const PantrySharingException('Sign in to join a shared pantry.');
    }
    final householdId = await _sharingService.joinPantry(
      inviteCode: inviteCode,
      uid: uid,
      displayName: displayName,
    );
    _departedPantryIds.remove(householdId);
    _activityService.logPantryActivity(
      householdId,
      type: 'collaboratorJoined',
      actorUid: uid,
      actorDisplayName: displayName,
    );
    await _tracker.exclusive(() => _mergeInto(householdId, uid));
    return householdId;
  }

  /// Leave a shared pantry the user doesn't own. Local items are kept.
  Future<void> leavePantry(String pantryId) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _tracker.exclusive(() async {
      await _detach(pantryId);
      await _sharingService.removeCollaborator(pantryId, uid);
      if (await _activePantryId() == pantryId) {
        await _preferencesDao.setSharedPantryId(null);
      }
    });
  }

  // ── Merge / leave helpers ───────────────────────────────

  Future<void> _mergeInto(String householdId, String uid) async {
    final previousId = await _activePantryId();
    if (previousId == householdId) return;

    final now = DateTime.now();
    final targets = <String, _MergeTarget>{};
    for (final doc in await _sharingService.getItemDocs(householdId)) {
      final companion = PantryWireMapper.toCompanion(
        newLocalId: _uuid.v4(),
        pantryId: householdId,
        itemId: doc.id,
        data: doc.data,
        now: now,
      );
      targets.putIfAbsent(
        _mergeKey(companion.name.value, companion.unitType.value,
            companion.location.value),
        () => _MergeTarget(doc.id, companion),
      );
    }

    final toAdd = <PantryItem>[];
    for (final item in await _pantryDao.getAllItems()) {
      if (item.firestorePantryId == householdId) continue;
      final target = targets[_mergeKey(item.name, item.unitType, item.location)];
      if (target == null) {
        toAdd.add(item);
      } else if (target.localId == null) {
        target.absorb(item);
        target.localId = item.id;
      } else {
        target.absorb(item);
        await _pantryDao.deleteItem(item.id);
      }
    }

    for (final target in targets.values) {
      final localId = target.localId;
      if (localId == null) continue;
      final merged = target.companion.copyWith(
        id: Value(localId),
        quantity: Value(target.quantity),
        expiresAt: Value(target.expiresAt),
        createdAt: const Value.absent(),
      );
      await _pantryDao.updateItem(merged);
      _sharingService.updateItem(
        pantryId: householdId,
        itemId: target.itemId,
        uid: uid,
        fields: _tracker.stamp(PantryWireMapper.fromCompanion(
          PantryItemsCompanion(
            quantity: Value(target.quantity),
            expiresAt: Value(target.expiresAt),
          ),
        )),
      );
    }

    await _pushNewItems(householdId, uid, toAdd);
    await _preferencesDao.setSharedPantryId(householdId);
    if (!_itemListeners.containsKey(householdId)) {
      _attachItemListener(householdId);
    }

    if (previousId != null) {
      try {
        await _leaveOrDelete(previousId, uid);
      } catch (e) {
        debugPrint('[PantrySync] leaving previous pantry failed: $e');
      }
    }
  }

  Future<void> _leaveOrDelete(String pantryId, String uid) async {
    await _detach(pantryId);
    final pantry = await _sharingService.getPantry(pantryId);
    if (pantry == null) return;
    final isOnlyMember = pantry.ownerUid == uid &&
        pantry.collaborators.keys.every((member) => member == uid);
    if (isOnlyMember) {
      await _sharingService.deleteSharedPantry(pantryId);
    } else {
      await _sharingService.removeCollaborator(pantryId, uid);
    }
  }

  Future<void> _detach(String pantryId) async {
    _departedPantryIds.add(pantryId);
    await _itemListeners.remove(pantryId)?.cancel();
    await _pantryDao.unlinkItemsForPantry(pantryId);
  }

  static String _mergeKey(String name, String unitType, String location) {
    final unit = FirestoreVocab.encodeUnit(unitType)[FirestoreVocab.unitField];
    final place =
        FirestoreVocab.encodeLocation(location)[FirestoreVocab.locationField];
    return '${name.trim().toLowerCase()}|$unit|$place';
  }

  // ── Firestore push helpers ──────────────────────────────

  Future<void> _pushNewItems(
      String pantryId, String uid, List<PantryItem> rows) async {
    if (rows.isEmpty) return;
    final ids = _sharingService.addItemsBatch(
      pantryId: pantryId,
      uid: uid,
      itemsByLocalId: {
        for (final row in rows)
          row.id: _tracker.stamp(PantryWireMapper.fromRow(row)),
      },
    );
    _tracker.markCreated(ids.values);
    for (final entry in ids.entries) {
      await _pantryDao.updateFirestoreIds(entry.key, pantryId, entry.value);
    }
  }

  /// Pushes [fields] for a linked item. Returns the item's row if it was
  /// pushed, or null if it isn't in a shared pantry.
  Future<PantryItem?> _pushFields(
      String localId, Map<String, dynamic> fields) async {
    final uid = _currentUid;
    if (uid == null || fields.isEmpty) return null;
    final row = await _pantryDao.getItemById(localId);
    final pantryId = row?.firestorePantryId;
    final itemId = row?.firestoreItemId;
    if (pantryId == null || itemId == null) return null;
    _sharingService.updateItem(
      pantryId: pantryId,
      itemId: itemId,
      uid: uid,
      fields: _tracker.stamp(fields),
    );
    return row;
  }

  void _logActivity(String pantryId, String type,
      {String? itemName, Map<String, dynamic>? details}) {
    final uid = _currentUid;
    if (uid == null) return;
    _activityService.logPantryActivity(
      pantryId,
      type: type,
      actorUid: uid,
      actorDisplayName: _displayName,
      itemName: itemName,
      details: details,
    );
  }
}

/// A household item that local items are being merged into.
class _MergeTarget {
  _MergeTarget(this.itemId, this.companion)
      : quantity = companion.quantity.value,
        expiresAt = companion.expiresAt.value;

  final String itemId;
  final PantryItemsCompanion companion;
  double quantity;
  DateTime? expiresAt;

  /// The local row that becomes this item; further matches are deleted.
  String? localId;

  void absorb(PantryItem item) {
    quantity += item.quantity;
    final expiry = item.expiresAt;
    final current = expiresAt;
    if (expiry != null && (current == null || expiry.isBefore(current))) {
      expiresAt = expiry;
    }
  }
}

// ── Provider ────────────────────────────────────────────────

final pantrySyncOrchestratorProvider = Provider<PantrySyncOrchestrator>((ref) {
  final db = ref.watch(appDatabaseProvider);

  final orchestrator = PantrySyncOrchestrator(
    pantryDao: db.pantryDao,
    preferencesDao: db.preferencesDao,
    sharingService: ref.watch(firestorePantrySharingServiceProvider),
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
