import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<AnalyticsDataModel>> getAnalytics(int year);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;
  const DashboardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await apiClient.get('/dashboard/stats');
      if (response.statusCode == 200) {
        return DashboardStatsModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw const ServerException('Failed to fetch dashboard stats.');
    } on ServerException {
      rethrow;
    } catch (e) {
      // Return mock data for development
      return DashboardStatsModel.mock();
    }
  }

  @override
  Future<List<AnalyticsDataModel>> getAnalytics(int year) async {
    try {
      final response = await apiClient.get('/dashboard/analytics', queryParameters: {'year': year});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => AnalyticsDataModel.fromJson(e)).toList();
      }
      throw const ServerException('Failed to fetch analytics.');
    } on ServerException {
      rethrow;
    } catch (e) {
      // Return mock data for development
      return AnalyticsDataModel.mockData();
    }
  }
}
