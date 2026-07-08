import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:pure_pantry/core/database/daos/recipe_dao.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late RecipeDao dao;

  setUp(() {
    db = createTestDatabase();
    dao = db.recipeDao;
  });

  tearDown(() async {
    await db.close();
  });

  RecipesCompanion _makeRecipe({
    required String id,
    String name = 'Test Recipe',
    String cuisine = '',
    bool isFavorite = false,
  }) {
    final now = DateTime.now();
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      cuisine: Value(cuisine),
      isFavorite: Value(isFavorite),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  group('RecipeDao', () {
    group('CRUD', () {
      test('insert and get recipe', () async {
        await dao.insertRecipe(_makeRecipe(id: 'r1', name: 'Pasta'));
        final recipe = await dao.getRecipeById('r1');
        expect(recipe, isNotNull);
        expect(recipe!.name, 'Pasta');
      });

      test('delete recipe', () async {
        await dao.insertRecipe(_makeRecipe(id: 'r1'));
        await dao.deleteRecipe('r1');
        final recipe = await dao.getRecipeById('r1');
        expect(recipe, isNull);
      });

      test('bulk insert recipes', () async {
        await dao.insertRecipes([
          _makeRecipe(id: 'r1', name: 'A'),
          _makeRecipe(id: 'r2', name: 'B'),
          _makeRecipe(id: 'r3', name: 'C'),
        ]);
        final all = await dao.getAllRecipes();
        expect(all.length, 3);
      });
    });

    group('getRecipesByCuisine', () {
      test('filters by cuisine', () async {
        await dao.insertRecipe(
            _makeRecipe(id: 'r1', name: 'Pasta', cuisine: 'Italian'));
        await dao.insertRecipe(
            _makeRecipe(id: 'r2', name: 'Tacos', cuisine: 'Mexican'));

        final italian = await dao.getRecipesByCuisine('Italian');
        expect(italian.length, 1);
        expect(italian.first.name, 'Pasta');
      });
    });

    group('getRecipeCount', () {
      test('returns correct count', () async {
        await dao.insertRecipes([
          _makeRecipe(id: 'r1'),
          _makeRecipe(id: 'r2'),
        ]);
        final count = await dao.getRecipeCount();
        expect(count, 2);
      });

      test('returns 0 when empty', () async {
        final count = await dao.getRecipeCount();
        expect(count, 0);
      });
    });

    group('toggleFavorite', () {
      test('sets favorite to true', () async {
        await dao.insertRecipe(_makeRecipe(id: 'r1', isFavorite: false));
        await dao.toggleFavorite('r1', true);

        final recipe = await dao.getRecipeById('r1');
        expect(recipe!.isFavorite, isTrue);
      });

      test('sets favorite to false', () async {
        await dao.insertRecipe(_makeRecipe(id: 'r1', isFavorite: true));
        await dao.toggleFavorite('r1', false);

        final recipe = await dao.getRecipeById('r1');
        expect(recipe!.isFavorite, isFalse);
      });
    });

    group('watchFavoriteRecipes', () {
      test('returns only favorites', () async {
        await dao.insertRecipe(_makeRecipe(id: 'r1', isFavorite: true));
        await dao.insertRecipe(_makeRecipe(id: 'r2', isFavorite: false));

        final favorites = await dao.watchFavoriteRecipes().first;
        expect(favorites.length, 1);
        expect(favorites.first.isFavorite, isTrue);
      });
    });
  });
}
