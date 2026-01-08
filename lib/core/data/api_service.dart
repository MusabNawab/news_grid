import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_grid/core/data/report_api_error.dart';
import 'package:news_grid/core/data/request_data.dart';
import 'package:news_grid/core/domain/api_caller.dart';
import 'package:news_grid/core/domain/api_error_handler.dart';
import 'package:news_grid/core/domain/network_info.dart';
import 'package:news_grid/core/enums/request_types.dart';

class ApiService implements ApiCaller {
  final Dio dio;
  final NetworkInfo networkInfo;
  final ApiErrorHandler errorReporter;

  ApiService({
    required this.dio,
    required this.networkInfo,
    required this.errorReporter,
  });

  @override
  Future<Either<ReportApiError, T>> callApi<T>({
    required RequestData requestData,
    T Function(dynamic)? fromJson,
  }) async {
    //check if internet is available before api call is being made
    if (!await networkInfo.isConnected) {
      return Left(
        ReportApiError(
          apiName: requestData.api,
          errorMsg: 'No internet connection!',
          parameters: requestData.queryParameters ?? requestData.body,
        ),
      );
    }

    //otherwise call api
    try {
      final options = Options(
        responseType: requestData.responseType,
        contentType: requestData.contentType,
        headers: requestData.headers,
      );

      Response response;

      switch (requestData.requestType) {
        case RequestType.get:
          response = await dio.get(
            requestData.api,
            data: requestData.body,
            queryParameters: requestData.queryParameters,
            options: options,
            cancelToken: requestData.cancelToken,
          );
          break;
        case RequestType.post:
          response = await dio.post(
            requestData.api,
            data: requestData.body,
            queryParameters: requestData.queryParameters,
            options: options,
            cancelToken: requestData.cancelToken,
          );
          break;
        case RequestType.put:
          response = await dio.put(
            requestData.api,
            data: requestData.body,
            queryParameters: requestData.queryParameters,
            options: options,
            cancelToken: requestData.cancelToken,
          );
          break;
        case RequestType.patch:
          response = await dio.patch(
            requestData.api,
            data: requestData.body,
            queryParameters: requestData.queryParameters,
            options: options,
            cancelToken: requestData.cancelToken,
          );
          break;
        case RequestType.delete:
          response = await dio.delete(
            requestData.api,
            data: requestData.body,
            queryParameters: requestData.queryParameters,
            options: options,
            cancelToken: requestData.cancelToken,
          );
          break;
      }

      dynamic decoded;
      if (requestData.responseType == ResponseType.plain) {
        decoded = response.data.toString();
      } else if (response.data is String) {
        decoded = jsonDecode(response.data);
      } else {
        decoded = response.data;
      }

      if (fromJson != null) {
        return Right(fromJson(decoded));
      }

      return Right(decoded as T);
    }
    //on api errors
    on DioException catch (e) {
      final error = e.error;
      if (e.type == DioExceptionType.cancel) {
        return Left(
          ReportApiError(
            apiName: requestData.api,
            parameters: requestData.queryParameters ?? requestData.body,
            errorMsg: 'Request Cancelled',
          ),
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode ?? 500;
        final message = e.message;

        //handle unauthentication
        if (statusCode == 401 || statusCode == 403) {
          return Left(
            ReportApiError(
              apiName: requestData.api,
              parameters: requestData.queryParameters ?? requestData.body,
              errorMsg: 'Please Login Again!',
            ),
          );
        } else //handle unauthentication
        if (statusCode == 426) {
          return Left(
            ReportApiError(
              apiName: requestData.api,
              parameters: requestData.queryParameters ?? requestData.body,
              errorMsg: 'API Limit Exceeded',
            ),
          );
        }
        return Left(
          ReportApiError(
            apiName: requestData.api,
            parameters: requestData.queryParameters ?? requestData.body,
            errorMsg: 'Error: $message (Code: $statusCode)',
          ),
        );
      } else if (error is HandshakeException || error is TlsException) {
        return Left(
          ReportApiError(
            apiName: requestData.api,
            parameters: requestData.queryParameters ?? requestData.body,
            errorMsg: 'TLS Handshake failed: ${error.toString()}',
          ),
        );
      } else if (error is SocketException) {
        final osMsg = error.osError?.message ?? error.message;
        if (osMsg.contains('Failed host lookup')) {
          return Left(
            ReportApiError(
              apiName: requestData.api,
              parameters: requestData.queryParameters ?? requestData.body,
              errorMsg: 'DNS lookup failed: $osMsg',
            ),
          );
        } else {
          return Left(
            ReportApiError(
              apiName: requestData.api,
              parameters: requestData.queryParameters ?? requestData.body,
              errorMsg: 'Socket error: $osMsg',
            ),
          );
        }
      } else if (e.type == DioExceptionType.connectionError) {
        return Left(
          ReportApiError(
            apiName: requestData.api,
            parameters: requestData.queryParameters ?? requestData.body,
            errorMsg: 'No internet connection!',
          ),
        );
      }

      if (kDebugMode) {
        debugPrint('Unhandled DioException in ${requestData.api} API: $e');
      }
      errorReporter.onError();
      return Left(
        ReportApiError(
          apiName: requestData.api,
          parameters: requestData.queryParameters ?? requestData.body,
          errorMsg: 'Connection issue, please try again.',
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in ${requestData.api} API: $e');
      }
      errorReporter.onError();
      return Left(
        ReportApiError(
          apiName: requestData.api,
          parameters: requestData.queryParameters ?? requestData.body,
          errorMsg: 'Something went wrong',
        ),
      );
    }
  }
}
