import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.fixedAssetTotal,
    required super.fixedAssetCount,
    required super.expendableTotal,
    required super.expendableCount,
    required super.stationeryTotal,
    required super.stationeryCount,
    required super.totalExpense,
    required super.totalExpenseCount,
    required super.totalExpenseMonth,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      fixedAssetTotal: (json['fixed_asset_total'] ?? 0).toDouble(),
      fixedAssetCount: json['fixed_asset_count'] ?? 0,
      expendableTotal: (json['expendable_total'] ?? 0).toDouble(),
      expendableCount: json['expendable_count'] ?? 0,
      stationeryTotal: (json['stationery_total'] ?? 0).toDouble(),
      stationeryCount: json['stationery_count'] ?? 0,
      totalExpense: (json['total_expense'] ?? 0).toDouble(),
      totalExpenseCount: json['total_expense_count'] ?? 0,
      totalExpenseMonth: json['total_expense_month'] ?? 'July',
    );
  }

  // Mock data for development/testing
  factory DashboardStatsModel.mock() {
    return const DashboardStatsModel(
      fixedAssetTotal: 60532,
      fixedAssetCount: 270,
      expendableTotal: 40032,
      expendableCount: 350,
      stationeryTotal: 12500,
      stationeryCount: 535,
      totalExpense: 7500,
      totalExpenseCount: 50,
      totalExpenseMonth: 'July',
    );
  }
}

class AnalyticsDataModel extends AnalyticsData {
  const AnalyticsDataModel({
    required super.month,
    required super.fixedAsset,
    required super.expendable,
    required super.stationery,
  });

  factory AnalyticsDataModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsDataModel(
      month: json['month'] ?? '',
      fixedAsset: (json['fixed_asset'] ?? 0).toDouble(),
      expendable: (json['expendable'] ?? 0).toDouble(),
      stationery: (json['stationery'] ?? 0).toDouble(),
    );
  }

  static List<AnalyticsDataModel> mockData() {
    return [
      const AnalyticsDataModel(
        month: 'Jan',
        fixedAsset: 37000,
        expendable: 38000,
        stationery: 29000,
      ),
      const AnalyticsDataModel(
        month: 'Feb',
        fixedAsset: 28000,
        expendable: 47000,
        stationery: 38000,
      ),
      const AnalyticsDataModel(
        month: 'Mar',
        fixedAsset: 28000,
        expendable: 38000,
        stationery: 29000,
      ),
      const AnalyticsDataModel(
        month: 'Apr',
        fixedAsset: 38000,
        expendable: 38000,
        stationery: 44000,
      ),
    ];
  }
}
