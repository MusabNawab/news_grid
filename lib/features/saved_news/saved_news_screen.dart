import 'package:flutter/material.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/core/shared_preferences/shared_preferences.dart';
import 'package:news_grid/features/homescreen/widgets/news_list_item.dart';
import 'package:news_grid/features/article_details/article_details.dart';
import 'package:news_grid/features/saved_news/widgets/no_saved_news.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key});

  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await StorageService.getUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final savedArticles = _user?.savedArticles ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Saved News",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 32),
              ),
            ),
            if (savedArticles.isEmpty)
              Expanded(child: NoSavedNews())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: savedArticles.length,
                  itemBuilder: (context, index) {
                    final article = savedArticles[index];
                    return NewsListItem(
                      article: article,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleDetailScreen(article: article),
                          ),
                        );
                        _loadUser();
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 80), // Bottom padding for nav bar
          ],
        ),
      ),
    );
  }
}
