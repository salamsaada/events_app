import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/auth_state.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
import 'package:eventsapp/core/widgets/common/custom_footer_links.dart';
// 🌟 قمنا بحذف استيراد شاشة الـ Wait لأننا لم نعد بحاجتها هنا
import 'package:eventsapp/screens/auth/verify_identity_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identityController = TextEditingController();
  
  @override
  void dispose() {
    _identityController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
     body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            String identity = _identityController.text.trim();

            // 🌟 إظهار رسالة النجاح القادمة من السيرفر مباشرة لتكون ديناميكية ومناسبة للإيميل أو الهاتف
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage),
                backgroundColor: Colors.green,
              ),
            );

            // 🚀 الطيران الموحد والذكي: نقل المستخدم مباشرة إلى شاشة الـ OTP الرقمية
            // سواء أدخل إيميل أو هاتف، ليقوم بكتابة الـ 6 أرقام التي وصلته فوراً
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyIdentityScreen(
                  identity: identity,
                  isForgotPassword: true, // تفعيل مسار نسيان كلمة السر بالداخل
                ),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    l10n.authSecureAccess,
                    style: AppTextStyles.goldSubtitle.copyWith(
                      letterSpacing: 3,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appTitle,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 42,
                      fontFamily: 'Serif',
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    width: 380,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), 
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                   
                    child: _buildRecoveryStep(context, l10n),
                  ),

                  const SizedBox(height: 40),
                  Text(
                    l10n.legacyOfExcellence,
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
      ),
    );
  }

  Widget _buildRecoveryStep(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.authSecurityProtocol,
            style: AppTextStyles.goldSubtitle.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            l10n.authPasswordRecoveryTitle,
            style: AppTextStyles.mainTitle.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            l10n.authRecoveryDescription,
            style: AppTextStyles.bodyGrey.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 35),

          Text(
            l10n.authEmailOrMobileNumber,
            style: AppTextStyles.captionBold.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: _identityController,
            label: l10n.authEmailOrMobileNumber,
            icon: Icons.stay_current_portrait,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "الرجاء إدخال البريد الإلكتروني أو رقم الهاتف";
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return CustomGoldButton(
                text: l10n.authRequestResetCode,
                icon: Icons.arrow_forward,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().requestPasswordReset(
                          identity: _identityController.text.trim(), // تم إضافة .trim() لضمان تنظيف النص من الفراغات العشوائية
                        );
                  }
                },
              );
            },
          ),

          const SizedBox(height: 25),

          CustomFooterLinks(
            leftText: l10n.authReturnToLogin,
            onLeftTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}