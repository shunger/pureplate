import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/recipes_table.dart';

part 'recipe_dao.g.dart';

@DriftAccessor(tables: [Recipes])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  // ── Queries ─────────────────────────────────────────────

  Future<List<Recipe>> getAllRecipes() =>
      (select(recipes)..orderBy([(r) => OrderingTerm.asc(r.name)])).get();

  Stream<List<Recipe>> watchAllRecipes() =>
      (select(recipes)..orderBy([(r) => OrderingTerm.asc(r.name)])).watch();

  Future<Recipe?> getRecipeById(String id) =>
      (select(recipes)..where((r) => r.id.equals(id))).getSingleOrNull();

  Stream<Recipe?> watchRecipeById(String id) =>
      (select(recipes)..where((r) => r.id.equals(id))).watchSingleOrNull();

  Future<List<Recipe>> getRecipesByCuisine(String cuisine) =>
      (select(recipes)..where((r) => r.cuisine.equals(cuisine))).get();

  Future<int> getRecipeCount() async {
    final count = countAll();
    final query = selectOnly(recipes)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Stream<List<Recipe>> watchFavoriteRecipes() =>
      (select(recipes)
            ..where((r) => r.isFavorite.equals(true))
            ..orderBy([(r) => OrderingTerm.asc(r.name)]))
          .watch();

  // ── Mutations ───────────────────────────────────────────

  Future<void> insertRecipe(RecipesCompanion recipe) =>
      into(recipes).insertOnConflictUpdate(recipe);

  Future<void> insertRecipes(List<RecipesCompanion> recipeList) =>
      batch((b) => b.insertAllOnConflictUpdate(recipes, recipeList));

  Future<void> updateRecipe(RecipesCompanion recipe) =>
      (update(recipes)..where((r) => r.id.equals(recipe.id.value)))
          .write(recipe);

  Future<void> deleteRecipe(String id) =>
      (delete(recipes)..where((r) => r.id.equals(id))).go();

  Future<void> toggleFavorite(String id, bool isFavorite) =>
      (update(recipes)..where((r) => r.id.equals(id))).write(RecipesCompanion(
          isFavorite: Value(isFavorite), updatedAt: Value(DateTime.now())));
}
