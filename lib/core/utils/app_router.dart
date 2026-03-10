import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../../features/auth/providers/mock_auth_provider.dart';
import '../../features/auth/screens/mock_login_screen.dart';
import '../../features/fixed_asset/presentation/screens/fixed_asset_screen.dart';
import '../../features/fixed_asset/presentation/screens/fixed_asset_detail_mock_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return _fadeRoute(settings, const MockLoginScreen());

      case '/assets':
        return _slideRoute(
          settings,
          _buildProtectedRoute(builder: (_) => const FixedAssetMockScreen()),
        );

      case '/asset-detail':
        final asset = settings.arguments;
        return _slideRoute(
          settings,
          _buildProtectedRoute(
            builder: (_) => FixedAssetDetailMockScreen(asset: asset),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  /// Wraps a widget to check authentication before displaying
  static Widget _buildProtectedRoute({required WidgetBuilder builder}) {
    return Consumer<MockAuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return const MockLoginScreen();
        }
        return builder(context);
      },
    );
  }

  static PageRouteBuilder _fadeRoute(RouteSettings s, Widget child) {
    return PageRouteBuilder(
      settings: s,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, c) =>
          FadeTransition(opacity: animation, child: c),
      transitionDuration: AppConstants.defaultAnimDuration,
    );
  }

  static PageRouteBuilder _slideRoute(RouteSettings s, Widget child) {
    return PageRouteBuilder(
      settings: s,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, c) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: c,
      ),
      transitionDuration: AppConstants.defaultAnimDuration,
    );
  }
}
