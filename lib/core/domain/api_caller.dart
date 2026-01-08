import 'package:fpdart/fpdart.dart';
import 'package:news_grid/core/data/request_data.dart';
import 'package:news_grid/core/domain/api_error_handler.dart';

abstract interface class ApiCaller {
  Future<Either<ApiErrorHandler, T>> callApi<T>({
    required RequestData requestData,
    T Function(dynamic)? fromJson,
  });
}
