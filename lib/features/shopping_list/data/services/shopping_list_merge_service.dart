import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/daos/shopping_list_dao.dart';
import '../../../../shared/models/product_category.dart';
import '../../data/datasources/shopping_list_mapper.dart';
import '../../domain/models/shopping_list.dart';

const _uuid = Uuid();

/// Merges multiple shopping lists into a single combined list for a trip.
///
/// Duplicate items are deduplicated by normalized name — quantities are summed,
/// and source notes are built from recipe attributions or list names.
class ShoppingListMergeService {
  /// Merge [sourceLists] into one new "Shopping Trip" list.
  ///
  /// Inserts the new list + items via [shoppingListDao], archives all source
  /// lists, and returns the new combined list so the UI can navigate to it.
  Future<ShoppingList> mergeLists({
    required List<ShoppingList> sourceLists,
    required ShoppingListDao shoppingListDao,
  }) async {
    assert(sourceLists.length >= 2);

    final listId = _uuid.v4();
    final now = DateTime.now();

    // Build a lookup from source-list ID → list name for fallback attribution.
    final listNames = <String, String>{
      for (final l in sourceLists) l.id: l.name,
    };

    // Aggregate items by normalized name.
    final aggregated = <String, _MergedItem>{};

    for (final list in sourceLists) {
      for (final item in list.items) {
        final key = _normalizeIngredientName(item.name);
        final existing = aggregated[key];

        // Determine the source label for this item.
        final sourceLabel =
            item.recipeName ?? listNames[item.listId] ?? list.name;

        if (existing != null) {
          existing.totalQuantity += item.quantity;
          existing.sourceLabels.add(sourceLabel);
          if (item.estimatedPrice != null) {
            existing.maxEstimatedPrice = existing.maxEstimatedPrice == null
                ? item.estimatedPrice
                : (item.estimatedPrice! > existing.maxEstimatedPrice!
                    ? item.estimatedPrice
                    : existing.maxEstimatedPrice);
          }
        } else {
          aggregated[key] = _MergedItem(
            name: item.name,
            category: item.category,
            totalQuantity: item.quantity,
            unitType: item.unitType,
            maxEstimatedPrice: item.estimatedPrice,
            sourceLabels: {sourceLabel},
          );
        }
      }
    }

    // Build merged items.
    var sortOrder = 0;
    final mergedItems = <ShoppingListItem>[];

    for (final entry in aggregated.values) {
      final sourceNote = 'For: ${entry.sourceLabels.join(', ')}';

      mergedItems.add(ShoppingListItem(
        id: _uuid.v4(),
        listId: listId,
        name: entry.name,
        category: entry.category,
        quantity: entry.totalQuantity,
        unitType: entry.unitType,
        estimatedPrice: entry.maxEstimatedPrice,
        notes: sourceNote,
        addedAt: now,
        sortOrder: sortOrder++,
      ));
    }

    // Sort by category then name.
    mergedItems.sort((a, b) {
      final catCompare = a.category.index.compareTo(b.category.index);
      if (catCompare != 0) return catCompare;
      return a.name.compareTo(b.name);
    });

    // Create the new list.
    final datePart = DateFormat('MMM d').format(now);
    final newList = ShoppingList(
      id: listId,
      name: 'Shopping Trip — $datePart',
      items: mergedItems,
      source: ShoppingListSource.manual,
      createdAt: now,
    );

    // Persist: insert new list + items, then archive sources.
    await shoppingListDao
        .insertList(ShoppingListMapper.listToCompanion(newList));
    await shoppingListDao.insertItems(
      mergedItems.map(ShoppingListMapper.itemToCompanion).toList(),
    );

    for (final source in sourceLists) {
      await shoppingListDao.archiveList(source.id);
    }

    return newList;
  }

  /// Normalize ingredient names for dedup — mirrors AutoListGenerator logic.
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
}

class _MergedItem {
  final String name;
  final ProductCategory category;
  double totalQuantity;
  final String unitType;
  double? maxEstimatedPrice;
  final Set<String> sourceLabels;

  _MergedItem({
    required this.name,
    required this.category,
    required this.totalQuantity,
    required this.unitType,
    this.maxEstimatedPrice,
    required this.sourceLabels,
  });
}
