import 'package:news_grid/core/enums/news_category.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';

extension NewsCategoryLabel on NewsCategory {
  String get label {
    return name[0].toUpperCase() + name.substring(1);
  }
}

extension ArticleCategory on Article {
  NewsCategory get category {
    // 1. Prepare text for keyword search (Title + Description + Source)
    final text = '$title ${description ?? ""} ${source.name}'.toLowerCase();
    final sourceName = source.name.toLowerCase();

    // 2. Check Specific Sources (High Accuracy)
    if (_matches(sourceName, [
      'techcrunch',
      'the verge',
      'wired',
      'ars technica',
      'engadget',
      'cnet',
      'android',
      '9to5mac',
    ])) {
      return NewsCategory.technology;
    }
    if (_matches(sourceName, [
      'bloomberg',
      'cnbc',
      'forbes',
      'business insider',
      'wsj',
      'investopedia',
      'financial times',
      'economist',
    ])) {
      return NewsCategory.business;
    }
    if (_matches(sourceName, [
      'espn',
      'bleacher report',
      'nfl',
      'nba',
      'mlb',
      'sports',
      'motorsport',
      'sky sports',
    ])) {
      return NewsCategory.sports;
    }
    if (_matches(sourceName, [
      'ign',
      'polygon',
      'variety',
      'hollywood reporter',
      'deadline',
      'tmz',
      'vanity fair',
    ])) {
      return NewsCategory.entertainment;
    }
    if (_matches(sourceName, [
      'medical news',
      'health',
      'webmd',
      'medscape',
      'nih',
      'cdc',
    ])) {
      return NewsCategory.health;
    }
    if (_matches(sourceName, [
      'nasa',
      'space.com',
      'scientific american',
      'national geographic',
    ])) {
      return NewsCategory.science;
    }
    if (_matches(sourceName, [
      'politico',
      'axios',
      'hill',
      'white house',
      'gov',
      'un news',
    ])) {
      return NewsCategory.politics;
    }

    // 3. Check Keywords in Content (Fallback)

    // Tech
    if (_matches(text, [
      'ai ',
      'artificial intelligence',
      'apple',
      'google',
      'microsoft',
      'samsung',
      'software',
      'app ',
      'browser',
      'code',
      'linux',
      'windows',
      'robot',
      'cyber',
      'startup',
      'crypto',
    ])) {
      return NewsCategory.technology;
    }

    // Business
    if (_matches(text, [
      'stock',
      'market',
      'economy',
      'inflation',
      'trade',
      'bank',
      'revenue',
      'profit',
      'ceo',
      'ipo',
      'fed ',
      'interest rate',
    ])) {
      return NewsCategory.business;
    }

    // Sports
    if (_matches(text, [
      'football',
      'soccer',
      'basketball',
      'hockey',
      'baseball',
      'tennis',
      'game',
      'score',
      'championship',
      'olympic',
      'athlete',
      'coach',
      'cup',
      'league',
    ])) {
      return NewsCategory.sports;
    }

    // Entertainment
    if (_matches(text, [
      'movie',
      'film',
      'cinema',
      'actor',
      'actress',
      'star',
      'music',
      'song',
      'album',
      'concert',
      'netflix',
      'hbo',
      'disney',
      'celebrity',
      'award',
      'tv',
    ])) {
      return NewsCategory.entertainment;
    }

    // Health
    if (_matches(text, [
      'virus',
      'flu',
      'covid',
      'cancer',
      'disease',
      'hospital',
      'doctor',
      'patient',
      'health',
      'medicine',
      'vaccine',
      'outbreak',
      'pandemic',
    ])) {
      return NewsCategory.health;
    }

    // Science
    if (_matches(text, [
      'nasa',
      'space',
      'astronomy',
      'physics',
      'chemistry',
      'biology',
      'scientist',
      'planet',
      'moon',
      'mars',
      'galaxy',
      'research',
      'study',
    ])) {
      return NewsCategory.science;
    }

    // Politics
    if (_matches(text, [
      'election',
      'vote',
      'president',
      'senate',
      'congress',
      'parliament',
      'law',
      'policy',
      'campaign',
      'democrat',
      'republican',
      'trump',
      'biden',
      'white house',
      'prime minister',
      'diplomat',
    ])) {
      return NewsCategory.politics;
    }

    // Design
    if (_matches(text, [
      'design',
      'ui',
      'ux',
      'architecture',
      'art ',
      'minimalism',
      'fashion',
      'interior',
    ])) {
      return NewsCategory.design;
    }

    // Default to General if no specific matches found
    return NewsCategory.general;
  }

  bool _matches(String text, List<String> keywords) {
    for (var keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
