import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../products/data/datasources/open_food_facts_datasource.dart';
import '../../../products/data/datasources/upc_database_datasource.dart';
import '../../../products/data/repositories/product_repository.dart';
import '../../../products/data/repositories/product_repository_impl.dart';
import '../../data/datasources/plu_database.dart';

/// PLU database singleton.
final pluDatabaseProvider = Provider<PluDatabase>((ref) {
  final db = PluDatabase();
  // Load asynchronously — consumers should check isLoaded
  db.load();
  return db;
});

/// PLU search query.
final pluSearchQueryProvider = StateProvider<String>((ref) => '');

/// PLU search results.
final pluSearchResultsProvider = Provider<List<PluEntry>>((ref) {
  final db = ref.watch(pluDatabaseProvider);
  final query = ref.watch(pluSearchQueryProvider);
  if (query.isEmpty) return db.recentEntries;
  return db.search(query);
});

/// Shared Dio instance for product API calls.
final _productDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: AppConstants.defaultTimeout,
    receiveTimeout: AppConstants.defaultTimeout,
    headers: {
      'User-Agent': 'PurePlateAI/1.0 (Flutter)',
    },
  ));
});

/// Product repository.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(_productDioProvider);
  final productDao = ref.watch(productDaoProvider);
  return ProductRepositoryImpl(
    productDao: productDao,
    offDatasource: OpenFoodFactsDatasource(dio),
    upcDatasource: UPCDatabaseDatasource(dio),
  );
});
