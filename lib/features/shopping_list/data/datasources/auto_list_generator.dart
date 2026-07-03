import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../pantry/domain/models/pantry_item.dart';
import '../../../recipes/domain/models/ingredient.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../domain/models/shopping_list.dart';
import '../../../../shared/models/product_category.dart';

/// Generates a smart shopping list by diffing recipe ingredients against
/// current pantry stock.
///
/// Core logic:
/// 1. Aggregate all ingredients from meal plan recipes.
/// 2. Deduplicate by normalized name (e.g., "chicken breast" matches "Chicken Breasts").
/// 3. Check pantry for each ingredient — deduct available quantity.
/// 4. Only add to shopping list if pantry quantity is insufficient.
/// 5. Group by category for organized shopping.
class AutoListGenerator {
  static const _uuid = Uuid();

  /// Generate a shopping list from recipes and current pantry.
  ///
  /// [recipes] — the recipes in the current meal plan.
  /// [pantryItems] — current pantry inventory.
  /// [mealPlanId] — ID of the meal plan that generated this list.
  ShoppingList generate({
    required List<Recipe> recipes,
    required List<PantryItem> pantryItems,
    required String mealPlanId,
  }) {
    final listId = _uuid.v4();
    final now = DateTime.now();

    // Step 1: Aggregate ingredients across all recipes.
    final aggregated = <String, _AggregatedIngredient>{};

    for (final recipe in recipes) {
      for (final ingredient in recipe.ingredients) {
        if (ingredient.optional) continue;

        final key = _normalizeIngredientName(ingredient.name);
        final existing = aggregated[key];

        if (existing != null) {
          existing.totalQuantity += _parseQuantity(ingredient.quantity);
          existing.recipeNames.add(recipe.name);
        } else {
          aggregated[key] = _AggregatedIngredient(
            name: ingredient.name,
            unit: ingredient.unit ?? 'count',
            category: _mapCategory(ingredient.category),
            totalQuantity: _parseQuantity(ingredient.quantity),
            recipeNames: {recipe.name},
          );
        }
      }
    }

    // Step 2: Build a pantry lookup by normalized name.
    final pantryLookup = <String, double>{};
    for (final item in pantryItems) {
      final key = _normalizeIngredientName(item.name);
      pantryLookup[key] = (pantryLookup[key] ?? 0) + item.quantity;
    }

    // Step 3: Generate shopping items, deducting pantry stock.
    final shoppingItems = <ShoppingListItem>[];
    var sortOrder = 0;

    for (final entry in aggregated.entries) {
      final key = entry.key;
      final agg = entry.value;
      final pantryQty = pantryLookup[key] ?? 0;

      // Build the recipe attribution note.
      final recipeNote = agg.recipeNames.length > 1
          ? 'For: ${agg.recipeNames.join(', ')}'
          : 'For: ${agg.recipeNames.first}';

      shoppingItems.add(ShoppingListItem(
        id: _uuid.v4(),
        listId: listId,
        name: agg.name,
        category: agg.category,
        quantity: agg.totalQuantity,
        unitType: agg.unit,
        pantryQuantityAvailable: pantryQty,
        notes: recipeNote,
        addedAt: now,
        sortOrder: sortOrder++,
      ));
    }

    // Step 4: Sort by category for organized shopping.
    shoppingItems.sort((a, b) {
      final catCompare = a.category.index.compareTo(b.category.index);
      if (catCompare != 0) return catCompare;
      return a.name.compareTo(b.name);
    });

    // Step 5: Remove items fully covered by pantry.
    final needToBuy =
        shoppingItems.where((item) => item.quantityNeeded > 0).toList();

    return ShoppingList(
      id: listId,
      name: 'Meal Plan Shopping List',
      items: needToBuy,
      source: ShoppingListSource.mealPlan,
      mealPlanId: mealPlanId,
      createdAt: now,
    );
  }

  /// Normalize ingredient names for fuzzy matching against pantry.
  /// "Chicken Breasts" → "chicken breast"
  /// "Red Bell Peppers" → "red bell pepper"
  String _normalizeIngredientName(String name) {
    var normalized = name.toLowerCase().trim();

    // Remove trailing 's' for basic pluralization handling.
    if (normalized.endsWith('es') && normalized.length > 3) {
      // "tomatoes" → "tomato", but not "cheese" → "chees"
      final candidate = normalized.substring(0, normalized.length - 2);
      if (candidate.endsWith('o') || candidate.endsWith('to')) {
        normalized = candidate;
      }
    } else if (normalized.endsWith('s') && !normalized.endsWith('ss')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }

  double _parseQuantity(String? qty) {
    if (qty == null || qty.isEmpty) return 1;

    // Handle fractions: "1/2" → 0.5, "1 1/2" → 1.5
    final parts = qty.trim().split(' ');
    double total = 0;
    for (final part in parts) {
      if (part.contains('/')) {
        final frac = part.split('/');
        if (frac.length == 2) {
          final num = double.tryParse(frac[0]) ?? 0;
          final den = double.tryParse(frac[1]) ?? 1;
          total += den > 0 ? num / den : 0;
        }
      } else {
        total += double.tryParse(part) ?? 0;
      }
    }
    return total > 0 ? total : 1;
  }

  ProductCategory _mapCategory(String? category) {
    if (category == null) return ProductCategory.other;
    switch (category.toLowerCase()) {
      case 'produce':
      case 'vegetables':
      case 'fruits':
        return ProductCategory.produce;
      case 'dairy':
      case 'eggs':
        return ProductCategory.dairy;
      case 'meat':
      case 'seafood':
      case 'poultry':
        return ProductCategory.meat;
      case 'bakery':
      case 'bread':
        return ProductCategory.bakery;
      case 'canned':
      case 'jarred':
        return ProductCategory.canned;
      case 'frozen':
        return ProductCategory.frozen;
      case 'pantry':
      case 'grains':
      case 'pasta':
      case 'rice':
        return ProductCategory.pantryStaple;
      case 'spices':
      case 'herbs':
      case 'seasonings':
        return ProductCategory.spices;
      case 'condiments':
      case 'sauces':
      case 'oils':
        return ProductCategory.condiments;
      case 'snacks':
        return ProductCategory.snacks;
      case 'beverages':
      case 'drinks':
        return ProductCategory.beverages;
      default:
        return ProductCategory.other;
    }
  }
}

class _AggregatedIngredient {
  final String name;
  final String unit;
  final ProductCategory category;
  double totalQuantity;
  final Set<String> recipeNames;

  _AggregatedIngredient({
    required this.name,
    required this.unit,
    required this.category,
    required this.totalQuantity,
    required this.recipeNames,
  });
}

/// Provider for the auto-list generator (stateless).
final autoListGeneratorProvider = Provider<AutoListGenerator>(
  (ref) => AutoListGenerator(),
);
