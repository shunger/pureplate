import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'remote_doc.dart';

/// Firestore service for pantry sharing between family members.
///
/// The collection is shared with Smart Shopping Scanner, so documents must stay
/// in the scanner's format (see `PantryWireMapper`).
///
/// Firestore structure:
///   sharedPantries/{pantryId}
///     - name, ownerUid, inviteCode, inviteCodeExpiresAt
///     - collaborators: { uid: { role, displayName } }
///     - createdAt, updatedAt
///     └── items/{itemId}
///         - name, category, quantity, unitType, location
///         - expiresAt, purchasedAt, isStaple, notes, ...
///         - addedBy, updatedBy, updatedByClient, createdAt, updatedAt
///
/// Item writes return without waiting for the server: Firestore queues them
/// while offline, and failures are logged rather than surfaced.
class FirestorePantrySharingService {
  final FirebaseFirestore _firestore;

  FirestorePantrySharingService(this._firestore);

  static const _memberRoles = ['owner', 'editor', 'viewer'];
  static const _batchLimit = 450;

  CollectionReference<Map<String, dynamic>> get _pantries =>
      _firestore.collection('sharedPantries');

  CollectionReference<Map<String, dynamic>> _items(String pantryId) =>
      _pantries.doc(pantryId).collection('items');

  Query<Map<String, dynamic>> _pantriesForUser(String uid) =>
      _pantries.where('collaborators.$uid.role', whereIn: _memberRoles);

  // ── Pantry management ───────────────────────────────────

