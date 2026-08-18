import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/models/dietary_restriction.dart';
import '../providers/onboarding_providers.dart';

/// Onboarding dietary preferences — dietary restrictions, allergen alerts,
/// and disliked ingredients.
class OnboardingDietaryScreen extends ConsumerStatefulWidget {
  const OnboardingDietaryScreen({super.key});

  @override
  ConsumerState<OnboardingDietaryScreen> createState() =>
      _OnboardingDietaryScreenState();
}

class _OnboardingDietaryScreenState
    extends ConsumerState<OnboardingDietaryScreen> {
  final _ingredientController = TextEditingController();
  final _customRestrictionController = TextEditingController();

  @override
  void dispose() {
    _ingredientController.dispose();
    _customRestrictionController.dispose();
    super.dispose();
  }

  void _addCustomRestriction(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    final notifier = ref.read(onboardingStateProvider.notifier);
    final current = ref.read(onboardingStateProvider).customDietaryRestrictions;
    if (!current.any((r) => r.toLowerCase() == trimmed.toLowerCase())) {
      notifier.setCustomDietaryRestrictions([...current, trimmed]);
    }
    _customRestrictionController.clear();
  }

  void _addIngredient(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    final notifier = ref.read(onboardingStateProvider.notifier);
    final current = ref.read(onboardingStateProvider).dislikedIngredients;
    if (!current.contains(trimmed.toLowerCase())) {
      notifier.setDislikedIngredients([...current, trimmed.toLowerCase()]);
    }
    _ingredientController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: DietaryRestriction.values.map((dr) {
                        final selected =
                            state.dietaryRestrictions.contains(dr);
                        return FilterChip(
                          label: Text(dr.displayName),
                          selected: selected,
                          onSelected: (v) {
                            final updated = List<DietaryRestriction>.from(
                                state.dietaryRestrictions);
                            if (v) {
                              updated.add(dr);
                            } else {
                              updated.remove(dr);
                            }
                            notifier.setDietaryRestrictions(updated);
                          },
                          showCheckmark: true,
                          selectedColor:
                              AppColors.sage.withValues(alpha: 0.2),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customRestrictionController,
                      decoration: InputDecoration(
                        hintText: 'Add a custom restriction...',
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () => _addCustomRestriction(
                              _customRestrictionController.text),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: _addCustomRestriction,
                    ),
                    if (state.customDietaryRestrictions.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.customDietaryRestrictions
                            .map((restriction) {
                          return Chip(
                            label: Text(restriction),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              final updated = List<String>.from(
                                  state.customDietaryRestrictions)
                                ..remove(restriction);
                              notifier
                                  .setCustomDietaryRestrictions(updated);
                            },
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // ── Disliked Ingredients ──────────────────────
                    Text(
                      'Ingredients you don\'t like',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We\'ll avoid these in recipe suggestions.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ingredientController,
                      decoration: InputDecoration(
                        hintText: 'Type an ingredient and press enter',
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () =>
                              _addIngredient(_ingredientController.text),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: _addIngredient,
                    ),
                    if (state.dislikedIngredients.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            state.dislikedIngredients.map((ingredient) {
                          return Chip(
                            label: Text(ingredient),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              final updated = List<String>.from(
                                  state.dislikedIngredients)
                                ..remove(ingredient);
                              notifier.setDislikedIngredients(updated);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(Routes.onboardingStyle),
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
                onPressed: () => context.go(Routes.onboardingStyle),
                child: Text(
                  'No restrictions',
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
}
