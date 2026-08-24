import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/voice_input_button.dart';
import '../../../../shared/models/product_category.dart';
import '../../data/datasources/shopping_list_mapper.dart';
import '../../domain/models/shopping_list.dart';
import '../providers/shopping_list_providers.dart';

const _uuid = Uuid();

// ── Create List Dialog ──────────────────────────────────────

class CreateListDialog extends ConsumerStatefulWidget {
  const CreateListDialog({super.key});

  @override
  ConsumerState<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends ConsumerState<CreateListDialog> {
  final _nameController = TextEditingController();
  final _storeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _storeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Shopping List'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'List name',
              hintText: 'e.g. Weekly Groceries',
              suffixIcon: VoiceInputButton(controller: _nameController),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _storeController,
            decoration: InputDecoration(
              labelText: 'Store (optional)',
              hintText: 'e.g. Trader Joe\'s',
              suffixIcon: VoiceInputButton(controller: _storeController),
            ),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => _create(context),
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _create(BuildContext context) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final store = _storeController.text.trim();
    final now = DateTime.now();

    final list = ShoppingList(
      id: _uuid.v4(),
      name: name,
      storeName: store.isEmpty ? null : store,
      createdAt: now,
    );

    final dao = ref.read(shoppingListDaoProvider);
    await dao.insertList(ShoppingListMapper.listToCompanion(list));

    if (context.mounted) Navigator.pop(context, list);
  }
}

// ── Add / Edit Shopping List Item Sheet ─────────────────────

class ShoppingListItemSheet extends ConsumerStatefulWidget {
  final String listId;
  final ShoppingListItem? existingItem;

  const ShoppingListItemSheet({
    super.key,
    required this.listId,
    this.existingItem,
  });

  @override
  ConsumerState<ShoppingListItemSheet> createState() =>
      _ShoppingListItemSheetState();
}

