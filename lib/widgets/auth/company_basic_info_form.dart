import 'package:eventsapp/core/theme/app_text_styles.dart'; 
import 'package:eventsapp/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/widgets/common/text_field_widget.dart';
import 'package:flutter/material.dart';

class CompanyBasicInfoForm extends StatelessWidget {
  const CompanyBasicInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "COMPANY DETAILS", 
          style: AppTextStyles.goldSubtitle,
        ),
        const SizedBox(height: 20), 
        
        const CustomTextField(
          label: "Company Name", 
          icon: Icons.business_rounded,
        ),
        const SizedBox(height: 15),
        
        const CustomTextField(
          label: "Official Email", 
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 15),
        
        const CustomTextField(
          label: "Contact Number", 
          icon: Icons.phone_android,
        ),
        const SizedBox(height: 15),
        
        const CustomTextField(
          label: "Password", 
          icon: Icons.lock_outline, 
          isPassword: true,
        ),
        
        const SizedBox(height: 35),
        
        CustomGoldButton(
          text: "NEXT: PORTFOLIO",
          icon: Icons.arrow_forward_ios,
          onTap: () {
            // سيتم التحكم في المنطق عبر Cubit لاحقاً
          },
        ),
      ],
    );
  }
}