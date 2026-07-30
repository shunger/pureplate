import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/sharing/data/datasources/firestore_pantry_sharing_service.dart';
import '../services/auth_service.dart';
import 'database_providers.dart';

/// Streams the current Firebase Auth user (anonymous or signed-in).
final currentUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provides the [AuthService] singleton.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    auth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
    sharingService: ref.watch(firestorePantrySharingServiceProvider),
    preferencesDao: ref.watch(preferencesDaoProvider),
  );
});

/// Reactive bool: `true` when the user is signed in with Google or Apple
/// (i.e. not anonymous).
final isCloudSignedInProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.whenOrNull(
        data: (user) {
          if (user == null) return false;
          return user.providerData.any((info) =>
              info.providerId == 'google.com' ||
              info.providerId == 'apple.com');
        },
      ) ??
      false;
});

/// The signed-in user's display name, or `null` if anonymous.
final userDisplayNameProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.whenOrNull(data: (user) => user?.displayName);
});

/// The signed-in user's email, or `null` if anonymous.
final userEmailProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.whenOrNull(data: (user) => user?.email);
});
