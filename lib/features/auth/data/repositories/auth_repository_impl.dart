import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
    bool rememberLogin = false,
  }) async {
    // Allow a local mock login for demo credentials before attempting network.
    const mockUsername = 'manager';
    const mockEmail = 'manager@example.com';
    const mockPassword = 'Manager#123';

    if ((username == mockUsername || username == mockEmail) &&
        password == mockPassword) {
      try {
        final userModel = UserModel(
          id: '1',
          username: mockUsername,
          email: mockEmail,
          fullName: 'Manager',
          role: 'admin',
        );
        await localDataSource.saveToken('mock-token-123');
        await localDataSource.saveUser(userModel);
        if (rememberLogin) {
          await localDataSource.setRememberLogin(true);
        }
        return Right(userModel);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }

    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          'No internet connection. Please check your network settings.',
        ),
      );
    }

    try {
      final data = await remoteDataSource.login(username, password);
      final token = data['token'] as String?;
      final userData = data['user'] as Map<String, dynamic>?;

      if (token == null || userData == null) {
        return const Left(ServerFailure('Invalid response from server.'));
      }

      final userModel = UserModel.fromJson(userData);
      await localDataSource.saveToken(token);
      await localDataSource.saveUser(userModel);

      if (rememberLogin) {
        await localDataSource.setRememberLogin(true);
      }

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null;
  }
}
