import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/family_profile.dart';
import '../../domain/models/meal_plan.dart';
import '../../../pantry/domain/models/pantry_item.dart';

/// Builds the JSON preference summary injected into every AI prompt.
///
/// This is computed entirely on-device from local data — never fetched from
/// the network. It combines family preferences, current pantry stock,
/// recipe feedback, and recent meal history into a structured context
/// that the LLM uses to personalize suggestions.
class PreferenceSummaryBuilder {
  /// Build the full preference summary for AI prompt injection.
  ///
  /// [profile] — family dietary restrictions, cuisine prefs, etc.
  /// [pantryItems] — current pantry inventory.
  /// [cuisineAffinities] — learned cuisine preference scores (0.0-1.0).
  /// [lovedIngredients] — ingredients from positively-rated recipes.
  /// [dislikedIngredients] — ingredients from negatively-rated recipes.
  /// [favoriteRecipeNames] — names of recipes marked as favorites.
  /// [recentMeals] — meals cooked in the last 14 days (avoid repeats).
  Map<String, dynamic> build({
    required FamilyProfile profile,
    required List<PantryItem> pantryItems,
    Map<String, double> cuisineAffinities = const {},
    List<String> lovedIngredients = const [],
    List<String> dislikedIngredients = const [],
    List<String> favoriteRecipeNames = const [],
    List<MealPlanDay> recentMeals = const [],
  }) {
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
      },
      'pantry_items': allPantryContext,
      'expiring_soon': expiringItems,
      'staples_available': staples,
      'cuisine_affinities': cuisineAffinities,
      'loved_ingredients': lovedIngredients,
      'disliked_ingredients': [
        ...profile.dislikedIngredients,
        ...dislikedIngredients,
      ],
      'favorite_recipes': favoriteRecipeNames,
      'recent_meals_14d':
          recentMeals.map((m) => m.recipeName).toSet().toList(),
    };
  }
}

/// Riverpod provider for the builder (stateless, so just a plain Provider).
final preferenceSummaryBuilderProvider = Provider<PreferenceSummaryBuilder>(
  (ref) => PreferenceSummaryBuilder(),
);
