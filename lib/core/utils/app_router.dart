import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../injection_container.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/fixed_asset/presentation/controllers/fixed_asset_controller.dart';
import '../../features/fixed_asset/presentation/screens/fixed_asset_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => sl<AuthController>(),
            child: const SplashScreen(),
          ),
        );

      case AppConstants.loginRoute:
        return _fadeRoute(
          settings,
          ChangeNotifierProvider(
            create: (_) => sl<AuthController>(),
            child: const LoginScreen(),
          ),
        );

      case AppConstants.dashboardRoute:
        return _slideRoute(
          settings,
          FutureBuilder<bool>(
            future: sl<AuthRepository>().isLoggedIn(),
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.data == true) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => sl<AuthController>()),
                    ChangeNotifierProvider(
                      create: (_) => sl<DashboardController>(),
                    ),
                  ],
                  child: const DashboardScreen(),
                );
              }
              return ChangeNotifierProvider(
                create: (_) => sl<AuthController>(),
                child: const LoginScreen(),
              );
            },
          ),
        );

      case AppConstants.assetsRoute:
        return _slideRoute(
          settings,
          FutureBuilder<bool>(
            future: sl<AuthRepository>().isLoggedIn(),
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.data == true) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => sl<AuthController>()),
                    ChangeNotifierProvider(
                      create: (_) => sl<FixedAssetController>(),
                    ),
                  ],
                  child: const FixedAssetScreen(),
                );
              }
              return ChangeNotifierProvider(
                create: (_) => sl<AuthController>(),
                child: const LoginScreen(),
              );
            },
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
