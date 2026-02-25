import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      username: params.username,
      password: params.password,
      rememberLogin: params.rememberLogin,
    );
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  final bool rememberLogin;

  const LoginParams({
    required this.username,
    required this.password,
    this.rememberLogin = false,
  });

  @override
  List<Object> get props => [username, password, rememberLogin];
}
