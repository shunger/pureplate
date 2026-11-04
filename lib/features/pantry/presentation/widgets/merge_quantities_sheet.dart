import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/pantry_sync_orchestrator.dart';

/// Asks which quantity to keep for items in both pantries, when this phone's
/// pantry merges into a shared one. Returns the chosen quantity per
/// [PantryMergeConflict.key]; every conflict gets an answer.
///
/// [sharedLabel] names the pantry being joined, [localLabel] this phone's.
Future<Map<String, double>> showMergeQuantitiesSheet(
  BuildContext context,
  List<PantryMergeConflict> conflicts, {
  required String sharedLabel,
  required String localLabel,
}) async {
  final defaults = {
    for (final c in conflicts) c.key: _MergeChoice.keepLarger.quantity(c),
  };
  if (!context.mounted) return defaults;
  final result = await showModalBottomSheet<Map<String, double>>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    // The merge waits for an answer, so it's given with the button.
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _MergeQuantitiesSheet(
      conflicts: conflicts,
      sharedLabel: sharedLabel,
      localLabel: localLabel,
    ),
  );
  return result ?? defaults;
}

enum _MergeChoice {
  keepLarger,
  addTogether;

  double quantity(PantryMergeConflict c) => switch (this) {
        keepLarger => c.sharedQuantity > c.localQuantity
            ? c.sharedQuantity
            : c.localQuantity,
        addTogether => c.sharedQuantity + c.localQuantity,
      };
}

String _format(double quantity) => quantity == quantity.roundToDouble()
    ? quantity.toInt().toString()
    : quantity.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');

class _MergeQuantitiesSheet extends StatefulWidget {
  final List<PantryMergeConflict> conflicts;
  final String sharedLabel;
  final String localLabel;

  const _MergeQuantitiesSheet({
    required this.conflicts,
    required this.sharedLabel,
    required this.localLabel,
  });

  @override
  State<_MergeQuantitiesSheet> createState() => _MergeQuantitiesSheetState();
}

class _MergeQuantitiesSheetState extends State<_MergeQuantitiesSheet> {
  late final Map<String, TextEditingController> _amounts = {
    for (final c in widget.conflicts)
      c.key: TextEditingController(
          text: _format(_MergeChoice.keepLarger.quantity(c))),
  };

  @override
  void dispose() {
    for (final controller in _amounts.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Sets every item to [choice], for the shortcuts at the top.
  void _applyToAll(_MergeChoice choice) {
    setState(() {
      for (final c in widget.conflicts) {
        _amounts[c.key]!.text = _format(choice.quantity(c));
      }
    });
  }

  void _done() {
    final result = <String, double>{};
    for (final c in widget.conflicts) {
      final typed = double.tryParse(_amounts[c.key]!.text.trim());
      result[c.key] = typed != null && typed >= 0
          ? typed
          : _MergeChoice.keepLarger.quantity(c);
    }
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final count = widget.conflicts.length;

    return PopScope(
      canPop: false,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        count == 1
                            ? '1 item is in both pantries'
                            : '$count items are in both pantries',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose how many to keep. If both apps were tracking '
                        'the same food, keep one amount; if they are '
                        'separate, add them together.',
                        style:
                            theme.textTheme.bodyMedium?.copyWith(color: muted),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          ActionChip(
                            label: const Text('Keep larger for all'),
                            onPressed: () =>
                                _applyToAll(_MergeChoice.keepLarger),
                          ),
                          ActionChip(
                            label: const Text('Add together for all'),
                            onPressed: () =>
                                _applyToAll(_MergeChoice.addTogether),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: count,
                    separatorBuilder: (_, _) =>
                        const Divider(indent: 24, endIndent: 24),
                    itemBuilder: (context, i) =>
                        _conflictRow(context, widget.conflicts[i]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: FilledButton(
                    onPressed: _done,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _conflictRow(BuildContext context, PantryMergeConflict c) {
    final theme = Theme.of(context);
    final controller = _amounts[c.key]!;
    final current = double.tryParse(controller.text.trim());

    Widget option(String label, double quantity) => ChoiceChip(
          label: Text(label),
          selected: current == quantity,
          onSelected: (_) =>
              setState(() => controller.text = _format(quantity)),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(c.name,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                width: 96,
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    isDense: true,
                    suffixText: c.unitType,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              option('${widget.sharedLabel}: ${_format(c.sharedQuantity)}',
                  c.sharedQuantity),
              if (c.localQuantity != c.sharedQuantity)
                option('${widget.localLabel}: ${_format(c.localQuantity)}',
                    c.localQuantity),
              option(
                  'Both: ${_format(c.sharedQuantity + c.localQuantity)}',
                  c.sharedQuantity + c.localQuantity),
            ],
          ),
        ],
      ),
    );
  }
}
