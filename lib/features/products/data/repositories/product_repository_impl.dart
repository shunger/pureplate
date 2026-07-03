import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/daos/product_dao.dart';
import '../../../../shared/models/result.dart';
import '../../domain/models/product.dart';
import '../datasources/open_food_facts_datasource.dart';
import '../datasources/product_mapper.dart';
import '../datasources/upc_database_datasource.dart';
import 'product_repository.dart';

class _CachedProduct {
  final Product product;
  final DateTime timestamp;

  _CachedProduct(this.product) : timestamp = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(timestamp) >
      const Duration(hours: AppConstants.cacheTtlHours);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductDao _productDao;
  final OpenFoodFactsDatasource _offDatasource;
  final UPCDatabaseDatasource _upcDatasource;

  final Map<String, _CachedProduct> _cache = {};

  ProductRepositoryImpl({
    required this._productDao,
    required this._offDatasource,
    required this._upcDatasource,
  });

  @override
  Future<Result<Product>> lookupProduct(String barcode) async {
    // 1. Check memory cache
    final cached = _cache[barcode];
    if (cached != null && !cached.isExpired) {
      return Result.success(cached.product);
    }

    // 2. Check local DB
    final local = await _productDao.getProductByBarcode(barcode);
    if (local != null) {
      final product = ProductMapper.fromDbRow(local);
      _cache[barcode] = _CachedProduct(product);
      return Result.success(product);
    }

    // 3. Try OpenFoodFacts
    try {
      final product = await _retryRequest(() async {
        final response = await _offDatasource.lookupProduct(barcode);
        if (response.status == 1 && response.product?.productName != null) {
          return ProductMapper.fromOpenFoodFacts(response.product!, barcode);
        }
        return null;
      });

      if (product != null) {
        // Supplement sparse OFF data with UPC Database
        var result = product;
        if (_isProductSparse(product)) {
          try {
            final upcResponse = await _upcDatasource.lookupProduct(barcode);
            if (upcResponse.items.isNotEmpty) {
              result = ProductMapper.supplementWithUPC(
                  product, upcResponse.items.first);
            }
          } catch (_) {
            // UPC supplement is best-effort, keep OFF data as-is
          }
        }
        _cache[barcode] = _CachedProduct(result);
        await saveProduct(result);
        return Result.success(result);
      }
    } catch (_) {
      // Fall through to UPC Database
    }

    // 4. Try UPC Database
    try {
      final product = await _retryRequest(() async {
        final response = await _upcDatasource.lookupProduct(barcode);
        if (response.items.isNotEmpty) {
          return ProductMapper.fromUPCDatabase(response.items.first);
        }
        return null;
      });

      if (product != null) {
        _cache[barcode] = _CachedProduct(product);
        await saveProduct(product);
        return Result.success(product);
      }
    } catch (_) {
      // Fall through to not found
    }

    return const Result.failure('Product not found');
  }

  @override
  Future<Result<List<Product>>> searchProducts(String query) async {
    final localResults = await searchLocalProducts(query);

    try {
      final products = await _retryRequest(() async {
        final response = await _offDatasource.searchProducts(query);
        return response.products
            .where((p) => p.productName != null && p.productName!.isNotEmpty)
            .map((p) => ProductMapper.fromOpenFoodFacts(p, p.id ?? ''))
            .take(AppConstants.maxSearchResults)
            .toList();
      });

      if (products != null && products.isNotEmpty) {
        return Result.success(products);
      }
    } catch (_) {
      // Fall through to local results
    }

    if (localResults.isNotEmpty) {
      return Result.success(localResults);
    }
    return const Result.failure(
        'No products found. The server may be temporarily unavailable — try again shortly.');
  }

  @override
  Future<Product?> getLocalProduct(String id) async {
    final row = await _productDao.getProductById(id);
    return row != null ? ProductMapper.fromDbRow(row) : null;
  }

  @override
  Future<Product?> getLocalProductByBarcode(String barcode) async {
    final row = await _productDao.getProductByBarcode(barcode);
    return row != null ? ProductMapper.fromDbRow(row) : null;
  }

  @override
  Future<void> saveProduct(Product product) async {
    await _productDao.insertProduct(ProductMapper.toCompanion(product));
  }

  @override
  Future<List<Product>> getCustomProducts() async {
    final rows = await _productDao.getCustomProducts();
    return rows.map(ProductMapper.fromDbRow).toList();
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    final rows = await _productDao.getFavoriteProducts();
    return rows.map(ProductMapper.fromDbRow).toList();
  }

  @override
  Future<void> toggleFavorite(String productId, bool isFavorite) async {
    await _productDao.toggleFavorite(productId, isFavorite);
  }

  @override
  Future<List<Product>> searchLocalProducts(String query) async {
    final rows = await _productDao.searchProducts(query);
    return rows.map(ProductMapper.fromDbRow).toList();
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  /// Retry a request up to maxRetries times with exponential backoff.
  Future<T?> _retryRequest<T>(Future<T?> Function() request) async {
    for (var attempt = 1; attempt <= AppConstants.maxRetries; attempt++) {
      try {
        return await request();
      } catch (e) {
        if (e is DioException && !_isRetryable(e)) rethrow;
        if (attempt == AppConstants.maxRetries) rethrow;
        await Future.delayed(
          Duration(
              milliseconds: (AppConstants.retryDelayMs * attempt).toInt()),
        );
      }
    }
    return null;
  }

  bool _isRetryable(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return true;
    }
    final statusCode = e.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return true;
    }
    return false;
  }

  bool _isProductSparse(Product product) {
    return product.nutritionInfo == null &&
        product.ingredients == null &&
        product.description == null;
  }
}
