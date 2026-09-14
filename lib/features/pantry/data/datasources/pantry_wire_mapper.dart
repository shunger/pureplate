import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../sharing/data/mappers/firestore_vocab.dart';

/// Converts local pantry rows to and from `sharedPantries/{id}/items` docs.
///
/// Field names and values follow Smart Shopping Scanner's format (see
/// [FirestoreVocab]). `productId` is deliberately not synced: product IDs are
/// local to each install and mean nothing on another device.
class PantryWireMapper {
  PantryWireMapper._();

  static const sourceApp = 'pantry';

  /// Full document for an item being added to a shared pantry.
  static Map<String, dynamic> fromRow(PantryItem item) => {
        'name': item.name,
        ...FirestoreVocab.encodeCategory(item.category),
        'quantity': item.quantity,
        ...FirestoreVocab.encodeUnit(item.unitType),
        ...FirestoreVocab.encodeLocation(item.location),
        'expiresAt': _timestamp(item.expiresAt),
        'purchasedAt': _timestamp(item.purchasedAt),
        'isStaple': item.isStaple,
        'reorderThreshold': item.reorderThreshold,
        'isBulk': item.isBulk,
        'purchasePrice': item.purchasePrice,
        'status': item.status,
        'packSize': item.packSize,
        'notes': item.notes,
        'sourceApp': sourceApp,
      };

  /// Only the fields present in [c], for updating an existing shared item.
  static Map<String, dynamic> fromCompanion(PantryItemsCompanion c) => {
        if (c.name.present) 'name': c.name.value,
        if (c.category.present) ...FirestoreVocab.encodeCategory(c.category.value),
        if (c.quantity.present) 'quantity': c.quantity.value,
        if (c.unitType.present) ...FirestoreVocab.encodeUnit(c.unitType.value),
        if (c.location.present) ...FirestoreVocab.encodeLocation(c.location.value),
        if (c.expiresAt.present) 'expiresAt': _timestamp(c.expiresAt.value),
        if (c.purchasedAt.present) 'purchasedAt': _timestamp(c.purchasedAt.value),
        if (c.isStaple.present) 'isStaple': c.isStaple.value,
        if (c.reorderThreshold.present)
          'reorderThreshold': c.reorderThreshold.value,
        if (c.isBulk.present) 'isBulk': c.isBulk.value,
        if (c.purchasePrice.present) 'purchasePrice': c.purchasePrice.value,
        if (c.status.present) 'status': c.status.value,
        if (c.packSize.present) 'packSize': c.packSize.value,
        if (c.notes.present) 'notes': c.notes.value,
      };

  /// Local row for a shared item. [newLocalId] and the timestamps are only
  /// used when the item is new locally; existing rows keep theirs.
  static PantryItemsCompanion toCompanion({
    required String newLocalId,
    required String pantryId,
    required String itemId,
    required Map<String, dynamic> data,
    required DateTime now,
  }) {
    return PantryItemsCompanion(
      id: Value(newLocalId),
      name: Value(data['name'] as String? ?? ''),
      category: Value(FirestoreVocab.decodeCategory(data)),
      quantity: Value((data['quantity'] as num?)?.toDouble() ?? 1),
      unitType: Value(FirestoreVocab.decodeUnit(data)),
      location: Value(FirestoreVocab.decodeLocation(data)),
      expiresAt: Value(_date(data['expiresAt'])),
      purchasedAt: Value(_date(data['purchasedAt'])),
      isStaple: Value(data['isStaple'] as bool? ?? false),
      reorderThreshold:
          Value((data['reorderThreshold'] as num?)?.toInt() ?? 0),
      isBulk: Value(data['isBulk'] as bool? ?? false),
      purchasePrice: Value((data['purchasePrice'] as num?)?.toDouble()),
      status: Value(data['status'] as String? ?? 'newItem'),
      packSize: Value((data['packSize'] as num?)?.toDouble()),
      notes: Value(data['notes'] as String?),
      firestorePantryId: Value(pantryId),
      firestoreItemId: Value(itemId),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  static Timestamp? _timestamp(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);

  static DateTime? _date(Object? value) =>
      value is Timestamp ? value.toDate() : null;
}
