import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
class Substitution with _$Substitution {
  const factory Substitution({
    required String name,
    String? quantity,
    String? unit,
    String? notes,
  }) = _Substitution;

  factory Substitution.fromJson(Map<String, dynamic> json) =>
      _$SubstitutionFromJson(json);
}

/// A single ingredient in a recipe.
@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    String? quantity,
    String? unit,

    /// Category for shopping list grouping (produce, dairy, etc.)
    String? category,

    /// Whether this ingredient is optional.
    @Default(false) bool optional,

    /// Known substitutions.
    @Default([]) List<Substitution> substitutions,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
