import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/shopping_list_dao.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart' show appDatabaseProvider;
import '../../../sharing/data/datasources/firestore_list_sharing_service.dart';

/// Orchestrates bidirectional sync between local Drift shopping lists and
/// Firestore shared lists.
///
/// Architecture:
/// - Local Drift DB is the primary read/write source.
/// - Firestore `sharedLists` is the sharing layer.
/// - Per-list sharing: each list can be shared independently.
/// - Echo suppression prevents re-processing our own changes.
class ShoppingListSyncOrchestrator {
  final ShoppingListDao _dao;
  final FirestoreListSharingService _sharingService;
  final FirebaseFirestore _firestore;

  String? _currentUid;
  final _uuid = const Uuid();

  // Active Firestore item listeners keyed by shared list Firestore ID.
  final Map<String, StreamSubscription> _itemListeners = {};

  // Items currently being pushed to Firestore — skip on incoming sync.
  final Set<String> _inFlightItemIds = {};

  // Top-level listener for the user's shared lists.
  StreamSubscription? _listsSubscription;

  ShoppingListSyncOrchestrator({
    required ShoppingListDao dao,
    required FirestoreListSharingService sharingService,
    required FirebaseFirestore firestore,
  })  : _dao = dao,
        _sharingService = sharingService,
        _firestore = firestore;

  // ── Lifecycle ─────────────────────────────────────────────

