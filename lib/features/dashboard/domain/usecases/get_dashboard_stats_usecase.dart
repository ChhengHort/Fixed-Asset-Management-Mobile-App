import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase implements UseCase<DashboardStats, NoParams> {
  final DashboardRepository repository;
  const GetDashboardStatsUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardStats>> call(NoParams params) {
    return repository.getDashboardStats();
  }
}

class GetAnalyticsUseCase implements UseCase<List<AnalyticsData>, AnalyticsParams> {
  final DashboardRepository repository;
  const GetAnalyticsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnalyticsData>>> call(AnalyticsParams params) {
    return repository.getAnalytics(params.year);
  }
}

class AnalyticsParams extends Equatable {
  final int year;
  const AnalyticsParams(this.year);

  @override
  List<Object> get props => [year];
}
