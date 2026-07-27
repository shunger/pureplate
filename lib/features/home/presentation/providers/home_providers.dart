import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';

/// Stats computed from pantry items for the home dashboard.
class PantryStats {
  final int totalItems;
  final int expiringCount;
  final int lowStockCount;

  const PantryStats({
    this.totalItems = 0,
    this.expiringCount = 0,
    this.lowStockCount = 0,
  });
}

/// Computes pantry stats from the pantry items stream.
/// Works with Drift DB PantryItem rows (not domain model).
final pantryStatsProvider = Provider<AsyncValue<PantryStats>>((ref) {
  final pantryAsync = ref.watch(pantryItemsProvider);
  return pantryAsync.whenData((items) {
    final now = DateTime.now();
    final expiring = items.where((i) {
      if (i.expiresAt == null) return false;
      final days = i.expiresAt!.difference(now).inDays;
      return days >= 0 && days <= 7;
    }).length;
    final lowStock =
        items.where((i) => i.isStaple && i.quantity <= i.reorderThreshold).length;
    return PantryStats(
      totalItems: items.length,
      expiringCount: expiring,
      lowStockCount: lowStock,
    );
  });
});

/// Today's meal from the meal plan (one-shot future, not a stream).
final todaysMealProvider = FutureProvider((ref) async {
  final dao = ref.watch(mealPlanDaoProvider);
  return dao.getTodaysMeal();
});

/// All meals planned for today, ordered by sortOrder.
final todaysMealsProvider = FutureProvider((ref) async {
  final dao = ref.watch(mealPlanDaoProvider);
  return dao.getTodaysMeals();
});
