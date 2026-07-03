import 'package:freezed_annotation/freezed_annotation.dart';
import 'ingredient.dart';
import 'instruction_step.dart';
import 'nutrition_info.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

enum RecipeSource { bundled, aiGenerated, userCreated }

/// A recipe — either bundled with the app, AI-generated, or user-created.
@freezed
abstract class Recipe with _$Recipe {
  const Recipe._();

  const factory Recipe({
    required String id,
    required String name,
    String? description,
    String? cuisine,
    String? imageUrl,

    /// Timing.
    @Default(0) int prepTimeMinutes,
    @Default(0) int cookTimeMinutes,
    @Default(4) int servings,
    String? difficulty,

    /// Structured data.
    @Default([]) List<Ingredient> ingredients,
    @Default([]) List<InstructionStep> instructions,
    NutritionInfo? nutrition,

    /// Dietary flags (derived from ingredients or set by AI).
    @Default(false) bool isVegetarian,
    @Default(false) bool isVegan,
    @Default(false) bool isGlutenFree,
    @Default(false) bool isDairyFree,
    @Default(false) bool isNutFree,

    /// Source tracking.
    @Default(RecipeSource.bundled) RecipeSource source,
    Map<String, dynamic>? aiMetadata,

    /// Timestamps.
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);

  /// Total time in minutes.
  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  /// Human-readable time string.
  String get totalTimeDisplay {
    final total = totalTimeMinutes;
    if (total < 60) return '${total}m';
    final hours = total ~/ 60;
    final mins = total % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}
