import 'package:drift/drift.dart';
import 'recipes_table.dart';

/// RecipeFeedback — user reactions to recipes. Drives the learning engine.
/// From MealPlannerAI.
class RecipeFeedback extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text().references(Recipes, #id)();

  // Feedback type: 'loved', 'disliked', 'favorite'.
  TextColumn get feedback => text()();

  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
