import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/pantry_sync_orchestrator.dart';

/// Bottom sheet for adding or editing a pantry item.
///
/// Supports:
/// - Manual entry (name, quantity, unit, category, location, expiry)
/// - Edit mode (pre-populated from existing item)
/// - Staple/bulk toggles with reorder threshold
/// - Delete in edit mode
class AddPantryItemSheet extends ConsumerStatefulWidget {
  /// If non-null, we're in edit mode.
  final PantryItem? existingItem;

  const AddPantryItemSheet({super.key, this.existingItem});

  @override
  ConsumerState<AddPantryItemSheet> createState() => _AddPantryItemSheetState();
}

class _AddPantryItemSheetState extends ConsumerState<AddPantryItemSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _priceController = TextEditingController();

  double _quantity = 1;
  String _unitType = 'each';
  String _location = 'pantry';
  String _category = 'other';
  DateTime? _expiresAt;
  bool _isStaple = false;
  int _reorderThreshold = 0;
  bool _isBulk = false;

  bool get _isEditing => widget.existingItem != null;

  static const _units = ['each', 'lbs', 'oz', 'kg', 'g', 'L', 'mL', 'cups', 'packs'];
  static const _categories = [
    'produce', 'dairy', 'meat', 'bakery', 'beverages', 'canned',
    'frozen', 'pantry', 'snacks', 'condiments', 'spices', 'other',
  ];
  static const _locations = [
    ('pantry', Icons.kitchen, 'Pantry'),
    ('fridge', Icons.thermostat, 'Fridge'),
    ('freezer', Icons.ac_unit, 'Freezer'),
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final item = widget.existingItem!;
      _nameController.text = item.name;
      _notesController.text = item.notes ?? '';
      _priceController.text =
          item.purchasePrice != null ? item.purchasePrice.toString() : '';
      _quantity = item.quantity;
      _unitType = item.unitType;
      _location = item.location;
      _category = item.category;
      _expiresAt = item.expiresAt;
      _isStaple = item.isStaple;
      _reorderThreshold = item.reorderThreshold;
      _isBulk = item.isBulk;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              _isEditing ? 'Edit Item' : 'Add to Pantry',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),

            // Name
            TextField(
              controller: _nameController,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Item name',
                hintText: 'e.g., Chicken Breast',
              ),
            ),
            const SizedBox(height: 16),

            // Quantity + Unit
            Row(
              children: [
                // Quantity
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton.filled(
                        onPressed: _quantity > 0.5
                            ? () => setState(() => _quantity -= 0.5)
                            : null,
                        icon: const Icon(Icons.remove, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.cream,
                          foregroundColor: AppColors.textPrimary,
                          minimumSize: const Size(36, 36),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            _quantity == _quantity.toInt()
                                ? _quantity.toInt().toString()
                                : _quantity.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () => setState(() => _quantity += 0.5),
                        icon: const Icon(Icons.add, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(36, 36),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Unit
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _unitType,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: _units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) => setState(() => _unitType = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Location selector
            Text('Location',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    )),
            const SizedBox(height: 8),
            Row(
              children: _locations.map((loc) {
                final isSelected = _location == loc.$1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: loc.$1 == 'freezer' ? 0 : 8,
                    ),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(loc.$2,
                              size: 16,
                              color: isSelected
                                  ? AppColors.coral
                                  : AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(loc.$3, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _location = loc.$1),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories
                  .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c[0].toUpperCase() + c.substring(1))))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),

            // Expiry date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.event,
                color: _expiresAt != null ? AppColors.coral : AppColors.textTertiary,
              ),
              title: Text(
                _expiresAt != null
                    ? 'Expires: ${_formatDate(_expiresAt!)}'
                    : 'Set expiry date',
                style: TextStyle(
                  color: _expiresAt != null
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
              trailing: _expiresAt != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _expiresAt = null),
                    )
                  : null,
              onTap: _pickExpiryDate,
            ),

            // Price
            TextField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Purchase price (optional)',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g., organic, family size',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Staple toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Staple item'),
              subtitle: const Text('Get reorder alerts when running low'),
              value: _isStaple,
              onChanged: (v) => setState(() => _isStaple = v),
              activeThumbColor: AppColors.coral,
            ),

            // Reorder threshold (visible when staple)
            if (_isStaple) ...[
              Row(
                children: [
                  const Text('Reorder when below:'),
                  const Spacer(),
                  IconButton(
                    onPressed: _reorderThreshold > 0
                        ? () =>
                            setState(() => _reorderThreshold--)
                        : null,
                    icon: const Icon(Icons.remove, size: 18),
                  ),
                  Text('$_reorderThreshold',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  IconButton(
                    onPressed: () =>
                        setState(() => _reorderThreshold++),
                    icon: const Icon(Icons.add, size: 18),
                  ),
                ],
              ),
            ],

            // Bulk toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Bulk item'),
              subtitle: const Text('Track as bulk quantity (no per-unit use)'),
              value: _isBulk,
              onChanged: (v) => setState(() => _isBulk = v),
              activeThumbColor: AppColors.coral,
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                if (_isEditing)
                  TextButton.icon(
                    onPressed: _confirmDelete,
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.error, size: 18),
                    label: const Text('Delete',
                        style: TextStyle(color: AppColors.error)),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Save' : 'Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final price = double.tryParse(_priceController.text.trim());
    final notes = _notesController.text.trim();
    final now = DateTime.now();
    final orchestrator = ref.read(pantrySyncOrchestratorProvider);

    if (_isEditing) {
      await orchestrator.updateItem(PantryItemsCompanion(
        id: Value(widget.existingItem!.id),
        name: Value(name),
        category: Value(_category),
        quantity: Value(_quantity),
        unitType: Value(_unitType),
        location: Value(_location),
        expiresAt: Value(_expiresAt),
        purchasePrice: Value(price),
        notes: Value(notes.isEmpty ? null : notes),
        isStaple: Value(_isStaple),
        reorderThreshold: Value(_reorderThreshold),
        isBulk: Value(_isBulk),
        updatedAt: Value(now),
      ));
    } else {
      await orchestrator.insertItem(PantryItemsCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        category: Value(_category),
        quantity: Value(_quantity),
        unitType: Value(_unitType),
        location: Value(_location),
        expiresAt: Value(_expiresAt),
        purchasedAt: Value(now),
        purchasePrice: Value(price),
        notes: Value(notes.isEmpty ? null : notes),
        isStaple: Value(_isStaple),
        reorderThreshold: Value(_reorderThreshold),
        isBulk: Value(_isBulk),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content:
            Text('Remove "${widget.existingItem!.name}" from your pantry?'),
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
      await ref
          .read(pantrySyncOrchestratorProvider)
          .deleteItem(widget.existingItem!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
