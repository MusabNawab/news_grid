import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_grid/features/home/home.dart';
import 'package:news_grid/core/data/dummy_data.dart';
import 'package:news_grid/core/enums/news_category.dart';
import 'package:news_grid/features/homescreen/widgets/bottom_nav_bar.dart';
import 'package:news_grid/features/homescreen/widgets/side_nav_bar.dart';
import 'package:news_grid/constants/app_breakpoints.dart';
import 'package:news_grid/features/saved_news/saved_news_screen.dart';
import 'package:news_grid/features/search_news/search_news.dart';
import 'package:news_grid/features/settings/settings_screen.dart';
import 'package:news_grid/widgets/no_internet_widget.dart';
import 'package:news_grid/widgets/rate_limit_error_widget.dart';

import 'package:news_grid/core/enums/cubit_state.dart';
import 'package:news_grid/features/homescreen/logic/get_top_headlines_cubit/get_top_headlines_cubit.dart';
import 'package:news_grid/features/homescreen/logic/local_filter_cubit/local_filter_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late ValueNotifier<int> _selectedIndexNotifier;

  @override
  void initState() {
    super.initState();
    _selectedIndexNotifier = ValueNotifier<int>(_selectedIndex);
    context.read<GetTopHeadlinesCubit>().get(country: 'us');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocalFilterCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: BlocListener<GetTopHeadlinesCubit, GetTopHeadlinesState>(
            listener: (context, state) {
              if (state.currentState == CubitState.success &&
                  state.response != null) {
                context.read<LocalFilterCubit>().updateArticles(
                  state.response!.articles,
                );
              }
            },
            child: BlocBuilder<GetTopHeadlinesCubit, GetTopHeadlinesState>(
              builder: (context, state) {
                if (state.currentState == CubitState.loading) {
                  return HomeTab(
                    articles: DummyData.getArticles(),
                    filterState: LocalFilterState(
                      allArticles: [],
                      filteredArticles: [],
                      selectedCategory: NewsCategory.general,
                    ),
                    isLoading: true,
                  );
                }

                if (state.currentState == CubitState.error) {
                  if (state.message.contains("No Internet Connection")) {
                    return NoInternetWidget(
                      onRetry: () {
                        context.read<GetTopHeadlinesCubit>().get(country: 'us');
                      },
                    );
                  }
                  return Center(child: Text(state.message));
                }

                if (state.currentState == CubitState.apiLimitExceeded) {
                  return RateLimitErrorWidget(
                    onRetry: () {
                      context.read<GetTopHeadlinesCubit>().get(country: 'us');
                    },
                  );
                }

                return BlocBuilder<LocalFilterCubit, LocalFilterState>(
                  builder: (context, filterState) {
                    final articles = filterState.filteredArticles;

                    return ValueListenableBuilder(
                      valueListenable: _selectedIndexNotifier,
                      builder: (context, value, child) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final isDesktop = AppResponsive.isDesktop(
                              constraints.maxWidth,
                            );

                            Widget body;
                            if (value == 0) {
                              body = HomeTab(
                                articles: articles,
                                filterState: filterState,
                                isOfflineMode: state.isOfflineMode,
                              );
                            } else if (value == 1) {
                              body = SearchNews();
                            } else if (value == 2) {
                              body = const SavedNewsScreen();
                            } else {
                              body = const SettingsScreen();
                            }

                            if (isDesktop) {
                              return Row(
                                children: [
                                  SideNavBar(
                                    selectedIndex: value,
                                    onTap: (index) {
                                      _selectedIndexNotifier.value = index;
                                      _selectedIndex = index;
                                    },
                                  ),
                                  Expanded(child: body),
                                ],
                              );
                            }

                            return Stack(
                              children: [
                                // Content Body
                                body,

                                // Bottom Nav Bar
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: BottomNavBar(
                                    selectedIndex: value,
                                    onTap: (index) {
                                      _selectedIndexNotifier.value = index;
                                      _selectedIndex = index;
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
