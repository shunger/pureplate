import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';

/// Compact pantry overview showing item count, expiring count, and reorder alerts.
class PantrySummaryCard extends ConsumerWidget {
  const PantrySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Wire to actual pantry providers once ported.
    // final pantryItems = ref.watch(pantryItemsProvider);

    // Placeholder data — replace with real provider.
    const totalItems = 47;
    const expiringCount = 3;
    const reorderCount = 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        child: InkWell(
          onTap: () => context.go(Routes.pantry),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.kitchen, color: AppColors.sage, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Pantry Overview',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatChip(
                      label: '$totalItems items',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.sage,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      label: '$expiringCount expiring',
                      icon: Icons.schedule,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      label: '$reorderCount low',
                      icon: Icons.shopping_bag_outlined,
                      color: AppColors.info,
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
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
