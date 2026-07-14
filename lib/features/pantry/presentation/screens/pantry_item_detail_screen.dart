import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../data/datasources/pantry_sync_orchestrator.dart';
import '../widgets/add_pantry_item_sheet.dart';

/// Full detail view for a single pantry item.
class PantryItemDetailScreen extends ConsumerWidget {
  final String itemId;

  const PantryItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantryAsync = ref.watch(pantryItemsProvider);

    return pantryAsync.when(
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (items) {
        final item = items.where((i) => i.id == itemId).firstOrNull;
        if (item == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(),
            body: const Center(child: Text('Item not found')),
          );
        }

        final daysUntilExpiry = item.expiresAt != null
            ? item.expiresAt!.difference(DateTime.now()).inDays
            : null;
        final needsReorder =
            item.isStaple && item.quantity <= item.reorderThreshold;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(item.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditSheet(context, item),
                tooltip: 'Edit item',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _confirmDelete(context, ref, item),
                tooltip: 'Delete item',
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Main info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),

                      _DetailRow(
                        icon: Icons.inventory_2_outlined,
                        label: 'Quantity',
                        value: _quantityDisplay(item),
                      ),
                      _DetailRow(
                        icon: Icons.category_outlined,
                        label: 'Category',
                        value: _capitalizeFirst(item.category),
                      ),
                      _DetailRow(
                        icon: Icons.kitchen,
                        label: 'Location',
                        value: _capitalizeFirst(item.location),
                      ),
                      if (item.expiresAt != null)
                        _DetailRow(
                          icon: Icons.event,
                          label: 'Expires',
                          value: _formatDate(item.expiresAt!),
                          valueColor: _expiryColor(context, daysUntilExpiry),
                        ),
                      if (item.purchasedAt != null)
                        _DetailRow(
                          icon: Icons.shopping_cart_outlined,
                          label: 'Purchased',
                          value: _formatDate(item.purchasedAt!),
                        ),
                      if (item.purchasePrice != null)
                        _DetailRow(
                          icon: Icons.attach_money,
                          label: 'Price',
                          value: '\$${item.purchasePrice!.toStringAsFixed(2)}',
                        ),
                    ],
                  ),
                ),
              ),

              // Status card
              if (item.isStaple || item.isBulk) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Smart Inventory',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        if (item.isStaple)
                          _DetailRow(
                            icon: Icons.star_outline,
                            label: 'Staple',
                            value: 'Reorder at ${item.reorderThreshold}',
                          ),
                        if (item.isBulk)
                          const _DetailRow(
                            icon: Icons.inventory,
                            label: 'Bulk',
                            value: 'Yes',
                          ),
                        if (needsReorder)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_amber,
                                    size: 16, color: AppColors.warning),
                                SizedBox(width: 8),
                                Text(
                                  'Low stock — add to shopping list',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],

              // Notes
              if (item.notes != null && item.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notes',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(item.notes!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],

              // Expiry status
              if (daysUntilExpiry != null) ...[
                const SizedBox(height: 12),
                _ExpiryBanner(daysLeft: daysUntilExpiry),
              ],

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
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

  Future<void> _confirmDelete(
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

    if (confirmed == true && context.mounted) {
      await ref.read(pantrySyncOrchestratorProvider).deleteItem(item.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  String _quantityDisplay(PantryItem item) {
    final qty = item.quantity;
    final qtyStr =
        qty == qty.toInt() ? qty.toInt().toString() : qty.toStringAsFixed(1);
    final ps = item.packSize;
    if (ps != null && ps > 0) {
      final packs = qty / ps;
      final packsStr = packs == packs.toInt()
          ? packs.toInt().toString()
          : packs.toStringAsFixed(1);
      final psStr =
          ps == ps.toInt() ? ps.toInt().toString() : ps.toStringAsFixed(1);
      return '$qtyStr ${item.unitType} ($packsStr \u00D7 $psStr ${item.unitType} packs)';
    }
    return '$qtyStr ${item.unitType}';
  }

  String _capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _expiryColor(BuildContext context, int? days) {
    if (days == null) return Theme.of(context).colorScheme.onSurfaceVariant;
    if (days < 0) return AppColors.error;
    if (days <= 3) return AppColors.warning;
    return AppColors.success;
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryBanner extends StatelessWidget {
  final int daysLeft;

  const _ExpiryBanner({required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color fgColor;
    final String message;

    if (daysLeft < 0) {
      bgColor = AppColors.error.withValues(alpha: 0.1);
      fgColor = AppColors.error;
      message = 'Expired ${-daysLeft} day${-daysLeft == 1 ? '' : 's'} ago';
    } else if (daysLeft == 0) {
      bgColor = AppColors.error.withValues(alpha: 0.1);
      fgColor = AppColors.error;
      message = 'Expires today!';
    } else if (daysLeft <= 3) {
      bgColor = AppColors.warning.withValues(alpha: 0.1);
      fgColor = AppColors.warning;
      message = 'Expires in $daysLeft day${daysLeft == 1 ? '' : 's'}';
    } else {
      bgColor = AppColors.success.withValues(alpha: 0.1);
      fgColor = AppColors.success;
      message = 'Fresh — $daysLeft days left';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 18, color: fgColor),
          const SizedBox(width: 10),
          Text(
            message,
            style: TextStyle(
              color: fgColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
