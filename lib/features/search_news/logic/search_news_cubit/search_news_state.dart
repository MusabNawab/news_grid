part of 'search_news_cubit.dart';

class SearchNewsState extends BaseState<SearchNewsState> {
  final TopHeadlinesResponse? response;

  SearchNewsState({
    required super.currentState,
    required super.message,
    required super.page,
    required super.isLastPage,

    this.response,
  });

  factory SearchNewsState.initial() {
    return SearchNewsState(
      currentState: CubitState.initial,
      message: '',
      page: 1,
      isLastPage: false,
    );
  }

  @override
  SearchNewsState copyWith({
    CubitState? currentState,
    int? status,
    String? message,
    int? page,
    bool? isLastPage,
    TopHeadlinesResponse? response,
  }) {
    return SearchNewsState(
      currentState: currentState ?? this.currentState,
      message: message ?? this.message,
      response: response ?? this.response,
      page: page ?? this.page,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}
