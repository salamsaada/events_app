import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/cubit/user_cubit.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class UserRegisterScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  UserRegisterScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserLogInScreen()),
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
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
                  Text(
                    l10n.authCreateAccountTitle,
                    style: AppTextStyles.mainTitle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authCreateAccountSubtitle,
                    style: AppTextStyles.bodyGrey,
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    controller: nameController,
                    onChanged: (value) {
                      context.read<UserCubit>().setFirstName(value);
                    },
                    label: l10n.authFullName,
                    icon: Icons.person_outline,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "l10n.authFullNameValidation";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: emailController,
                    onChanged: (value) {
                      context.read<UserCubit>().setEmailController(value);
                    },
                    label: l10n.authEmailOrPhoneNumber,
                    icon: Icons.stay_current_portrait,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "l10n.authEmailOrPhoneValidation";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: passwordController,
                    onChanged: (value) {
                      context.read<UserCubit>().setPasswordController(value);
                    },
                    label: l10n.authPassword,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "l10n.authPasswordValidation";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      context.read<UserCubit>().setConfirmPasswordController(
                        value,
                      );
                    },
                    label: l10n.authConfirmPassword,
                    icon: Icons.lock_reset_outlined,
                    isPassword: true,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "l10n.authConfirmPasswordValidation";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  CustomGoldButton(
                    text: l10n.authCreateAccountButton,
                    onTap: State is SignUpLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<UserCubit>().signUp();
                            }
                          },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserLogInScreen(),
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
