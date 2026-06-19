import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/custom_footer_links.dart';
import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/auth_state.dart';
import 'package:eventsapp/screens/auth/reset_password_screen.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:pinput/pinput.dart';

class VerifyIdentityWidget extends StatefulWidget {
  final String identity;
  final bool isForgotPassword;

  const VerifyIdentityWidget({
    super.key,
    required this.identity,
    this.isForgotPassword = false,
  });

  @override
  State<VerifyIdentityWidget> createState() => _VerifyIdentityWidgetState();
}

class _VerifyIdentityWidgetState extends State<VerifyIdentityWidget> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 58,
      textStyle: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage),
              backgroundColor: Colors.green,
            ),
          );
          if (!widget.isForgotPassword) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                  identity: widget.identity, // 🌟
                  code: _otpController.text.trim(),
                ),
              ),
            );
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.verifyYourIdentity,
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 15),

          Text(
            widget.identity.contains('@')
                ? AppLocalizations.of(context)!.codeSentEmail(widget.identity)
                : AppLocalizations.of(
                    context,
                  )!.codeSentWhatsApp(widget.identity),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 35),

          Pinput(
            length: 6,
            controller: _otpController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyDecorationWith(
              border: Border.all(color: AppColors.primaryGold, width: 2),
              color: theme.colorScheme.surface,
            ),
          ),

          const SizedBox(height: 45),

          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGold,
                  ),
                );
              }

              return CustomGoldButton(
                text: AppLocalizations.of(context)!.verifyAccess,
                icon: Icons.arrow_forward,
                onTap: () {
                  final code = _otpController.text.trim();
                  if (code.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.pleaseEnterFullCode,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (widget.isForgotPassword) {
                    context.read<AuthCubit>().verifyForgotPasswordOtpOnly(
                      email: widget.identity,
                      otp: code,
                    );
                  } else {
                    if (widget.identity.contains('@')) {
                      context.read<AuthCubit>().verifyAccountOtp(
                        email: widget.identity,
                        code: code,
                      );
                    } else {
                      context.read<AuthCubit>().verifyWhatsAppOtp(
                        phone: widget.identity,
                        code: code,
                      );
                    }
                  }
                },
              );
            },
          ),

          const SizedBox(height: 25),

          CustomFooterLinks(
            leftText: widget.identity.contains('@')
                ? AppLocalizations.of(context)!.backToEmail
                : AppLocalizations.of(context)!.backToPhone,
            rightText: AppLocalizations.of(context)!.resendCode,
            onLeftTap: () => Navigator.pop(context),
            // onRightTap: () => context.read<AuthCubit>().resendOtp(widget.identity),
          ),
        ],
      ),
    );
  }
}
