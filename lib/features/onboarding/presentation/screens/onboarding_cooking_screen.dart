import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../meal_plan/domain/models/family_profile.dart';
import '../providers/onboarding_providers.dart';

/// Onboarding cooking preferences — cuisine, cook time, budget.
/// Final onboarding step: saves profile and marks onboarding complete.
class OnboardingCookingScreen extends ConsumerStatefulWidget {
  const OnboardingCookingScreen({super.key});

  @override
  ConsumerState<OnboardingCookingScreen> createState() =>
      _OnboardingCookingScreenState();
}

class _OnboardingCookingScreenState
    extends ConsumerState<OnboardingCookingScreen> {
  final _cuisineController = TextEditingController();

  @override
  void dispose() {
    _cuisineController.dispose();
    super.dispose();
  }

  void _addCustomCuisine(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    final notifier = ref.read(onboardingStateProvider.notifier);
    final current = ref.read(onboardingStateProvider).cuisinePreferences;
    if (!current.any((c) => c.toLowerCase() == trimmed.toLowerCase())) {
      notifier.setCuisinePreferences([...current, trimmed]);
    }
    _cuisineController.clear();
  }

  static const _cuisineOptions = [
    'Italian',
    'Mexican',
    'Chinese',
    'Indian',
    'Japanese',
    'Thai',
    'Mediterranean',
    'American',
    'Korean',
    'French',
    'Middle Eastern',
    'Vietnamese',
  ];

  @override
  Widget build(BuildContext context) {
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
              'How do you like to cook?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pick your favorite cuisines, preferred cook time, and budget.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cuisine preferences
                    Text(
                      'Favorite Cuisines',
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
                      children: _cuisineOptions.map((cuisine) {
                        final selected =
                            state.cuisinePreferences.contains(cuisine);
                        return FilterChip(
                          label: Text(cuisine),
                          selected: selected,
                          onSelected: (v) {
                            final updated =
                                List<String>.from(state.cuisinePreferences);
                            if (v) {
                              updated.add(cuisine);
                            } else {
                              updated.remove(cuisine);
                            }
                            notifier.setCuisinePreferences(updated);
                          },
                          selectedColor:
                              AppColors.coral.withValues(alpha: 0.15),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _cuisineController,
                      decoration: InputDecoration(
                        hintText: 'Add another cuisine...',
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
                              _addCustomCuisine(_cuisineController.text),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: _addCustomCuisine,
                    ),
                    Builder(builder: (context) {
                      final customCuisines = state.cuisinePreferences
                          .where((c) => !_cuisineOptions.contains(c))
                          .toList();
                      if (customCuisines.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: customCuisines.map((cuisine) {
                            return Chip(
                              label: Text(cuisine),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                final updated = List<String>.from(
                                    state.cuisinePreferences)
                                  ..remove(cuisine);
                                notifier.setCuisinePreferences(updated);
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Cook time
                    Text(
                      'Preferred Cook Time',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...PreferredCookTime.values
                        .map((ct) => RadioListTile<PreferredCookTime>(
                              title: Text(_cookTimeLabel(ct)),
                              value: ct,
                              groupValue: state.preferredCookTime,
                              onChanged: (v) => notifier.setCookTime(v!),
                              activeColor: AppColors.coral,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            )),

                    const SizedBox(height: 20),

                    // Budget level
                    Text(
                      'Budget Level',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...BudgetLevel.values
                        .map((bl) => RadioListTile<BudgetLevel>(
                              title: Text(_budgetLabel(bl)),
                              value: bl,
                              groupValue: state.budgetLevel,
                              onChanged: (v) => notifier.setBudgetLevel(v!),
                              activeColor: AppColors.coral,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Finish button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _finish(context),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                child: const Text('Start Cooking!'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _finish(BuildContext context) async {
    final state = ref.read(onboardingStateProvider);
    final profileDao = ref.read(familyProfileDaoProvider);
    final prefsDao = ref.read(preferencesDaoProvider);
    final now = DateTime.now();
    final id = const Uuid().v4();

    // Build cuisine preferences as a JSON map.
    final cuisineMap = <String, dynamic>{};
    for (final c in state.cuisinePreferences) {
      cuisineMap[c] = 1.0;
    }

    // Cook time to DB string.
    String cookTimeStr;
    switch (state.preferredCookTime) {
      case PreferredCookTime.under30:
        cookTimeStr = '30';
      case PreferredCookTime.under45:
        cookTimeStr = '30-45';
      case PreferredCookTime.under60:
        cookTimeStr = '45-60';
      case PreferredCookTime.anyTime:
        cookTimeStr = '60+';
    }

    // Save family profile.
    await profileDao.upsertProfile(FamilyProfilesCompanion(
      id: Value(id),
      adults: Value(state.adults),
      kids: Value(state.kids),
      kidAgeRangesJson: Value(
          jsonEncode(state.kidAgeRanges.map((r) => r.name).toList())),
      dietaryRestrictionsJson: Value(jsonEncode([
        ...state.dietaryRestrictions.map((d) => d.name),
        ...state.customDietaryRestrictions,
      ])),
      cuisinePreferencesJson: Value(jsonEncode(cuisineMap)),
      preferredCookTime: Value(cookTimeStr),
      budgetLevel: Value(state.budgetLevel.name),
      skillLevel: Value(state.skillLevel.name),
      spiceTolerance: Value(state.spiceTolerance.name),
      varietyPreference: Value(state.varietyPreference.name),
      dislikedIngredientsJson:
          Value(jsonEncode(state.dislikedIngredients)),
      onboardingCompleted: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));

    // Mark onboarding completed in preferences.
    await prefsDao.setOnboardingCompleted(true);

    if (mounted) {
      context.go(Routes.home);
    }
  }

  String _cookTimeLabel(PreferredCookTime ct) {
    switch (ct) {
      case PreferredCookTime.under30:
        return 'Under 30 minutes';
      case PreferredCookTime.under45:
        return '30-45 minutes';
      case PreferredCookTime.under60:
        return '45-60 minutes';
      case PreferredCookTime.anyTime:
        return 'Any time (60+ ok)';
    }
  }

  String _budgetLabel(BudgetLevel bl) {
    switch (bl) {
      case BudgetLevel.budget:
        return 'Budget-friendly';
      case BudgetLevel.moderate:
        return 'Moderate';
      case BudgetLevel.premium:
        return 'Premium ingredients';
    }
  }
}
