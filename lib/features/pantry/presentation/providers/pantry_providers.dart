import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/providers/database_providers.dart';

/// Location filter for the pantry screen.
/// null = show all locations.
final pantryLocationFilterProvider = StateProvider<String?>((ref) => null);

/// Search query for filtering pantry items.
final pantrySearchQueryProvider = StateProvider<String>((ref) => '');

/// Groups pantry items by productId for multi-batch display.
///
/// Items with the same productId are grouped together (e.g., two cartons
/// of milk bought on different dates). Items with null productId get
/// their own group.
final groupedPantryItemsProvider =
    Provider<AsyncValue<List<PantryGroup>>>((ref) {
  final itemsAsync = ref.watch(pantryItemsProvider);

  return itemsAsync.when(
    data: (items) {
      final groups = <String, List<PantryItem>>{};
      var soloIndex = 0;

      for (final item in items) {
        final key = item.productId ?? '_solo_${soloIndex++}';
        groups.putIfAbsent(key, () => []).add(item);
      }

      final result = groups.entries.map((entry) {
        final batches = entry.value
          ..sort((a, b) {
            // Sort batches by expiry (soonest first, nulls last).
            if (a.expiresAt == null && b.expiresAt == null) return 0;
            if (a.expiresAt == null) return 1;
            if (b.expiresAt == null) return -1;
            return a.expiresAt!.compareTo(b.expiresAt!);
          });
        return PantryGroup(
          productId: batches.first.productId,
          name: batches.first.name,
          batches: batches,
        );
      }).toList();

      // Sort groups by soonest expiry across all batches.
      result.sort((a, b) {
        final aExp = a.soonestExpiry;
        final bExp = b.soonestExpiry;
        if (aExp == null && bExp == null) return a.name.compareTo(b.name);
        if (aExp == null) return 1;
        if (bExp == null) return -1;
        return aExp.compareTo(bExp);
      });

      return AsyncValue.data(result);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

/// Filtered pantry items based on location and search query.
final filteredPantryGroupsProvider =
    Provider<AsyncValue<List<PantryGroup>>>((ref) {
  final groupsAsync = ref.watch(groupedPantryItemsProvider);
  final locationFilter = ref.watch(pantryLocationFilterProvider);
  final searchQuery = ref.watch(pantrySearchQueryProvider).toLowerCase();

  return groupsAsync.when(
    data: (groups) {
      var filtered = groups;

      // Filter by location.
      if (locationFilter != null) {
        filtered = filtered
            .map((g) => PantryGroup(
                  productId: g.productId,
                  name: g.name,
                  batches: g.batches
                      .where((b) => b.location == locationFilter)
                      .toList(),
                ))
            .where((g) => g.batches.isNotEmpty)
            .toList();
      }

      // Filter by search query.
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((g) {
          return g.name.toLowerCase().contains(searchQuery) ||
              g.batches.any((b) =>
                  b.category.toLowerCase().contains(searchQuery) ||
                  (b.notes?.toLowerCase().contains(searchQuery) ?? false));
        }).toList();
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

/// Pantry item count by location for the filter chips.
final pantryLocationCountsProvider =
    Provider<AsyncValue<Map<String?, int>>>((ref) {
  final itemsAsync = ref.watch(pantryItemsProvider);

  return itemsAsync.when(
    data: (items) {
      final counts = <String?, int>{null: items.length};
      for (final item in items) {
        counts[item.location] = (counts[item.location] ?? 0) + 1;
      }
      return AsyncValue.data(counts);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

// ── PantryGroup ─────────────────────────────────────────────

/// A group of pantry items sharing the same product (multi-batch).
class PantryGroup {
  final String? productId;
  final String name;
  final List<PantryItem> batches;

  const PantryGroup({
    required this.productId,
    required this.name,
    required this.batches,
  });

  double get totalQuantity =>
      batches.fold(0, (sum, b) => sum + b.quantity);

  DateTime? get soonestExpiry {
    DateTime? earliest;
    for (final b in batches) {
      if (b.expiresAt != null) {
        if (earliest == null || b.expiresAt!.isBefore(earliest)) {
          earliest = b.expiresAt;
        }
      }
    }
    return earliest;
  }

  /// Worst expiry status across batches.
  String? get expiryStatus {
    final now = DateTime.now();
    bool hasExpired = false;
    bool hasExpiring = false;

    for (final b in batches) {
      if (b.expiresAt == null) continue;
      final days = b.expiresAt!.difference(now).inDays;
      if (days < 0) {
        hasExpired = true;
      } else if (days <= 3) {
        hasExpiring = true;
      }
    }

    if (hasExpired) return 'expired';
    if (hasExpiring) return 'expiring';
    return null;
  }

  String get location => batches.first.location;
  bool get isMultiBatch => batches.length > 1;
  bool get isStaple => batches.any((b) => b.isStaple);
}
