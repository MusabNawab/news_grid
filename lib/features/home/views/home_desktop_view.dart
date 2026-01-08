import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_grid/core/enums/news_category.dart';
import 'package:news_grid/features/home/widgets/home_header.dart';
import 'package:news_grid/features/home/widgets/offline_status.dart';
import 'package:news_grid/features/home/widgets/top_headline.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:news_grid/features/homescreen/logic/local_filter_cubit/local_filter_cubit.dart';
import 'package:news_grid/features/homescreen/widgets/category_filters_list.dart';
import 'package:news_grid/features/homescreen/widgets/news_list_item.dart';

class HomeDesktopView extends StatelessWidget {
  const HomeDesktopView({
    super.key,
    required this.articles,
    required this.filterState,
    required this.isLoading,
    required this.isOfflineMode,
    required this.onArticleTap,
  });
  final List<Article> articles;
  final LocalFilterState filterState;
  final bool isLoading;
  final Function(Article article) onArticleTap;
  final bool isOfflineMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (isOfflineMode) OfflineStatus(),
            const HomeHeader(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    "Discover\nWorld News",
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CategoryList(
                  categories: NewsCategory.values,
                  selectedCategory: filterState.selectedCategory,
                  onCategorySelected: (cat) =>
                      context.read<LocalFilterCubit>().updateCategory(cat),
                ),
                const SizedBox(height: 24),
                // Featured Section
                if (articles.isNotEmpty)
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: TopHeadlineWidget(
                        article: articles[0],
                        onTap: () => onArticleTap(articles[0]),
                      ),
                    ),
                  ),
                if (articles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text("No articles found for this category."),
                    ),
                  ),
                if (articles.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                color: Theme.of(context).colorScheme.primary,
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Flexible(
                                child: Text(
                                  "Latest Updates",
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List Items
                  ...articles
                      .skip(1)
                      .map(
                        (article) => Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: NewsListItem(
                              article: article,
                              onTap: () => onArticleTap(article),
                            ),
                          ),
                        ),
                      ),
                ],
              ],
            ),

            // Bottom Padding for Nav Bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
