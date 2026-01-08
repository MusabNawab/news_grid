import 'package:news_grid/core/api_config/api_endpoints.dart';
import 'package:news_grid/core/data/api_service.dart';
import 'package:news_grid/core/data/request_data.dart';
import 'package:news_grid/core/enums/cubit_state.dart';
import 'package:news_grid/core/enums/request_types.dart';
import 'package:news_grid/core/initializer/initializer.dart';
import 'package:news_grid/core/logic/base_cubit/base_cubit.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:news_grid/core/shared_preferences/shared_preferences.dart';

part 'get_top_headlines_state.dart';

class GetTopHeadlinesCubit extends BaseCubit<GetTopHeadlinesState> {
  GetTopHeadlinesCubit()
    : super(GetTopHeadlinesState.initial(), getIt<ApiService>());

  void reset() {
    emit(GetTopHeadlinesState.initial());
  }

  Future<void> get({required String country}) async {
    if (state.currentState == CubitState.initial) {
      emit(state.copyWith(currentState: CubitState.loading));
    }

    final api = ApiEndpoints.topHeadlines;
    final queryParameters = {'country': country};
    final requestData = RequestData(
      api: api,
      requestType: RequestType.get,
      queryParameters: queryParameters,
    );

    await callApi<TopHeadlinesResponse>(
      requestData: requestData,
      onSuccess: (TopHeadlinesResponse data) async {
        if (data.status == 'ok') {
          // Cache the response
          await StorageService.saveTopHeadlines(data);
          emit(
            state.copyWith(
              currentState: CubitState.success,
              response: data,
              isOfflineMode: false,
            ),
          );
        } else {
          // Try to load from cache
          final cachedData = await StorageService.getTopHeadlines();
          if (cachedData != null) {
            emit(
              state.copyWith(
                currentState: CubitState.success,
                response: cachedData,
                isOfflineMode: true,
              ),
            );
          } else {
            handleApiError(
              api: api,
              params: queryParameters,
              errorMessage: 'Error in $api: $data',
            );
          }
        }
      },
      onError: (error) async {
        if (error.contains('(Code: 429)')) {
          emit(
            state.copyWith(
              currentState: CubitState.apiLimitExceeded,
              message: "API Rate Limit Exceeded",
              isOfflineMode: false,
            ),
          );
          return;
        }

        final cachedData = await StorageService.getTopHeadlines();
        if (cachedData != null) {
          emit(
            state.copyWith(
              currentState: CubitState.success,
              response: cachedData,
              isOfflineMode: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              currentState: CubitState.error,
              message: "No Internet Connection and no cached data.",
              isOfflineMode: false,
            ),
          );
        }
      },
      fromJson: (dynamic json) => TopHeadlinesResponse.fromJson(json),
    );
  }
}
