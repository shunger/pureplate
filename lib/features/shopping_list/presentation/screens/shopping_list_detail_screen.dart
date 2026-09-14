import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/product_category.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../sharing/presentation/providers/sharing_providers.dart';
import '../../data/datasources/shopping_list_sync_orchestrator.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(list.name),
        actions: [
          _ShareButton(list: list),
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
                    Icon(
                      Icons.add_shopping_cart,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items yet',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add items to this list',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    final sync = ref.read(shoppingListSyncOrchestratorProvider);
    switch (action) {
      case 'check_all':
        await sync.setAllCompleted(list.id, true);
      case 'uncheck_all':
        await sync.setAllCompleted(list.id, false);
      case 'clear_completed':
        await sync.clearCompleted(list.id);
      case 'archive':
        await ref.read(shoppingListDaoProvider).archiveList(list.id);
        if (context.mounted) Navigator.pop(context);
      case 'delete':
        final confirmed = await _confirmDelete(context);
        if (confirmed) {
          await sync.deleteList(list.id);
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

// ── Share button ─────────────────────────────────────────────

class _ShareButton extends ConsumerWidget {
  final ShoppingList list;

  const _ShareButton({required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShared = list.firestoreId != null;

    return IconButton(
      icon: Icon(isShared ? Icons.people : Icons.share),
      tooltip: isShared ? 'Shared list' : 'Share list',
      onPressed: () async {
        if (isShared) {
          context.push(Routes.listCollaborators
              .replaceFirst(':firestoreId', list.firestoreId!));
        } else {
          await _shareList(context, ref);
        }
      },
    );
  }

  Future<void> _shareList(BuildContext context, WidgetRef ref) async {
    // Premium gate, mirroring the pantry sharing gate in pantry_screen.dart so
    // the same advertised benefit is not free through one door and paid
    // through the other. Only new shares are gated: a list already shared
    // (possibly from Smart Shopping Scanner) stays manageable.
    final isPremium = ref.read(isPremiumProvider);
    if (isPremium.valueOrNull != true) {
      context.push(Routes.premium);
      return;
    }

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to share lists')),
      );
      return;
    }

    try {
      final orchestrator = ref.read(shoppingListSyncOrchestratorProvider);
      final firestoreId = await orchestrator.shareList(
        localListId: list.id,
        displayName: user.displayName ?? 'Member',
      );

      if (!context.mounted) return;

      // Show the invite code in a bottom sheet.
      _showInviteCodeSheet(context, ref, firestoreId);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $e')),
      );
    }
  }

  void _showInviteCodeSheet(
      BuildContext context, WidgetRef ref, String firestoreId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _InviteCodeSheet(firestoreId: firestoreId),
    );
  }
}

class _InviteCodeSheet extends ConsumerWidget {
  final String firestoreId;

  const _InviteCodeSheet({required this.firestoreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUserProvider).valueOrNull?.uid;
    final listsAsync =
        uid != null ? ref.watch(sharedListsProvider(uid)) : null;

    String inviteCode = '------';
    if (listsAsync != null) {
      final lists = listsAsync.valueOrNull ?? [];
      for (final l in lists) {
        if (l.firestoreId == firestoreId) {
          inviteCode = l.inviteCode ?? '------';
          break;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text('List Shared!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Share this invite code with others.',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline),
            ),
            child: Text(
              inviteCode,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 6,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inviteCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invite code copied!')),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy Code'),
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coral),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push(Routes.listCollaborators
                      .replaceFirst(':firestoreId', firestoreId));
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coral),
                child: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          ref.read(shoppingListSyncOrchestratorProvider).deleteItem(item.id),
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
                  onChanged: (val) => ref
                      .read(shoppingListSyncOrchestratorProvider)
                      .toggleItemCompletion(item.id, val ?? false),
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
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (_subtitle.isNotEmpty)
                        Text(
                          _subtitle,
                          style: TextStyle(
                            color: item.isCompleted
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.onSurfaceVariant,
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
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurface,
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: Row(
        children: [
          Text(
            '$completed/$total items',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (cost > 0) ...[
            Text(
              ' · ',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            Text(
              '\$${cost.toStringAsFixed(2)} est.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                backgroundColor: Theme.of(context).colorScheme.outline,
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
