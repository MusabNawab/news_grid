import 'package:flutter/material.dart';
import 'package:news_grid/features/article_details/article_details.dart';
import 'package:news_grid/features/home/views/home_desktop_view.dart';
import 'package:news_grid/features/home/views/home_mobile_view.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:news_grid/constants/app_breakpoints.dart';
import 'package:news_grid/features/homescreen/logic/local_filter_cubit/local_filter_cubit.dart';

import 'package:skeletonizer/skeletonizer.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.articles,
    required this.filterState,
    this.isLoading = false,
    this.isOfflineMode = false,
  });
  final List<Article> articles;
  final LocalFilterState filterState;
  final bool isLoading;
  final bool isOfflineMode;
  @override
  Widget build(BuildContext context) {
    void onArticleTap(Article article) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleDetailScreen(article: article),
        ),
      );
    }

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = AppResponsive.isDesktop(constraints.maxWidth);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: isDesktop
              ? HomeDesktopView(
                  key: const ValueKey('desktop_view'),
                  articles: articles,
                  filterState: filterState,
                  isLoading: isLoading,
                  isOfflineMode: isOfflineMode,
                  onArticleTap: onArticleTap,
                )
              : HomeMobileView(
                  key: const ValueKey('mobile_view'),
                  articles: articles,
                  filterState: filterState,
                  isLoading: isLoading,
                  isOfflineMode: isOfflineMode,
                  onArticleTap: onArticleTap,
                ),
        );
      },
    );

    return Skeletonizer(enabled: isLoading, child: content);
  }
}
