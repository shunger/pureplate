import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/purchase_history_table.dart';

part 'purchase_history_dao.g.dart';

@DriftAccessor(tables: [PurchaseHistories, PurchaseRecords])
class PurchaseHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$PurchaseHistoryDaoMixin {
  PurchaseHistoryDao(super.db);

  // ── Queries ─────────────────────────────────────────────

  Stream<List<PurchaseHistory>> watchAllHistories() =>
      (select(purchaseHistories)
            ..orderBy([(h) => OrderingTerm.desc(h.dateLastPurchased)]))
          .watch();

  Future<PurchaseHistory?> getHistoryById(String id) =>
      (select(purchaseHistories)..where((h) => h.id.equals(id)))
          .getSingleOrNull();

  Future<PurchaseHistory?> getHistoryByBarcode(String barcode) =>
      (select(purchaseHistories)..where((h) => h.barcode.equals(barcode)))
          .getSingleOrNull();

  Future<List<PurchaseHistory>> searchHistory(String query) {
    final pattern = '%$query%';
    return (select(purchaseHistories)
          ..where((h) =>
              h.productName.like(pattern) |
              h.brand.like(pattern) |
              h.barcode.like(pattern)))
        .get();
  }

  Stream<List<PurchaseRecord>> watchRecordsForHistory(String historyId) =>
      (select(purchaseRecords)
            ..where((r) => r.historyId.equals(historyId))
            ..orderBy([(r) => OrderingTerm.desc(r.datePurchased)]))
          .watch();

  Future<List<PurchaseRecord>> getRecordsForHistory(String historyId) =>
      (select(purchaseRecords)
            ..where((r) => r.historyId.equals(historyId))
            ..orderBy([(r) => OrderingTerm.desc(r.datePurchased)]))
          .get();

  // ── Mutations ───────────────────────────────────────────

  Future<void> insertHistory(PurchaseHistoriesCompanion history) =>
      into(purchaseHistories).insertOnConflictUpdate(history);

  Future<void> updateHistory(PurchaseHistoriesCompanion history) =>
      (update(purchaseHistories)..where((h) => h.id.equals(history.id.value)))
          .write(history);

  Future<void> deleteHistory(String id) => transaction(() async {
        await (delete(purchaseRecords)..where((r) => r.historyId.equals(id)))
            .go();
        await (delete(purchaseHistories)..where((h) => h.id.equals(id))).go();
      });

  Future<void> insertRecord(PurchaseRecordsCompanion record) =>
      into(purchaseRecords).insertOnConflictUpdate(record);

  /// Atomically add a purchase record, creating or updating the history entry.
  Future<void> addPurchaseRecord({
    required String historyId,
    required String productName,
    String? barcode,
    String? brand,
    String? productId,
    required String recordId,
    required double quantity,
    double? price,
    required DateTime datePurchased,
    String? storeName,
  }) =>
      transaction(() async {
        final existing = await getHistoryById(historyId);
        if (existing != null) {
          await updateHistory(PurchaseHistoriesCompanion(
            id: Value(historyId),
            dateLastPurchased: Value(datePurchased),
          ));
        } else {
          await insertHistory(PurchaseHistoriesCompanion(
            id: Value(historyId),
            barcode: Value(barcode),
            productName: Value(productName),
            brand: Value(brand),
            productId: Value(productId),
            dateFirstPurchased: Value(datePurchased),
            dateLastPurchased: Value(datePurchased),
          ));
        }
        await insertRecord(PurchaseRecordsCompanion(
          id: Value(recordId),
          historyId: Value(historyId),
          quantity: Value(quantity),
          price: Value(price),
          datePurchased: Value(datePurchased),
          storeName: Value(storeName),
        ));
      });
}
