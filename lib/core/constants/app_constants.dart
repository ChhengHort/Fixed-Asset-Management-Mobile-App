class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://api.assettech.com/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberLoginKey = 'remember_login';

  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard';
  static const String assetsRoute = '/assets';
  static const String profileRoute = '/profile';

  // Animation
  static const Duration defaultAnimDuration = Duration(milliseconds: 300);
}
