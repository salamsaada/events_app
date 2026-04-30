// الواجهة الثانية: إدخال كود OTP
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/custom_footer_links.dart';
import 'package:flutter/material.dart';

class VerifyIdentityWidget extends StatelessWidget {
  const VerifyIdentityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Verify Your Identity",
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 15),
        Text(
          "A unique 5-digit code has been sent to your registered concierge contact. Please enter it below to proceed.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 35),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => _buildOTPBox()),
        ),

        const SizedBox(height: 45),

        CustomGoldButton(
          text: "VERIFY ACCESS",
          icon: Icons.arrow_forward,
          onTap: () {
            // نداء للـ Cubit لاحقاً
          },
        ),

        const SizedBox(height: 25),

        CustomFooterLinks(
          leftText: "< BACK TO EMAIL",
          rightText: "RESEND CODE",
          onLeftTap: () => Navigator.pop(context),
          //onRightTap: () => _resendOTP(),
        ),
      ],
    );
  }

  Widget _buildOTPBox() {
    return Container(
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.buttonSubtle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: Text(
          "0",
          style: TextStyle(
            color: AppColors.greyText.withValues(alpha: 0.5),
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
