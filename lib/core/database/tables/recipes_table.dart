import 'package:drift/drift.dart';

/// Recipes table — bundled, AI-generated, or user-created recipes.
/// From MealPlannerAI.
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get cuisine => text().withDefault(const Constant(''))();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  IntColumn get prepTimeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get cookTimeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get totalTimeMinutes => integer().withDefault(const Constant(0))();
  TextColumn get difficulty => text().withDefault(const Constant('medium'))();

  // Structured data stored as JSON.
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get dietaryFlagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get ingredientsJson => text().withDefault(const Constant('[]'))();
  TextColumn get instructionsJson => text().withDefault(const Constant('[]'))();
  TextColumn get nutritionJson => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  // Source: 'bundled', 'ai_generated', 'user_created'.
  TextColumn get source => text().withDefault(const Constant('bundled'))();
  TextColumn get aiMetadataJson => text().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  // Timestamps.
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
