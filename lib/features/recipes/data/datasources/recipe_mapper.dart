import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/instruction_step.dart';
import '../../domain/models/nutrition_info.dart';

/// Maps between Drift DB rows and domain Recipe models.
///
/// The Recipes table stores ingredients, instructions, nutrition, tags,
/// and dietary flags as JSON TEXT columns. This mapper handles the
/// serialization/deserialization.
class RecipeMapper {
  RecipeMapper._();

  /// Convert a Drift [db.Recipe] row to a domain [Recipe].
  static Recipe fromDb(db.Recipe row) {
    return Recipe(
      id: row.id,
      name: row.name,
      description: row.description.isEmpty ? null : row.description,
      cuisine: row.cuisine.isEmpty ? null : row.cuisine,
      imageUrl: row.imageUrl,
      prepTimeMinutes: row.prepTimeMinutes,
      cookTimeMinutes: row.cookTimeMinutes,
      servings: row.servings,
      difficulty: row.difficulty,
      ingredients: _parseIngredients(row.ingredientsJson),
      instructions: _parseInstructions(row.instructionsJson),
      nutrition: _parseNutrition(row.nutritionJson),
      isVegetarian: _dietaryFlagContains(row.dietaryFlagsJson, 'vegetarian'),
      isVegan: _dietaryFlagContains(row.dietaryFlagsJson, 'vegan'),
      isGlutenFree: _dietaryFlagContains(row.dietaryFlagsJson, 'gluten_free'),
      isDairyFree: _dietaryFlagContains(row.dietaryFlagsJson, 'dairy_free'),
      isNutFree: _dietaryFlagContains(row.dietaryFlagsJson, 'nut_free'),
      source: _parseSource(row.source),
      aiMetadata: _parseJsonMap(row.aiMetadataJson),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// Convert a domain [Recipe] to a Drift [db.RecipesCompanion].
  static db.RecipesCompanion toCompanion(Recipe recipe) {
    final dietaryFlags = <String>[
      if (recipe.isVegetarian) 'vegetarian',
      if (recipe.isVegan) 'vegan',
      if (recipe.isGlutenFree) 'gluten_free',
      if (recipe.isDairyFree) 'dairy_free',
      if (recipe.isNutFree) 'nut_free',
    ];

    return db.RecipesCompanion(
      id: Value(recipe.id),
      name: Value(recipe.name),
      description: Value(recipe.description ?? ''),
      cuisine: Value(recipe.cuisine ?? ''),
      imageUrl: Value(recipe.imageUrl),
      prepTimeMinutes: Value(recipe.prepTimeMinutes),
      cookTimeMinutes: Value(recipe.cookTimeMinutes),
      totalTimeMinutes: Value(recipe.totalTimeMinutes),
      servings: Value(recipe.servings),
      difficulty: Value(recipe.difficulty ?? 'medium'),
      ingredientsJson: Value(jsonEncode(
          recipe.ingredients.map((i) => i.toJson()).toList())),
      instructionsJson: Value(jsonEncode(
          recipe.instructions.map((i) => i.toJson()).toList())),
      nutritionJson: Value(
          recipe.nutrition != null ? jsonEncode(recipe.nutrition!.toJson()) : null),
      tagsJson: Value('[]'),
      dietaryFlagsJson: Value(jsonEncode(dietaryFlags)),
      source: Value(_sourceToString(recipe.source)),
      aiMetadataJson: Value(
          recipe.aiMetadata != null ? jsonEncode(recipe.aiMetadata) : null),
      createdAt: Value(recipe.createdAt),
      updatedAt: Value(recipe.updatedAt ?? DateTime.now()),
    );
  }

  // ── Private helpers ───────────────────────────────────────

  static List<Ingredient> _parseIngredients(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .cast<Map<String, dynamic>>()
          .map((m) => Ingredient.fromJson(m))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static List<InstructionStep> _parseInstructions(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .cast<Map<String, dynamic>>()
          .map((m) => InstructionStep.fromJson(m))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static NutritionInfo? _parseNutrition(String? json) {
    if (json == null || json.isEmpty) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return NutritionInfo.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static bool _dietaryFlagContains(String json, String flag) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.contains(flag);
    } catch (_) {
      return false;
    }
  }

  static RecipeSource _parseSource(String source) {
    switch (source) {
      case 'ai_generated':
        return RecipeSource.aiGenerated;
      case 'user_created':
        return RecipeSource.userCreated;
      default:
        return RecipeSource.bundled;
    }
  }

  static String _sourceToString(RecipeSource source) {
    switch (source) {
      case RecipeSource.aiGenerated:
        return 'ai_generated';
      case RecipeSource.userCreated:
        return 'user_created';
      case RecipeSource.bundled:
        return 'bundled';
    }
  }

  static Map<String, dynamic>? _parseJsonMap(String? json) {
    if (json == null || json.isEmpty) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
