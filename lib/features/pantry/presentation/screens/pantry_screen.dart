import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/product_category.dart';
import '../../../../shared/widgets/sign_in_bottom_sheet.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../sharing/presentation/providers/sharing_providers.dart';
import '../../../shopping_list/data/datasources/shopping_list_mapper.dart';
import '../../../shopping_list/domain/models/shopping_list.dart'
    as shopping_domain;
import '../../../shopping_list/presentation/providers/shopping_list_providers.dart';
import '../../data/datasources/pantry_sync_orchestrator.dart';
import '../providers/pantry_providers.dart';
import '../widgets/add_pantry_item_sheet.dart';

/// Main pantry screen — shows grouped inventory with location filters,
/// search, expiry warnings, and swipe actions.
class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  // FAB positions – null until first layout, then default to corners.
  Offset? _fabOffset;
  Offset? _scanFabOffset;
  static const _fabSize = 56.0;
  static const _fabMargin = 16.0;

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(filteredPantryGroupsProvider);
    final locationFilter = ref.watch(pantryLocationFilterProvider);
    final countsAsync = ref.watch(pantryLocationCountsProvider);
    final expiringAsync = ref.watch(expiringItemsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pantry'),
        actions: [
          // Share / collaborators
          IconButton(
            onPressed: () => _handleShareTap(),
            icon: const Icon(Icons.people_outline),
            tooltip: 'Sharing',
          ),
          // Expiring items badge
          expiringAsync.when(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: () => _showExpiringSheet(),
                    icon: Badge(
                      label: Text('${items.length}'),
                      backgroundColor: AppColors.warning,
                      child: const Icon(Icons.schedule),
                    ),
                    tooltip: 'Expiring items',
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          IconButton(
            onPressed: () => _openSearch(),
            icon: const Icon(Icons.search),
            tooltip: 'Search pantry',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _fabOffset ??= Offset(
            constraints.maxWidth - _fabSize - _fabMargin,
            constraints.maxHeight - _fabSize - _fabMargin,
          );
          _scanFabOffset ??= Offset(
            _fabMargin,
            constraints.maxHeight - _fabSize - _fabMargin,
          );

          return Stack(
            children: [
              Column(
                children: [
                  // Location filter chips
                  countsAsync.when(
                    data: (counts) => _LocationFilterBar(
                      selectedLocation: locationFilter,
                      counts: counts,
                      onSelected: (loc) => ref
                          .read(pantryLocationFilterProvider.notifier)
                          .state = loc,
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
                                  ref
                                      .watch(pantrySearchQueryProvider)
                                      .isNotEmpty,
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
              Positioned(
                left: _scanFabOffset!.dx,
                top: _scanFabOffset!.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _scanFabOffset = Offset(
                        (_scanFabOffset!.dx + details.delta.dx)
                            .clamp(0, constraints.maxWidth - _fabSize),
                        (_scanFabOffset!.dy + details.delta.dy)
                            .clamp(0, constraints.maxHeight - _fabSize),
                      );
                    });
                  },
                  child: FloatingActionButton(
                    heroTag: 'scan',
                    onPressed: () => context.push(Routes.scanner),
                    tooltip: 'Scan barcode',
                    child: const Icon(Icons.photo_camera_outlined),
                  ),
                ),
              ),
              Positioned(
                left: _fabOffset!.dx,
                top: _fabOffset!.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _fabOffset = Offset(
                        (_fabOffset!.dx + details.delta.dx)
                            .clamp(0, constraints.maxWidth - _fabSize),
                        (_fabOffset!.dy + details.delta.dy)
                            .clamp(0, constraints.maxHeight - _fabSize),
                      );
                    });
                  },
                  child: FloatingActionButton(
                    heroTag: 'add',
                    onPressed: () => _showAddSheet(),
                    tooltip: 'Add item',
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddPantryItemSheet(),
    );
  }

  void _showExpiringSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ExpiringItemsSheet(),
    );
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: _PantrySearchDelegate(ref),
    );
  }

  Future<void> _handleShareTap() async {
    // 1. Premium gate
    final isPremium = ref.read(isPremiumProvider);
    if (isPremium.valueOrNull != true) {
      context.push(Routes.premium);
      return;
    }

    // 2. Sign-in gate
    final isSignedIn = ref.read(isCloudSignedInProvider);
    if (!isSignedIn) {
      final signedIn = await showSignInBottomSheet(context, ref);
      if (!signedIn || !mounted) return;
      // After sign-in, _ensurePersonalPantry runs and sets sharedPantryId.
      // Wait a frame for providers to update.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
    }

    // 3. Navigate to collaborators
    final pantryId = ref.read(sharedPantryIdProvider).valueOrNull;
    if (pantryId != null && mounted) {
      context.push(
          Routes.collaborators.replaceFirst(':firestoreId', pantryId));
    }
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
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Spices',
            count: counts['spices'] ?? 0,
            icon: Icons.spa,
            isSelected: selectedLocation == 'spices',
            onTap: () => onSelected('spices'),
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
                color: isSelected ? AppColors.coral : Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Text('($count)',
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? AppColors.coral : Theme.of(context).colorScheme.onSurfaceVariant,
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

    return Semantics(
      customSemanticsActions: {
        const CustomSemanticsAction(label: 'Use one'): () => _useOne(ref),
        const CustomSemanticsAction(label: 'Delete'): () => _confirmDelete(context, ref, item),
      },
      child: Dismissible(
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
          onLongPress: () => _showAddToShoppingListSheet(context, ref),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Expiry indicator icon
                _expiryIcon(group.expiryStatus),
                const SizedBox(width: 12),

                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(item),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),

                // Quantity
                Flexible(
                  flex: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _quantityLabel(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
                      '\u00D7${group.batches.length}',
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
                  Icon(Icons.push_pin,
                      size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ],
              ],
            ),
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
    return parts.join(' \u00B7 ');
  }

  String _quantityLabel() {
    final qty = group.totalQuantity;
    final unit = group.batches.first.unitType;
    final qtyStr =
        qty == qty.toInt() ? qty.toInt().toString() : qty.toStringAsFixed(1);
    final ps = group.packSize;
    if (ps != null && ps > 0) {
      final packs = qty / ps;
      final packsStr = packs == packs.toInt()
          ? packs.toInt().toString()
          : packs.toStringAsFixed(1);
      final psStr =
          ps == ps.toInt() ? ps.toInt().toString() : ps.toStringAsFixed(1);
      return '$qtyStr $unit ($packsStr\u00D7$psStr)';
    }
    return '$qtyStr $unit';
  }

  Widget _expiryIcon(String? status) {
    switch (status) {
      case 'expired':
        return const Icon(Icons.error, color: AppColors.expired, size: 16);
      case 'expiring':
        return const Icon(Icons.warning_amber, color: AppColors.expiringSoon, size: 16);
      default:
        return const Icon(Icons.check_circle, color: AppColors.fresh, size: 16);
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

  void _showAddToShoppingListSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddToShoppingListSheet(group: group),
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

  String _expiringQuantityLabel(PantryItem item) {
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
      return '$qtyStr ${item.unitType} ($packsStr\u00D7$psStr)';
    }
    return '$qtyStr ${item.unitType}';
  }

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
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Use Soon',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(Routes.inventorySuggestions);
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
                      title: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        isExpired
                            ? 'Expired ${-days} day${-days == 1 ? "" : "s"} ago'
                            : 'Expires in $days day${days == 1 ? "" : "s"}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isExpired ? AppColors.expired : AppColors.warning,
                            ),
                      ),
                      trailing: Text(
                        _expiringQuantityLabel(item),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilter ? 'No items match your filter' : 'Your pantry is empty',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilter
                  ? 'Try a different location or clear your search'
                  : 'Tap + to add items, or scan a barcode',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add to Shopping List sheet ───────────────────────────────

const _kNewListId = '__new_list__';

class _AddToShoppingListSheet extends ConsumerStatefulWidget {
  final PantryGroup group;

  const _AddToShoppingListSheet({required this.group});

  @override
  ConsumerState<_AddToShoppingListSheet> createState() =>
      _AddToShoppingListSheetState();
}

class _AddToShoppingListSheetState
    extends ConsumerState<_AddToShoppingListSheet> {
  String? _selectedListId;
  bool _isSaving = false;
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    final qty = widget.group.totalQuantity;
    _qtyController = TextEditingController(
      text: qty == qty.toInt() ? qty.toInt().toString() : qty.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    setState(() => _isSaving = true);

    try {
      final dao = ref.read(shoppingListDaoProvider);
      final uuid = const Uuid();
      final item = widget.group.batches.first;
      String targetListId;

      if (_selectedListId == null || _selectedListId == _kNewListId) {
        targetListId = uuid.v4();
        final now = DateTime.now();
        final newList = shopping_domain.ShoppingList(
          id: targetListId,
          name: 'Shopping List',
          source: shopping_domain.ShoppingListSource.manual,
          createdAt: now,
        );
        await dao.insertList(ShoppingListMapper.listToCompanion(newList));
      } else {
        targetListId = _selectedListId!;
      }

      final parsedQty = double.tryParse(_qtyController.text) ?? 1;
      final category = ProductCategory.values.asNameMap()[item.category] ??
          ProductCategory.other;

      final shoppingItem = shopping_domain.ShoppingListItem(
        id: uuid.v4(),
        listId: targetListId,
        name: item.name,
        category: category,
        quantity: parsedQty,
        unitType: item.unitType,
        addedAt: DateTime.now(),
      );

      await dao.insertItem(ShoppingListMapper.itemToCompanion(shoppingItem));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} added to list'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listsAsync = ref.watch(activeShoppingListsDomainProvider);
    final item = widget.group.batches.first;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            'Add to Shopping List',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          // Item preview
          Row(
            children: [
              Text(
                (ProductCategory.values.asNameMap()[item.category] ??
                        ProductCategory.other)
                    .emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.group.name,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quantity field
          TextFormField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Quantity (${item.unitType})',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          // List selector
          listsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (lists) {
              final items = <DropdownMenuItem<String>>[
                const DropdownMenuItem(
                  value: _kNewListId,
                  child: Text('New list'),
                ),
                ...lists.map((l) => DropdownMenuItem(
                      value: l.id,
                      child: Text(
                        l.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ];

              return DropdownButtonFormField<String>(
                initialValue: _selectedListId ?? _kNewListId,
                decoration: InputDecoration(
                  labelText: 'Shopping list',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                items: items,
                onChanged: (v) => setState(() => _selectedListId = v),
              );
            },
          ),
          const SizedBox(height: 16),
          // Add button
          FilledButton.icon(
            onPressed: _isSaving ? null : _addItem,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.add_shopping_cart),
            label: Text(_isSaving ? 'Adding...' : 'Add'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ],
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
          tooltip: 'Clear search',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          _ref.read(pantrySearchQueryProvider.notifier).state = '';
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
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
