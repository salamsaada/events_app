import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {

  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      bgColor: AppColors.background,
      surfaceColor: AppColors.surface,
      primaryColor: AppColors.primaryGold,
    );
  }

  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      bgColor: AppColors.lightBackground,
      surfaceColor: AppColors.lightSurface,
      primaryColor: AppColors.primaryGold, 
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color bgColor,
    required Color surfaceColor,
    required Color primaryColor,
  }) {
    bool isDark = brightness == Brightness.dark;

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgColor,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        surface: surfaceColor,
        onSurface: isDark ? Colors.white : Colors.black, 
      ),

     textTheme: TextTheme(
  displayLarge: AppTextStyles.mainTitle.copyWith(color: isDark ? Colors.white : Colors.black),
  bodyLarge: AppTextStyles.bodyMain.copyWith(color: isDark ? Colors.white : Colors.black),
  bodySmall: AppTextStyles.bodyGrey.copyWith(color: isDark ? AppColors.secondaryText : AppColors.lightSecondaryText),
),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor, 
        labelStyle: AppTextStyles.bodyGrey,
        hintStyle: AppTextStyles.bodyGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: isDark ? Colors.black : Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.buttonText,
          elevation: 2,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: AppTextStyles.mainTitle.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}