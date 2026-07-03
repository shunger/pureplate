import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/providers/database_providers.dart' show appDatabaseProvider;
import '../../../sharing/data/datasources/firestore_pantry_sharing_service.dart';

/// Orchestrates bidirectional sync between the local Drift pantry and
/// Firestore shared pantries.
///
/// Architecture:
/// - Local Drift DB is the primary read/write source.
/// - Firestore is the sharing layer for family members.
/// - Always-on listeners for real-time updates.
/// - Echo suppression prevents re-processing our own changes.
class PantrySyncOrchestrator {
  final PantryDao _pantryDao;
  final FirestorePantrySharingService _sharingService;
  final FirebaseFirestore _firestore;

  String? _currentUid;
  final _uuid = const Uuid();

  // Active Firestore item listeners keyed by pantryId.
  final Map<String, StreamSubscription> _itemListeners = {};

  // Items currently being pushed to Firestore — skip on incoming sync.
  final Set<String> _inFlightItemIds = {};

  // Top-level listener for the user's shared pantries.
  StreamSubscription? _pantriesSubscription;

  PantrySyncOrchestrator({
    required this._pantryDao,
    required this._sharingService,
    required this._firestore,
  });

  // ── Lifecycle ───────────────────────────────────────────

  /// Start syncing. Call once after authentication.
  void startSync(String uid) {
    if (_currentUid == uid) return; // Already syncing for this user.
    stopSync();
    _currentUid = uid;

    _pantriesSubscription =
        _sharingService.watchSharedPantriesForUser(uid).listen(
      _reconcilePantries,
      onError: (_) {}, // Swallow transient network errors.
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
    _inFlightItemIds.clear();
    _currentUid = null;
  }

  // ── Pantry-level reconciliation ─────────────────────────

  void _reconcilePantries(List<SharedPantryInfo> remotePantries) {
    final remoteIds = remotePantries.map((p) => p.firestoreId).toSet();

    // Attach listeners for new pantries.
    for (final pantry in remotePantries) {
      if (!_itemListeners.containsKey(pantry.firestoreId)) {
        _attachItemListener(pantry.firestoreId);
        // Adopt unlinked local items for this pantry.
        _adoptUnlinkedItems(pantry.firestoreId);
      }
    }

    // Detach listeners for removed pantries.
    final toRemove = _itemListeners.keys
        .where((id) => !remoteIds.contains(id))
        .toList();
    for (final id in toRemove) {
      _itemListeners[id]?.cancel();
      _itemListeners.remove(id);
      _unlinkItemsForPantry(id);
    }
  }

  void _attachItemListener(String pantryId) {
    _itemListeners[pantryId] = _firestore
        .collection('sharedPantries')
        .doc(pantryId)
        .collection('items')
        .snapshots()
        .listen(
      (snap) => _reconcileItems(pantryId, snap),
      onError: (_) {},
    );
  }

  // ── Item-level reconciliation ───────────────────────────

  Future<void> _reconcileItems(
      String pantryId, QuerySnapshot<Map<String, dynamic>> snap) async {
    final remoteItemIds = <String>{};

    for (final doc in snap.docs) {
      final firestoreItemId = doc.id;
      remoteItemIds.add(firestoreItemId);

      // Skip items we're currently pushing (echo suppression).
      if (_inFlightItemIds.contains(firestoreItemId)) continue;

      // Skip items updated by us (echo suppression).
      final data = doc.data();
      if (data['updatedBy'] == _currentUid) continue;

      // Upsert into local DB.
      final companion = _firestoreToCompanion(pantryId, firestoreItemId, data);
      await _pantryDao.upsertByFirestoreItemId(companion);
    }

    // Remove items that were deleted remotely.
    await _pantryDao.deleteItemsNotInRemoteSet(pantryId, remoteItemIds);
  }

  PantryItemsCompanion _firestoreToCompanion(
      String pantryId, String firestoreItemId, Map<String, dynamic> data) {
    return PantryItemsCompanion(
      id: Value(_uuid.v4()),
      name: Value(data['name'] as String? ?? ''),
      category: Value(data['category'] as String? ?? 'other'),
      quantity: Value((data['quantity'] as num?)?.toDouble() ?? 1),
      unitType: Value(data['unitType'] as String? ?? 'each'),
      location: Value(data['location'] as String? ?? 'pantry'),
      expiresAt: Value(_timestampToDate(data['expiresAt'])),
      purchasedAt: Value(_timestampToDate(data['purchasedAt'])),
      isStaple: Value(data['isStaple'] as bool? ?? false),
      notes: Value(data['notes'] as String?),
      firestorePantryId: Value(pantryId),
      firestoreItemId: Value(firestoreItemId),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Adopt local items that aren't linked to any shared pantry.
  Future<void> _adoptUnlinkedItems(String pantryId) async {
    final allItems = await _pantryDao.getAllItems();
    for (final item in allItems) {
      if (item.firestorePantryId == null && item.firestoreItemId == null) {
        // Push to Firestore and link.
        final firestoreItemId = await _sharingService.addItem(
          pantryId: pantryId,
          uid: _currentUid!,
          itemData: _itemToFirestoreData(item),
        );
        await _pantryDao.updateFirestoreIds(
            item.id, pantryId, firestoreItemId);
      }
    }
  }

  /// Unlink local items when leaving a shared pantry.
  Future<void> _unlinkItemsForPantry(String pantryId) async {
    final items = await _pantryDao.getItemsByFirestorePantryId(pantryId);
    for (final item in items) {
      await _pantryDao.updateFirestoreIds(item.id, null, null);
    }
  }

  // ── Public mutation API ─────────────────────────────────
  // All mutations go through here so changes are pushed to Firestore.

  /// Insert a new pantry item. Pushes to Firestore if sharing is active.
  Future<void> insertItem(PantryItemsCompanion item) async {
    await _pantryDao.insertItem(item);

    // Push to all active shared pantries.
    for (final pantryId in _itemListeners.keys) {
      final firestoreItemId = await _sharingService.addItem(
        pantryId: pantryId,
        uid: _currentUid!,
        itemData: _companionToFirestoreData(item),
      );
      _markInFlight(firestoreItemId);
      await _pantryDao.updateFirestoreIds(
          item.id.value, pantryId, firestoreItemId);
    }
  }

  /// Update an existing pantry item. Pushes changed fields to Firestore.
  Future<void> updateItem(PantryItemsCompanion item) async {
    await _pantryDao.updateItem(item);
    await _pushToFirestore(item.id.value, _companionToFirestoreData(item));
  }

  /// Delete a pantry item locally and from Firestore.
  Future<void> deleteItem(String id) async {
    final item = await _pantryDao.getItemById(id);
    await _pantryDao.deleteItem(id);

    if (item?.firestorePantryId != null && item?.firestoreItemId != null) {
      await _sharingService.removeItem(
        pantryId: item!.firestorePantryId!,
        itemId: item.firestoreItemId!,
      );
    }
  }

  /// Update quantity — convenience method.
  Future<void> updateQuantity(String id, double quantity) async {
    await _pantryDao.updateQuantity(id, quantity);
    await _pushFieldToFirestore(id, 'quantity', quantity);
  }

  /// Update status — convenience method.
  Future<void> updateStatus(String id, String status) async {
    await _pantryDao.updateStatus(id, status);
    await _pushFieldToFirestore(id, 'status', status);
  }

  /// Update location — convenience method.
  Future<void> updateLocation(String id, String location) async {
    await _pantryDao.updateLocation(id, location);
    await _pushFieldToFirestore(id, 'location', location);
  }

  /// Update staple settings — convenience method.
  Future<void> updateStapleSettings(
      String id, bool isStaple, int reorderThreshold, bool isBulk) async {
    await _pantryDao.updateStapleSettings(id, isStaple, reorderThreshold, isBulk);
    final item = await _pantryDao.getItemById(id);
    if (item?.firestorePantryId != null && item?.firestoreItemId != null) {
      await _sharingService.updateItem(
        pantryId: item!.firestorePantryId!,
        itemId: item.firestoreItemId!,
        uid: _currentUid!,
        fields: {
          'isStaple': isStaple,
          'reorderThreshold': reorderThreshold,
          'isBulk': isBulk,
        },
      );
      _markInFlight(item.firestoreItemId!);
    }
  }

  // ── Firestore push helpers ──────────────────────────────

  Future<void> _pushToFirestore(
      String localId, Map<String, dynamic> fields) async {
    final item = await _pantryDao.getItemById(localId);
    if (item?.firestorePantryId == null || item?.firestoreItemId == null) return;

    await _sharingService.updateItem(
      pantryId: item!.firestorePantryId!,
      itemId: item.firestoreItemId!,
      uid: _currentUid!,
      fields: fields,
    );
    _markInFlight(item.firestoreItemId!);
  }

  Future<void> _pushFieldToFirestore(
      String localId, String field, dynamic value) async {
    await _pushToFirestore(localId, {field: value});
  }

  void _markInFlight(String firestoreItemId) {
    _inFlightItemIds.add(firestoreItemId);
    // Remove after 2 seconds to allow Firestore echo to arrive.
    Future.delayed(const Duration(seconds: 2), () {
      _inFlightItemIds.remove(firestoreItemId);
    });
  }

  // ── Data conversion helpers ─────────────────────────────

  Map<String, dynamic> _itemToFirestoreData(PantryItem item) => {
        'name': item.name,
        'category': item.category,
        'quantity': item.quantity,
        'unitType': item.unitType,
        'location': item.location,
        if (item.expiresAt != null)
          'expiresAt': Timestamp.fromDate(item.expiresAt!),
        if (item.purchasedAt != null)
          'purchasedAt': Timestamp.fromDate(item.purchasedAt!),
        'isStaple': item.isStaple,
        if (item.notes != null) 'notes': item.notes,
      };

  Map<String, dynamic> _companionToFirestoreData(PantryItemsCompanion c) {
    final data = <String, dynamic>{};
    if (c.name.present) data['name'] = c.name.value;
    if (c.category.present) data['category'] = c.category.value;
    if (c.quantity.present) data['quantity'] = c.quantity.value;
    if (c.unitType.present) data['unitType'] = c.unitType.value;
    if (c.location.present) data['location'] = c.location.value;
    if (c.isStaple.present) data['isStaple'] = c.isStaple.value;
    if (c.notes.present) data['notes'] = c.notes.value;
    if (c.expiresAt.present && c.expiresAt.value != null) {
      data['expiresAt'] = Timestamp.fromDate(c.expiresAt.value!);
    }
    if (c.purchasedAt.present && c.purchasedAt.value != null) {
      data['purchasedAt'] = Timestamp.fromDate(c.purchasedAt.value!);
    }
    return data;
  }

  DateTime? _timestampToDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return null;
  }
}

// ── Provider ────────────────────────────────────────────────

final pantrySyncOrchestratorProvider = Provider<PantrySyncOrchestrator>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final sharingService = ref.watch(firestorePantrySharingServiceProvider);

  final orchestrator = PantrySyncOrchestrator(
    pantryDao: db.pantryDao,
    sharingService: sharingService,
    firestore: FirebaseFirestore.instance,
  );

  // TODO: Auto-start when user is authenticated:
  // ref.listen(currentUserProvider, (_, next) {
  //   final uid = next.value?.uid;
  //   if (uid != null) {
  //     orchestrator.startSync(uid);
  //   } else {
  //     orchestrator.stopSync();
  //   }
  // });

  ref.onDispose(() => orchestrator.stopSync());
  return orchestrator;
});

