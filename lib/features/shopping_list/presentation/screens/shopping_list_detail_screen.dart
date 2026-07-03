import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/product_category.dart';
import '../../domain/models/shopping_list.dart';
import '../providers/shopping_list_providers.dart';
import '../widgets/shopping_list_widgets.dart';

/// Detail screen for a single shopping list — items grouped by category.
class ShoppingListDetailScreen extends ConsumerWidget {
  final String listId;

  const ShoppingListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(shoppingListDetailProvider(listId));

    return listAsync.when(
      data: (list) {
        if (list == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('List')),
            body: const Center(child: Text('List not found')),
          );
        }
        return _DetailBody(list: list);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  final ShoppingList list;

  const _DetailBody({required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = list.itemsByCategory;
    final sortedCategories = grouped.keys.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(list.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (action) =>
                _handleMenuAction(context, ref, action),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'check_all', child: Text('Check all')),
              const PopupMenuItem(
                  value: 'uncheck_all', child: Text('Uncheck all')),
              const PopupMenuItem(
                  value: 'clear_completed',
                  child: Text('Clear completed')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                  value: 'archive', child: Text('Archive list')),
              const PopupMenuItem(
                value: 'delete',
                child:
                    Text('Delete list', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
      body: list.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_shopping_cart,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items yet',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap + to add items to this list',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      for (final category in sortedCategories) ...[
                        _CategoryHeader(category: category),
                        ...grouped[category]!.map((item) => _ItemTile(
                              item: item,
                              listId: list.id,
                            )),
                      ],
                    ],
                  ),
                ),
                // Completion summary bar
                _CompletionBar(list: list),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ShoppingListItemSheet(listId: list.id),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final dao = ref.read(shoppingListDaoProvider);
    switch (action) {
      case 'check_all':
        await dao.checkAllItems(list.id);
      case 'uncheck_all':
        await dao.resetAllItems(list.id);
      case 'clear_completed':
        await dao.clearCompletedItems(list.id);
      case 'archive':
        await dao.archiveList(list.id);
        if (context.mounted) Navigator.pop(context);
      case 'delete':
        final confirmed = await _confirmDelete(context);
        if (confirmed) {
          await dao.deleteList(list.id);
          if (context.mounted) Navigator.pop(context);
        }
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text('Permanently delete "${list.name}" and all its items?'),
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
    return result ?? false;
  }
}

// ── Category header ─────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final ProductCategory category;

  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        '${category.emoji} ${category.displayName}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

// ── Item tile ───────────────────────────────────────────────

class _ItemTile extends ConsumerWidget {
  final ShoppingListItem item;
  final String listId;

  const _ItemTile({required this.item, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          ref.read(shoppingListDaoProvider).deleteItem(item.id),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: InkWell(
          onTap: () => _showEditSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Checkbox(
                  value: item.isCompleted,
                  onChanged: (val) =>
                      ref.read(shoppingListDaoProvider).toggleItemCompletion(
                            item.id,
                            val ?? false,
                          ),
                  activeColor: AppColors.coral,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isCompleted
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (_subtitle.isNotEmpty)
                        Text(
                          _subtitle,
                          style: TextStyle(
                            color: item.isCompleted
                                ? AppColors.textTertiary
                                : AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                if (item.estimatedPrice != null)
                  Text(
                    '\$${(item.estimatedPrice! * item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: item.isCompleted
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[];
    final qtyStr = item.quantity == item.quantity.toInt()
        ? item.quantity.toInt().toString()
        : item.quantity.toStringAsFixed(1);
    parts.add('$qtyStr ${item.unitType}');
    if (item.notes != null && item.notes!.isNotEmpty) {
      parts.add(item.notes!);
    }
    return parts.join(' · ');
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          ShoppingListItemSheet(listId: listId, existingItem: item),
    );
  }
}

// ── Completion summary bar ──────────────────────────────────

class _CompletionBar extends StatelessWidget {
  final ShoppingList list;

  const _CompletionBar({required this.list});

  @override
  Widget build(BuildContext context) {
    final completed = list.completedItemCount;
    final total = list.items.length;
    final cost = list.totalEstimatedCost;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Text(
            '$completed/$total items',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (cost > 0) ...[
            const Text(
              ' · ',
              style: TextStyle(color: AppColors.textTertiary),
            ),
            Text(
              '\$${cost.toStringAsFixed(2)} est.',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: list.completionPercent,
                backgroundColor: AppColors.divider,
                color: list.completionPercent >= 1.0
                    ? AppColors.success
                    : AppColors.coral,
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
