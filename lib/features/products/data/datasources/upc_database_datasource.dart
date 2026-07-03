import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/api_models.dart';

class UPCDatabaseDatasource {
  final Dio _dio;

  UPCDatabaseDatasource(this._dio);

  /// Look up a product by barcode.
  Future<UPCDatabaseResponse> lookupProduct(String barcode) async {
    final response = await _dio.get(
      AppConstants.upcDatabaseBaseUrl,
      queryParameters: {'upc': barcode},
    );
    return UPCDatabaseResponse.fromJson(
        response.data as Map<String, dynamic>);
  }
}