  /// Start syncing. Call once after authentication.
  void startSync(String uid) {
    if (_currentUid == uid) return;
    stopSync();
    _currentUid = uid;

    _listsSubscription =
        _sharingService.watchSharedListsForUser(uid).listen(
      _reconcileLists,
      onError: (_) {},
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
    _inFlightItemIds.clear();
    _currentUid = null;
  }

  // ── List-level reconciliation ─────────────────────────────

  void _reconcileLists(List<SharedListInfo> remoteLists) {
    final remoteIds = remoteLists.map((l) => l.firestoreId).toSet();

    // Attach listeners for new shared lists.
    for (final list in remoteLists) {
      if (!_itemListeners.containsKey(list.firestoreId)) {
        _attachItemListener(list.firestoreId);
      }
    }

    // Detach listeners for lists we're no longer part of.
    final toRemove = _itemListeners.keys
        .where((id) => !remoteIds.contains(id))
        .toList();
    for (final id in toRemove) {
      _itemListeners[id]?.cancel();
      _itemListeners.remove(id);
    }
  }

  void _attachItemListener(String firestoreListId) {
    _itemListeners[firestoreListId] = _firestore
        .collection('sharedLists')
        .doc(firestoreListId)
        .collection('items')
        .snapshots()
        .listen(
      (snap) => _reconcileItems(firestoreListId, snap),
      onError: (_) {},
    );
  }

  // ── Item-level reconciliation ─────────────────────────────

  Future<void> _reconcileItems(
      String firestoreListId, QuerySnapshot<Map<String, dynamic>> snap) async {
    final remoteItemIds = <String>{};

    for (final doc in snap.docs) {
      final firestoreItemId = doc.id;
      remoteItemIds.add(firestoreItemId);

      // Skip items we're currently pushing (echo suppression).
      if (_inFlightItemIds.contains(firestoreItemId)) continue;

      // Skip items updated by us (echo suppression).
      final data = doc.data();
      if (data['updatedBy'] == _currentUid) continue;

      // Find a local list linked to this Firestore list to use as listId.
      final localListId = await _findOrCreateLocalList(firestoreListId);
      if (localListId == null) continue;

      // Upsert into local DB.
      final companion =
          _firestoreToCompanion(localListId, firestoreListId, firestoreItemId, data);
      await _dao.upsertByFirestoreItemId(companion);
    }

    // Remove items that were deleted remotely.
    await _dao.deleteItemsNotInRemoteSet(firestoreListId, remoteItemIds);
  }

  /// Find a local list linked to the given Firestore list ID, or return null.
  Future<String?> _findOrCreateLocalList(String firestoreListId) async {
    // Check if any local list already has this firestoreId.
    final lists = await _dao.watchActiveLists().first;
    for (final list in lists) {
      if (list.firestoreId == firestoreListId) return list.id;
    }
    // Also check archived lists.
    final archived = await _dao.watchArchivedLists().first;
    for (final list in archived) {
      if (list.firestoreId == firestoreListId) return list.id;
    }
    // No local list exists yet — create one from the Firestore doc.
    final firestoreDoc = await _firestore
        .collection('sharedLists')
        .doc(firestoreListId)
        .get();
    if (!firestoreDoc.exists) return null;
    final data = firestoreDoc.data()!;
    final newId = _uuid.v4();
    await _dao.insertList(ShoppingListsCompanion(
      id: Value(newId),
      name: Value(data['name'] as String? ?? 'Shared List'),
      storeName: Value(data['storeName'] as String?),
      firestoreId: Value(firestoreListId),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
    return newId;
  }

  ShoppingListItemsCompanion _firestoreToCompanion(
      String localListId,
      String firestoreListId,
      String firestoreItemId,
      Map<String, dynamic> data) {
    return ShoppingListItemsCompanion(
      id: Value(_uuid.v4()),
      listId: Value(localListId),
      name: Value(data['productName'] as String? ?? ''),
      brand: Value(data['brand'] as String?),
      productId: Value(data['barcode'] as String?),
      quantity: Value((data['quantity'] as num?)?.toDouble() ?? 1),
      estimatedPrice: Value((data['price'] as num?)?.toDouble()),
      isCompleted: Value(data['isChecked'] as bool? ?? false),
      category: Value(data['category'] as String? ?? 'other'),
      notes: Value(data['notes'] as String?),
      firestoreListId: Value(firestoreListId),
      firestoreItemId: Value(firestoreItemId),
      addedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }

  // ── Public mutation API ───────────────────────────────────
  // All mutations go through here so changes are pushed to Firestore.

  /// Share an existing local list. Pushes list + items to Firestore.
  Future<String> shareList({
    required String localListId,
    required String displayName,
  }) async {
    final list = await _dao.getListById(localListId);
    if (list == null) throw ListSharingException('List not found.');

    // Create the shared list doc.
    final firestoreListId = await _sharingService.shareList(
      uid: _currentUid!,
      displayName: displayName,
      name: list.name,
      storeName: list.storeName,
    );

    // Link the local list to Firestore.
    await _dao.updateListFirestoreId(localListId, firestoreListId);

    // Push all existing items.
    final items = await _dao.getItemsForList(localListId);
    for (final item in items) {
      final firestoreItemId = await _sharingService.addItem(
        listId: firestoreListId,
        uid: _currentUid!,
        itemData: _itemToFirestoreData(item),
      );
      _markInFlight(firestoreItemId);
      await _dao.updateFirestoreIds(item.id, firestoreListId, firestoreItemId);
    }

    // Attach a listener for this list.
    if (!_itemListeners.containsKey(firestoreListId)) {
      _attachItemListener(firestoreListId);
    }

    return firestoreListId;
  }

  /// Insert a new item. Pushes to Firestore if the list is shared.
  Future<void> insertItem(ShoppingListItemsCompanion item) async {
    await _dao.insertItem(item);

    // Check if this list is shared.
    final list = await _dao.getListById(item.listId.value);
    if (list?.firestoreId != null) {
      final firestoreItemId = await _sharingService.addItem(
        listId: list!.firestoreId!,
        uid: _currentUid!,
        itemData: _companionToFirestoreData(item),
      );
      _markInFlight(firestoreItemId);
      await _dao.updateFirestoreIds(
          item.id.value, list.firestoreId!, firestoreItemId);
    }
  }

  /// Update an existing item. Pushes changed fields to Firestore.
  Future<void> updateItem(ShoppingListItemsCompanion item) async {
    await _dao.updateItem(item);
    await _pushToFirestore(item.id.value, _companionToFirestoreData(item));
  }

  /// Delete an item locally and from Firestore.
  Future<void> deleteItem(String id) async {
    final item = await _dao.getItemById(id);
    await _dao.deleteItem(id);

    if (item?.firestoreListId != null && item?.firestoreItemId != null) {
      await _sharingService.removeItem(
        listId: item!.firestoreListId!,
        itemId: item.firestoreItemId!,
      );
    }
  }

  /// Toggle item completion — pushes to Firestore.
  Future<void> toggleItemCompletion(String id, bool isCompleted) async {
    await _dao.toggleItemCompletion(id, isCompleted);
    await _pushFieldToFirestore(id, 'isChecked', isCompleted);
  }

  // ── Firestore push helpers ────────────────────────────────

  Future<void> _pushToFirestore(
      String localId, Map<String, dynamic> fields) async {
    final item = await _dao.getItemById(localId);
    if (item?.firestoreListId == null || item?.firestoreItemId == null) return;

    await _sharingService.updateItem(
      listId: item!.firestoreListId!,
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
    Future.delayed(const Duration(seconds: 2), () {
      _inFlightItemIds.remove(firestoreItemId);
    });
  }

  // ── Data conversion helpers ───────────────────────────────

  /// Convert a local ShoppingListItem to SmartShoppingScanner field names.
  Map<String, dynamic> _itemToFirestoreData(ShoppingListItem item) => {
        'productName': item.name,
        if (item.brand != null) 'brand': item.brand,
        if (item.productId != null) 'barcode': item.productId,
        'quantity': item.quantity,
        if (item.estimatedPrice != null) 'price': item.estimatedPrice,
        'isChecked': item.isCompleted,
        'category': item.category,
        if (item.notes != null) 'notes': item.notes,
      };

  /// Convert a Drift companion to SmartShoppingScanner field names.
  Map<String, dynamic> _companionToFirestoreData(
      ShoppingListItemsCompanion c) {
    final data = <String, dynamic>{};
    if (c.name.present) data['productName'] = c.name.value;
    if (c.brand.present) data['brand'] = c.brand.value;
    if (c.productId.present) data['barcode'] = c.productId.value;
    if (c.quantity.present) data['quantity'] = c.quantity.value;
    if (c.estimatedPrice.present) data['price'] = c.estimatedPrice.value;
    if (c.isCompleted.present) data['isChecked'] = c.isCompleted.value;
    if (c.category.present) data['category'] = c.category.value;
    if (c.notes.present) data['notes'] = c.notes.value;
    return data;
  }
}

// ── Provider ──────────────────────────────────────────────────

final shoppingListSyncOrchestratorProvider =
    Provider<ShoppingListSyncOrchestrator>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final sharingService = ref.watch(firestoreListSharingServiceProvider);

  final orchestrator = ShoppingListSyncOrchestrator(
    dao: db.shoppingListDao,
    sharingService: sharingService,
    firestore: FirebaseFirestore.instance,
  );

  // Auto-start sync when user is authenticated.
  ref.listen(currentUserProvider, (_, next) {
    final uid = next.value?.uid;
    if (uid != null) {
      orchestrator.startSync(uid);
    } else {
      orchestrator.stopSync();
    }
  });

  ref.onDispose(() => orchestrator.stopSync());
  return orchestrator;
});
