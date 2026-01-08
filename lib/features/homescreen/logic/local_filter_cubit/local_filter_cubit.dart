import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_grid/core/enums/news_category.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:news_grid/utils/extensions/catergory_extension.dart';

part 'local_filter_state.dart';

class LocalFilterCubit extends Cubit<LocalFilterState> {
  LocalFilterCubit() : super(LocalFilterState.initial());

  void updateArticles(List<Article> articles) {
    emit(
      state.copyWith(
        allArticles: articles,
        filteredArticles: articles,
        selectedCategory: NewsCategory.all,
      ),
    );
  }

  void updateCategory(NewsCategory category) {
    if (category == NewsCategory.all) {
      emit(
        state.copyWith(
          selectedCategory: category,
          filteredArticles: state.allArticles,
        ),
      );
    } else {
      final filtered = state.allArticles.where((article) {
        return article.category == category;
      }).toList();

      emit(
        state.copyWith(selectedCategory: category, filteredArticles: filtered),
      );
    }
  }
}
