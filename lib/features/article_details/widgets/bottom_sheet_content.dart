import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_grid/features/article_details/widgets/article_web_view.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:news_grid/utils/extensions/catergory_extension.dart';
import 'package:news_grid/utils/methods/helper_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Meta Tags
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  article.category.label,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    HelperMethods.formatPublishedDate(article.publishedAt),
                    style: textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Headline
          Text(
            article.title,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontSize: 24, height: 1.2),
          ),

          const SizedBox(height: 20),

          // Author Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text('Author:'),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.author ?? "Unknown Author",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      article.source.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Theme.of(context).dividerColor),
          ),

          // Content Body
          Text(
            article.description ?? "",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'Playfair Display',
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            article.content ??
                "Full article content not available via API. Please visit the source link below.",
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 32),

          // Read Full Article Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                if (kIsWeb) {
                  final uri = Uri.parse(article.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleWebView(url: article.url),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Read Full Article",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.open_in_new, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
