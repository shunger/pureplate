import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';

/// Shows all meals planned for today in an expandable card.
///
/// Collapsed: "Up next: Dinner — Chicken Stir Fry" (first uncooked meal).
/// Expanded: list of all meals with cooked ones dimmed + strikethrough.
/// Empty state: static "No meals planned" card.
class TodaysMealCard extends ConsumerWidget {
  const TodaysMealCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(todaysMealsProvider);

    return mealsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (meals) {
        if (meals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Up next',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.coral,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No meals planned',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Find the first uncooked meal for the collapsed title.
        final nextMeal = meals.where((m) => !m.isCooked).firstOrNull;
        final allCooked = nextMeal == null;

        final subtitle = allCooked
            ? 'All meals cooked today!'
            : '${_mealTypeLabel(nextMeal.mealType)} — '
                '${nextMeal.recipeName ?? 'Planned Meal'}';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Theme(
              // Remove the divider line that ExpansionTile adds.
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                childrenPadding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                leading: Icon(
                  allCooked ? Icons.check_circle : Icons.restaurant_menu,
                  color: allCooked ? AppColors.sage : AppColors.coral,
                  size: 20,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Up next',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.coral,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
                children: meals
                    .map((meal) => _MealRow(meal: meal))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _mealTypeLabel(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
        return 'Snack';
      case 'dessert':
        return 'Dessert';
      default:
        return mealType[0].toUpperCase() + mealType.substring(1);
    }
  }
}

class _MealRow extends StatelessWidget {
  final MealPlanDay meal;

  const _MealRow({required this.meal});

  @override
  Widget build(BuildContext context) {
    final cooked = meal.isCooked;

    return InkWell(
      onTap: () => context.push('/recipes/${meal.recipeId}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              _iconForMealType(meal.mealType),
              size: 18,
              color: cooked
                  ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${TodaysMealCard._mealTypeLabel(meal.mealType)} — '
                '${meal.recipeName ?? 'Planned Meal'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cooked
                          ? Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.onSurface,
                      decoration:
                          cooked ? TextDecoration.lineThrough : null,
                    ),
              ),
            ),
            if (cooked)
              Icon(
                Icons.check_circle_outline,
                size: 18,
                color: AppColors.sage.withValues(alpha: 0.7),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconForMealType(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.wb_sunny_outlined;
      case 'lunch':
        return Icons.lunch_dining_outlined;
      case 'dinner':
        return Icons.dinner_dining_outlined;
      case 'snack':
        return Icons.cookie_outlined;
      case 'dessert':
        return Icons.cake_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }
}
