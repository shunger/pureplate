import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart';
import '../../data/datasources/firestore_list_sharing_service.dart';
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

/// The Firestore pantry doc ID from user preferences, exposed reactively.
final sharedPantryIdProvider = Provider<AsyncValue<String?>>((ref) {
  final prefsAsync = ref.watch(userPreferencesProvider);
  return prefsAsync.whenData((prefs) => prefs.sharedPantryId);
});

/// The full [SharedPantryInfo] for the user's current shared pantry.
/// Combines user UID with the shared pantries stream to find the matching pantry.
final currentSharedPantryProvider =
    Provider<AsyncValue<SharedPantryInfo?>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.valueOrNull;
  if (user == null) return const AsyncValue.data(null);

  final pantriesAsync = ref.watch(sharedPantriesProvider(user.uid));
  final pantryIdAsync = ref.watch(sharedPantryIdProvider);

  return pantryIdAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (pantryId) {
      if (pantryId == null) return const AsyncValue.data(null);
      return pantriesAsync.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (pantries) {
          final match = pantries.cast<SharedPantryInfo?>().firstWhere(
                (p) => p!.firestoreId == pantryId,
                orElse: () => null,
              );
          return AsyncValue.data(match);
        },
      );
    },
  );
});

// ── Shopping list sharing providers ─────────────────────────

/// Stream of shared lists for a given user UID.
final sharedListsProvider =
    StreamProvider.family<List<SharedListInfo>, String>((ref, uid) {
  final service = ref.watch(firestoreListSharingServiceProvider);
  return service.watchSharedListsForUser(uid);
});

/// Stream of items in a shared list.
final sharedListItemsProvider =
    StreamProvider.family<List<SharedListItem>, String>((ref, listId) {
  final service = ref.watch(firestoreListSharingServiceProvider);
  return service.watchSharedListItems(listId);
});

/// The Firestore shared list doc ID from user preferences, exposed reactively.
final sharedListIdProvider = Provider<AsyncValue<String?>>((ref) {
  final prefsAsync = ref.watch(userPreferencesProvider);
  return prefsAsync.whenData((prefs) => prefs.sharedListId);
});
