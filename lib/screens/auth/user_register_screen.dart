import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:flutter/material.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
              Text(l10n.authCreateAccountTitle, style: AppTextStyles.mainTitle),
              const SizedBox(height: 10),
              Text(
                l10n.authCreateAccountSubtitle,
                style: AppTextStyles.bodyGrey,
              ),
              const SizedBox(height: 40),

              CustomTextField(
                label: l10n.authFullName,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: l10n.authEmailOrPhoneNumber,
                icon: Icons.stay_current_portrait,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: l10n.authPassword,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: l10n.authConfirmPassword,
                icon: Icons.lock_reset_outlined,
                isPassword: true,
              ),
              const SizedBox(height: 40),

              CustomGoldButton(
                text: l10n.authCreateAccountButton,
                onTap: () {},
              ),

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
                      text: l10n.authAlreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: l10n.authSignInLink,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                l10n.authOrContinueWith,
                style: AppTextStyles.captionBold.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  // 2. إذا كنتِ تريدين التحكم بالشفافية بشكل ديناميكي:
                  // color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(context, 'assets/images/images.png', () {}),
            const SizedBox(width: 25),
            _socialIcon(
              context,
              'assets/images/round-facebook-logo-isolated-white-background_469489-897.avif',
              () {},
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface
              : theme.colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Image.asset(path, height: 25, width: 25),
      ),
    );
  }
}
