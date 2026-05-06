import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/screens/auth/user_register_screen.dart';
import 'package:eventsapp/core/widgets/common/choice_card_widget.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
               Text(
                "Begin Your Journey",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 40),

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
                title: "Guest Explorer",
                description:
                    "Just looking around? Browse our exclusive events collection without creating an account.",
                imagePath: "assets/images/Screenshot 2026-04-21 162404.png",
                buttonText: "EXPLORE AS GUEST",
                isPreferred: false,
                destination: const HomePage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
