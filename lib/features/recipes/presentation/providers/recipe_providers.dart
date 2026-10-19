import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';
import '../../data/datasources/recipe_mapper.dart';
import '../../data/services/recipe_image_service.dart';
import '../../data/services/recipe_pdf_service.dart';
import '../../data/services/recipe_share_service.dart';
import '../../domain/models/recipe.dart';

/// PDF generation service for recipes.
final recipePdfServiceProvider =
    Provider<RecipePdfService>((ref) => RecipePdfService());

/// Recipe export/import service.
final recipeShareServiceProvider =
    Provider<RecipeShareService>((ref) => RecipeShareService());

/// All recipes mapped from DB rows to domain models.
final allRecipesDomainProvider = StreamProvider<List<Recipe>>((ref) {
  return ref.watch(recipeDaoProvider).watchAllRecipes().map(
      (rows) => rows.map(RecipeMapper.fromDb).toList());
});

/// A single recipe by ID.
final recipeDetailProvider =
    StreamProvider.family<Recipe?, String>((ref, recipeId) {
  return ref.watch(recipeDaoProvider).watchRecipeById(recipeId).map(
      (row) => row != null ? RecipeMapper.fromDb(row) : null);
});

/// Favorite recipes.
final favoriteRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  return ref.watch(recipeDaoProvider).watchFavoriteRecipes().map(
      (rows) => rows.map(RecipeMapper.fromDb).toList());
});

/// Search/filter state for the recipe browser.
final recipeSearchQueryProvider = StateProvider<String>((ref) => '');
final recipeCuisineFilterProvider = StateProvider<String?>((ref) => null);
final recipeFavoritesOnlyProvider = StateProvider<bool>((ref) => false);
final recipeMineOnlyProvider = StateProvider<bool>((ref) => false);

/// Draws photos for recipes that have none. Started once at launch.
final recipeImageServiceProvider = Provider<RecipeImageService>((ref) {
  final service = RecipeImageService(ref.watch(recipeDaoProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// Filtered recipes based on search query and cuisine filter.
final filteredRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final recipesAsync = ref.watch(allRecipesDomainProvider);
  final query = ref.watch(recipeSearchQueryProvider).toLowerCase();
  final cuisine = ref.watch(recipeCuisineFilterProvider);

  final favoritesOnly = ref.watch(recipeFavoritesOnlyProvider);
  final mineOnly = ref.watch(recipeMineOnlyProvider);

  return recipesAsync.whenData((recipes) {
    var filtered = recipes;

    if (favoritesOnly) {
      filtered = filtered.where((r) => r.isFavorite).toList();
    }

    if (mineOnly) {
      filtered = filtered.where((r) => r.isMine).toList();
    }

    if (query.isNotEmpty) {
      filtered = filtered
          .where((r) =>
              r.name.toLowerCase().contains(query) ||
              (r.cuisine?.toLowerCase().contains(query) ?? false) ||
              (r.description?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    if (cuisine != null) {
      filtered = filtered
          .where((r) =>
              r.cuisine?.toLowerCase() == cuisine.toLowerCase())
          .toList();
    }

    return filtered;
  });
});

/// Available cuisines derived from all recipes.
final availableCuisinesProvider = Provider<AsyncValue<List<String>>>((ref) {
  final recipesAsync = ref.watch(allRecipesDomainProvider);
  return recipesAsync.whenData((recipes) {
    final cuisines = recipes
        .map((r) => r.cuisine)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList()
      ..sort();
    return cuisines;
  });
});
