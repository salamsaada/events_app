import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconAndTextColor = isDark ? AppColors.whiteText : AppColors.primary;
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Icon(Icons.home, color: iconAndTextColor, size: 20),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: iconAndTextColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Icon(Icons.notifications, color: iconAndTextColor, size: 20),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: TextStyle(
                color: iconAndTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
