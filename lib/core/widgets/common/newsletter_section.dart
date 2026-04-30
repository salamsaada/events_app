import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.primaryGold.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'عضوية النخبة',
            style: AppTextStyles.mainTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'انضم إلى دائرتنا الملكية للحصول على أولوية الحجز\nوالوصول الحصري للقاعات.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMain.copyWith(
                color: AppColors.greyText,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: AppColors.darkGrey.withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyMain,
                decoration: InputDecoration(
                  hintText: 'بريدك الإلكتروني للعمل',
                  hintStyle: AppTextStyles.bodyGrey.copyWith(
                    color: AppColors.darkGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: Text(
                'قدم الآن',
                style: AppTextStyles.buttonText.copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
