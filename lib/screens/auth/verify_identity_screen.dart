import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🚀 أضفنا استيراد البلوك
import 'package:eventsapp/cubit/auth_cubit.dart'; // 🚀 استيراد الكيوبت
import 'package:eventsapp/cubit/auth_state.dart'; // 🚀 استيراد الحالات
import 'package:eventsapp/cubit/notification_cubit.dart'; // 🚀 استيراد كيوبت الإشعارات
import 'package:eventsapp/core/widgets/common/verify_identity_widget.dart'; 

class VerifyIdentityScreen extends StatelessWidget {
  final String identity; 
  final bool isForgotPassword;

  const VerifyIdentityScreen({
    super.key,
    required this.identity,
    required this.isForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // 🚀 السحر هنا: وضعنا BlocListener لمراقبة نجاح العملية بالخلفية
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // إذا نجحت عملية التحقق (OTP) وحصلنا على توكن الدخول، ولم تكن العملية استعادة كلمة مرور
          if (state is AuthSuccess && !isForgotPassword) {
            try {
              // 🚀 رفع رمز الجهاز صامتاً في الخلفية للسيرفر
              context.read<NotificationCubit>().uploadDeviceToken();
              print("✅ تم استدعاء رفع توكن الإشعارات بنجاح بعد الـ OTP");
            } catch (e) {
              print("⚠️ فشل استدعاء رفع التوكن: $e");
            }
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: VerifyIdentityWidget(
                      identity: identity, 
                      isForgotPassword: isForgotPassword,
                    ),
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
}