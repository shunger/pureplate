import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firestore_pantry_sharing_service.dart';

/// Stream of shared pantries for the current user.
/// Requires the user UID to be passed as a family parameter.
final sharedPantriesProvider =
    StreamProvider.family<List<SharedPantryInfo>, String>((ref, uid) {
  final service = ref.watch(firestorePantrySharingServiceProvider);
  return service.watchSharedPantriesForUser(uid);
});

/// Stream of items in a shared pantry.
final sharedPantryItemsProvider =
    StreamProvider.family<List<SharedPantryItem>, String>((ref, pantryId) {
  final service = ref.watch(firestorePantrySharingServiceProvider);
  return service.watchSharedPantryItems(pantryId);
});
