// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_dao.dart';

// ignore_for_file: type=lint
mixin _$FeedbackDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecipesTable get recipes => attachedDatabase.recipes;
  $RecipeFeedbackTable get recipeFeedback => attachedDatabase.recipeFeedback;
  FeedbackDaoManager get managers => FeedbackDaoManager(this);
}

class FeedbackDaoManager {
  final _$FeedbackDaoMixin _db;
  FeedbackDaoManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db.attachedDatabase, _db.recipes);
  $$RecipeFeedbackTableTableManager get recipeFeedback =>
      $$RecipeFeedbackTableTableManager(
        _db.attachedDatabase,
        _db.recipeFeedback,
      );
}
