import 'package:flutter/foundation.dart';
import 'package:news_grid/core/api_config/api_baseurl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

class DioInitializer {
  static Dio init() {
    final baseOptions = BaseOptions(
      baseUrl: ApiBaseurl.getBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final dio = Dio(baseOptions);

    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        enabled: kDebugMode,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);

    return dio;
  }
}
