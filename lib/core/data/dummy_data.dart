import 'package:news_grid/features/homescreen/data/top_headlines.dart';

class DummyData {
  static List<Article> getArticles({int count = 10}) {
    return List.generate(
      count,
      (index) => Article(
        source: Source(id: 'source_$index', name: 'Bone Source'),
        author: 'Bone Author',
        title:
            'This is a long fake title to simulate a real news headline for the skeleton loader.',
        description:
            'This is a longer fake description to simulate the body of a news article card in the skeleton loader UI.',
        url: 'https://example.com',
        urlToImage: 'https://via.placeholder.com/150',
        publishedAt: DateTime.now(),
        content: 'Fake content for skeleton loading...',
      ),
    );
  }
}
