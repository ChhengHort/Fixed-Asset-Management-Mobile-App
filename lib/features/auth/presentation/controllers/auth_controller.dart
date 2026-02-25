import 'package:flutter/foundation.dart';
import '../../../../core/utils/use_case.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;
  bool _rememberLogin = false;

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedUserUseCase,
  });

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get rememberLogin => _rememberLogin;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  void setRememberLogin(bool value) {
    _rememberLogin = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(LoginParams(
      username: username,
      password: password,
      rememberLogin: _rememberLogin,
    ));

    return result.fold(
      (failure) {
        _state = AuthState.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _user = user;
        _state = AuthState.authenticated;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    await logoutUseCase(const NoParams());
    _user = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    _state = AuthState.loading;
    notifyListeners();

    final result = await getCachedUserUseCase(const NoParams());

    result.fold(
      (failure) {
        _state = AuthState.unauthenticated;
        notifyListeners();
      },
      (user) {
        _user = user;
        _state = AuthState.authenticated;
        notifyListeners();
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
