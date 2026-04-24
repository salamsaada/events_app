import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart'; 
import 'package:eventsapp/widgets/custom_footer_links.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth/company_basic_info_form.dart';
import '../../widgets/auth/company_portfolio_form.dart';

class CompanyRegisterScreen extends StatelessWidget {
  final int currentStep; 

  const CompanyRegisterScreen({super.key, this.currentStep = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              _buildTopHeader(),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground.withOpacity(0.9), 
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),

                child: currentStep == 1 
                    ? const CompanyBasicInfoForm() 
                    : const CompanyPortfolioForm(),
              ),

              const SizedBox(height: 30),

              CustomFooterLinks(
                leftText: "< RETURN TO LOGIN",
                rightText: "CONTACT CONCIERGE",
                onLeftTap: () => Navigator.pop(context),
                // onRightTap: () => _contactSupport(),
              ),
              
              const SizedBox(height: 20),

              Text(
                "STEP $currentStep OF 2",
                style: AppTextStyles.goldSubtitle.copyWith(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Column(
      children: [
        const Text(
          "ROYAL PARTNERSHIP", 
          style: AppTextStyles.goldSubtitle, 
        ),
        const SizedBox(height: 10),
        const Text(
          "Corporate Registry", 
          style: AppTextStyles.mainTitle, 
        ),
        const SizedBox(height: 5),
        Container(
          height: 1,
          width: 40,
          color: AppColors.primaryGold.withOpacity(0.5),
        ),
      ],
    );
  }
}