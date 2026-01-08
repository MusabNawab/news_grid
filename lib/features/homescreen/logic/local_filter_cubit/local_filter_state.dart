part of 'local_filter_cubit.dart';

class LocalFilterState {
  final NewsCategory selectedCategory;
  final List<Article> allArticles;
  final List<Article> filteredArticles;

  const LocalFilterState({
    required this.selectedCategory,
    required this.allArticles,
    required this.filteredArticles,
  });

  factory LocalFilterState.initial() {
    return const LocalFilterState(
      selectedCategory: NewsCategory.all,
      allArticles: [],
      filteredArticles: [],
    );
  }

  LocalFilterState copyWith({
    NewsCategory? selectedCategory,
    List<Article>? allArticles,
    List<Article>? filteredArticles,
  }) {
    return LocalFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      allArticles: allArticles ?? this.allArticles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
    );
  }
}
