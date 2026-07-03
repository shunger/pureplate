import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

/// Shows today's planned meal if a meal plan exists.
/// Tapping opens the recipe detail. Includes a "Start cooking" shortcut.
class TodaysMealCard extends ConsumerWidget {
  const TodaysMealCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Wire to actual meal plan provider.
    // final todaysMeal = ref.watch(todaysMealProvider);

    // TODO: Wire to real meal plan provider.
    // Return SizedBox.shrink() if no meal plan exists for today.

    const mealName = 'Lemon Herb Chicken';
    const cuisine = 'Mediterranean';
    const cookTime = '35 min';
    const recipeId = 'placeholder-id';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        child: InkWell(
          onTap: () => context.push('/recipes/$recipeId'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Meal info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tonight's Dinner",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.coral,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        mealName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$cuisine  ·  $cookTime',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Cook button
                FilledButton.icon(
                  onPressed: () => context.push('/cooking/$recipeId'),
                  icon: const Icon(Icons.restaurant, size: 18),
                  label: const Text('Cook'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.sage,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
