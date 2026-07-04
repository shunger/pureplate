import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../meal_plan/domain/models/family_profile.dart';
import '../providers/onboarding_providers.dart';

/// Onboarding family setup — adults count, kids count, kid age ranges.
class OnboardingFamilyScreen extends ConsumerWidget {
  const OnboardingFamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Your Family'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(Routes.onboardingWelcome),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who are you cooking for?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This helps us size recipes and personalize suggestions.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Adults stepper
            _StepperRow(
              label: 'Adults',
              value: state.adults,
              onDecrement:
                  state.adults > 1 ? () => notifier.setAdults(state.adults - 1) : null,
              onIncrement: () => notifier.setAdults(state.adults + 1),
            ),
            const SizedBox(height: 20),

            // Kids stepper
            _StepperRow(
              label: 'Kids',
              value: state.kids,
              onDecrement:
                  state.kids > 0 ? () => notifier.setKids(state.kids - 1) : null,
              onIncrement: () => notifier.setKids(state.kids + 1),
            ),

            // Kid age ranges
            if (state.kids > 0) ...[
              const SizedBox(height: 24),
              const Text(
                'Age ranges',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: KidAgeRange.values.map((range) {
                  final selected = state.kidAgeRanges.contains(range);
                  return FilterChip(
                    label: Text(range.label),
                    selected: selected,
                    onSelected: (v) {
                      final updated = List<KidAgeRange>.from(state.kidAgeRanges);
                      if (v) {
                        updated.add(range);
                      } else {
                        updated.remove(range);
                      }
                      notifier.setKidAgeRanges(updated);
                    },
                  );
                }).toList(),
              ),
            ],

            const Spacer(),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(Routes.onboardingDietary),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _StepperRow({
    required this.label,
    required this.value,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, color: AppColors.textPrimary)),
        const Spacer(),
        IconButton.filled(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.cream,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size(40, 40),
          ),
        ),
        SizedBox(
          width: 48,
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        IconButton.filled(
          onPressed: onIncrement,
          icon: const Icon(Icons.add, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: Colors.white,
            minimumSize: const Size(40, 40),
          ),
        ),
      ],
    );
  }
}
