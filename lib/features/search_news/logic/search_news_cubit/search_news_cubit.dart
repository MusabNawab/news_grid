import 'dart:developer';

import 'package:news_grid/core/api_config/api_endpoints.dart';
import 'package:news_grid/core/data/api_service.dart';
import 'package:news_grid/core/data/request_data.dart';
import 'package:news_grid/core/enums/cubit_state.dart';
import 'package:news_grid/core/enums/request_types.dart';
import 'package:news_grid/core/initializer/initializer.dart';
import 'package:news_grid/core/logic/base_cubit/base_cubit.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';

part 'search_news_state.dart';

class SearchNewsCubit extends BaseCubit<SearchNewsState> {
  SearchNewsCubit() : super(SearchNewsState.initial(), getIt<ApiService>());

  void reset() {
    emit(SearchNewsState.initial());
  }

  Future<void> get({required String keyword}) async {
    emit(state.copyWith(currentState: CubitState.loading));

    final api = ApiEndpoints.searchNews;
    final queryParameters = {'q': keyword, 'page': state.page, 'pageSize': 20};
    final requestData = RequestData(
      api: api,
      requestType: RequestType.get,
      queryParameters: queryParameters,
    );

    await callApi<TopHeadlinesResponse>(
      requestData: requestData,
      onSuccess: (TopHeadlinesResponse data) async {
        log('$data');
        if (data.status == 'ok') {
          emit(
            state.copyWith(
              currentState: CubitState.success,
              response: TopHeadlinesResponse(
                status: data.status,
                totalResults: data.totalResults,
                articles: [
                  ...(state.response?.articles ?? []),
                  ...data.articles,
                ],
              ),
              page: state.page + 1,
              isLastPage: false,
            ),
          );
        } else {
          handleApiError(
            api: api,
            params: queryParameters,
            errorMessage: 'Error in $api: $data',
          );
        }
      },
      onError: (error) {
        if (error.contains('426')) {
          emit(
            state.copyWith(
              currentState: CubitState.apiLimitExceeded,
              isLastPage: true,
            ),
          );
        } else {
          emit(state.copyWith(currentState: CubitState.error, message: error));
        }
      },
      fromJson: (dynamic json) => TopHeadlinesResponse.fromJson(json),
    );
  }
}
