import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/core/initializer/initializer.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit() : super(ThemeMode.system);

  Future<void> init() async {
    final user = getIt<User>();
    emit(user.themeMode ?? ThemeMode.system);
  }

  Future<void> toggle() async {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
