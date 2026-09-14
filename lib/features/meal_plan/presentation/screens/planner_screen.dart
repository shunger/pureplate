import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../pantry/data/datasources/pantry_sync_orchestrator.dart';
import '../../../pantry/data/services/pantry_consumption_service.dart';
import '../../../shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';
import '../../../recipes/data/datasources/recipe_mapper.dart';
import '../../domain/models/meal_plan.dart';
import '../providers/meal_plan_providers.dart';
import '../providers/plan_generation_providers.dart';
import '../widgets/meal_plan_widgets.dart';

/// Main Planner tab — shows the latest/active meal plan as a week view.
class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  /// Day IDs the user has approved (checked = keep this meal).
  final _approvedDayIds = <String>{};
  bool _isRegenerating = false;

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(latestMealPlanProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Generate new plan',
            onPressed: () {
              _approvedDayIds.clear();
              context.push(Routes.planGeneration);
            },
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
          return _buildPlanView(plan);
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

  Future<void> _changeStartDate(MealPlan plan) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: plan.startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;

    final newStart = DateTime(picked.year, picked.month, picked.day);
    if (newStart == plan.startDate) return;

    await ref.read(mealPlanDaoProvider).shiftPlanStartDate(plan.id, newStart);
  }

  Future<void> _retryUnapproved(MealPlan plan) async {
    final sortedDays = List.of(plan.days)
      ..sort((a, b) => a.date.compareTo(b.date));

    final daysToReplace = sortedDays
        .where((d) => !_approvedDayIds.contains(d.id))
        .toList();

    if (daysToReplace.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check the meals you want to keep first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final keptNames = sortedDays
        .where((d) => _approvedDayIds.contains(d.id))
        .map((d) => d.recipeName)
        .toList();

    setState(() => _isRegenerating = true);

    // Get the raw DB rows for the days to replace.
    final dao = ref.read(mealPlanDaoProvider);
    final allDbDays = await dao.getDaysForPlan(plan.id);
    final dbDaysToReplace = allDbDays
        .where((d) => daysToReplace.any((dom) => dom.id == d.id))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final success = await ref
        .read(planGenerationStateProvider.notifier)
        .regeneratePartial(
          planId: plan.id,
          daysToReplace: dbDaysToReplace,
          keptMealNames: keptNames,
        );

    if (!mounted) return;
    setState(() => _isRegenerating = false);

    if (success) {
      // Clear approvals for the regenerated days so user can review again.
      // Keep the approved ones checked.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${daysToReplace.length} meal${daysToReplace.length == 1 ? '' : 's'} refreshed!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final error = ref.read(planGenerationStateProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to regenerate meals.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onReorderItem(
      List<MealPlanDay> sortedDays, int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final dao = ref.read(mealPlanDaoProvider);
    await dao.swapDayDates(sortedDays[oldIndex].id, sortedDays[newIndex].id);
  }

  String _buildCookedMessage(String recipeName, ConsumptionResult? result) {
    if (result == null || result.deductedCount == 0) {
      return '$recipeName marked as cooked';
    }
    final parts = <String>[
      'Pantry updated — ${result.deductedCount} item${result.deductedCount == 1 ? '' : 's'} deducted',
    ];
    if (result.addedToListCount > 0) {
      parts.add(
        '${result.addedToListCount} added to ${result.shoppingListName ?? 'shopping list'}',
      );
    }
    return parts.join(', ');
  }

  Widget _buildPlanView(MealPlan plan) {
    final sortedDays = List.of(plan.days)
      ..sort((a, b) => a.date.compareTo(b.date));

    final unapprovedCount =
        sortedDays.where((d) => !_approvedDayIds.contains(d.id)).length;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PlanSummaryHeader(
            plan: plan,
            onDateTap: () => _changeStartDate(plan),
            onRetry: _isRegenerating ? null : () => _retryUnapproved(plan),
            retryLabel: _isRegenerating
                ? 'Regenerating...'
                : unapprovedCount == sortedDays.length
                    ? 'Try again'
                    : 'Refresh $unapprovedCount meal${unapprovedCount == 1 ? '' : 's'}',
          ),
        ),
        if (_isRegenerating)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: LinearProgressIndicator(color: AppColors.coral),
              ),
            ),
          ),
        SliverReorderableList(
          itemCount: sortedDays.length,
          onReorderItem: (oldIndex, newIndex) =>
              _onReorderItem(sortedDays, oldIndex, newIndex),
          itemBuilder: (context, index) {
            final day = sortedDays[index];
            final isApproved = _approvedDayIds.contains(day.id);
            return ReorderableDragStartListener(
              key: ValueKey(day.id),
              index: index,
              child: Dismissible(
                key: ValueKey('dismiss_${day.id}'),
                direction: day.isCooked
                    ? DismissDirection.none
                    : DismissDirection.startToEnd,
                confirmDismiss: (_) async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref
                      .read(mealPlanDaoProvider)
                      .markCooked(day.id, true);

                  // Deduct pantry items.
                  ConsumptionResult? result;
                  final dbRecipe = await ref
                      .read(recipeDaoProvider)
                      .getRecipeById(day.recipeId);
                  if (dbRecipe != null) {
                    final recipe = RecipeMapper.fromDb(dbRecipe);
                    result = await ref
                        .read(pantryConsumptionServiceProvider)
                        .deductIngredientsForRecipe(
                          recipe: recipe,
                          pantryDao: ref.read(pantryDaoProvider),
                          shoppingListDao:
                              ref.read(shoppingListDaoProvider),
                          pantrySync:
                              ref.read(pantrySyncOrchestratorProvider),
                          listSync: ref
                              .read(shoppingListSyncOrchestratorProvider),
                        );
                  }

                  final msg = _buildCookedMessage(
                    day.recipeName,
                    result,
                  );
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return false; // Snap back; stream update renders cooked state
                },
                background: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sage,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 24),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Mark Cooked',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                child: MealPlanDayCard(
                  day: day,
                  isApproved: isApproved,
                  isCooked: day.isCooked,
                  onTap: () => context.push('/recipes/${day.recipeId}'),
                  onApprovalToggle: day.isCooked
                      ? null
                      : (approved) {
                          setState(() {
                            if (approved) {
                              _approvedDayIds.add(day.id);
                            } else {
                              _approvedDayIds.remove(day.id);
                            }
                          });
                        },
                ),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
