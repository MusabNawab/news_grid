import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static const String _dbName = 'news_grid_app.db';
  static const int _dbVersion = 1;

  static const String _tableUsers = 'users';
  static const String _tableArticles = 'articles';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    // User Table
    await db.execute('''
      CREATE TABLE $_tableUsers (
        id INTEGER PRIMARY KEY DEFAULT 1,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        notificationEnabled INTEGER,
        themeMode TEXT
      )
    ''');

    // Articles Table
    // Using URL as ID. Assuming unique URLs.
    await db.execute('''
      CREATE TABLE $_tableArticles (
        url TEXT PRIMARY KEY,
        source_id TEXT,
        source_name TEXT,
        author TEXT,
        title TEXT,
        description TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT
      )
    ''');
  }

  // Expose table names for use in other services
  static const String tableUsers = _tableUsers;
  static const String tableArticles = _tableArticles;
}
