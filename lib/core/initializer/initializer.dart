import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_grid/core/data/api_service.dart';
import 'package:news_grid/core/data/report_api_error.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/core/domain/api_error_handler.dart';
import 'package:news_grid/core/initializer/dio_initializer.dart';
import 'package:news_grid/core/logic/app_theme_cubit/app_theme_cubit.dart';
import 'package:news_grid/core/logic/connectivity_cubit/connectivity_cubit.dart';
import 'package:news_grid/core/data/connectivity_network_info.dart';
import 'package:news_grid/core/domain/network_info.dart';

// Create a global instance (or use GetIt.instance)
final getIt = GetIt.instance;

class Initializer {
  static void init() {
    getIt.registerLazySingleton<User>(
      () => User(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        notificationEnabled: true,
        themeMode: ThemeMode.system,
      ),
    );

    //register network cubit
    final connectivityCubit = getIt.registerSingleton<ConnectivityCubit>(
      ConnectivityCubit(),
    );

    //theme cubit
    getIt.registerSingleton<AppThemeCubit>(AppThemeCubit());

    //register Dio
    getIt.registerLazySingleton<Dio>(() => DioInitializer.init());

    //DI for api service
    getIt.registerLazySingleton<NetworkInfo>(
      () => ConnectivityNetworkInfo(connectivityCubit),
    );

    getIt.registerLazySingleton<ApiErrorHandler>(() => ReportApiError());
    getIt.registerLazySingleton<ApiService>(
      () => ApiService(
        dio: getIt<Dio>(),
        networkInfo: getIt<NetworkInfo>(),
        errorReporter: getIt<ApiErrorHandler>(),
      ),
    );
  }
}
