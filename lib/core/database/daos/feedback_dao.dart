import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/recipe_feedback_table.dart';

part 'feedback_dao.g.dart';

@DriftAccessor(tables: [RecipeFeedback])
class FeedbackDao extends DatabaseAccessor<AppDatabase>
    with _$FeedbackDaoMixin {
  FeedbackDao(super.db);

  Future<List<RecipeFeedbackData>> getAllFeedback() =>
      (select(recipeFeedback)
            ..orderBy([(f) => OrderingTerm.desc(f.createdAt)]))
          .get();

  Future<List<RecipeFeedbackData>> getFeedbackForRecipe(String recipeId) =>
      (select(recipeFeedback)..where((f) => f.recipeId.equals(recipeId)))
          .get();

  Stream<List<RecipeFeedbackData>> watchFeedbackForRecipe(String recipeId) =>
      (select(recipeFeedback)..where((f) => f.recipeId.equals(recipeId)))
          .watch();

  Future<void> insertFeedback(RecipeFeedbackCompanion feedback) =>
      into(recipeFeedback).insertOnConflictUpdate(feedback);

  Future<void> deleteFeedback(String id) =>
      (delete(recipeFeedback)..where((f) => f.id.equals(id))).go();
}
