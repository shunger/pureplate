import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'remote_doc.dart';

/// Firestore service for shopping list sharing between users.
///
/// Uses the `sharedLists` collection with the same schema as
/// SmartShoppingScanner for cross-app compatibility
/// (see `ShoppingListWireMapper`).
///
/// Firestore structure:
///   sharedLists/{listId}
///     - name, storeName, ownerUid, inviteCode, inviteCodeCreatedAt,
///       inviteCodeExpiresAt
///     - collaborators: { uid: { role, displayName } }
///     - createdAt, updatedAt
///     └── items/{itemId}
///         - productName, brand, quantity, price, isChecked, category, notes,
///           addedBy, updatedBy, updatedByClient, createdAt, updatedAt
///
/// Item writes return without waiting for the server: Firestore queues them
/// while offline, and failures are logged rather than surfaced.
class FirestoreListSharingService {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  FirestoreListSharingService(this._firestore, [FirebaseFunctions? functions])
      : _functions = functions ?? FirebaseFunctions.instance;

  static const _memberRoles = ['owner', 'editor', 'viewer'];
  static const _batchLimit = 450;

  CollectionReference<Map<String, dynamic>> get _lists =>
      _firestore.collection('sharedLists');

  CollectionReference<Map<String, dynamic>> _items(String listId) =>
      _lists.doc(listId).collection('items');

  Query<Map<String, dynamic>> _listsForUser(String uid) =>
      _lists.where('collaborators.$uid.role', whereIn: _memberRoles);

  // ── List management ─────────────────────────────────────

  /// Reserve a document ID for a list about to be shared, so the local list
  /// can be linked before the shared list's snapshot arrives.
  String newListId() => _lists.doc().id;

  /// Create the shared list document for [listId] (from [newListId]).
  ///
  /// Goes through the `createSharedSpace` function rather than writing the
  /// document here: sharing is a Premium feature, and only the server can
  /// check the entitlement (the paywall in the UI is skippable in a modified
  /// build).
  Future<void> shareList({
    required String listId,
    required String displayName,
    required String name,
    String? storeName,
  }) async {
    try {
      await _functions.httpsCallable('createSharedSpace').call({
        'kind': 'list',
        'id': listId,
        'name': name,
        if (storeName != null) 'storeName': storeName,
        'displayName': displayName,
      });
    } on FirebaseFunctionsException catch (e) {
      throw ListSharingException(_sharingErrorMessage(e));
    }
  }

  /// A user-facing message for a failed `createSharedSpace` call.
  String _sharingErrorMessage(FirebaseFunctionsException e) {
    if (e.code == 'permission-denied') {
      return e.message ??
          'Sharing is a Premium feature. Subscribe to share your lists.';
    }
    if (e.code == 'unavailable' || e.code == 'deadline-exceeded') {
      return 'Could not reach the server. Check your connection and try again.';
    }
    return e.message ?? 'Could not share this list.';
  }

  /// Join a shared list using an invite code.
  Future<String> joinList({
    required String inviteCode,
    required String uid,
    required String displayName,
  }) async {
    final snap = await _lists
        .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      throw ListSharingException('Invalid invite code.');
    }

    final doc = snap.docs.first;
    final data = doc.data();

