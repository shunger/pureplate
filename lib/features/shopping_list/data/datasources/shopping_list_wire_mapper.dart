import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../sharing/data/mappers/firestore_vocab.dart';

/// Converts local shopping list items to and from `sharedLists/{id}/items`
/// docs, using Smart Shopping Scanner's field names.
///
/// `unitType` and `categoryDetail` are Pure Pantry extras the scanner ignores.
/// Nothing is sent as `barcode`: local product IDs are random UUIDs, not
/// barcodes, and the scanner would create bogus products from them.
class ShoppingListWireMapper {
  ShoppingListWireMapper._();

  static const sourceApp = 'pantry';

  /// Full document for an item being added to a shared list.
  static Map<String, dynamic> fromRow(ShoppingListItem item) => {
        'productName': item.name,
        'brand': item.brand,
        'quantity': item.quantity,
        'unitType': item.unitType,
        'price': item.estimatedPrice,
        'isChecked': item.isCompleted,
        ...FirestoreVocab.encodeCategory(item.category),
        'notes': item.notes,
        'sourceApp': sourceApp,
      };

  /// Only the fields present in [c], for updating an existing shared item.
  static Map<String, dynamic> fromCompanion(ShoppingListItemsCompanion c) => {
        if (c.name.present) 'productName': c.name.value,
        if (c.brand.present) 'brand': c.brand.value,
        if (c.quantity.present) 'quantity': c.quantity.value,
        if (c.unitType.present) 'unitType': c.unitType.value,
        if (c.estimatedPrice.present) 'price': c.estimatedPrice.value,
        if (c.isCompleted.present) 'isChecked': c.isCompleted.value,
        if (c.category.present) ...FirestoreVocab.encodeCategory(c.category.value),
        if (c.notes.present) 'notes': c.notes.value,
      };

  /// Local row for a shared item. [newLocalId] and the timestamps are only
  /// used when the item is new locally; existing rows keep theirs.
  static ShoppingListItemsCompanion toCompanion({
    required String newLocalId,
    required String localListId,
    required String firestoreListId,
    required String itemId,
    required Map<String, dynamic> data,
    required DateTime now,
  }) {
    return ShoppingListItemsCompanion(
      id: Value(newLocalId),
      listId: Value(localListId),
      name: Value(data['productName'] as String? ?? ''),
      brand: Value(data['brand'] as String?),
      quantity: Value((data['quantity'] as num?)?.toDouble() ?? 1),
      unitType: Value(data['unitType'] as String? ?? 'count'),
      estimatedPrice: Value((data['price'] as num?)?.toDouble()),
      isCompleted: Value(data['isChecked'] as bool? ?? false),
      category: Value(FirestoreVocab.decodeCategory(data)),
      notes: Value(data['notes'] as String?),
      firestoreListId: Value(firestoreListId),
      firestoreItemId: Value(itemId),
      addedAt: Value(now),
      updatedAt: Value(now),
    );
  }
}
