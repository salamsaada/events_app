import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle mainTitle = TextStyle(
    color: AppColors.whiteText,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle goldSubtitle = TextStyle(
    color: AppColors.primaryGold,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );

  static const TextStyle bodyMain = TextStyle(
    color: AppColors.whiteText,
    fontSize: 15,
    height: 1.5,
  );

  static const TextStyle bodyGrey = TextStyle(
    color: AppColors.greyText,
    fontSize: 13,
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  static const TextStyle captionBold = TextStyle(
    color: AppColors.greyText,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );

  static const TextStyle subtitle = TextStyle(
    color: AppColors.whiteText,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.whiteText,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tileTitle = TextStyle(
    color: AppColors.mediumGrey,
    fontSize: 14,
  );

  static const TextStyle tileCaption = TextStyle(
    color: AppColors.lightGrey,
    fontSize: 12,
  );
}
