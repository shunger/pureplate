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

  /// Favoriting also marks the recipe as one of the user's own.
  Future<void> toggleFavorite(String id, bool isFavorite) =>
      (update(recipes)..where((r) => r.id.equals(id))).write(RecipesCompanion(
          isFavorite: Value(isFavorite),
          isMine: isFavorite ? const Value(true) : const Value.absent(),
          updatedAt: Value(DateTime.now())));

  /// Marks a recipe as one the user chose to keep.
  Future<void> markMine(String id) =>
      (update(recipes)..where((r) => r.id.equals(id)))
          .write(const RecipesCompanion(isMine: Value(true)));

  /// Marks recipes the user has already shown they want: favorited, created
  /// or imported by them, photographed by them, or cooked from a meal plan.
  /// AI-drawn photos end in `-ai.jpg`, so they don't count as the user's.
  /// Safe to run on every launch.
  Future<void> backfillMine() => customUpdate('''
        UPDATE recipes SET is_mine = 1
        WHERE is_mine = 0 AND (
          is_favorite = 1
          OR source = 'user_created'
          OR (image_url IS NOT NULL AND image_url != ''
              AND image_url NOT LIKE 'http%'
              AND image_url NOT LIKE '%-ai.jpg')
          OR id IN (SELECT recipe_id FROM meal_plan_days WHERE is_cooked = 1)
        )''', updates: {recipes}, updateKind: UpdateKind.update);

  /// Recipes with no photo yet, for the photo generator.
  Future<List<Recipe>> getRecipesWithoutImage() => (select(recipes)
        ..where((r) => r.imageUrl.isNull() | r.imageUrl.equals('')))
      .get();

  Future<void> updateImageUrl(String id, String? imageUrl) =>
      (update(recipes)..where((r) => r.id.equals(id))).write(RecipesCompanion(
          imageUrl: Value(imageUrl), updatedAt: Value(DateTime.now())));
}