class _ShoppingListItemSheetState
    extends ConsumerState<ShoppingListItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  late ProductCategory _category;

  bool get _isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(
      text: item != null ? _formatQty(item.quantity) : '1',
    );
    _unitController = TextEditingController(text: item?.unitType ?? 'count');
    _priceController = TextEditingController(
      text: item?.estimatedPrice?.toStringAsFixed(2) ?? '',
    );
    _notesController = TextEditingController(text: item?.notes ?? '');
    _category = item?.category ?? ProductCategory.other;
  }

  String _formatQty(double qty) =>
      qty == qty.toInt() ? qty.toInt().toString() : qty.toStringAsFixed(1);

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
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
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isEditing ? 'Edit Item' : 'Add Item',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: !_isEditing,
              decoration: InputDecoration(
                labelText: 'Item name',
                hintText: 'e.g. Whole milk',
                suffixIcon: VoiceInputButton(controller: _nameController),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Qty',
                      suffixIcon: VoiceInputButton(
                        controller: _quantityController,
                        isNumeric: true,
                        iconSize: 18,
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _unitController,
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      suffixIcon: VoiceInputButton(
                        controller: _unitController,
                        iconSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ProductCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ProductCategory.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text('${c.emoji} ${c.displayName}'),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _category = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Estimated price (optional)',
                prefixText: '\$ ',
                suffixIcon: VoiceInputButton(
                  controller: _priceController,
                  isNumeric: true,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                suffixIcon: VoiceInputButton(controller: _notesController),
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(_isEditing ? 'Save Changes' : 'Add Item'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final qty = double.tryParse(_quantityController.text.trim()) ?? 1;
    final unit = _unitController.text.trim().isEmpty
        ? 'count'
        : _unitController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final notes = _notesController.text.trim();
    final now = DateTime.now();

    final item = ShoppingListItem(
      id: widget.existingItem?.id ?? _uuid.v4(),
      listId: widget.listId,
      name: name,
      category: _category,
      quantity: qty,
      unitType: unit,
      estimatedPrice: price,
      notes: notes.isEmpty ? null : notes,
      isCompleted: widget.existingItem?.isCompleted ?? false,
      priority: widget.existingItem?.priority ?? 0,
      addedAt: widget.existingItem?.addedAt ?? now,
      updatedAt: now,
      sortOrder: widget.existingItem?.sortOrder ?? 0,
      productId: widget.existingItem?.productId,
      brand: widget.existingItem?.brand,
      actualPrice: widget.existingItem?.actualPrice,
      salePrice: widget.existingItem?.salePrice,
      isOnSale: widget.existingItem?.isOnSale ?? false,
      recipeId: widget.existingItem?.recipeId,
      recipeName: widget.existingItem?.recipeName,
      pantryQuantityAvailable:
          widget.existingItem?.pantryQuantityAvailable ?? 0,
    );

    try {
      final dao = ref.read(shoppingListDaoProvider);
      final companion = ShoppingListMapper.itemToCompanion(item);

      if (_isEditing) {
        await dao.updateItem(companion);
      } else {
        await dao.insertItem(companion);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save item: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// ── Shopping List Card ──────────────────────────────────────

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onTap;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const ShoppingListCard({
    super.key,
    required this.list,
    required this.onTap,
    this.onArchive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = list.items.length;
    final completed = list.completedItemCount;
    final progress = list.completionPercent;
    final cost = list.totalEstimatedCost;

    return Dismissible(
      key: Key(list.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _confirmDelete(context);
        } else {
          onArchive?.call();
          return false;
        }
      },
      background: Container(
        color: AppColors.sage,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Icon(
              list.isArchived ? Icons.unarchive : Icons.archive,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              list.isArchived ? 'Restore' : 'Archive',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        list.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (list.source == ShoppingListSource.mealPlan)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Meal Plan',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                // Progress bar
                if (itemCount > 0) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Theme.of(context).colorScheme.outline,
                      color: progress >= 1.0
                          ? AppColors.success
                          : AppColors.coral,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  children: [
                    Text(
                      itemCount == 0
                          ? 'No items'
                          : '$completed/$itemCount items',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    if (list.storeName != null) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.store, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        list.storeName!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (cost > 0)
                      Text(
                        '\$${cost.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
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
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete?.call();
      return true;
    }
    return false;
  }
}

// ── Go Shopping Sheet ───────────────────────────────────────

class GoShoppingSheet extends ConsumerStatefulWidget {
  const GoShoppingSheet({super.key});

  @override
  ConsumerState<GoShoppingSheet> createState() => _GoShoppingSheetState();
}

class _GoShoppingSheetState extends ConsumerState<GoShoppingSheet> {
  final _selected = <String>{};
  bool _merging = false;

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(activeShoppingListsDomainProvider);

    return listsAsync.when(
      data: (lists) => _buildContent(context, lists),
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SizedBox(
        height: 200,
        child: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<ShoppingList> lists) {
    final allSelected = _selected.length == lists.length;
    final selectedCount = _selected.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Go Shopping',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (allSelected) {
                      _selected.clear();
                    } else {
                      _selected
                        ..clear()
                        ..addAll(lists.map((l) => l.id));
                    }
                  });
                },
                child: Text(allSelected ? 'Deselect All' : 'Select All'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Select lists to combine into one shopping trip.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          // List rows
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final list = lists[index];
                final isChecked = _selected.contains(list.id);
                return CheckboxListTile(
                  value: isChecked,
                  onChanged: (_) {
                    setState(() {
                      if (isChecked) {
                        _selected.remove(list.id);
                      } else {
                        _selected.add(list.id);
                      }
                    });
                  },
                  title: Text(
                    list.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    [
                      '${list.items.length} items',
                      if (list.storeName != null) list.storeName!,
                    ].join(' · '),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Combine button
          FilledButton.icon(
            onPressed: selectedCount >= 2 && !_merging ? _combine : null,
            icon: _merging
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.shopping_bag),
            label: Text(
              selectedCount >= 2
                  ? 'Combine $selectedCount lists'
                  : 'Select at least 2 lists',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _combine() async {
    final lists = ref.read(activeShoppingListsDomainProvider).valueOrNull ?? [];
    final selectedLists =
        lists.where((l) => _selected.contains(l.id)).toList();

    if (selectedLists.length < 2) return;

    setState(() => _merging = true);

    try {
      final mergeService = ref.read(shoppingListMergeServiceProvider);
      final dao = ref.read(shoppingListDaoProvider);

      final newList = await mergeService.mergeLists(
        sourceLists: selectedLists,
        shoppingListDao: dao,
      );

      if (!mounted) return;

      // Pop the sheet.
      Navigator.pop(context);

      // Show confirmation snackbar.
      final totalItems = newList.items.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Combined ${selectedLists.length} lists — $totalItems items total',
          ),
        ),
      );

      // Navigate to the new combined list.
      context.go('${Routes.lists}/${newList.id}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _merging = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to combine lists: $e')),
      );
    }
  }
}
