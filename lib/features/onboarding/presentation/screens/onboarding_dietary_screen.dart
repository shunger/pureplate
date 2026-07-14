import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/models/dietary_restriction.dart';
import '../providers/onboarding_providers.dart';

/// Onboarding dietary preferences — dietary restrictions and allergen alerts.
class OnboardingDietaryScreen extends ConsumerWidget {
  const OnboardingDietaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dietary Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Any dietary needs?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply. We\'ll filter recipes accordingly.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: DietaryRestriction.values.map((dr) {
                    final selected = state.dietaryRestrictions.contains(dr);
                    return FilterChip(
                      label: Text(dr.displayName),
                      selected: selected,
                      onSelected: (v) {
                        final updated =
                            List<DietaryRestriction>.from(state.dietaryRestrictions);
                        if (v) {
                          updated.add(dr);
                        } else {
                          updated.remove(dr);
                        }
                        notifier.setDietaryRestrictions(updated);
                      },
                      showCheckmark: true,
                      selectedColor: AppColors.sage.withValues(alpha: 0.2),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(Routes.onboardingCooking),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.go(Routes.onboardingCooking),
                child: Text(
                  'No restrictions',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
