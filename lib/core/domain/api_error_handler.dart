abstract class ApiErrorHandler {
  final String? apiName;
  final dynamic parameters;
  final String? errorMsg;
  ApiErrorHandler({this.apiName, this.parameters, this.errorMsg});

  void onError() {
    throw UnimplementedError();
  }

  @override
  String toString() =>
      'ApiErrorHandler(apiName: $apiName, parameters: $parameters, errorMsg: $errorMsg)';
}
