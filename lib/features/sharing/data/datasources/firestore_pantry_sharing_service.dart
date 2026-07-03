import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestore service for pantry sharing between family members.
///
/// Firestore structure:
///   sharedPantries/{pantryId}
///     - name, ownerUid, inviteCode, inviteCodeExpiresAt
///     - collaborators: { uid: { role, displayName } }
///     - createdAt, updatedAt
///     └── items/{itemId}
///         - name, category, quantity, unitType, location
///         - expiresAt, purchasedAt, isStaple, notes
///         - addedBy, updatedBy, createdAt, updatedAt
class FirestorePantrySharingService {
  final FirebaseFirestore _firestore;

  FirestorePantrySharingService(this._firestore);

  CollectionReference<Map<String, dynamic>> get _pantries =>
      _firestore.collection('sharedPantries');

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

  // ── Item operations ─────────────────────────────────────

  /// Add an item to a shared pantry. Returns the Firestore item document ID.
  Future<String> addItem({
    required String pantryId,
    required String uid,
    required Map<String, dynamic> itemData,
  }) async {
    final doc = await _pantries.doc(pantryId).collection('items').add({
      ...itemData,
      'addedBy': uid,
      'updatedBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _pantries.doc(pantryId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Update specific fields on a shared pantry item.
  Future<void> updateItem({
    required String pantryId,
    required String itemId,
    required String uid,
    required Map<String, dynamic> fields,
  }) async {
    await _pantries.doc(pantryId).collection('items').doc(itemId).update({
      ...fields,
      'updatedBy': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove an item from a shared pantry.
  Future<void> removeItem({
    required String pantryId,
    required String itemId,
  }) async {
    await _pantries.doc(pantryId).collection('items').doc(itemId).delete();
    await _pantries.doc(pantryId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Streams ─────────────────────────────────────────────

  /// Watch all items in a shared pantry.
  Stream<List<SharedPantryItem>> watchSharedPantryItems(String pantryId) {
    return _pantries.doc(pantryId).collection('items').snapshots().map(
        (snap) => snap.docs.map((d) => SharedPantryItem.fromFirestore(d)).toList());
  }

  /// Watch all shared pantries the user belongs to.
  Stream<List<SharedPantryInfo>> watchSharedPantriesForUser(String uid) {
    return _pantries.snapshots().map((snap) => snap.docs
        .where((d) {
          final collabs =
              (d.data()['collaborators'] as Map<String, dynamic>?) ?? {};
          return collabs.containsKey(uid);
        })
        .map((d) => SharedPantryInfo.fromFirestore(d))
        .toList());
  }

  /// One-shot query for user's shared pantries.
  Future<List<SharedPantryInfo>> getSharedPantriesForUser(String uid) async {
    final snap = await _pantries.get();
    return snap.docs
        .where((d) {
          final collabs =
              (d.data()['collaborators'] as Map<String, dynamic>?) ?? {};
          return collabs.containsKey(uid);
        })
        .map((d) => SharedPantryInfo.fromFirestore(d))
        .toList();
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
