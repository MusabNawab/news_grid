import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_grid/core/data/database_service.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  //save user
  static Future<void> saveUser(User user) async {
    try {
      final db = await DatabaseService.database;
      final data = {
        'id': 1,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'notificationEnabled': (user.notificationEnabled ?? false) ? 1 : 0,
        'themeMode': user.themeMode.toString(),
      };
      await db.insert(
        DatabaseService.tableUsers,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error saving user to DB: $e");
      }
    }
  }

  static Future<User?> getUser() async {
    try {
      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseService.tableUsers,
        where: 'id = ?',
        whereArgs: [1],
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      final savedArticles = await getSavedArticles();

      return User(
        firstName: map['firstName'],
        lastName: map['lastName'],
        email: map['email'],
        notificationEnabled: (map['notificationEnabled'] as int) == 1,
        themeMode: _parseThemeMode(map['themeMode']),
        savedArticles: savedArticles,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error getting user from DB: $e");
      }
    }
    return null;
  }

  static ThemeMode _parseThemeMode(String? value) {
    if (value == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => ThemeMode.light,
    );
  }

  // --- Article Methods ---
  static Future<void> saveArticle(Article article) async {
    final db = await DatabaseService.database;
    final data = {
      'url': article.url,
      'source_id': article.source.id,
      'source_name': article.source.name,
      'author': article.author,
      'title': article.title,
      'description': article.description,
      'urlToImage': article.urlToImage,
      'publishedAt': article.publishedAt.toIso8601String(),
      'content': article.content,
    };
    await db.insert(
      DatabaseService.tableArticles,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeArticle(String url) async {
    final db = await DatabaseService.database;
    await db.delete(
      DatabaseService.tableArticles,
      where: 'url = ?',
      whereArgs: [url],
    );
  }

  static Future<List<Article>> getSavedArticles() async {
    final db = await DatabaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseService.tableArticles,
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Article(
        source: Source(id: map['source_id'], name: map['source_name'] ?? ''),
        author: map['author'],
        title: map['title'],
        description: map['description'],
        url: map['url'],
        urlToImage: map['urlToImage'],
        publishedAt: DateTime.tryParse(map['publishedAt']) ?? DateTime.now(),
        content: map['content'],
      );
    });
  }

  // Top Headlines Persistence
  static const String _topHeadlinesKey = 'top_headlines_cache';

  static Future<void> saveTopHeadlines(TopHeadlinesResponse response) async {
    try {
      final prefs = await _getPrefs();
      final String json = jsonEncode(response.toJson());
      await prefs.setString(_topHeadlinesKey, json);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error saving Top Headlines to SharedPreferences: $e");
      }
    }
  }

  static Future<TopHeadlinesResponse?> getTopHeadlines() async {
    try {
      final prefs = await _getPrefs();
      final String? jsonString = prefs.getString(_topHeadlinesKey);
      if (jsonString != null) {
        return TopHeadlinesResponse.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error getting Top Headlines from SharedPreferences: $e");
      }
    }
    return null;
  }

  //clear
  static Future<void> clear() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }
}
