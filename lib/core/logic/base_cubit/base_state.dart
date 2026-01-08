part of 'base_cubit.dart';

abstract class BaseState<T extends BaseState<T>> {
  final CubitState currentState;
  final int? status;
  final String message;
  final int page;
  final bool isLastPage;

  BaseState({
    required this.currentState,
    this.status,
    required this.message,
    this.page = 1,
    this.isLastPage = false,
  });

  T copyWith({
    CubitState? currentState,
    int? status,
    String? message,
    int? page,
    bool? isLastPage,
  });
}
