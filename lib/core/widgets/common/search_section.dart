import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 342,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: AppColors.greyText, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ابحث عن القاعات، الكادر، أو المخططين...',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                  fontFamily: 'NotoSansArabic',
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
