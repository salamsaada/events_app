import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/widgets/common/custom_gold_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth/professional_identity_form.dart';
import '../../widgets/auth/professional_portfolio_form.dart';

class ProfessionalRegisterScreen extends StatelessWidget {
  final int currentStep;

  const ProfessionalRegisterScreen({
    super.key, 
    this.currentStep = 1, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.whiteText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "$currentStep / 2",
                style: AppTextStyles.goldSubtitle, 
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            _buildProgressBar(),

            const SizedBox(height: 30),
            
            currentStep == 1
                ? const ProfessionalIdentityForm()
                : const ProfessionalPortfolioForm(),

            const SizedBox(height: 40),

            CustomGoldButton(
              text: currentStep == 1 ? "NEXT: PORTFOLIO" : "COMPLETE REGISTRATION",
              onTap: () {
                // الربط مع الكيوبت سيتم هنا
              },
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      children: [
        Container(
          height: 2,
          width: double.infinity,
          color: Colors.white10,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 2,
        
          width: currentStep == 1 ? 150 : 400, 
          color: AppColors.primaryGold,
        ),
      ],
    );
  }
}