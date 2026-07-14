import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/meal_plan.dart';

/// Header showing plan date range and completion progress.
class PlanSummaryHeader extends StatelessWidget {
  final MealPlan plan;

  const PlanSummaryHeader({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');
    final range =
        '${dateFormat.format(plan.startDate)} - ${dateFormat.format(plan.endDate)}';
    final percent = (plan.completionPercent * 100).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month,
                      color: AppColors.coral, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    range,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '$percent% done',
                    style: TextStyle(
                      color: percent == 100
                          ? AppColors.success
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: plan.completionPercent,
                  backgroundColor: Theme.of(context).colorScheme.outline,
                  color: AppColors.sage,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card representing a single day in the meal plan.
class MealPlanDayCard extends StatelessWidget {
  final MealPlanDay day;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onCookedToggle;

  const MealPlanDayCard({
    super.key,
    required this.day,
    this.onTap,
    this.onCookedToggle,
  });

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEE, MMM d');
    final isToday = _isToday(day.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        color: isToday ? AppColors.coral.withValues(alpha: 0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isToday
              ? const BorderSide(color: AppColors.coral, width: 1.5)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Date column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayFormat.format(day.date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isToday
                            ? AppColors.coral
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (isToday)
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coral,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Recipe name
                Expanded(
                  child: Text(
                    day.recipeName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      decoration:
                          day.isCooked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                // Cooked toggle
                Checkbox(
                  value: day.isCooked,
                  onChanged: onCookedToggle != null
                      ? (v) => onCookedToggle!(v ?? false)
                      : null,
                  activeColor: AppColors.sage,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
