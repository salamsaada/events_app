import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.background
        : theme.colorScheme.surface;
    final selectedBackground = isDark
        ? AppColors.surface
        : AppColors.primaryGold.withValues(alpha: 0.14);
    final selectedColor = AppColors.primaryGold;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.person,
              l10n.profileTitle,
              3,
              selectedBackground,
              selectedColor,
              unselectedColor,
            ),
            _buildNavItem(
              Icons.receipt_long,
              l10n.myOrders,
              2,
              selectedBackground,
              selectedColor,
              unselectedColor,
            ),
            _buildNavItem(
              Icons.chat_bubble,
              l10n.lastConversations,
              1,
              selectedBackground,
              selectedColor,
              unselectedColor,
            ),
            _buildNavItem(
              Icons.home,
              l10n.home,
              0,
              selectedBackground,
              selectedColor,
              unselectedColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    Color selectedBackground,
    Color selectedColor,
    Color unselectedColor,
  ) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
