import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../sharing/data/mappers/firestore_vocab.dart';

/// Converts local shopping list items to and from `sharedLists/{id}/items`
/// docs, using Smart Shopping Scanner's field names.
///
/// `price` is the estimate and `actualPrice` the price paid, in both apps.
/// Categories and units go through [FirestoreVocab], as for pantry items.
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
        ...FirestoreVocab.encodeUnit(item.unitType),
        'price': item.estimatedPrice,
        'actualPrice': item.actualPrice,
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
        if (c.unitType.present) ...FirestoreVocab.encodeUnit(c.unitType.value),
        if (c.estimatedPrice.present) 'price': c.estimatedPrice.value,
        if (c.actualPrice.present) 'actualPrice': c.actualPrice.value,
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
      unitType: Value(_listUnit(data)),
      estimatedPrice: Value((data['price'] as num?)?.toDouble()),
      actualPrice: Value((data['actualPrice'] as num?)?.toDouble()),
      isCompleted: Value(data['isChecked'] as bool? ?? false),
      category: Value(FirestoreVocab.decodeCategory(data)),
      notes: Value(data['notes'] as String?),
      firestoreListId: Value(firestoreListId),
      firestoreItemId: Value(itemId),
      addedAt: Value(now),
      updatedAt: Value(now),
    );
  }

  /// Shopping lists count items in `count` rather than the pantry's `each`.
  static String _listUnit(Map<String, dynamic> data) {
    if (data['unitType'] == null) return 'count';
    final unit = FirestoreVocab.decodeUnit(data);
    return unit == 'each' ? 'count' : unit;
  }
}
