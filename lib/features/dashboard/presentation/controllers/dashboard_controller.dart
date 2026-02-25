import 'package:flutter/foundation.dart';
import '../../../../core/utils/use_case.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';

enum DashboardLoadState { initial, loading, loaded, error }

class DashboardController extends ChangeNotifier {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetAnalyticsUseCase getAnalyticsUseCase;

  DashboardLoadState _state = DashboardLoadState.initial;
  DashboardStats? _stats;
  List<AnalyticsData> _analyticsData = [];
  String? _errorMessage;
  int _selectedYear = DateTime.now().year;

  DashboardController({
    required this.getDashboardStatsUseCase,
    required this.getAnalyticsUseCase,
  });

  DashboardLoadState get state => _state;
  DashboardStats? get stats => _stats;
  List<AnalyticsData> get analyticsData => _analyticsData;
  String? get errorMessage => _errorMessage;
  int get selectedYear => _selectedYear;
  bool get isLoading => _state == DashboardLoadState.loading;

  Future<void> loadDashboard() async {
    _state = DashboardLoadState.loading;
    notifyListeners();

    await Future.wait([
      _loadStats(),
      _loadAnalytics(_selectedYear),
    ]);

    if (_stats != null) {
      _state = DashboardLoadState.loaded;
    } else {
      _state = DashboardLoadState.error;
    }
    notifyListeners();
  }

  Future<void> _loadStats() async {
    final result = await getDashboardStatsUseCase(const NoParams());
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (stats) {
        _stats = stats;
      },
    );
  }

  Future<void> _loadAnalytics(int year) async {
    final result = await getAnalyticsUseCase(AnalyticsParams(year));
    result.fold(
      (failure) {},
      (data) {
        _analyticsData = data;
      },
    );
  }

  Future<void> changeYear(int year) async {
    _selectedYear = year;
    notifyListeners();
    await _loadAnalytics(year);
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}
