import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/instruction_step.dart';

/// Card for recipe browser grid/list — shows image, name, time, cuisine badge.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeCard({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or placeholder
            Container(
              height: 120,
              width: double.infinity,
              color: AppColors.coral.withValues(alpha: 0.1),
              child: recipe.imageUrl != null
                  ? Image.network(
                      recipe.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                    )
                  : _imagePlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        recipe.totalTimeDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (recipe.cuisine != null &&
                          recipe.cuisine!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.sage.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            recipe.cuisine!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.sageDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const Center(
      child: Icon(Icons.restaurant, size: 36, color: AppColors.coralLight),
    );
  }
}

/// Ingredient tile with quantity, unit, and optional checkbox.
class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool checked;
  final ValueChanged<bool?>? onChanged;

  const IngredientTile({
    super.key,
    required this.ingredient,
    this.checked = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final quantity = [
      if (ingredient.quantity != null) ingredient.quantity!,
      if (ingredient.unit != null) ingredient.unit!,
    ].join(' ');

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: onChanged != null
          ? Checkbox(
              value: checked,
              onChanged: onChanged,
              activeColor: AppColors.sage,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            )
          : null,
      title: Text(
        ingredient.name,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          decoration: checked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: quantity.isNotEmpty
          ? Text(
              quantity,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      subtitle: ingredient.optional
          ? const Text('Optional',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary))
          : null,
    );
  }
}

/// Instruction step tile — step number, instruction, tip, timer button.
class InstructionStepTile extends StatelessWidget {
  final InstructionStep step;
  final bool isActive;
  final VoidCallback? onTimerTap;

  const InstructionStepTile({
    super.key,
    required this.step,
    this.isActive = false,
    this.onTimerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.coral.withValues(alpha: 0.05)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: AppColors.coral, width: 1.5)
            : Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.coral : AppColors.textTertiary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step.stepNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.instruction,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (step.tip != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      size: 16, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.tip!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (step.timeMinutes != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onTimerTap,
                icon: const Icon(Icons.timer, size: 16),
                label: Text('${step.timeMinutes} min'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.coral,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
