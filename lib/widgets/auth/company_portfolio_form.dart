import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart'; 
import 'package:eventsapp/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/widgets/common/text_field_widget.dart';
import 'package:flutter/material.dart';

class CompanyPortfolioForm extends StatelessWidget {
  const CompanyPortfolioForm({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "LOCATION & WORKS", 
          style: AppTextStyles.goldSubtitle,
        ),
        const SizedBox(height: 15),
        
        const CustomTextField(
          label: "Headquarters Location", 
          icon: Icons.map_outlined
        ),
        const SizedBox(height: 25),
 
        Text(
          "GALLERY", 
          style: AppTextStyles.captionBold.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 10),

        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.cardBackground.withOpacity(0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: theme.primaryColor),
              const SizedBox(height: 8),
              Text(
                "Upload Company Works", 
                style: AppTextStyles.bodyGrey.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 35),
   
        CustomGoldButton(
          text: "COMPLETE REGISTRATION",
          onTap: () {
            // سيتم الربط مع الـ Cubit لاحقاً
          },
        ),
      ],
    );
  }
}