import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String identity;
  final String code;

  const ResetPasswordScreen({
    super.key,
    required this.identity,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // 🌟 التعديل: جعل الخلفية تقرأ من ثيم النظام لتدعم الغامق والفاتح تلقائياً
      backgroundColor: theme.colorScheme.background, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم تغيير كلمة المرور بنجاح!"), backgroundColor: Colors.green),
            );
            
            // 🚀 الطيران المباشر والآمن لشاشة الـ Login لتفادي مشكلة توقف التطبيق المفاجئ
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const UserLogInScreen()), // ⚠️ تأكدي من كتابة اسم شاشة الـ Login لديكِ هنا
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Center( // تبريز المحتوى في وسط الشاشة جمالياً
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // قفل جمالي يعبر عن حماية الحساب وتغيير الكلمة
                    const Icon(
                      Icons.lock_reset_outlined,
                      size: 80,
                      color: AppColors.primaryGold,
                    ),
                    const SizedBox(height: 25),
                    
                    // العنوان الرئيسي المحدث بلون متناسق مع الثيم
                    Text(
                      "Create New Password",
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    
                    // النص الفرعي بلون رمادي ناعم ومقروء في كل الأوضاع
                    Text(
                      "Your new password must be different from previous used passwords.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // حقل كلمة السر الجديدة
                    CustomTextField(
                      label: "New Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.length < 8) return "Password must be at least 8 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // تأكيد كلمة السر
                    CustomTextField(
                      label: "Confirm Password",
                      icon: Icons.lock_reset,
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value != _passwordController.text) return "Passwords do not match";
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 35),

                    // زر الحفظ الذهبي مع حالة التحميل
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
                        }
                        return CustomGoldButton(
                          text: "RESET PASSWORD",
                          icon: Icons.check_circle_outline,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().resetPassword(
                                identity: widget.identity,
                                code: widget.code,
                                newPassword: _passwordController.text.trim(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}