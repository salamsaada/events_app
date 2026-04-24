import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart'; 
import 'package:eventsapp/screens/auth/company_register_screen.dart';
import 'package:eventsapp/screens/auth/professional_register_screen.dart';
import 'package:eventsapp/screens/auth/user_register_screen.dart';
import 'package:eventsapp/widgets/choice_card_widget.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            children: [
              const Text(
                "CHOOSE YOUR DESTINATION",
                style: AppTextStyles.goldSubtitle,
              ),
              const SizedBox(height: 10),

              const Text(
                "Begin Your Journey",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteText,
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  fontFamily: 'Serif', 
                ),
              ),
              const SizedBox(height: 40),
 
              buildChoiceCard(
                context,
                title: "Company",
                description: "For event planners, venues, and luxury service providers.",
                imagePath: "assets/images/Screenshot 2026-04-21 162429.png",
                buttonText: "SELECT ACCOUNT",
                destination: const CompanyRegisterScreen(),
              ),
              
              buildChoiceCard(
                context,
                title: "User",
                description: "For guests seeking access to signature events.",
                imagePath: "assets/images/Screenshot 2026-04-21 162329.png",
                buttonText: "JOIN THE GALA",
                destination: const UserRegisterScreen(),
              ),
              
              buildChoiceCard(
                context,
                title: "Professional",
                description: "For specialists and designers looking to showcase expertise.",
                imagePath: "assets/images/Screenshot 2026-04-21 162404.png",
                buttonText: "SELECT ACCOUNT",
                destination: const ProfessionalRegisterScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}