    // Check expiry.
    final expiresAt = (data['inviteCodeExpiresAt'] as Timestamp?)?.toDate();
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      throw ListSharingException(
          'This invite code has expired. Ask the owner for a new one.');
    }

    // Add collaborator.
    await doc.reference.update({
      'collaborators.$uid': {'role': 'editor', 'displayName': displayName},
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  /// Preview a list by invite code without joining.
  Future<SharedListInfo?> lookupByInviteCode(String inviteCode) async {
    final snap = await _lists
        .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return SharedListInfo.fromFirestore(snap.docs.first);
  }

  /// Fetch a single shared list, or null if it no longer exists.
  Future<SharedListInfo?> getList(String listId) async {
    final doc = await _lists.doc(listId).get();
    return doc.exists ? SharedListInfo.fromFirestore(doc) : null;
  }

  /// Regenerate the invite code for a shared list.
  Future<String> regenerateInviteCode(String listId) async {
    final code = await _generateUniqueInviteCode();
    await _lists.doc(listId).update({
      'inviteCode': code,
      'inviteCodeCreatedAt': FieldValue.serverTimestamp(),
      'inviteCodeExpiresAt':
          Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  /// Remove a collaborator from a shared list.
  Future<void> removeCollaborator(String listId, String uid) async {
    await _lists.doc(listId).update({
      'collaborators.$uid': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a shared list and all of its items. Only the owner may do this.
  Future<void> deleteSharedList(String listId) async {
    final items = await _items(listId).get();
    for (var i = 0; i < items.docs.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final doc in items.docs.skip(i).take(_batchLimit)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
    await _lists.doc(listId).delete();
  }

  // ── Item operations ───────────────────────────────────────

  /// Add an item to a shared list. Returns the new item document ID.
  String addItem({
    required String listId,
    required String uid,
    required Map<String, dynamic> itemData,
  }) {
    final ref = _items(listId).doc();
    _queue('addItem', ref.set(_newItem(uid, itemData)));
    _touch(listId);
    return ref.id;
  }

  /// Add several items in batched writes. Returns local ID → item document ID.
  Map<String, String> addItemsBatch({
    required String listId,
    required String uid,
    required Map<String, Map<String, dynamic>> itemsByLocalId,
  }) {
    final ids = <String, String>{};
    final entries = itemsByLocalId.entries.toList();
    for (var i = 0; i < entries.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final entry in entries.skip(i).take(_batchLimit)) {
        final ref = _items(listId).doc();
        batch.set(ref, _newItem(uid, entry.value));
        ids[entry.key] = ref.id;
      }
      _queue('addItemsBatch', batch.commit());
    }
    if (entries.isNotEmpty) _touch(listId);
    return ids;
  }

  /// Update specific fields on a shared list item.
  void updateItem({
    required String listId,
    required String itemId,
    required String uid,
    required Map<String, dynamic> fields,
  }) {
    updateItemsBatch(listId: listId, uid: uid, fieldsByItemId: {itemId: fields});
  }

  /// Update several items in batched writes.
  void updateItemsBatch({
    required String listId,
    required String uid,
    required Map<String, Map<String, dynamic>> fieldsByItemId,
  }) {
    final entries = fieldsByItemId.entries.toList();
    for (var i = 0; i < entries.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final entry in entries.skip(i).take(_batchLimit)) {
        batch.update(_items(listId).doc(entry.key), {
          ...entry.value,
          'updatedBy': uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      _queue('updateItems', batch.commit());
    }
  }

  /// Remove an item from a shared list.
  void removeItem({
    required String listId,
    required String itemId,
  }) {
    removeItemsBatch(listId: listId, itemIds: [itemId]);
  }

  /// Remove several items in batched writes.
  void removeItemsBatch({
    required String listId,
    required List<String> itemIds,
  }) {
    for (var i = 0; i < itemIds.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final itemId in itemIds.skip(i).take(_batchLimit)) {
        batch.delete(_items(listId).doc(itemId));
      }
      _queue('removeItems', batch.commit());
    }
    if (itemIds.isNotEmpty) _touch(listId);
  }

  Map<String, dynamic> _newItem(String uid, Map<String, dynamic> itemData) => {
        ...itemData,
        'addedBy': uid,
        'updatedBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  void _touch(String listId) => _queue(
        'touchList',
        _lists.doc(listId).update({'updatedAt': FieldValue.serverTimestamp()}),
      );

  void _queue(String operation, Future<void> write) {
    unawaited(write.then((_) {}, onError: (Object e) {
      debugPrint('[ListSharing] $operation failed: $e');
    }));
  }

  // ── Streams ───────────────────────────────────────────────

  /// Watch all items in a shared list.
  Stream<List<SharedListItem>> watchSharedListItems(String listId) {
    return _items(listId).snapshots().map(
        (snap) => snap.docs.map((d) => SharedListItem.fromFirestore(d)).toList());
  }

  /// Watch the raw item documents in a shared list (for sync).
  Stream<List<RemoteDoc>> watchItemDocs(String listId) {
    return _items(listId).snapshots().map(
        (snap) => [for (final d in snap.docs) RemoteDoc(d.id, d.data())]);
  }

  /// Watch all shared lists the user belongs to.
  Stream<List<SharedListInfo>> watchSharedListsForUser(String uid) {
    return _listsForUser(uid).snapshots().map((snap) =>
        snap.docs.map((d) => SharedListInfo.fromFirestore(d)).toList());
  }

  // ── Invite code generation ────────────────────────────────

  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const _codeLength = 6;

  Future<String> _generateUniqueInviteCode() async {
    final rng = Random.secure();
    for (var attempt = 0; attempt < 10; attempt++) {
      final code = String.fromCharCodes(
        List.generate(
            _codeLength, (_) => _codeChars.codeUnitAt(rng.nextInt(_codeChars.length))),
      );
      final existing = await _lists
          .where('inviteCode', isEqualTo: code)
          .limit(1)
          .get();
      if (existing.docs.isEmpty) return code;
    }
    throw ListSharingException('Failed to generate unique invite code.');
  }
}

// ── Data classes ──────────────────────────────────────────────

class SharedListInfo {
  final String firestoreId;
  final String name;
  final String? storeName;
  final String ownerUid;
  final String? inviteCode;
  final DateTime? inviteCodeExpiresAt;
  final Map<String, ListCollaborator> collaborators;
  final DateTime? createdAt;

  const SharedListInfo({
    required this.firestoreId,
    required this.name,
    this.storeName,
    required this.ownerUid,
    this.inviteCode,
    this.inviteCodeExpiresAt,
    this.collaborators = const {},
    this.createdAt,
  });

  factory SharedListInfo.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final collabsRaw =
        (data['collaborators'] as Map<String, dynamic>?) ?? {};
    final collaborators = collabsRaw.map((uid, value) {
      final map = value as Map<String, dynamic>;
      return MapEntry(
          uid,
          ListCollaborator(
            uid: uid,
            role: map['role'] as String? ?? 'viewer',
            displayName: map['displayName'] as String? ?? 'Unknown',
          ));
    });

    return SharedListInfo(
      firestoreId: doc.id,
      name: data['name'] as String? ?? 'Shared List',
      storeName: data['storeName'] as String?,
      ownerUid: data['ownerUid'] as String? ?? '',
      inviteCode: data['inviteCode'] as String?,
      inviteCodeExpiresAt:
          (data['inviteCodeExpiresAt'] as Timestamp?)?.toDate(),
      collaborators: collaborators,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ListCollaborator {
  final String uid;
  final String role;
  final String displayName;

  const ListCollaborator({
    required this.uid,
    required this.role,
    required this.displayName,
  });
}

class SharedListItem {
  final String firestoreItemId;
  final String productName;
  final String? brand;
  final String? barcode;
  final double quantity;
  final double? price;
  final bool isChecked;
  final String? category;
  final String? notes;
  final String? addedBy;
  final String? updatedBy;

  const SharedListItem({
    required this.firestoreItemId,
    required this.productName,
    this.brand,
    this.barcode,
    this.quantity = 1,
    this.price,
    this.isChecked = false,
    this.category,
    this.notes,
    this.addedBy,
    this.updatedBy,
  });

  factory SharedListItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SharedListItem(
      firestoreItemId: doc.id,
      productName: data['productName'] as String? ?? '',
      brand: data['brand'] as String?,
      barcode: data['barcode'] as String?,
      quantity: (data['quantity'] as num?)?.toDouble() ?? 1,
      price: (data['price'] as num?)?.toDouble(),
      isChecked: data['isChecked'] as bool? ?? false,
      category: data['category'] as String?,
      notes: data['notes'] as String?,
      addedBy: data['addedBy'] as String?,
      updatedBy: data['updatedBy'] as String?,
    );
  }
}

class ListSharingException implements Exception {
  final String message;
  const ListSharingException(this.message);
  @override
  String toString() => message;
}

// ── Provider ──────────────────────────────────────────────────

final firestoreListSharingServiceProvider =
    Provider<FirestoreListSharingService>((ref) {
  return FirestoreListSharingService(FirebaseFirestore.instance);
});
