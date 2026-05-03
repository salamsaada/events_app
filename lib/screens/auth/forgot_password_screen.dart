import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/core/widgets/common/custom_footer_links.dart';
import 'package:eventsapp/core/widgets/common/verify_identity_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final bool isStepTwo = false;

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "SECURE ACCESS",
                  style: AppTextStyles.goldSubtitle.copyWith(
                    letterSpacing: 3,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Royal Events",
                  style: TextStyle(
                    color: theme.colorScheme.primary, 
                    fontSize: 42,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 30),

                Container(
                  width: 380,
                  constraints: const BoxConstraints(minHeight: 400),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isStepTwo ? 0 : 0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: isStepTwo
                      ? const VerifyIdentityWidget()
                      : _buildRecoveryStep(context),
                ),

                const SizedBox(height: 40),
                Text(
                  "THE LEGACY OF EXCELLENCE",
                  style: AppTextStyles.captionBold.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryStep(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "SECURITY PROTOCOL", 
          style: AppTextStyles.goldSubtitle.copyWith(color: theme.colorScheme.primary),
        ),
        Text(
          "Password\nRecovery", 
          style: AppTextStyles.mainTitle.copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 15),
        Text(
          "Enter your registered credentials to receive a secure access token via our concierge network.",
          style: AppTextStyles.bodyGrey.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 35),

        Text(
          "EMAIL OR MOBILE NUMBER", 
          style: AppTextStyles.captionBold.copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 20),

        const CustomTextField(
          label: "Email or Phone number",
          icon: Icons.stay_current_portrait,
        ),

        const SizedBox(height: 30),

        CustomGoldButton(
          text: "REQUEST RESET CODE",
          icon: Icons.arrow_forward,
          onTap: () {
            // منطق طلب الكود
          },
        ),

        const SizedBox(height: 25),

        CustomFooterLinks(
          leftText: "< RETURN TO LOGIN",
          onLeftTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}