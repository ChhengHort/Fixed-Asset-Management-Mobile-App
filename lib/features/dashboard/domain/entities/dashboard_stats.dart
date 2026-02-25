import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final double fixedAssetTotal;
  final int fixedAssetCount;
  final double expendableTotal;
  final int expendableCount;
  final double stationeryTotal;
  final int stationeryCount;
  final double totalExpense;
  final int totalExpenseCount;
  final String totalExpenseMonth;

  const DashboardStats({
    required this.fixedAssetTotal,
    required this.fixedAssetCount,
    required this.expendableTotal,
    required this.expendableCount,
    required this.stationeryTotal,
    required this.stationeryCount,
    required this.totalExpense,
    required this.totalExpenseCount,
    required this.totalExpenseMonth,
  });

  @override
  List<Object> get props => [
        fixedAssetTotal,
        fixedAssetCount,
        expendableTotal,
        expendableCount,
        stationeryTotal,
        stationeryCount,
        totalExpense,
        totalExpenseCount,
        totalExpenseMonth,
      ];
}

class AnalyticsData extends Equatable {
  final String month;
  final double fixedAsset;
  final double expendable;
  final double stationery;

  const AnalyticsData({
    required this.month,
    required this.fixedAsset,
    required this.expendable,
    required this.stationery,
  });

  @override
  List<Object> get props => [month, fixedAsset, expendable, stationery];
}
