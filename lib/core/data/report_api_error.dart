import 'dart:developer';

import 'package:news_grid/core/domain/api_error_handler.dart';

class ReportApiError extends ApiErrorHandler {
  ReportApiError({super.apiName, super.errorMsg, super.parameters});

  @override
  void onError() {
    log('Error in $apiName: $errorMsg');
  }
}
