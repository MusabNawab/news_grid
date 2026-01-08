import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_grid/core/data/api_service.dart';
import 'package:news_grid/core/data/request_data.dart';
import 'package:news_grid/core/enums/cubit_state.dart';

part 'base_state.dart';

abstract class BaseCubit<T extends BaseState<T>> extends Cubit<T> {
  final ApiService apiService;
  CancelToken? _activeCancelToken;

  BaseCubit(super.initialState, this.apiService);

  @override
  Future<void> close() {
    _activeCancelToken?.cancel();
    return super.close();
  }

  Future<void> callApi<D extends Object>({
    required RequestData requestData,
    required Function(D data) onSuccess,
    required D Function(dynamic)? fromJson,
    Function(String error)? onError,
    bool? getHeaders,
  }) async {
    if (_activeCancelToken != null && !_activeCancelToken!.isCancelled) {
      _activeCancelToken!.cancel();
    }

    final newCancelToken = CancelToken();
    _activeCancelToken = newCancelToken;

    final newRequestData = requestData.copyWith(cancelToken: newCancelToken);

    try {
      final response = await apiService.callApi<D>(
        requestData: newRequestData,
        fromJson: fromJson,
      );

      if (newCancelToken.isCancelled) {
        return;
      }

      response.fold(
        (repositoryError) {
          if (onError != null) {
            onError(repositoryError.errorMsg ?? 'Unknown Error');
          } else {
            emit(
              state.copyWith(
                currentState: CubitState.error,
                message: repositoryError.errorMsg,
              ),
            );
            // 2. AUTOMATIC ERROR REPORTING (Global)
            handleApiError(
              api: requestData.api,
              params: requestData.queryParameters ?? requestData.body,
              errorMessage: repositoryError.errorMsg ?? '',
            );
          }
        },
        (data) {
          if (newCancelToken.isCancelled) {
            return;
          }
          onSuccess(data);
        },
      );
    } catch (e) {
      if (newCancelToken.isCancelled) {
        return;
      }

      if (kDebugMode) {
        debugPrint('$e');
      }

      if (onError != null) {
        onError(e.toString());
      } else {
        handleApiError(
          api: requestData.api,
          params: requestData.queryParameters ?? requestData.body,
          errorMessage: 'Error in ${requestData.api} api: $e',
        );
      }
    }
  }

  void handleApiError({
    required String api,
    required dynamic params,
    required String errorMessage,
    CubitState? customState,
  }) {
    if (kReleaseMode) {
      //report error
      debugPrint(errorMessage);
    }

    if (kDebugMode) {
      debugPrint(errorMessage);
    }

    emit(
      state.copyWith(
        currentState: customState ?? CubitState.error,
        message: errorMessage,
      ),
    );
  }
}
