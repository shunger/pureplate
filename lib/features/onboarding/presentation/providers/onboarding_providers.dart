import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/dietary_restriction.dart';
import '../../../meal_plan/domain/models/family_profile.dart';

/// In-progress onboarding state accumulated across screens.
class OnboardingState {
  final int adults;
  final int kids;
  final List<KidAgeRange> kidAgeRanges;
  final List<DietaryRestriction> dietaryRestrictions;
  final List<String> cuisinePreferences;
  final PreferredCookTime preferredCookTime;
  final BudgetLevel budgetLevel;
  final SkillLevel skillLevel;
  final SpiceTolerance spiceTolerance;
  final VarietyPreference varietyPreference;
  final List<String> dislikedIngredients;

  const OnboardingState({
    this.adults = 2,
    this.kids = 0,
    this.kidAgeRanges = const [],
    this.dietaryRestrictions = const [],
    this.cuisinePreferences = const [],
    this.preferredCookTime = PreferredCookTime.under45,
    this.budgetLevel = BudgetLevel.moderate,
    this.skillLevel = SkillLevel.comfortable,
    this.spiceTolerance = SpiceTolerance.medium,
    this.varietyPreference = VarietyPreference.mixed,
    this.dislikedIngredients = const [],
  });

  OnboardingState copyWith({
    int? adults,
    int? kids,
    List<KidAgeRange>? kidAgeRanges,
    List<DietaryRestriction>? dietaryRestrictions,
    List<String>? cuisinePreferences,
    PreferredCookTime? preferredCookTime,
    BudgetLevel? budgetLevel,
    SkillLevel? skillLevel,
    SpiceTolerance? spiceTolerance,
    VarietyPreference? varietyPreference,
    List<String>? dislikedIngredients,
  }) {
    return OnboardingState(
      adults: adults ?? this.adults,
      kids: kids ?? this.kids,
      kidAgeRanges: kidAgeRanges ?? this.kidAgeRanges,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
      preferredCookTime: preferredCookTime ?? this.preferredCookTime,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      skillLevel: skillLevel ?? this.skillLevel,
      spiceTolerance: spiceTolerance ?? this.spiceTolerance,
      varietyPreference: varietyPreference ?? this.varietyPreference,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setAdults(int value) => state = state.copyWith(adults: value);
  void setKids(int value) => state = state.copyWith(kids: value);
  void setKidAgeRanges(List<KidAgeRange> value) =>
      state = state.copyWith(kidAgeRanges: value);
  void setDietaryRestrictions(List<DietaryRestriction> value) =>
      state = state.copyWith(dietaryRestrictions: value);
  void setCuisinePreferences(List<String> value) =>
      state = state.copyWith(cuisinePreferences: value);
  void setCookTime(PreferredCookTime value) =>
      state = state.copyWith(preferredCookTime: value);
  void setBudgetLevel(BudgetLevel value) =>
      state = state.copyWith(budgetLevel: value);
  void setSkillLevel(SkillLevel value) =>
      state = state.copyWith(skillLevel: value);
  void setSpiceTolerance(SpiceTolerance value) =>
      state = state.copyWith(spiceTolerance: value);
  void setVarietyPreference(VarietyPreference value) =>
      state = state.copyWith(varietyPreference: value);
  void setDislikedIngredients(List<String> value) =>
      state = state.copyWith(dislikedIngredients: value);
}

final onboardingStateProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
