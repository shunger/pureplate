import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/dietary_restriction.dart';

part 'family_profile.freezed.dart';
part 'family_profile.g.dart';

enum KidAgeRange {
  toddler('1-3'),
  preschool('4-5'),
  elementary('6-10'),
  tween('11-13'),
  teen('14-17');

  final String label;
  const KidAgeRange(this.label);
}

enum BudgetLevel { budget, moderate, premium }
enum PreferredCookTime { under30, under45, under60, anyTime }

/// Family profile — drives AI personalization.
@freezed
abstract class FamilyProfile with _$FamilyProfile {
  const factory FamilyProfile({
    required String id,
    @Default(2) int adults,
    @Default(0) int kids,
    @Default([]) List<KidAgeRange> kidAgeRanges,
    @Default([]) List<DietaryRestriction> dietaryRestrictions,
    @Default([]) List<String> cuisinePreferences,
    @Default(PreferredCookTime.under45) PreferredCookTime preferredCookTime,
    @Default(BudgetLevel.moderate) BudgetLevel budgetLevel,
    @Default([]) List<String> pantryStaples,
    @Default([]) List<String> dislikedIngredients,
  }) = _FamilyProfile;

  factory FamilyProfile.fromJson(Map<String, dynamic> json) =>
      _$FamilyProfileFromJson(json);
}
