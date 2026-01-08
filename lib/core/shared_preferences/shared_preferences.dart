import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/features/homescreen/data/top_headlines.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static const String _userKey = 'ciel_user';

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
      final prefs = await _getPrefs();
      final String userJson = user.toJson();
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error saving user to SharedPreferences: $e");
      }
    }
  }

  static Future<User?> getUser() async {
    try {
      final prefs = await _getPrefs();
      final String? userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(userJson);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error getting user from SharedPreferences: $e");
      }
    }
    return null;
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
