import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  const AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Simple mock login fallback so the app works without a backend for demo
    const mockUsername = 'manager';
    const mockEmail = 'manager@example.com';
    const mockPassword = 'Manager#123';

    if ((username == mockUsername || username == mockEmail) &&
        password == mockPassword) {
      await Future.delayed(const Duration(milliseconds: 400));
      return {
        'token': 'mock-token-123',
        'user': {
          'id': 1,
          'username': mockUsername,
          'email': mockEmail,
          'name': 'Manager',
          'role': 'admin',
        },
      };
    }

    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      }
      throw const ServerException('Login failed. Please try again.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
