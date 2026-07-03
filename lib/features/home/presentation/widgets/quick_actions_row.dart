import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';

/// Row of quick-action buttons: Scan, Add to Pantry, Browse Recipes, Shopping.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ActionButton(
              icon: Icons.qr_code_scanner,
              label: 'Scan',
              color: AppColors.coral,
              onTap: () => context.push(Routes.scanner),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.add_circle_outline,
              label: 'Add Item',
              color: AppColors.sage,
              onTap: () => context.push(Routes.addPantryItem),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.menu_book_outlined,
              label: 'Recipes',
              color: AppColors.info,
              onTap: () => context.push(Routes.recipes),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.chat_outlined,
              label: 'Ask AI',
              color: AppColors.coralDark,
              onTap: () => context.push(Routes.chat),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 6),
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
          ),
        ),
      ),
    );
  }
}
