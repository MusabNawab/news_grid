import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_grid/core/styles/app_colors.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  final int selectedIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    Widget navItem(IconData icon, String label, int index) {
      final isSelected = selectedIndex == index;
      return GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FaIcon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.textLight,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 100,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          navItem(FontAwesomeIcons.house, "Home", 0),
          navItem(FontAwesomeIcons.magnifyingGlass, "Search", 1),
          navItem(FontAwesomeIcons.solidBookmark, "Saved", 2),
          navItem(FontAwesomeIcons.gear, "Settings", 3),
        ],
      ),
    );
  }
}
