import '../../domain/models/product.dart';
import '../../../../shared/models/result.dart';

abstract class ProductRepository {
  /// Look up product by barcode (cache -> local DB -> OpenFoodFacts -> UPC DB).
  Future<Result<Product>> lookupProduct(String barcode);

  /// Search products via API.
  Future<Result<List<Product>>> searchProducts(String query);

  /// Get product from local DB.
  Future<Product?> getLocalProduct(String id);

  /// Get product by barcode from local DB.
  Future<Product?> getLocalProductByBarcode(String barcode);

  /// Save product to local DB.
  Future<void> saveProduct(Product product);

  /// Get all custom products.
  Future<List<Product>> getCustomProducts();

  /// Get all favorite products.
  Future<List<Product>> getFavoriteProducts();

  /// Toggle favorite status.
  Future<void> toggleFavorite(String productId, bool isFavorite);

  /// Search local products.
  Future<List<Product>> searchLocalProducts(String query);

  /// Clear lookup cache.
  void clearCache();
}
