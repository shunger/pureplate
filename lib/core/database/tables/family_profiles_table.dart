import 'package:drift/drift.dart';

/// FamilyProfiles — family size, dietary restrictions, cuisine preferences.
/// Drives AI personalization via PreferenceSummaryBuilder.
/// From MealPlannerAI.
class FamilyProfiles extends Table {
  TextColumn get id => text()();
  IntColumn get adults => integer().withDefault(const Constant(2))();
  IntColumn get kids => integer().withDefault(const Constant(0))();
  TextColumn get kidAgeRangesJson => text().withDefault(const Constant('[]'))();
  TextColumn get dietaryRestrictionsJson => text().withDefault(const Constant('[]'))();
  TextColumn get cuisinePreferencesJson => text().withDefault(const Constant('{}'))();
  TextColumn get otherDietaryNotes => text().nullable()();

  // Cooking style: '15', '30', '30-45', '45-60', '60+'.
  TextColumn get preferredCookTime => text().withDefault(const Constant('30-45'))();

  // Budget level: 'budget', 'moderate', 'premium'.
  TextColumn get budgetLevel => text().withDefault(const Constant('moderate'))();

  TextColumn get pantryStaplesJson => text().withDefault(const Constant('[]'))();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  // Timestamps.
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
