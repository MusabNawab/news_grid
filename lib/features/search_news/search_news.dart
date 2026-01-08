import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_grid/core/enums/cubit_state.dart';
import 'package:news_grid/core/data/dummy_data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:news_grid/features/homescreen/widgets/news_list_item.dart';
import 'package:news_grid/features/search_news/logic/search_news_cubit/search_news_cubit.dart';
import 'package:news_grid/features/search_news/widgets/custom_search_bar.dart';
import 'package:news_grid/features/article_details/article_details.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({super.key});

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  Timer? _debounce;
  final _searchCubit = SearchNewsCubit();
  final ScrollController _scrollController = ScrollController();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    _searchCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_searchCubit.state.currentState != CubitState.loading &&
          !_searchCubit.state.isLastPage) {
        _searchCubit.get(keyword: _currentQuery);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        _currentQuery = query;
        _searchCubit.reset();
        _searchCubit.get(keyword: query);
      } else {
        _currentQuery = '';
        _searchCubit.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return BlocProvider(
      create: (context) => _searchCubit,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Search News",
              style: textTheme.headlineLarge?.copyWith(fontSize: 28),
            ),
          ),
          const SizedBox(height: 24),
          CustomSearchBar(onChanged: _onSearchChanged),
          Expanded(
            child: BlocBuilder<SearchNewsCubit, SearchNewsState>(
              builder: (context, state) {
                if (state.currentState == CubitState.loading &&
                    state.page == 1) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return NewsListItem(
                          article: DummyData.getArticles()[0],
                          onTap: () {},
                        );
                      },
                    ),
                  );
                }

                if (state.currentState == CubitState.error && state.page == 1) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                if (state.response != null &&
                    state.response!.articles.isNotEmpty) {
                  final articles = state.response!.articles;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: articles.length + (state.isLastPage ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == articles.length) {
                        if (state.isLastPage) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Maximum results reached. Please refine your search.",
                                style: textTheme.bodySmall?.copyWith(
                                  color: theme.disabledColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final article = articles[index];
                      return NewsListItem(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                if (state.currentState == CubitState.success &&
                    (state.response?.articles.isEmpty ?? true)) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: theme.disabledColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No articles found",
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Initial State
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: theme.disabledColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Search for specific topics",
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
