import 'package:flutter/material.dart';
import 'package:news_grid/features/article_details/widgets/article_action_btn.dart';
import 'package:news_grid/features/article_details/widgets/bottom_sheet_content.dart';

import 'package:news_grid/features/homescreen/data/top_headlines.dart';

import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/core/shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:news_grid/widgets/image_with_placeholder.dart';
import 'package:news_grid/constants/app_breakpoints.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _isSaved = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final user = await StorageService.getUser();
    if (user != null) {
      final isSaved =
          user.savedArticles?.any((a) => a.title == widget.article.title) ??
          false;
      if (mounted) {
        setState(() {
          _user = user;
          _isSaved = isSaved;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (_user == null) return;

    final currentSaved = _user!.savedArticles ?? [];
    List<Article> updatedSaved;

    if (_isSaved) {
      updatedSaved = currentSaved
          .where((a) => a.title != widget.article.title)
          .toList();
    } else {
      updatedSaved = [...currentSaved, widget.article];
    }

    final updatedUser = _user!.copyWith(savedArticles: updatedSaved);
    await StorageService.saveUser(updatedUser);

    if (mounted) {
      setState(() {
        _user = updatedUser;
        _isSaved = !_isSaved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = AppResponsive.isDesktop(constraints.maxWidth);

          // For desktop, we center the content and limit the width
          Widget content = Stack(
            children: [
              // 1. Full Screen Image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: constraints.maxHeight * 0.45,
                child: Hero(
                  tag: widget.article.url,
                  child: ImageWithPlaceholder(
                    imageUrl: widget.article.urlToImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 1.5 Gradient Overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Back Button & Actions
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ArticleActionBtn(
                      icon: Icons.chevron_left,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        ArticleActionBtn(
                          icon: _isSaved
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          onTap: _toggleBookmark,
                        ),
                        const SizedBox(width: 12),
                        ArticleActionBtn(
                          icon: Icons.share,
                          onTap: () {
                            SharePlus.instance.share(
                              ShareParams(
                                subject: widget.article.title,
                                text:
                                    '${widget.article.title}\n\nRead more at: ${widget.article.url}',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Bottom Sheet Content
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.4,
                child: BottomSheetContent(article: widget.article),
              ),
            ],
          );

          if (isDesktop) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: content,
              ),
            );
          }

          return content;
        },
      ),
    );
  }
}
