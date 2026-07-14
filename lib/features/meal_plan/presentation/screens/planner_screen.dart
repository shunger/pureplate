import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../providers/meal_plan_providers.dart';
import '../widgets/meal_plan_widgets.dart';

/// Main Planner tab — shows the latest/active meal plan as a week view.
class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(latestMealPlanProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Generate new plan',
            onPressed: () => context.push(Routes.planGeneration),
          ),
        ],
      ),
      body: planAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
        error: (e, _) => Center(
          child: Text('Error loading plan: $e'),
        ),
        data: (plan) {
          if (plan == null) {
            return _buildEmptyState(context);
          }
          return _buildPlanView(context, ref, plan);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 48,
                color: AppColors.coral,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No meal plan yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate a personalized meal plan based on\nyour pantry and preferences.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push(Routes.planGeneration),
              icon: const Icon(Icons.auto_awesome, size: 20),
              label: const Text('Generate Plan'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanView(BuildContext context, WidgetRef ref, plan) {
    final sortedDays = List.of(plan.days)
      ..sort((a, b) => a.date.compareTo(b.date));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PlanSummaryHeader(plan: plan),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final day = sortedDays[index];
              return MealPlanDayCard(
                day: day,
                onTap: () => context.push('/recipes/${day.recipeId}'),
                onCookedToggle: (cooked) {
                  ref
                      .read(mealPlanDaoProvider)
                      .markCooked(day.id, cooked);
                },
              );
            },
            childCount: sortedDays.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
