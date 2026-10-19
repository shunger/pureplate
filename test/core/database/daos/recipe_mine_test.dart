import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/features/meal_plan/data/datasources/meal_plan_mapper.dart';
import 'package:pure_pantry/features/recipes/data/datasources/recipe_mapper.dart';

import '../../../helpers/test_database.dart';
import '../../../helpers/test_fixtures.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  RecipesCompanion recipe(String id,
      {String source = 'ai_generated', String? imageUrl, bool favorite = false}) {
    final now = DateTime(2026);
    return RecipesCompanion(
      id: Value(id),
      name: Value(id),
      source: Value(source),
      imageUrl: Value(imageUrl),
      isFavorite: Value(favorite),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  Future<bool> isMine(String id) async =>
      (await db.recipeDao.getRecipeById(id))!.isMine;

  test('favoriting marks a recipe as mine, unfavoriting keeps it', () async {
    await db.recipeDao.insertRecipe(recipe('r1'));
    expect(await isMine('r1'), isFalse);
    await db.recipeDao.toggleFavorite('r1', true);
    expect(await isMine('r1'), isTrue);
    await db.recipeDao.toggleFavorite('r1', false);
    expect(await isMine('r1'), isTrue);
  });

  test('cooking a planned meal marks its recipe as mine', () async {
    await db.recipeDao.insertRecipe(recipe('r1'));
    await db.mealPlanDao.insertPlan(MealPlanMapper.planToCompanion(makeMealPlan()));
    await db.mealPlanDao.insertPlanDays(
        [MealPlanMapper.dayToCompanion(makeMealPlanDay(recipeId: 'r1'))]);
    await db.mealPlanDao.markCooked('day-1', true);
    expect(await isMine('r1'), isTrue);
  });

  test('backfill tags what the user already chose, not AI leftovers', () async {
    await db.recipeDao.insertRecipes([
      recipe('favorite', favorite: true),
      recipe('own-photo', imageUrl: '/x/Documents/recipe_images/own-photo.jpg'),
      recipe('ai-photo', imageUrl: '/x/Documents/recipe_images/ai-photo-ai.jpg'),
      recipe('stock', source: 'bundled', imageUrl: 'https://images.example/a.jpg'),
      recipe('created', source: 'user_created'),
      recipe('plain'),
    ]);
    await db.recipeDao.backfillMine();
    expect(await isMine('favorite'), isTrue);
    expect(await isMine('own-photo'), isTrue);
    expect(await isMine('created'), isTrue);
    expect(await isMine('ai-photo'), isFalse);
    expect(await isMine('stock'), isFalse);
    expect(await isMine('plain'), isFalse);
  });

  test("re-saving a recipe doesn't clear mine", () async {
    await db.recipeDao.insertRecipe(recipe('r1'));
    await db.recipeDao.markMine('r1');
    final domain = RecipeMapper.fromDb((await db.recipeDao.getRecipeById('r1'))!);
    await db.recipeDao.insertRecipe(
        RecipeMapper.toCompanion(domain.copyWith(isMine: false, name: 'Renamed')));
    expect(await isMine('r1'), isTrue);
  });

  test('recipes without a photo are found for the photo generator', () async {
    await db.recipeDao.insertRecipes([
      recipe('none'),
      recipe('empty', imageUrl: ''),
      recipe('has', imageUrl: 'https://images.example/a.jpg'),
    ]);
    final ids = (await db.recipeDao.getRecipesWithoutImage()).map((r) => r.id);
    expect(ids, unorderedEquals(['none', 'empty']));
  });
}
