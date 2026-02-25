import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/fixed_asset.dart';
import '../../domain/repositories/fixed_asset_repository.dart';
import '../datasources/fixed_asset_remote_datasource.dart';

class FixedAssetRepositoryImpl implements FixedAssetRepository {
  final FixedAssetRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const FixedAssetRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AssetPagination>> getAssets({
    required int page,
    required int perPage,
    AssetStatus? status,
    String? searchQuery,
  }) async {
    try {
      final result = await remoteDataSource.getAssets(
        page: page, perPage: perPage, status: status, searchQuery: searchQuery,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetStatusCount>> getStatusCounts() async {
    try {
      final result = await remoteDataSource.getStatusCounts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FixedAsset>> getAssetById(String id) async {
    try {
      final result = await remoteDataSource.getAssetById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
