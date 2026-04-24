import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart'; 
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:eventsapp/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/widgets/common/text_field_widget.dart';
import 'package:flutter/material.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new, 
            color: AppColors.whiteText, 
            size: 20
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "CREATE\nACCOUNT",
                style: AppTextStyles.mainTitle,
              ),
              const SizedBox(height: 10),
              const Text(
                "Fill in your details to join the gala.",
                style: AppTextStyles.bodyGrey, 
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: "Full Name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

              const CustomTextField(
                label: "Email or phone number",
                icon: Icons.stay_current_portrait,
              ),
              const SizedBox(height: 20),

              const CustomTextField(
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),

              const CustomTextField(
                label: "Confirm Password",
                icon: Icons.lock_reset_outlined,
                isPassword: true,
              ),
              
              const SizedBox(height: 40),

              CustomGoldButton(
                text: "CREATE ACCOUNT",
                onTap: () {
                  // هنا منطق الـ Cubit لاحقاً
                },
              ),
              
              const SizedBox(height: 20),
              
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserLogInScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: AppTextStyles.bodyGrey,
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: AppColors.primaryGold, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildSocialSection(), 

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.white10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "OR CONTINUE WITH", 
                style: AppTextStyles.captionBold.copyWith(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            const Expanded(child: Divider(color: Colors.white10)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon('assets/images/images.png', () {}),
            const SizedBox(width: 25),
            _socialIcon('assets/images/round-facebook-logo-isolated-white-background_469489-897.avif', () {}),
          ],
        ),
      ],
    );
  }

  Widget _socialIcon(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardBackground, 
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Image.asset(path, height: 25, width: 25),
      ),
    );
  }
}