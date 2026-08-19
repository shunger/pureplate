import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../pantry/data/services/pantry_consumption_service.dart';
import '../../data/datasources/recipe_mapper.dart';
import '../providers/recipe_providers.dart';

/// Step-by-step cooking mode with large text, timers, and screen-awake lock.
class CookingModeScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const CookingModeScreen({super.key, required this.recipeId});

  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  int _currentStep = 0;
  Timer? _timer;
  int _timerSeconds = 0;
  bool _timerRunning = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(widget.recipeId));

    return recipeAsync.when(
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('Cooking')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (recipe) {
        if (recipe == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(),
            body: const Center(child: Text('Recipe not found')),
          );
        }

        final instructions = recipe.instructions;
        if (instructions.isEmpty) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(title: Text(recipe.name)),
            body: const Center(child: Text('No instructions available')),
          );
        }

        final step = instructions[_currentStep];
        final isFirst = _currentStep == 0;
        final isLast = _currentStep == instructions.length - 1;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(recipe.name),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    '${_currentStep + 1} / ${instructions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / instructions.length,
                    backgroundColor: Theme.of(context).colorScheme.outline,
                    color: AppColors.coral,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 32),

                // Step number
                Text(
                  'Step ${step.stepNumber}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),

                // Instruction text (large)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.instruction,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.6,
                          ),
                        ),
                        if (step.tip != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_outline,
                                    size: 20, color: AppColors.info),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    step.tip!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.info,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        // Timer section
                        if (step.timeMinutes != null) ...[
                          const SizedBox(height: 24),
                          _buildTimerSection(step.timeMinutes!),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Navigation buttons
                Row(
                  children: [
                    if (!isFirst)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _previousStep,
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text('Previous'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    if (!isFirst && !isLast) const SizedBox(width: 12),
                    if (!isLast)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _nextStep,
                          icon: const Icon(Icons.arrow_forward, size: 18),
                          label: const Text('Next'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    if (isLast)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _finishCooking(context),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Done!'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.sage,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerSection(int minutes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _formatTimer(_timerRunning ? _timerSeconds : minutes * 60),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: _timerRunning && _timerSeconds <= 10
                    ? AppColors.error
                    : Theme.of(context).colorScheme.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_timerRunning)
                  FilledButton.icon(
                    onPressed: () => _startTimer(minutes),
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text('Start Timer'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coral,
                    ),
                  )
                else ...[
                  FilledButton.icon(
                    onPressed: _stopTimer,
                    icon: const Icon(Icons.stop, size: 20),
                    label: const Text('Stop'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer(int minutes) {
    setState(() {
      _timerSeconds = minutes * 60;
      _timerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds <= 0) {
        timer.cancel();
        setState(() => _timerRunning = false);
        return;
      }
      setState(() => _timerSeconds--);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _timerRunning = false);
  }

  void _nextStep() {
    _timer?.cancel();
    setState(() {
      _currentStep++;
      _timerRunning = false;
    });
  }

  void _previousStep() {
    _timer?.cancel();
    setState(() {
      _currentStep--;
      _timerRunning = false;
    });
  }

  Future<void> _finishCooking(BuildContext context) async {
    // Try to mark today's meal as cooked if this recipe is in a plan
    final meal = await ref.read(mealPlanDaoProvider).getTodaysMeal();
    if (meal != null && meal.recipeId == widget.recipeId) {
      await ref.read(mealPlanDaoProvider).markCooked(meal.id, true);
    }

    // Deduct pantry items for this recipe.
    ConsumptionResult? result;
    final dbRecipe =
        await ref.read(recipeDaoProvider).getRecipeById(widget.recipeId);
    if (dbRecipe != null) {
      final recipe = RecipeMapper.fromDb(dbRecipe);
      result = await ref
          .read(pantryConsumptionServiceProvider)
          .deductIngredientsForRecipe(
            recipe: recipe,
            pantryDao: ref.read(pantryDaoProvider),
            shoppingListDao: ref.read(shoppingListDaoProvider),
          );
    }

    if (!context.mounted) return;

    final message = _buildCookingMessage(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.sage,
      ),
    );
    Navigator.of(context).pop();
  }

  String _buildCookingMessage(ConsumptionResult? result) {
    if (result == null || result.deductedCount == 0) {
      return 'Great cooking! Meal marked as done.';
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

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
