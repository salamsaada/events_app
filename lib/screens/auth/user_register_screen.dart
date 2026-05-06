import 'package:dio/dio.dart';
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.whiteText,
            size: 20,
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
              const Text("CREATE\nACCOUNT", style: AppTextStyles.mainTitle),
              const SizedBox(height: 10),
              const Text(
                "Fill in your details to join the gala.",
                style: AppTextStyles.bodyGrey,
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: "First Name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: "Last Name",
                icon: Icons.family_restroom,
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
              CustomGoldButton(text: "CREATE ACCOUNT", onTap: () {}),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserLogInScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSocialSection(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "OR CONTINUE WITH",
                style: AppTextStyles.captionBold.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
                child: Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
            )),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(
              context,
              "assets/images/Screenshot 2026-05-06 014545.png",
              () async {
                try {
                  final appAuth = const FlutterAppAuth();

                  // 1. طلب تسجيل الدخول من جوجل
                  final AuthorizationTokenResponse? result =
                      await appAuth.authorizeAndExchangeCode(
                    AuthorizationTokenRequest(
                      '644185664828-ksjjqf3obmurcamrk1rolefonj17icrd.apps.googleusercontent.com',
                      'com.example.eventsapp:/oauth2redirect',
                      issuer: 'https://accounts.google.com',
                      scopes: ['openid', 'profile', 'email'],
                    ),
                  );

                  if (result != null && result.idToken != null) {
        
                    print("---------------------------------------");
                    print("ID TOKEN SUCCESS: ${result.idToken}");
                    print("---------------------------------------");

                    try {

                      String baseUrl = "https://api.eventsapp.com"; // الرابط الأساسي (يتغير مرة واحدة)
                      String endpoint = "/api/google-login";        // المسار الخاص بالعملية

                      final response = await Dio().post(
                        baseUrl + endpoint, 
                        data: {
                          "token": result.idToken,
                        },
                      );

                      if (response.statusCode == 200) {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      print("Server Error: $e");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Server Connection Error: $e")),
                        );
                      }
                    }
                  }
                } catch (e) {
                  print("Google Sign-In Error: $e");
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Google Sign-In Error: $e")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialIcon(BuildContext context, String path, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Image.asset(
          path,
          height: 40,
          width: 40,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
    );
  }
}