import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/products_table.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  // ── Queries ─────────────────────────────────────────────

  Future<List<Product>> getAllProducts() => select(products).get();

  Future<Product?> getProductById(String id) =>
      (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<Product?> getProductByBarcode(String barcode) =>
      (select(products)..where((p) => p.barcode.equals(barcode)))
          .getSingleOrNull();

  Future<Product?> getProductByPluCode(String pluCode) =>
      (select(products)..where((p) => p.pluCode.equals(pluCode)))
          .getSingleOrNull();

  Future<List<Product>> searchProducts(String query) {
    final pattern = '%$query%';
    return (select(products)
          ..where((p) =>
              p.name.like(pattern) |
              p.brand.like(pattern) |
              p.barcode.like(pattern) |
              p.description.like(pattern)))
        .get();
  }

  Stream<List<Product>> watchFavoriteProducts() =>
      (select(products)
            ..where((p) => p.isFavorite.equals(true))
            ..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .watch();

  Stream<List<Product>> watchCustomProducts() =>
      (select(products)
            ..where((p) => p.isCustom.equals(true))
            ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
          .watch();

  Future<List<Product>> getProductsByCategory(String category) =>
      (select(products)..where((p) => p.category.equals(category))).get();

  // ── Mutations ───────────────────────────────────────────

  Future<void> insertProduct(ProductsCompanion product) =>
      into(products).insertOnConflictUpdate(product);

  Future<void> updateProduct(ProductsCompanion product) =>
      (update(products)..where((p) => p.id.equals(product.id.value)))
          .write(product);

  Future<void> deleteProduct(String id) =>
      (delete(products)..where((p) => p.id.equals(id))).go();

  Future<void> toggleFavorite(String id, bool isFavorite) =>
      (update(products)..where((p) => p.id.equals(id)))
          .write(ProductsCompanion(isFavorite: Value(isFavorite)));

  Future<void> updateLastLookedUp(String id) =>
      (update(products)..where((p) => p.id.equals(id)))
          .write(ProductsCompanion(lastLookedUp: Value(DateTime.now())));
}
