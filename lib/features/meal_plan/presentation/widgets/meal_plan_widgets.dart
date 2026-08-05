import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/meal_plan.dart';

/// Header showing plan date range and completion progress.
class PlanSummaryHeader extends StatelessWidget {
  final MealPlan plan;
  final VoidCallback? onDateTap;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const PlanSummaryHeader({
    super.key,
    required this.plan,
    this.onDateTap,
    this.onRetry,
    this.retryLabel,
  });

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
                  InkWell(
                    onTap: onDateTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month,
                              color: AppColors.coral, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            range,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (onDateTap != null) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.edit_calendar,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ],
                        ],
                      ),
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
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: plan.completionPercent,
                        backgroundColor:
                            Theme.of(context).colorScheme.outline,
                        color: AppColors.sage,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  if (retryLabel != null) ...[
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(retryLabel!),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.coral,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ],
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
  final ValueChanged<bool>? onApprovalToggle;
  final bool isApproved;
  final bool isCooked;

  const MealPlanDayCard({
    super.key,
    required this.day,
    this.onTap,
    this.onApprovalToggle,
    this.isApproved = false,
    this.isCooked = false,
  });

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEE, MMM d');
    final isToday = _isToday(day.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        color: isCooked
            ? AppColors.sage.withValues(alpha: 0.12)
            : isApproved
                ? AppColors.sage.withValues(alpha: 0.08)
                : isToday
                    ? AppColors.coral.withValues(alpha: 0.05)
                    : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isCooked
              ? const BorderSide(color: AppColors.sage, width: 1.5)
              : isApproved
                  ? const BorderSide(color: AppColors.sage, width: 1.5)
                  : isToday
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
                        color: isCooked
                            ? Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : isToday
                                ? AppColors.coral
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                      ),
                    ),
                    if (isToday && !isCooked)
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
                      color: isCooked
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.45)
                          : Theme.of(context).colorScheme.onSurface,
                      decoration:
                          isCooked ? TextDecoration.lineThrough : null,
                      decorationColor: isCooked
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.3)
                          : null,
                    ),
                  ),
                ),
                // Cooked check or approval checkbox
                if (isCooked)
                  const Icon(Icons.check_circle,
                      color: AppColors.sage, size: 28)
                else
                  Checkbox(
                    value: isApproved,
                    onChanged: onApprovalToggle != null
                        ? (v) => onApprovalToggle!(v ?? false)
                        : null,
                    activeColor: AppColors.sage,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                // Navigate chevron
                Icon(Icons.chevron_right,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
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
