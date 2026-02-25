import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/fixed_asset.dart';
import '../repositories/fixed_asset_repository.dart';


// ─── Get Assets (paginated + filtered) ───────────────────────────────────────
class GetAssetsUseCase implements UseCase<AssetPagination, GetAssetsParams> {
  final FixedAssetRepository repository;
  const GetAssetsUseCase(this.repository);

  @override
  Future<Either<Failure, AssetPagination>> call(GetAssetsParams params) {
    return repository.getAssets(
      page: params.page,
      perPage: params.perPage,
      status: params.status,
      searchQuery: params.searchQuery,
    );
  }
}

class GetAssetsParams extends Equatable {
  final int page;
  final int perPage;
  final AssetStatus? status;
  final String? searchQuery;

  const GetAssetsParams({
    this.page = 1,
    this.perPage = 10,
    this.status,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, perPage, status, searchQuery];
}

// ─── Get Status Counts ────────────────────────────────────────────────────────
class GetStatusCountsUseCase implements UseCase<AssetStatusCount, NoParams> {
  final FixedAssetRepository repository;
  const GetStatusCountsUseCase(this.repository);

  @override
  Future<Either<Failure, AssetStatusCount>> call(NoParams params) {
    return repository.getStatusCounts();
  }
}

// ─── Get Asset Detail ─────────────────────────────────────────────────────────
class GetAssetByIdUseCase implements UseCase<FixedAsset, String> {
  final FixedAssetRepository repository;
  const GetAssetByIdUseCase(this.repository);

  @override
  Future<Either<Failure, FixedAsset>> call(String id) {
    return repository.getAssetById(id);
  }
}
