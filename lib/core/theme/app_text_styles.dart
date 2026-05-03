import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {

  static const TextStyle mainTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle goldSubtitle = TextStyle(
    color: AppColors.primaryGold,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );

  static const TextStyle bodyMain = TextStyle(
    fontSize: 15,
    height: 1.5,
  );

  static const TextStyle bodyGrey = TextStyle(
    fontSize: 13,
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tileTitle = TextStyle(
    fontSize: 14,
  );

  static const TextStyle tileCaption = TextStyle(
    fontSize: 12,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );
}