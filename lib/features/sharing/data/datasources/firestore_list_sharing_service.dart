import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestore service for shopping list sharing between users.
///
/// Uses the `sharedLists` collection with the same schema as
/// SmartShoppingScanner for cross-app compatibility.
///
/// Firestore structure:
///   sharedLists/{listId}
///     - name, storeName, ownerUid, inviteCode, inviteCodeCreatedAt,
///       inviteCodeExpiresAt
///     - collaborators: { uid: { role, displayName } }
///     - createdAt, updatedAt
///     └── items/{itemId}
///         - productName, brand, barcode, quantity, price, isChecked,
///           category, notes, addedBy, updatedBy, createdAt, updatedAt
class FirestoreListSharingService {
  final FirebaseFirestore _firestore;

  FirestoreListSharingService(this._firestore);

  CollectionReference<Map<String, dynamic>> get _lists =>
      _firestore.collection('sharedLists');

  // ── List management ─────────────────────────────────────

  /// Share a local shopping list — creates a Firestore doc and returns its ID.
  Future<String> shareList({
    required String uid,
    required String displayName,
    required String name,
    String? storeName,
  }) async {
    final inviteCode = await _generateUniqueInviteCode();
    final doc = await _lists.add({
      'name': name,
      'storeName': storeName,
      'ownerUid': uid,
      'inviteCode': inviteCode,
      'inviteCodeCreatedAt': FieldValue.serverTimestamp(),
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

  // ── Item operations ───────────────────────────────────────

  /// Add an item to a shared list. Returns the Firestore item document ID.
  Future<String> addItem({
    required String listId,
    required String uid,
    required Map<String, dynamic> itemData,
  }) async {
    final doc = await _lists.doc(listId).collection('items').add({
      ...itemData,
      'addedBy': uid,
      'updatedBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _lists.doc(listId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Update specific fields on a shared list item.
  Future<void> updateItem({
    required String listId,
    required String itemId,
    required String uid,
    required Map<String, dynamic> fields,
  }) async {
    await _lists.doc(listId).collection('items').doc(itemId).update({
      ...fields,
      'updatedBy': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove an item from a shared list.
  Future<void> removeItem({
    required String listId,
    required String itemId,
  }) async {
    await _lists.doc(listId).collection('items').doc(itemId).delete();
    await _lists.doc(listId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Streams ───────────────────────────────────────────────

  /// Watch all items in a shared list.
  Stream<List<SharedListItem>> watchSharedListItems(String listId) {
    return _lists.doc(listId).collection('items').snapshots().map(
        (snap) => snap.docs.map((d) => SharedListItem.fromFirestore(d)).toList());
  }

  /// Watch all shared lists the user belongs to.
  Stream<List<SharedListInfo>> watchSharedListsForUser(String uid) {
    return _lists.snapshots().map((snap) => snap.docs
        .where((d) {
          final collabs =
              (d.data()['collaborators'] as Map<String, dynamic>?) ?? {};
          return collabs.containsKey(uid);
        })
        .map((d) => SharedListInfo.fromFirestore(d))
        .toList());
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
