import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../meal_plan/domain/models/family_profile.dart';
import '../providers/onboarding_providers.dart';

/// Onboarding cooking style — skill level, spice tolerance, variety preference.
class OnboardingStyleScreen extends ConsumerWidget {
  const OnboardingStyleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cooking Style'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about your style',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This helps us suggest recipes that match your comfort level.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Skill Level ──────────────────────────────
                    Text(
                      'Cooking Skill',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: SkillLevel.values.map((level) {
                        final selected = state.skillLevel == level;
                        return ChoiceChip(
                          label: Text(_skillLabel(level)),
                          selected: selected,
                          onSelected: (_) => notifier.setSkillLevel(level),
                          selectedColor:
                              AppColors.sage.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _skillDescription(state.skillLevel),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Spice Tolerance ──────────────────────────
                    Text(
                      'Spice Tolerance',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: SpiceTolerance.values.map((level) {
                        final selected = state.spiceTolerance == level;
                        return ChoiceChip(
                          label: Text(_spiceLabel(level)),
                          selected: selected,
                          onSelected: (_) =>
                              notifier.setSpiceTolerance(level),
                          selectedColor:
                              AppColors.coral.withValues(alpha: 0.15),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // ── Variety Preference ───────────────────────
                    Text(
                      'Meal Variety',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: VarietyPreference.values.map((pref) {
                        final selected = state.varietyPreference == pref;
                        return ChoiceChip(
                          label: Text(_varietyLabel(pref)),
                          selected: selected,
                          onSelected: (_) =>
                              notifier.setVarietyPreference(pref),
                          selectedColor:
                              AppColors.sage.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _varietyDescription(state.varietyPreference),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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
                  'Skip for now',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _skillLabel(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.comfortable:
        return 'Comfortable';
      case SkillLevel.experienced:
        return 'Experienced';
    }
  }

  String _skillDescription(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return 'I follow recipes step by step';
      case SkillLevel.comfortable:
        return 'I can improvise a bit';
      case SkillLevel.experienced:
        return 'I love experimenting';
    }
  }

  String _spiceLabel(SpiceTolerance level) {
    switch (level) {
      case SpiceTolerance.mild:
        return 'Mild';
      case SpiceTolerance.medium:
        return 'Medium';
      case SpiceTolerance.spicy:
        return 'Spicy';
      case SpiceTolerance.hot:
        return 'Bring the heat';
    }
  }

  String _varietyLabel(VarietyPreference pref) {
    switch (pref) {
      case VarietyPreference.familiar:
        return 'Stick to favorites';
      case VarietyPreference.mixed:
        return 'Mix of both';
      case VarietyPreference.adventurous:
        return 'Always something new';
    }
  }

  String _varietyDescription(VarietyPreference pref) {
    switch (pref) {
      case VarietyPreference.familiar:
        return 'Reliable meals I know we\'ll love';
      case VarietyPreference.mixed:
        return 'Mostly familiar, some new';
      case VarietyPreference.adventurous:
        return 'Surprise me often';
    }
  }
}
