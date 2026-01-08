import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_grid/core/enums/request_types.dart';

class RequestData {
  final RequestType requestType;
  final String api;
  final Map<String, dynamic> headers;
  final Map<String, dynamic>? queryParameters;
  final dynamic body;
  final CancelToken? cancelToken;
  final ResponseType? responseType;
  final String? contentType;
  RequestData({
    required this.requestType,
    required this.api,
    Map<String, dynamic>? headers,
    this.queryParameters,
    this.body,
    this.cancelToken,
    this.responseType,
    this.contentType,
  }) : headers =
           headers ?? {'Authorization': 'Bearer ${dotenv.env['API_KEY']}'};

  RequestData copyWith({
    RequestType? requestType,
    String? api,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    CancelToken? cancelToken,
    ResponseType? responseType,
    String? contentType,
  }) {
    return RequestData(
      requestType: requestType ?? this.requestType,
      api: api ?? this.api,
      headers: headers ?? this.headers,
      queryParameters: queryParameters ?? this.queryParameters,
      body: body ?? this.body,
      cancelToken: cancelToken ?? this.cancelToken,
      responseType: responseType ?? this.responseType,
      contentType: contentType ?? this.contentType,
    );
  }

  @override
  String toString() {
    return 'RequestData(requestType: $requestType, api: $api, headers: $headers, queryParameters: $queryParameters, body: $body, cancelToken: $cancelToken, responseType: $responseType, contentType: $contentType, )';
  }
}
