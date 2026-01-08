import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:news_grid/features/homescreen/data/top_headlines.dart';

class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final List<Article>? savedArticles;
  final bool? notificationEnabled;
  final ThemeMode? themeMode;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.savedArticles,
    this.notificationEnabled,
    this.themeMode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'savedArticles': savedArticles?.map((x) => x.toJson()).toList(),
      'notificationEnabled': notificationEnabled,
      'themeMode': themeMode?.toString(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      savedArticles: map['savedArticles'] != null
          ? List<Article>.from(
              (map['savedArticles'] as List).map<Article?>(
                (x) => Article.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
      notificationEnabled: map['notificationEnabled'],
      themeMode: map['themeMode'] != null
          ? map['themeMode'] == ThemeMode.light.toString()
                ? ThemeMode.light
                : ThemeMode.dark
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    List<Article>? savedArticles,
    bool? notificationEnabled,
    ThemeMode? themeMode,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      savedArticles: savedArticles ?? this.savedArticles,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, email: $email, savedArticles: $savedArticles, notificationEnabled: $notificationEnabled, themeMode: $themeMode)';
  }
}
