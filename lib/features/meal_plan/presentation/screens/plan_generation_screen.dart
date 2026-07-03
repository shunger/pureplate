import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/plan_generation_providers.dart';

/// Screen where users configure and trigger AI meal plan generation.
///
/// Flow:
/// 1. User selects number of days (3, 5, or 7).
/// 2. Pantry context is shown (expiring items highlighted).
/// 3. User taps "Generate" → calls Cloud Function via AiPlanRepository.
/// 4. Progress indicator with fun food facts while waiting.
/// 5. On success → navigate to planner calendar view.
class PlanGenerationScreen extends ConsumerStatefulWidget {
  const PlanGenerationScreen({super.key});

  @override
  ConsumerState<PlanGenerationScreen> createState() =>
      _PlanGenerationScreenState();
}

class _PlanGenerationScreenState extends ConsumerState<PlanGenerationScreen> {
  int _selectedDays = 5;

  @override
  Widget build(BuildContext context) {
    final generationState = ref.watch(planGenerationStateProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Plan Your Week'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: generationState.isGenerating
          ? _buildGeneratingView(context)
          : _buildConfigView(context),
    );
  }

  Widget _buildConfigView(BuildContext context) {
    final generationState = ref.watch(planGenerationStateProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'How many dinners?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI will create a personalized plan based on your pantry, '
            'preferences, and what needs to be used soon.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Day selector
          Row(
            children: [3, 5, 7].map((days) {
              final isSelected = _selectedDays == days;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: days == 3 ? 0 : 6,
                    right: days == 7 ? 0 : 6,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedDays = days),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coral
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coral
                                : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.coral.withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$days',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'days',
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Pantry context preview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.kitchen,
                          color: AppColors.sage, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'AI will prioritize',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ContextRow(
                    icon: Icons.schedule,
                    color: AppColors.warning,
                    text: '3 items expiring soon',
                  ),
                  _ContextRow(
                    icon: Icons.inventory_2,
                    color: AppColors.sage,
                    text: '47 pantry items available',
                  ),
                  _ContextRow(
                    icon: Icons.favorite,
                    color: AppColors.coral,
                    text: 'Your cuisine preferences & feedback',
                  ),
                ],
              ),
            ),
          ),

          // Error message
          if (generationState.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      generationState.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Generate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _generatePlan(),
              icon: const Icon(Icons.auto_awesome, size: 20),
              label: const Text('Generate My Plan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => context.push(Routes.chat),
              child: const Text(
                'Or chat with AI for a custom plan',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.coral,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Creating your meal plan...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Checking your pantry, matching your preferences,\n'
              'and finding the best recipes for you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePlan() async {
    final notifier = ref.read(planGenerationStateProvider.notifier);
    final planId = await notifier.generate(numDays: _selectedDays);

    if (planId != null && mounted) {
      context.go(Routes.planner);
    }
  }
}

class _ContextRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _ContextRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
