import 'package:flutter/material.dart';
import 'package:news_grid/core/styles/app_colors.dart';

class AppTextStyles {
  static const String fontHeader = 'Playfair';
  static const String fontBody = 'Inter';

  // --- Headlines (Playfair Display) ---

  // Used for: App Bar Title ("NewsGrid."), Big Section Headers
  static const TextStyle appTitle = TextStyle(
    fontFamily: fontHeader,
    fontSize: 28,
    fontWeight: FontWeight.w900, // Black
    color: AppColors.primaryDark,
    letterSpacing: -0.5,
  );

  // Used for: Featured/Hero Card Title
  static const TextStyle heroTitle = TextStyle(
    fontFamily: fontHeader,
    fontSize: 24,
    fontWeight: FontWeight.w900, // Black
    color: Colors.white,
    height: 1.2,
  );

  // Used for: List Item Article Titles
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontHeader,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textDark,
    height: 1.3,
  );

  // --- Body & UI (Inter) ---

  // Used for: Category Pills (Selected)
  static const TextStyle categorySelected = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold
    color: Colors.white,
  );

  // Used for: Category Pills (Unselected)
  static const TextStyle categoryUnselected = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textBody,
  );

  // Used for: Article Detail Body Text
  static const TextStyle bodyText = TextStyle(
    fontFamily: fontBody,
    fontSize: 17,
    fontWeight: FontWeight.w400, // Regular
    color: Color(0xFF475569), // slate-600
    height: 1.6, // Relaxed line height for reading
  );

  // Used for: Metadata (Time, Author, "Jan 06")
  static const TextStyle metaData = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textLight,
  );

  // Used for: Buttons ("Read Full Article")
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: Colors.white,
  );
}
