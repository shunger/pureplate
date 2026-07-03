import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/pantry_sync_orchestrator.dart';
import '../providers/pantry_providers.dart';
import '../widgets/add_pantry_item_sheet.dart';

/// Main pantry screen — shows grouped inventory with location filters,
/// search, expiry warnings, and swipe actions.
class PantryScreen extends ConsumerWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(filteredPantryGroupsProvider);
    final locationFilter = ref.watch(pantryLocationFilterProvider);
    final countsAsync = ref.watch(pantryLocationCountsProvider);
    final expiringAsync = ref.watch(expiringItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Pantry'),
        actions: [
          // Expiring items badge
          expiringAsync.when(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () => _showExpiringSheet(context, ref),
                    icon: Badge(
                      label: Text('${items.length}'),
                      backgroundColor: AppColors.warning,
                      child: const Icon(Icons.schedule),
                    ),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          IconButton(
            onPressed: () => _openSearch(context, ref),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          // Location filter chips
          countsAsync.when(
            data: (counts) => _LocationFilterBar(
              selectedLocation: locationFilter,
              counts: counts,
              onSelected: (loc) =>
                  ref.read(pantryLocationFilterProvider.notifier).state = loc,
            ),
            loading: () => const SizedBox(height: 48),
            error: (_, _) => const SizedBox.shrink(),
          ),

          // Item list
          Expanded(
            child: groupsAsync.when(
              data: (groups) => groups.isEmpty
                  ? _EmptyState(
                      hasFilter: locationFilter != null ||
                          ref.watch(pantrySearchQueryProvider).isNotEmpty,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: groups.length,
                      itemBuilder: (context, index) =>
                          _PantryGroupTile(group: groups[index]),
                    ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddPantryItemSheet(),
    );
  }

  void _showExpiringSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ExpiringItemsSheet(),
    );
  }

  void _openSearch(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: _PantrySearchDelegate(ref),
    );
  }
}

// ── Location filter bar ─────────────────────────────────────

class _LocationFilterBar extends StatelessWidget {
  final String? selectedLocation;
  final Map<String?, int> counts;
  final ValueChanged<String?> onSelected;

  const _LocationFilterBar({
    required this.selectedLocation,
    required this.counts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            count: counts[null] ?? 0,
            isSelected: selectedLocation == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pantry',
            count: counts['pantry'] ?? 0,
            icon: Icons.kitchen,
            isSelected: selectedLocation == 'pantry',
            onTap: () => onSelected('pantry'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Fridge',
            count: counts['fridge'] ?? 0,
            icon: Icons.thermostat,
            isSelected: selectedLocation == 'fridge',
            onTap: () => onSelected('fridge'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Freezer',
            count: counts['freezer'] ?? 0,
            icon: Icons.ac_unit,
            isSelected: selectedLocation == 'freezer',
            onTap: () => onSelected('freezer'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14,
                color: isSelected ? AppColors.coral : AppColors.textTertiary),
            const SizedBox(width: 4),
          ],
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Text('($count)',
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? AppColors.coral : AppColors.textTertiary,
                )),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }
}

// ── Pantry group tile ───────────────────────────────────────

class _PantryGroupTile extends ConsumerWidget {
  final PantryGroup group;

  const _PantryGroupTile({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = group.batches.first;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swipe left = delete
          return await _confirmDelete(context, ref, item);
        } else {
          // Swipe right = use one (FIFO)
          await _useOne(ref);
          return false;
        }
      },
      background: Container(
        color: AppColors.sage,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          children: [
            Icon(Icons.remove_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Use 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          onTap: () => _showEditSheet(context, item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Expiry indicator dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _expiryColor(group.expiryStatus),
                  ),
                ),
                const SizedBox(width: 12),

                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(item),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _quantityLabel(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Multi-batch indicator
                if (group.isMultiBatch) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '×${group.batches.length}',
                      style: const TextStyle(
                        color: AppColors.info,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                // Staple indicator
                if (group.isStaple) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.push_pin,
                      size: 14, color: AppColors.textTertiary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _subtitle(PantryItem item) {
    final parts = <String>[];
    parts.add(item.category);
    parts.add(item.location);
    if (item.expiresAt != null) {
      final days = item.expiresAt!.difference(DateTime.now()).inDays;
      if (days < 0) {
        parts.add('expired ${-days}d ago');
      } else if (days == 0) {
        parts.add('expires today');
      } else {
        parts.add('expires in ${days}d');
      }
    }
    return parts.join(' · ');
  }

  String _quantityLabel() {
    final qty = group.totalQuantity;
    final unit = group.batches.first.unitType;
    final qtyStr =
        qty == qty.toInt() ? qty.toInt().toString() : qty.toStringAsFixed(1);
    return '$qtyStr $unit';
  }

  Color _expiryColor(String? status) {
    switch (status) {
      case 'expired':
        return AppColors.expired;
      case 'expiring':
        return AppColors.expiringSoon;
      default:
        return AppColors.fresh;
    }
  }

  void _showEditSheet(BuildContext context, PantryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddPantryItemSheet(existingItem: item),
    );
  }

  Future<bool> _confirmDelete(
      BuildContext context, WidgetRef ref, PantryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Remove "${item.name}" from your pantry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(pantrySyncOrchestratorProvider).deleteItem(item.id);
      return true;
    }
    return false;
  }

  /// Use one unit from the soonest-expiring batch (FIFO).
  Future<void> _useOne(WidgetRef ref) async {
    final orchestrator = ref.read(pantrySyncOrchestratorProvider);
    final batch = group.batches.first; // Already sorted soonest-first.
    final newQty = batch.quantity - 1;

    if (newQty <= 0) {
      await orchestrator.deleteItem(batch.id);
    } else {
      await orchestrator.updateQuantity(batch.id, newQty);
    }
  }
}

// ── Expiring items sheet ────────────────────────────────────

class _ExpiringItemsSheet extends ConsumerWidget {
  const _ExpiringItemsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiringAsync = ref.watch(expiringItemsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.warning),
                const SizedBox(width: 8),
                Text(
                  'Use Soon',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navigate to AI inventory suggestions
                    // with expiring items pre-populated.
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Get recipes'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: expiringAsync.when(
                data: (items) => ListView.builder(
                  controller: scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final days =
                        item.expiresAt!.difference(DateTime.now()).inDays;
                    final isExpired = days < 0;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isExpired
                            ? AppColors.expired.withValues(alpha: 0.1)
                            : AppColors.warning.withValues(alpha: 0.1),
                        child: Icon(
                          isExpired ? Icons.warning : Icons.schedule,
                          color: isExpired ? AppColors.expired : AppColors.warning,
                          size: 20,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        isExpired
                            ? 'Expired ${-days} day${-days == 1 ? "" : "s"} ago'
                            : 'Expires in $days day${days == 1 ? "" : "s"}',
                        style: TextStyle(
                          color: isExpired ? AppColors.expired : AppColors.warning,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        '${item.quantity == item.quantity.toInt() ? item.quantity.toInt() : item.quantity} ${item.unitType}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool hasFilter;
  const _EmptyState({this.hasFilter = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilter ? Icons.filter_list_off : Icons.kitchen_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilter ? 'No items match your filter' : 'Your pantry is empty',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilter
                  ? 'Try a different location or clear your search'
                  : 'Tap + to add items, or scan a barcode',
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search delegate ─────────────────────────────────────────

class _PantrySearchDelegate extends SearchDelegate<String?> {
  final WidgetRef _ref;

  _PantrySearchDelegate(this._ref);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query = '';
            _ref.read(pantrySearchQueryProvider.notifier).state = '';
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          _ref.read(pantrySearchQueryProvider.notifier).state = '';
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) {
    _ref.read(pantrySearchQueryProvider.notifier).state = query;
    close(context, query);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _ref.read(pantrySearchQueryProvider.notifier).state = query;
    return const PantryScreen();
  }
}
