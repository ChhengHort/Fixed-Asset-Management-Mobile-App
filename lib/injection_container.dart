// import 'package:get_it/get_it.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'core/network/api_client.dart';
// import 'core/network/network_info.dart';

// // Auth
// import 'features/auth/data/datasources/auth_local_datasource.dart';
// import 'features/auth/data/datasources/auth_remote_datasource.dart';
// import 'features/auth/data/repositories/auth_repository_impl.dart';
// import 'features/auth/domain/repositories/auth_repository.dart';
// import 'features/auth/domain/usecases/login_usecase.dart';
// import 'features/auth/domain/usecases/logout_usecase.dart';
// import 'features/auth/domain/usecases/get_cached_user_usecase.dart';
// import 'features/auth/presentation/controllers/auth_controller.dart';

// // Dashboard
// import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
// import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
// import 'features/dashboard/domain/repositories/dashboard_repository.dart';
// import 'features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
// import 'features/dashboard/domain/usecases/get_analytics_usecase.dart';
// import 'features/dashboard/presentation/controllers/dashboard_controller.dart';

// // Fixed Asset
// import 'features/fixed_asset/data/datasources/fixed_asset_remote_datasource.dart';
// import 'features/fixed_asset/data/repositories/fixed_asset_repository_impl.dart';
// import 'features/fixed_asset/domain/repositories/fixed_asset_repository.dart';
// import 'features/fixed_asset/presentation/controllers/fixed_asset_controller.dart';
// import 'features/fixed_asset/domain/usecases/fixed_asset_usecases.dart';

// final sl = GetIt.instance;

// Future<void> initDependencies() async {
//   // External
//   final sharedPrefs = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPrefs);
//   sl.registerLazySingleton(() => const FlutterSecureStorage());

//   // Core
//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
//   sl.registerLazySingleton(() => ApiClient(sl()));

//   // Auth - DataSources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(sl()),
//   );
//   sl.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(sl(), sl()),
//   );

//   // Auth - Repository
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//       remoteDataSource: sl(),
//       localDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );

//   // Auth - UseCases
//   sl.registerLazySingleton(() => LoginUseCase(sl()));
//   sl.registerLazySingleton(() => LogoutUseCase(sl()));
//   sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

//   // Auth - Controller
//   sl.registerFactory(
//     () => AuthController(
//       loginUseCase: sl(),
//       logoutUseCase: sl(),
//       getCachedUserUseCase: sl(),
//     ),
//   );

//   // Dashboard - DataSources
//   sl.registerLazySingleton<DashboardRemoteDataSource>(
//     () => DashboardRemoteDataSourceImpl(sl()),
//   );

//   // Dashboard - Repository
//   sl.registerLazySingleton<DashboardRepository>(
//     () => DashboardRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
//   );

//   // Dashboard - UseCases
//   sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));
//   sl.registerLazySingleton(() => GetAnalyticsUseCase(sl()));

//   // Dashboard - Controller
//   sl.registerFactory(
//     () => DashboardController(
//       getDashboardStatsUseCase: sl(),
//       getAnalyticsUseCase: sl(),
//     ),
//   );

//   // Fixed Asset - DataSource
//   sl.registerLazySingleton<FixedAssetRemoteDataSource>(
//     () => FixedAssetRemoteDataSourceImpl(sl()),
//   );

//   // Fixed Asset - Repository
//   sl.registerLazySingleton<FixedAssetRepository>(
//     () => FixedAssetRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
//   );

//   // Fixed Asset - UseCases
//   // sl.registerLazySingleton(() => GetAssetsUseCase(sl<FixedAssetRepository>()));
//   // sl.registerLazySingleton(
//   //   () => GetStatusCountsUseCase(sl<FixedAssetRepository>()),
//   // );
//   // sl.registerLazySingleton(
//   //   () => GetAssetByIdUseCase(sl<FixedAssetRepository>()),
//   // );
//   sl.registerLazySingleton(
//     () => ApiClient(sl<NetworkInfo>() as FlutterSecureStorage),
//   );
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
//   );
//   sl.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(
//       sl<SharedPreferences>() as FlutterSecureStorage,
//       sl<FlutterSecureStorage>() as SharedPreferences,
//     ),
//   );

//   // Fixed Asset - Controller
//   sl.registerFactory(
//     () => FixedAssetController(
//       getAssetsUseCase: sl<GetAssetsUseCase>(),
//       getStatusCountsUseCase: sl<GetStatusCountsUseCase>(),
//       getAssetByIdUseCase: sl<GetAssetByIdUseCase>(),
//     ),
//   );
// }

// ==============================================================
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

// Auth
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

// Dashboard
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'features/dashboard/domain/usecases/get_analytics_usecase.dart';
import 'features/dashboard/presentation/controllers/dashboard_controller.dart';

// Fixed Asset
import 'features/fixed_asset/data/datasources/fixed_asset_remote_datasource.dart';
import 'features/fixed_asset/data/repositories/fixed_asset_repository_impl.dart';
import 'features/fixed_asset/domain/repositories/fixed_asset_repository.dart';
import 'features/fixed_asset/domain/usecases/fixed_asset_usecases.dart';
import 'features/fixed_asset/presentation/controllers/fixed_asset_controller.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ───────────────────────────────────────────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ── Core ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<FlutterSecureStorage>()),
  );

  // ── Auth - DataSources ─────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sl<FlutterSecureStorage>(),
      sl<SharedPreferences>(),
    ),
  );

  // ── Auth - Repository ──────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // ── Auth - UseCases ────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl<AuthRepository>()));

  // ── Auth - Controller ──────────────────────────────────────────────────────
  sl.registerFactory(
    () => AuthController(
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCachedUserUseCase: sl<GetCachedUserUseCase>(),
    ),
  );

  // ── Dashboard - DataSources ────────────────────────────────────────────────
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // ── Dashboard - Repository ─────────────────────────────────────────────────
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // ── Dashboard - UseCases ───────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetDashboardStatsUseCase(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAnalyticsUseCase(sl<DashboardRepository>()),
  );

  // ── Dashboard - Controller ─────────────────────────────────────────────────
  sl.registerFactory(
    () => DashboardController(
      getDashboardStatsUseCase: sl<GetDashboardStatsUseCase>(),
      getAnalyticsUseCase: sl<GetAnalyticsUseCase>(),
    ),
  );

  // ── Fixed Asset - DataSource ───────────────────────────────────────────────
  sl.registerLazySingleton<FixedAssetRemoteDataSource>(
    () => FixedAssetRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // ── Fixed Asset - Repository ───────────────────────────────────────────────
  sl.registerLazySingleton<FixedAssetRepository>(
    () => FixedAssetRepositoryImpl(
      remoteDataSource: sl<FixedAssetRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // ── Fixed Asset - UseCases ─────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetAssetsUseCase(sl<FixedAssetRepository>()));
  sl.registerLazySingleton(
    () => GetStatusCountsUseCase(sl<FixedAssetRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAssetByIdUseCase(sl<FixedAssetRepository>()),
  );

  // ── Fixed Asset - Controller ───────────────────────────────────────────────
  sl.registerFactory(
    () => FixedAssetController(
      getAssetsUseCase: sl<GetAssetsUseCase>(),
      getStatusCountsUseCase: sl<GetStatusCountsUseCase>(),
      getAssetByIdUseCase: sl<GetAssetByIdUseCase>(),
    ),
  );
}
