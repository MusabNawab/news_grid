import 'package:flutter/material.dart';
import 'package:news_grid/core/styles/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  const CustomSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search for news...',
            hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.8)),
            prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
