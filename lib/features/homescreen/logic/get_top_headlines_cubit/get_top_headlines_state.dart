part of 'get_top_headlines_cubit.dart';

class GetTopHeadlinesState extends BaseState<GetTopHeadlinesState> {
  final TopHeadlinesResponse? response;
  final bool isOfflineMode;

  GetTopHeadlinesState({
    required super.currentState,
    required super.message,
    this.response,
    this.isOfflineMode = false,
  });

  factory GetTopHeadlinesState.initial() {
    return GetTopHeadlinesState(
      currentState: CubitState.initial,
      message: '',
      isOfflineMode: false,
    );
  }

  @override
  GetTopHeadlinesState copyWith({
    CubitState? currentState,
    int? status,
    String? message,
    int? page,
    bool? isLastPage,
    TopHeadlinesResponse? response,
    bool? isOfflineMode,
  }) {
    return GetTopHeadlinesState(
      currentState: currentState ?? this.currentState,
      message: message ?? this.message,
      response:
          response, // Don't persist previous response if new one is provided or null
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}
