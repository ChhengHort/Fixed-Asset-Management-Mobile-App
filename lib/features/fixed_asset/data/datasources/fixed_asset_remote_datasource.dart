import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/fixed_asset.dart';
import '../models/fixed_asset_model.dart';

abstract class FixedAssetRemoteDataSource {
  Future<AssetPaginationModel> getAssets({
    required int page,
    required int perPage,
    AssetStatus? status,
    String? searchQuery,
  });

  Future<AssetStatusCountModel> getStatusCounts();
  Future<FixedAssetModel> getAssetById(String id);
}

class FixedAssetRemoteDataSourceImpl implements FixedAssetRemoteDataSource {
  final ApiClient apiClient;
  const FixedAssetRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AssetPaginationModel> getAssets({
    required int page,
    required int perPage,
    AssetStatus? status,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (status != null && status != AssetStatus.all) 'status': status.apiValue,
        if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
      };
      final response = await apiClient.get('/fixed-assets', queryParameters: queryParams);
      if (response.statusCode == 200) {
        return AssetPaginationModel.fromJson(
          response.data as Map<String, dynamic>,
          page: page,
          perPage: perPage,
        );
      }
      throw const ServerException('Failed to load assets.');
    } catch (_) {
      return AssetPaginationModel.mock(
        page: page, perPage: perPage, status: status, query: searchQuery,
      );
    }
  }

  @override
  Future<AssetStatusCountModel> getStatusCounts() async {
    try {
      final response = await apiClient.get('/fixed-assets/status-counts');
      if (response.statusCode == 200) {
        return AssetStatusCountModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw const ServerException('Failed.');
    } catch (_) {
      return AssetStatusCountModel.mock();
    }
  }

  @override
  Future<FixedAssetModel> getAssetById(String id) async {
    final response = await apiClient.get('/fixed-assets/$id');
    if (response.statusCode == 200) {
      return FixedAssetModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw const ServerException('Asset not found.');
  }
}
