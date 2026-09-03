import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/database/daos/preferences_dao.dart';

/// Keeps the local premium cache in step with the server-owned entitlement
/// document at `users/{uid}/entitlement/current`.
///
/// The Drift row is a cache so premium resolves offline and on first frame;
/// this is what makes it eventually correct. Because only Cloud Functions can
/// write that document, cancellations, refunds and renewals arrive here too —
/// which is what makes premium actually lapse rather than persist forever.
class EntitlementService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final PreferencesDao _preferencesDao;

  EntitlementService({
    required PreferencesDao preferencesDao,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _preferencesDao = preferencesDao,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _docFor(String uid) =>
      _firestore.doc('users/$uid/entitlement/current');

  /// Watches the signed-in user's entitlement, writing each change through to
  /// the local cache. Re-subscribes when the account changes, because
  /// entitlement follows the Firebase account, not the device.
  Stream<bool> watch() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream<bool>.value(false);

      return _docFor(user.uid).snapshots().asyncMap(_apply).handleError(
        (Object e) {
          // Offline or a transient Firestore error: keep the cached value
          // rather than downgrading someone who has actually paid.
          debugPrint('Entitlement watch error (keeping cache): $e');
        },
      );
    });
  }

  /// One-shot sync. Used on launch so premium is correct before the first
  /// gated screen is reached, without waiting for the stream to warm up.
  Future<bool> sync() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    try {
      return await _apply(await _docFor(uid).get());
    } catch (e) {
      debugPrint('Entitlement sync failed (keeping cache): $e');
      return false;
    }
  }

  Future<bool> _apply(DocumentSnapshot<Map<String, dynamic>> snap) async {
    if (!snap.exists) {
      // The server has no entitlement for this account. That is the correct
      // answer for a free user, and for a reinstall under a new anonymous UID
      // the fix is Restore Purchases, which re-verifies and re-writes it.
      await _preferencesDao.applyEntitlement(
        isPremium: false,
        subscriptionId: null,
        plan: null,
        expiresAt: null,
      );
      return false;
    }

    final data = snap.data() ?? const <String, dynamic>{};

    final expiresMs = (data['expiresAt'] as num?)?.toInt();
    final expiresAt = expiresMs != null
        ? DateTime.fromMillisecondsSinceEpoch(expiresMs)
        : null;

    // Trust the server's flag, but honour an expiry that has already passed —
    // covers a renewal notification that never arrived.
    final serverPremium = data['isPremium'] as bool? ?? false;
    final isPremium = serverPremium &&
        (expiresAt == null || expiresAt.isAfter(DateTime.now()));

    await _preferencesDao.applyEntitlement(
      isPremium: isPremium,
      subscriptionId: data['originalTransactionId'] as String?,
      plan: data['productId'] as String?,
      expiresAt: expiresAt,
    );

    return isPremium;
  }
}
