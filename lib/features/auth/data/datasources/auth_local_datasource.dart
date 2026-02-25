import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel> getCachedUser();
  Future<void> clearAll();
  Future<void> setRememberLogin(bool value);
  Future<bool> getRememberLogin();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl(this.secureStorage, this.sharedPreferences);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: AppConstants.tokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(AppConstants.userKey, user.toJsonString());
  }

  @override
  Future<UserModel> getCachedUser() async {
    final userString = sharedPreferences.getString(AppConstants.userKey);
    if (userString == null) {
      throw const CacheException('No cached user found.');
    }
    return UserModel.fromJsonString(userString);
  }

  @override
  Future<void> clearAll() async {
    await secureStorage.deleteAll();
    await sharedPreferences.clear();
  }

  @override
  Future<void> setRememberLogin(bool value) async {
    await sharedPreferences.setBool(AppConstants.rememberLoginKey, value);
  }

  @override
  Future<bool> getRememberLogin() async {
    return sharedPreferences.getBool(AppConstants.rememberLoginKey) ?? false;
  }
}