  /// Create a new shared pantry owned by [uid].
  Future<String> createSharedPantry({
    required String uid,
    required String displayName,
    String name = 'Family Pantry',
  }) async {
    final inviteCode = await _generateUniqueInviteCode();
    final doc = await _pantries.add({
      'name': name,
      'ownerUid': uid,
      'inviteCode': inviteCode,
      'inviteCodeExpiresAt':
          Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      'collaborators': {
        uid: {'role': 'owner', 'displayName': displayName},
      },
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Join a shared pantry using an invite code.
  Future<String> joinPantry({
    required String inviteCode,
    required String uid,
    required String displayName,
  }) async {
    final snap = await _pantries
        .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      throw PantrySharingException('Invalid invite code.');
    }

    final doc = snap.docs.first;
    final data = doc.data();

    // Check expiry.
    final expiresAt = (data['inviteCodeExpiresAt'] as Timestamp?)?.toDate();
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      throw PantrySharingException(
          'This invite code has expired. Ask the owner for a new one.');
    }

    // Add collaborator.
    await doc.reference.update({
      'collaborators.$uid': {'role': 'editor', 'displayName': displayName},
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  /// Preview a pantry by invite code without joining.
  Future<SharedPantryInfo?> lookupByInviteCode(String inviteCode) async {
    final snap = await _pantries
        .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return SharedPantryInfo.fromFirestore(snap.docs.first);
  }

  /// Fetch a single shared pantry, or null if it no longer exists.
  Future<SharedPantryInfo?> getPantry(String pantryId) async {
    final doc = await _pantries.doc(pantryId).get();
    return doc.exists ? SharedPantryInfo.fromFirestore(doc) : null;
  }

  /// Regenerate the invite code for a pantry.
  Future<String> regenerateInviteCode(String pantryId) async {
    final code = await _generateUniqueInviteCode();
    await _pantries.doc(pantryId).update({
      'inviteCode': code,
      'inviteCodeExpiresAt':
          Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  /// Remove a collaborator from a pantry.
  Future<void> removeCollaborator(String pantryId, String uid) async {
    await _pantries.doc(pantryId).update({
      'collaborators.$uid': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a pantry and all of its items. Only the owner may do this.
  Future<void> deleteSharedPantry(String pantryId) async {
    final items = await _items(pantryId).get();
    for (var i = 0; i < items.docs.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final doc in items.docs.skip(i).take(_batchLimit)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
    await _pantries.doc(pantryId).delete();
  }

  // ── Item operations ─────────────────────────────────────

  /// Add an item to a shared pantry. Returns the new item document ID.
  String addItem({
    required String pantryId,
    required String uid,
    required Map<String, dynamic> itemData,
  }) {
    final ref = _items(pantryId).doc();
    _queue('addItem', ref.set(_newItem(uid, itemData)));
    _touch(pantryId);
    return ref.id;
  }

  /// Add several items in batched writes. Returns local ID → item document ID.
  Map<String, String> addItemsBatch({
    required String pantryId,
    required String uid,
    required Map<String, Map<String, dynamic>> itemsByLocalId,
  }) {
    final ids = <String, String>{};
    final entries = itemsByLocalId.entries.toList();
    for (var i = 0; i < entries.length; i += _batchLimit) {
      final batch = _firestore.batch();
      for (final entry in entries.skip(i).take(_batchLimit)) {
        final ref = _items(pantryId).doc();
        batch.set(ref, _newItem(uid, entry.value));
        ids[entry.key] = ref.id;
      }
      _queue('addItemsBatch', batch.commit());
    }
    if (entries.isNotEmpty) _touch(pantryId);
    return ids;
  }

  /// Update specific fields on a shared pantry item.
  void updateItem({
    required String pantryId,
    required String itemId,
    required String uid,
    required Map<String, dynamic> fields,
  }) {
    _queue(
      'updateItem',
      _items(pantryId).doc(itemId).update({
        ...fields,
        'updatedBy': uid,
        'updatedAt': FieldValue.serverTimestamp(),
      }),
    );
  }

  /// Remove an item from a shared pantry.
  void removeItem({
    required String pantryId,
    required String itemId,
  }) {
    _queue('removeItem', _items(pantryId).doc(itemId).delete());
    _touch(pantryId);
  }

  Map<String, dynamic> _newItem(String uid, Map<String, dynamic> itemData) => {
        ...itemData,
        'addedBy': uid,
        'updatedBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  void _touch(String pantryId) => _queue(
        'touchPantry',
        _pantries
            .doc(pantryId)
            .update({'updatedAt': FieldValue.serverTimestamp()}),
      );

  void _queue(String operation, Future<void> write) {
    unawaited(write.then((_) {}, onError: (Object e) {
      debugPrint('[PantrySharing] $operation failed: $e');
    }));
  }

  // ── Streams ─────────────────────────────────────────────

  /// Watch all items in a shared pantry.
  Stream<List<SharedPantryItem>> watchSharedPantryItems(String pantryId) {
    return _items(pantryId).snapshots().map(
        (snap) => snap.docs.map((d) => SharedPantryItem.fromFirestore(d)).toList());
  }

  /// Watch the raw item documents in a shared pantry (for sync).
  Stream<List<RemoteDoc>> watchItemDocs(String pantryId) {
    return _items(pantryId).snapshots().map(
        (snap) => [for (final d in snap.docs) RemoteDoc(d.id, d.data())]);
  }

  /// One-shot read of the raw item documents in a shared pantry.
  Future<List<RemoteDoc>> getItemDocs(String pantryId) async {
    final snap = await _items(pantryId).get();
    return [for (final d in snap.docs) RemoteDoc(d.id, d.data())];
  }

  /// Watch all shared pantries the user belongs to.
  Stream<List<SharedPantryInfo>> watchSharedPantriesForUser(String uid) {
    return _pantriesForUser(uid).snapshots().map((snap) =>
        snap.docs.map((d) => SharedPantryInfo.fromFirestore(d)).toList());
  }

  /// One-shot query for user's shared pantries.
  Future<List<SharedPantryInfo>> getSharedPantriesForUser(String uid) async {
    final snap = await _pantriesForUser(uid).get();
    return snap.docs.map((d) => SharedPantryInfo.fromFirestore(d)).toList();
  }

  // ── Invite code generation ──────────────────────────────

  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const _codeLength = 6;

  Future<String> _generateUniqueInviteCode() async {
    final rng = Random.secure();
    for (var attempt = 0; attempt < 10; attempt++) {
      final code = String.fromCharCodes(
        List.generate(
            _codeLength, (_) => _codeChars.codeUnitAt(rng.nextInt(_codeChars.length))),
      );
      final existing = await _pantries
          .where('inviteCode', isEqualTo: code)
          .limit(1)
          .get();
      if (existing.docs.isEmpty) return code;
    }
    throw PantrySharingException('Failed to generate unique invite code.');
  }
}

// ── Data classes ────────────────────────────────────────────

class SharedPantryInfo {
  final String firestoreId;
  final String name;
  final String ownerUid;
  final String? inviteCode;
  final DateTime? inviteCodeExpiresAt;
  final Map<String, PantryCollaborator> collaborators;
  final DateTime? createdAt;

  const SharedPantryInfo({
    required this.firestoreId,
    required this.name,
    required this.ownerUid,
    this.inviteCode,
    this.inviteCodeExpiresAt,
    this.collaborators = const {},
    this.createdAt,
  });

  factory SharedPantryInfo.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final collabsRaw =
        (data['collaborators'] as Map<String, dynamic>?) ?? {};
    final collaborators = collabsRaw.map((uid, value) {
      final map = value as Map<String, dynamic>;
      return MapEntry(uid, PantryCollaborator(
        uid: uid,
        role: map['role'] as String? ?? 'viewer',
        displayName: map['displayName'] as String? ?? 'Unknown',
      ));
    });

    return SharedPantryInfo(
      firestoreId: doc.id,
      name: data['name'] as String? ?? 'Shared Pantry',
      ownerUid: data['ownerUid'] as String? ?? '',
      inviteCode: data['inviteCode'] as String?,
      inviteCodeExpiresAt:
          (data['inviteCodeExpiresAt'] as Timestamp?)?.toDate(),
      collaborators: collaborators,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class PantryCollaborator {
  final String uid;
  final String role;
  final String displayName;

  const PantryCollaborator({
    required this.uid,
    required this.role,
    required this.displayName,
  });
}

class SharedPantryItem {
  final String firestoreItemId;
  final String name;
  final String category;
  final double quantity;
  final String unitType;
  final String location;
  final DateTime? expiresAt;
  final DateTime? purchasedAt;
  final bool isStaple;
  final String? notes;
  final String? addedBy;
  final String? updatedBy;

  const SharedPantryItem({
    required this.firestoreItemId,
    required this.name,
    this.category = 'other',
    this.quantity = 1,
    this.unitType = 'each',
    this.location = 'pantry',
    this.expiresAt,
    this.purchasedAt,
    this.isStaple = false,
    this.notes,
    this.addedBy,
    this.updatedBy,
  });

  factory SharedPantryItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SharedPantryItem(
      firestoreItemId: doc.id,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? 'other',
      quantity: (data['quantity'] as num?)?.toDouble() ?? 1,
      unitType: data['unitType'] as String? ?? 'each',
      location: data['location'] as String? ?? 'pantry',
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      purchasedAt: (data['purchasedAt'] as Timestamp?)?.toDate(),
      isStaple: data['isStaple'] as bool? ?? false,
      notes: data['notes'] as String?,
      addedBy: data['addedBy'] as String?,
      updatedBy: data['updatedBy'] as String?,
    );
  }
}

class PantrySharingException implements Exception {
  final String message;
  const PantrySharingException(this.message);
  @override
  String toString() => message;
}

// ── Provider ────────────────────────────────────────────────

final firestorePantrySharingServiceProvider =
    Provider<FirestorePantrySharingService>((ref) {
  return FirestorePantrySharingService(FirebaseFirestore.instance);
});
