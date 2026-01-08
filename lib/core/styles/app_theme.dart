import 'package:flutter/material.dart';
import 'package:news_grid/core/styles/app_colors.dart';
import 'package:news_grid/core/styles/text_style.dart';

class AppTheme {
  static ThemeData getTheme(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      return dark;
    }
    return light;
  }

  // Light Theme
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontBody,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        surface: AppColors.surface,
        onSurface: AppColors.textDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),

      textTheme: TextTheme(
        headlineLarge: AppTextStyles.appTitle,
        headlineMedium: AppTextStyles.heroTitle,
        titleMedium: AppTextStyles.cardTitle,
        bodyMedium: AppTextStyles.bodyText,
        labelSmall: AppTextStyles.metaData,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
    );
  }

  // Dark Theme
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: AppTextStyles.fontBody,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textMainDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      textTheme: TextTheme(
        // Override light mode colors with dark mode equivalents
        headlineLarge: AppTextStyles.appTitle.copyWith(
          color: AppColors.textMainDark,
        ),
        headlineMedium: AppTextStyles.heroTitle.copyWith(color: Colors.white),
        titleMedium: AppTextStyles.cardTitle.copyWith(
          color: AppColors.textMainDark,
        ),
        bodyMedium: AppTextStyles.bodyText.copyWith(
          color: AppColors.textBodyDark,
        ),
        labelSmall: AppTextStyles.metaData.copyWith(
          color: AppColors.textBodyDark,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
