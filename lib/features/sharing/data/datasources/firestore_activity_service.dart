import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Writes activity events to `sharedLists/{id}/activity` and
/// `sharedPantries/{id}/activity` in Smart Shopping Scanner's format, so Pure
/// Pantry changes show up in scanner users' activity feeds.
///
/// Every new event also triggers the `onListActivity` / `onPantryActivity`
/// Cloud Functions, which push a notification to each other collaborator. Log
/// individual user actions only — never bulk sync work.
///
/// Types the notification text understands: itemAdded, itemChecked,
/// itemUnchecked, itemRemoved, quantityChanged, collaboratorJoined,
/// statusChanged, itemDepleted.
class FirestoreActivityService {
  final FirebaseFirestore _firestore;

  FirestoreActivityService(this._firestore);

  void logListActivity(
    String firestoreListId, {
    required String type,
    required String actorUid,
    required String actorDisplayName,
    String? itemName,
    Map<String, dynamic>? details,
  }) {
    _log('sharedLists', firestoreListId, type, actorUid, actorDisplayName,
        itemName, details);
  }

  void logPantryActivity(
    String firestorePantryId, {
    required String type,
    required String actorUid,
    required String actorDisplayName,
    String? itemName,
    Map<String, dynamic>? details,
  }) {
    _log('sharedPantries', firestorePantryId, type, actorUid, actorDisplayName,
        itemName, details);
  }

  void _log(
    String collection,
    String parentId,
    String type,
    String actorUid,
    String actorDisplayName,
    String? itemName,
    Map<String, dynamic>? details,
  ) {
    final write = _firestore
        .collection(collection)
        .doc(parentId)
        .collection('activity')
        .add({
      'type': type,
      'actorUid': actorUid,
      'actorDisplayName': actorDisplayName,
      'itemName': ?itemName,
      'details': ?details,
      'timestamp': FieldValue.serverTimestamp(),
    });
    unawaited(write.then((_) {}, onError: (Object e) {
      debugPrint('[Activity] $type on $collection/$parentId failed: $e');
    }));
  }
}

final firestoreActivityServiceProvider =
    Provider<FirestoreActivityService>((ref) {
  return FirestoreActivityService(FirebaseFirestore.instance);
});
