class TopHeadlinesResponse {
  final String status;
  final int? totalResults;
  final String? code;
  final List<Article> articles;

  TopHeadlinesResponse({
    required this.status,
    this.totalResults,
    this.code,
    required this.articles,
  });

  factory TopHeadlinesResponse.fromJson(Map<String, dynamic> json) {
    return TopHeadlinesResponse(
      status: json['status'] ?? '',
      totalResults: json['totalResults'],
      code: json['code'],
      articles:
          (json['articles'] as List<dynamic>?)
              ?.map((e) => Article.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'code': code,
      'articles': articles.map((e) => e.toJson()).toList(),
    };
  }

  TopHeadlinesResponse copyWith({
    String? status,
    int? totalResults,
    String? code,
    List<Article>? articles,
  }) {
    return TopHeadlinesResponse(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      code: code ?? this.code,
      articles: articles ?? this.articles,
    );
  }

  @override
  String toString() {
    return 'TopHeadlinesResponse(status: $status, totalResults: $totalResults, code: $code, articles: $articles)';
  }
}

class Article {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source'] ?? {}),
      author: json['author'],
      title: json['title'] ?? 'No Title',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt:
          DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
    };
  }
}

class Source {
  final String? id;
  final String name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name'] ?? 'Unknown Source');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
