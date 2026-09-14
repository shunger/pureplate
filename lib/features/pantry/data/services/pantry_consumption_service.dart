import 'package:uuid/uuid.dart';

import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/database/daos/shopping_list_dao.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../shopping_list/data/datasources/shopping_list_mapper.dart';
import '../../../shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';
import '../../../shopping_list/domain/models/shopping_list.dart';
import '../../../../shared/models/product_category.dart';
import '../datasources/pantry_sync_orchestrator.dart';

/// Result of deducting pantry items after cooking a recipe.
class ConsumptionResult {
  final int deductedCount;
  final int addedToListCount;
  final String? shoppingListName;

  const ConsumptionResult({
    required this.deductedCount,
    required this.addedToListCount,
    this.shoppingListName,
  });
}

/// Deducts pantry quantities when a meal is cooked, and auto-adds
/// depleted items to a shopping list.
class PantryConsumptionService {
  static const _uuid = Uuid();

  /// Deduct ingredient quantities from pantry for a cooked recipe.
  ///
  /// - Skips optional ingredients and staple pantry items.
  /// - Deletes pantry items that reach 0.
  /// - Adds depleted items to the most recent active shopping list,
  ///   or creates a new "Restock" list.
  ///
  /// Reads come from the DAOs; writes go through the sync orchestrators so
  /// shared pantries and lists see the change.
  Future<ConsumptionResult> deductIngredientsForRecipe({
    required Recipe recipe,
    required PantryDao pantryDao,
    required ShoppingListDao shoppingListDao,
    required PantrySyncOrchestrator pantrySync,
    required ShoppingListSyncOrchestrator listSync,
  }) async {
    final pantryItems = await pantryDao.getAllItems();

    // Build a lookup: normalized name → list of pantry items.
    final pantryLookup = <String, List<_PantryMatch>>{};
    for (final item in pantryItems) {
      final key = _normalizeIngredientName(item.name);
      pantryLookup.putIfAbsent(key, () => []).add(_PantryMatch(
        id: item.id,
        quantity: item.quantity,
        name: item.name,
        isStaple: item.isStaple,
        category: item.category,
        unitType: item.unitType,
      ));
    }

    var deductedCount = 0;
    final depletedItems = <_DepletedItem>[];

    for (final ingredient in recipe.ingredients) {
      if (ingredient.optional) continue;

      final key = _normalizeIngredientName(ingredient.name);
      final matches = pantryLookup[key];
      if (matches == null || matches.isEmpty) continue;

      var remainingToDeduct = _parseQuantity(ingredient.quantity);

      for (final match in matches) {
        if (match.isStaple) continue;
        if (remainingToDeduct <= 0) break;

        final deduction =
            remainingToDeduct < match.quantity ? remainingToDeduct : match.quantity;
        final newQuantity = match.quantity - deduction;
        remainingToDeduct -= deduction;

        if (newQuantity <= 0) {
          await pantrySync.deleteItem(match.id, depleted: true);
          depletedItems.add(_DepletedItem(
            name: match.name,
            category: match.category,
            unitType: match.unitType,
          ));
        } else {
          await pantrySync.updateQuantity(match.id, newQuantity);
        }

        match.quantity = newQuantity;
        deductedCount++;
      }
    }

    // Auto-add depleted items to a shopping list.
    var addedToListCount = 0;
    String? shoppingListName;

    if (depletedItems.isNotEmpty) {
      // Find the most recent active shopping list.
      final activeLists = await shoppingListDao
          .watchActiveLists()
          .first;
      String targetListId;

      if (activeLists.isNotEmpty) {
        targetListId = activeLists.first.id;
        shoppingListName = activeLists.first.name;
      } else {
        // Create a new "Restock" list.
        targetListId = _uuid.v4();
        shoppingListName = 'Restock';
        final now = DateTime.now();
        final newList = ShoppingList(
          id: targetListId,
          name: shoppingListName,
          source: ShoppingListSource.manual,
          createdAt: now,
        );
        await shoppingListDao
            .insertList(ShoppingListMapper.listToCompanion(newList));
      }

      final companions = depletedItems.map((item) {
        final listItem = ShoppingListItem(
          id: _uuid.v4(),
          listId: targetListId,
          name: item.name,
          category: _mapCategory(item.category),
          quantity: 1,
          unitType: item.unitType,
          notes: 'Auto-added — used up cooking ${recipe.name}',
          addedAt: DateTime.now(),
        );
        return ShoppingListMapper.itemToCompanion(listItem);
      }).toList();

      await listSync.insertItems(companions);
      addedToListCount = depletedItems.length;
    }

    return ConsumptionResult(
      deductedCount: deductedCount,
      addedToListCount: addedToListCount,
      shoppingListName: shoppingListName,
    );
  }

  // ── Name normalization (mirrors AutoListGenerator) ──────────

  String _normalizeIngredientName(String name) {
    var normalized = name.toLowerCase().trim();

    if (normalized.endsWith('es') && normalized.length > 3) {
      final candidate = normalized.substring(0, normalized.length - 2);
      if (candidate.endsWith('o') || candidate.endsWith('to')) {
        normalized = candidate;
      }
    } else if (normalized.endsWith('s') && !normalized.endsWith('ss')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }

  // ── Quantity parsing (mirrors AutoListGenerator) ────────────

  double _parseQuantity(String? qty) {
    if (qty == null || qty.isEmpty) return 1;

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

  // ── Category mapping ───────────────────────────────────────

  ProductCategory _mapCategory(String category) {
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

class _PantryMatch {
  final String id;
  double quantity;
  final String name;
  final bool isStaple;
  final String category;
  final String unitType;

  _PantryMatch({
    required this.id,
    required this.quantity,
    required this.name,
    required this.isStaple,
    required this.category,
    required this.unitType,
  });
}

class _DepletedItem {
  final String name;
  final String category;
  final String unitType;

  _DepletedItem({
    required this.name,
    required this.category,
    required this.unitType,
  });
}
