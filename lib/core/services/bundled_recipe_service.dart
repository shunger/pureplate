import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../database/app_database.dart';
import '../database/daos/recipe_dao.dart';

/// Loads bundled starter recipes from assets on first launch.
///
/// Recipes are stored as JSON in assets/data/bundled_recipes.json and
/// inserted into the local DB if the recipe table is empty.
class BundledRecipeService {
  final RecipeDao _recipeDao;

  BundledRecipeService(this._recipeDao);

  /// Seed the database with bundled recipes if none exist yet.
  /// Also backfills image URLs for existing users who already have bundled recipes.
  Future<void> loadIfNeeded() async {
    final count = await _recipeDao.getRecipeCount();
    if (count > 0) {
      await _updateBundledImages();
      return;
    }

    final jsonString =
        await rootBundle.loadString('assets/data/bundled_recipes.json');
    final List<dynamic> recipesJson = jsonDecode(jsonString) as List<dynamic>;

    final companions = recipesJson.cast<Map<String, dynamic>>().map((r) {
      final now = DateTime.now();
      return RecipesCompanion(
        id: Value(r['id'] as String),
        name: Value(r['name'] as String),
        description: Value(r['description'] as String? ?? ''),
        cuisine: Value(r['cuisine'] as String? ?? ''),
        servings: Value(r['servings'] as int? ?? 4),
        prepTimeMinutes: Value(r['prep_time_minutes'] as int? ?? 0),
        cookTimeMinutes: Value(r['cook_time_minutes'] as int? ?? 0),
        totalTimeMinutes: Value(
          (r['prep_time_minutes'] as int? ?? 0) +
              (r['cook_time_minutes'] as int? ?? 0),
        ),
        difficulty: Value(r['difficulty'] as String? ?? 'easy'),
        tagsJson: Value(jsonEncode(r['tags'] ?? [])),
        dietaryFlagsJson: Value(jsonEncode(r['dietary_flags'] ?? [])),
        ingredientsJson: Value(jsonEncode(r['ingredients'] ?? [])),
        instructionsJson: Value(jsonEncode(r['instructions'] ?? [])),
        nutritionJson: Value(
          r['nutrition'] != null ? jsonEncode(r['nutrition']) : null,
        ),
        imageUrl: Value(r['image_url'] as String?),
        source: const Value('bundled'),
        aiMetadataJson: const Value(null),
        isFavorite: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
    }).toList();

    await _recipeDao.insertRecipes(companions);
  }

  /// Backfill image URLs for bundled recipes that were inserted before
  /// image URLs were added to the JSON asset.
  Future<void> _updateBundledImages() async {
    final jsonString =
        await rootBundle.loadString('assets/data/bundled_recipes.json');
    final List<dynamic> recipesJson = jsonDecode(jsonString) as List<dynamic>;

    for (final r in recipesJson.cast<Map<String, dynamic>>()) {
      final id = r['id'] as String;
      final imageUrl = r['image_url'] as String?;
      if (imageUrl == null) continue;

      final existing = await _recipeDao.getRecipeById(id);
      if (existing != null &&
          existing.source == 'bundled' &&
          existing.imageUrl == null) {
        await _recipeDao.updateRecipe(RecipesCompanion(
          id: Value(id),
          imageUrl: Value(imageUrl),
          updatedAt: Value(DateTime.now()),
        ));
      }
    }
  }
}
