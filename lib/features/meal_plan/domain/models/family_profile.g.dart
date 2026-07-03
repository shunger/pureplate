// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyProfile _$FamilyProfileFromJson(Map<String, dynamic> json) =>
    _FamilyProfile(
      id: json['id'] as String,
      adults: (json['adults'] as num?)?.toInt() ?? 2,
      kids: (json['kids'] as num?)?.toInt() ?? 0,
      kidAgeRanges:
          (json['kidAgeRanges'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$KidAgeRangeEnumMap, e))
              .toList() ??
          const [],
      dietaryRestrictions:
          (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DietaryRestrictionEnumMap, e))
              .toList() ??
          const [],
      cuisinePreferences:
          (json['cuisinePreferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferredCookTime:
          $enumDecodeNullable(
            _$PreferredCookTimeEnumMap,
            json['preferredCookTime'],
          ) ??
          PreferredCookTime.under45,
      budgetLevel:
          $enumDecodeNullable(_$BudgetLevelEnumMap, json['budgetLevel']) ??
          BudgetLevel.moderate,
      pantryStaples:
          (json['pantryStaples'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dislikedIngredients:
          (json['dislikedIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FamilyProfileToJson(
  _FamilyProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'adults': instance.adults,
  'kids': instance.kids,
  'kidAgeRanges': instance.kidAgeRanges
      .map((e) => _$KidAgeRangeEnumMap[e]!)
      .toList(),
  'dietaryRestrictions': instance.dietaryRestrictions
      .map((e) => _$DietaryRestrictionEnumMap[e]!)
      .toList(),
  'cuisinePreferences': instance.cuisinePreferences,
  'preferredCookTime': _$PreferredCookTimeEnumMap[instance.preferredCookTime]!,
  'budgetLevel': _$BudgetLevelEnumMap[instance.budgetLevel]!,
  'pantryStaples': instance.pantryStaples,
  'dislikedIngredients': instance.dislikedIngredients,
};

const _$KidAgeRangeEnumMap = {
  KidAgeRange.toddler: 'toddler',
  KidAgeRange.preschool: 'preschool',
  KidAgeRange.elementary: 'elementary',
  KidAgeRange.tween: 'tween',
  KidAgeRange.teen: 'teen',
};

const _$DietaryRestrictionEnumMap = {
  DietaryRestriction.vegetarian: 'vegetarian',
  DietaryRestriction.vegan: 'vegan',
  DietaryRestriction.glutenFree: 'glutenFree',
  DietaryRestriction.dairyFree: 'dairyFree',
  DietaryRestriction.nutFree: 'nutFree',
  DietaryRestriction.shellfishFree: 'shellfishFree',
  DietaryRestriction.eggFree: 'eggFree',
  DietaryRestriction.soyFree: 'soyFree',
  DietaryRestriction.keto: 'keto',
  DietaryRestriction.paleo: 'paleo',
  DietaryRestriction.halal: 'halal',
  DietaryRestriction.kosher: 'kosher',
  DietaryRestriction.lowSodium: 'lowSodium',
  DietaryRestriction.diabeticFriendly: 'diabeticFriendly',
};

const _$PreferredCookTimeEnumMap = {
  PreferredCookTime.under30: 'under30',
  PreferredCookTime.under45: 'under45',
  PreferredCookTime.under60: 'under60',
  PreferredCookTime.anyTime: 'anyTime',
};

const _$BudgetLevelEnumMap = {
  BudgetLevel.budget: 'budget',
  BudgetLevel.moderate: 'moderate',
  BudgetLevel.premium: 'premium',
};
