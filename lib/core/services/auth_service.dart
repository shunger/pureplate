import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../features/sharing/data/datasources/firestore_pantry_sharing_service.dart';
import '../database/daos/preferences_dao.dart';

/// Handles Google / Apple sign-in for cloud backup.
///
/// Strategy: try `linkWithCredential` first so the anonymous UID is preserved
/// (keeps any Firestore data attached to that UID). If linking fails because
/// the credential is already in use (reinstall scenario), fall back to
/// `signInWithCredential` which adopts the existing account.
class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirestorePantrySharingService _sharingService;
  final PreferencesDao _preferencesDao;

  AuthService({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirestorePantrySharingService sharingService,
    required PreferencesDao preferencesDao,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _sharingService = sharingService,
        _preferencesDao = preferencesDao;

  // ── Google Sign-In ──────────────────────────────────────

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // User cancelled.

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _linkOrSignIn(credential);
    await _ensurePersonalPantry();
  }

  // ── Apple Sign-In ───────────────────────────────────────

  Future<void> signInWithApple() async {
    // Generate a nonce for security.
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    await _linkOrSignIn(oauthCredential);

    // Apple only sends the name on first sign-in; persist it.
    final displayName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');

    if (displayName.isNotEmpty) {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
    }

    await _ensurePersonalPantry();
  }

  // ── Sign Out ────────────────────────────────────────────

  /// Signs out of the identity provider and Firebase, then re-signs-in
  /// anonymously so Cloud Functions still work. Local data is preserved.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Google sign-out may fail if user signed in with Apple — ignore.
    }
    await _auth.signOut();
    await _auth.signInAnonymously();
  }

  // ── Helpers ─────────────────────────────────────────────

  /// Try linking the credential to the current anonymous user.
  /// If the credential is already linked to another account (reinstall),
  /// sign in with it directly instead.
  Future<void> _linkOrSignIn(AuthCredential credential) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null && currentUser.isAnonymous) {
      try {
        await currentUser.linkWithCredential(credential);
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use' ||
            e.code == 'provider-already-linked' ||
            e.code == 'email-already-in-use') {
          // Fall through to signInWithCredential.
        } else {
          rethrow;
        }
      }
    }
    await _auth.signInWithCredential(credential);
  }

  /// After sign-in, ensure the user has at least one personal pantry
  /// in Firestore. If none exists, create "My Pantry" and save its ID.
  Future<void> _ensurePersonalPantry() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final existing = await _sharingService.getSharedPantriesForUser(user.uid);
    if (existing.isNotEmpty) {
      // Restore scenario. Prefer a household someone else owns over the
      // user's own personal pantry (mirrors PantrySyncOrchestrator).
      final preferred = existing.firstWhere(
        (p) => p.ownerUid != user.uid,
        orElse: () => existing.first,
      );
      await _preferencesDao.setSharedPantryId(preferred.firestoreId);
      return;
    }

    // Create a personal pantry.
    final pantryId = await _sharingService.createSharedPantry(
      displayName: user.displayName ?? 'Me',
      name: 'My Pantry',
    );
    await _preferencesDao.setSharedPantryId(pantryId);
  }

  /// Generate a cryptographically secure random nonce for Apple Sign-In.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
}
