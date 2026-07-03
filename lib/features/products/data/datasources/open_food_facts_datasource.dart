import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/api_models.dart';

class OpenFoodFactsDatasource {
  final Dio _dio;

  OpenFoodFactsDatasource(this._dio);

  /// Look up a product by barcode.
  Future<OpenFoodFactsResponse> lookupProduct(String barcode) async {
    final url = '${AppConstants.openFoodFactsBaseUrl}/$barcode.json';
    final response = await _dio.get(url);
    return OpenFoodFactsResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Search for products by query.
  Future<OpenFoodFactsSearchResponse> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      AppConstants.openFoodFactsSearchUrl,
      queryParameters: {
        'search_terms': query,
        'search_simple': 1,
        'action': 'process',
        'json': 1,
        'page': page,
        'page_size': pageSize,
      },
    );
    return OpenFoodFactsSearchResponse.fromJson(
        response.data as Map<String, dynamic>);
  }
}
