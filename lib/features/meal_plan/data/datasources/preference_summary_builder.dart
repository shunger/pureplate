import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/family_profile.dart';
import '../../domain/models/meal_plan.dart';
import '../../../pantry/domain/models/pantry_item.dart';

/// A feedback record paired with the cuisine of the recipe it refers to.
class FeedbackCuisine {
  final String feedback; // 'loved', 'disliked', 'favorite'
  final String cuisine;

  const FeedbackCuisine({required this.feedback, required this.cuisine});
}

/// Builds the JSON preference summary injected into every AI prompt.
///
/// This is computed entirely on-device from local data — never fetched from
/// the network. It combines family preferences, current pantry stock,
/// recipe feedback, and recent meal history into a structured context
/// that the LLM uses to personalize suggestions.
class PreferenceSummaryBuilder {
  /// Compute cuisine affinity scores by blending onboarding preferences
  /// with feedback signals.
  ///
  /// Onboarding preferences provide the baseline (0.8 for liked cuisines,
  /// 0.5 for unmentioned). Feedback shifts scores up or down based on the
  /// ratio of positive to negative reactions per cuisine.
  ///
  /// Final scores are clamped to [0.05, 1.0] — never fully zero so the AI
  /// can still occasionally suggest a cuisine the user hasn't tried.
  static Map<String, double> computeCuisineAffinities({
    List<String> profileCuisines = const [],
    List<FeedbackCuisine> feedbackRecords = const [],
  }) {
    // Start from onboarding preferences.
    final affinities = <String, double>{};
    for (final cuisine in profileCuisines) {
      affinities[cuisine.toLowerCase()] = 0.8;
    }

    if (feedbackRecords.isEmpty) return affinities;

    // Count positive and negative signals per cuisine.
    final positiveCounts = <String, int>{};
    final negativeCounts = <String, int>{};

    for (final record in feedbackRecords) {
      final cuisine = record.cuisine.toLowerCase();
      if (record.feedback == 'loved' || record.feedback == 'favorite') {
        positiveCounts[cuisine] = (positiveCounts[cuisine] ?? 0) + 1;
      } else if (record.feedback == 'disliked') {
        negativeCounts[cuisine] = (negativeCounts[cuisine] ?? 0) + 1;
      }
    }

    // Merge all cuisines that have any signal.
    final allCuisines = {
      ...affinities.keys,
      ...positiveCounts.keys,
      ...negativeCounts.keys,
    };

    for (final cuisine in allCuisines) {
      final baseline = affinities[cuisine] ?? 0.5;
      final positive = positiveCounts[cuisine] ?? 0;
      final negative = negativeCounts[cuisine] ?? 0;
      final total = positive + negative;

      if (total == 0) continue;

      // Feedback shift: +1 per positive, -1 per negative, scaled by
      // sqrt(total) so early feedback has more impact per-signal but
      // can't swing wildly with just one data point.
      final rawShift = (positive - negative) / math.sqrt(total);
      // Scale: each unit of rawShift moves the score by 0.15, capped.
      final shift = (rawShift * 0.15).clamp(-0.4, 0.4);

      affinities[cuisine] = (baseline + shift).clamp(0.05, 1.0);
    }

    return affinities;
  }

  /// Build the full preference summary for AI prompt injection.
  ///
  /// [profile] — family dietary restrictions, cuisine prefs, etc.
  /// [pantryItems] — current pantry inventory.
  /// [cuisineAffinities] — learned cuisine preference scores (0.0-1.0).
  ///   If empty, auto-computed from [feedbackWithCuisine] and profile.
  /// [feedbackWithCuisine] — feedback records paired with recipe cuisines,
  ///   used to auto-adjust cuisine affinities from user reactions.
  /// [lovedIngredients] — ingredients from positively-rated recipes.
  /// [dislikedIngredients] — ingredients from negatively-rated recipes.
  /// [favoriteRecipeNames] — names of recipes marked as favorites.
  /// [recentMeals] — meals cooked in the last 14 days (avoid repeats).
  Map<String, dynamic> build({
    required FamilyProfile profile,
    required List<PantryItem> pantryItems,
    Map<String, double> cuisineAffinities = const {},
    List<FeedbackCuisine> feedbackWithCuisine = const [],
    List<String> lovedIngredients = const [],
    List<String> dislikedIngredients = const [],
    List<String> favoriteRecipeNames = const [],
    List<MealPlanDay> recentMeals = const [],
    List<String> recentSuggestions = const [],
  }) {
    // Auto-compute cuisine affinities if not explicitly provided.
    final resolvedAffinities = cuisineAffinities.isNotEmpty
        ? cuisineAffinities
        : computeCuisineAffinities(
            profileCuisines: profile.cuisinePreferences,
            feedbackRecords: feedbackWithCuisine,
          );

    // Partition pantry into categories for the AI.
    final expiringItems = pantryItems
        .where((item) =>
            item.expiryStatus == ExpiryStatus.expiringSoon ||
            item.expiryStatus == ExpiryStatus.expired)
        .map((item) => item.toAiContext())
        .toList();

    final staples = pantryItems
        .where((item) => item.isStaple)
        .map((item) => item.name)
        .toList();

    final allPantryContext = pantryItems
        .take(50) // Limit to top 50 to control token count
        .map((item) => item.toAiContext())
        .toList();

    return {
      'family': {
        'adults': profile.adults,
        'kids': profile.kids,
        if (profile.kidAgeRanges.isNotEmpty)
          'kid_age_ranges':
              profile.kidAgeRanges.map((r) => r.label).toList(),
        'dietary_restrictions':
            profile.dietaryRestrictions.map((d) => d.displayName).toList(),
        'preferred_cook_time': profile.preferredCookTime.name,
        'budget_level': profile.budgetLevel.name,
        'skill_level': profile.skillLevel.name,
        'spice_tolerance': profile.spiceTolerance.name,
        'variety_preference': profile.varietyPreference.name,
      },
      'pantry_items': allPantryContext,
      'expiring_soon': expiringItems,
      'staples_available': staples,
      'cuisine_affinities': resolvedAffinities,
      'loved_ingredients': lovedIngredients,
      'disliked_ingredients': [
        ...profile.dislikedIngredients,
        ...dislikedIngredients,
      ],
      'favorite_recipes': favoriteRecipeNames,
      'recent_meals_14d':
          recentMeals.map((m) => m.recipeName).toSet().toList(),
      'recent_suggestions': recentSuggestions.toSet().toList(),
    };
  }
}

/// Riverpod provider for the builder (stateless, so just a plain Provider).
final preferenceSummaryBuilderProvider = Provider<PreferenceSummaryBuilder>(
  (ref) => PreferenceSummaryBuilder(),
);
