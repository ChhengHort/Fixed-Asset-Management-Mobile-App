import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/fixed_asset.dart';

abstract class FixedAssetRepository {
  Future<Either<Failure, AssetPagination>> getAssets({
    required int page,
    required int perPage,
    AssetStatus? status,
    String? searchQuery,
  });

  Future<Either<Failure, AssetStatusCount>> getStatusCounts();

  Future<Either<Failure, FixedAsset>> getAssetById(String id);
}
