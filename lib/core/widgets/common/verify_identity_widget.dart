import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/custom_footer_links.dart';
import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/auth_state.dart'; 
import 'package:eventsapp/screens/auth/reset_password_screen.dart'; // 🌟 استيراد شاشتك المخصصة لتعيين الكلمة الجديدة
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class VerifyIdentityWidget extends StatefulWidget {
  final String email; 
  final bool isForgotPassword; 

  const VerifyIdentityWidget({
    super.key,
    required this.email,
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

    // 🎨 🌟 تعديل الثيم الخاص بحقول الـ Pinput ليدعم الوضع الفاتح والغامق تلقائياً
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 58,
      textStyle: TextStyle(
        // جعل لون الرقم داخل المربع أسود في الفاتح وأبيض في الغامق تلقائياً
        color: theme.colorScheme.onSurface, 
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        // جعل لون خلفية المربعات يقرأ من ألوان النظام المحايدة
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        // حدود خفيفة متناسقة تظهر بوضوح في كلا الوضعين
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage), backgroundColor: Colors.green),
          );

          if (!widget.isForgotPassword) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else {
            // 🚀 🌟 الحل الحاسم لخطأ الـ Route: الطيران المباشر والديناميكي وتمرير البيانات لشاشتكِ الفخمة
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                  identity: widget.email,         // تمرير البريد أو الهاتف كـ identity
                  code: _otpController.text.trim(), // تمرير كود الـ OTP المكون من 6 أرقام
                ),
              ),
            );
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Verify Your Identity",
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 15),
          Text(
            "A unique 6-digit code has been sent to ${widget.email}. Please enter it below to proceed.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 35),

          Pinput(
            length: 6, 
            controller: _otpController,
            defaultPinTheme: defaultPinTheme,
            // ثيم المربع النشط عند الكتابة بحدود ذهبية فخمة تظهر في الوضعين
            focusedPinTheme: defaultPinTheme.copyDecorationWith(
              border: Border.all(color: AppColors.primaryGold, width: 2), 
              color: theme.colorScheme.surface,
            ),
          ),

          const SizedBox(height: 45),

          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
              }
              
              return CustomGoldButton(
                text: "VERIFY ACCESS",
                icon: Icons.arrow_forward,
                onTap: () {
                  final code = _otpController.text.trim();
                  if (code.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("الرجاء إدخال الكود كاملاً"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (widget.isForgotPassword) {
                    // 🚀 🌟 التعديل الجديد: استدعاء دالة الفحص عبر السيرفر فوراً
                    context.read<AuthCubit>().verifyForgotPasswordOtpOnly(
                      email: widget.email,
                      otp: code,
                    );
                  } else {
                    // مسار تفعيل الحساب العادي عند إنشاء الحساب (اتركيه كما هو)
                    context.read<AuthCubit>().verifyAccountOtp(
                      phone: widget.email,
                      code: code,
                    );
                  }
                },
              );
            },
          ),

          const SizedBox(height: 25),

          CustomFooterLinks(
            leftText: "< BACK TO EMAIL",
            rightText: "RESEND CODE",
            onLeftTap: () => Navigator.pop(context),
            // onRightTap: () => context.read<AuthCubit>().resendOtp(widget.email),
          ),
        ],
      ),
    );
  }
}