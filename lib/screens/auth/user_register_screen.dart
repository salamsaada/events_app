import 'package:eventsapp/cubit/auth_cubit.dart';
import 'package:eventsapp/cubit/auth_state.dart';
import 'package:eventsapp/screens/auth/verify_email_verification_screen.dart';
import 'package:eventsapp/screens/auth/verify_identity_screen.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
import 'package:eventsapp/core/widgets/common/text_field_widget.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
 // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _identityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
     body:BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // 🌟 الفحص الذكي: هل نجاح التسجيل قادم من مسار جوجل؟
      bool isGoogleSignIn = state.successMessage.contains('success_google');

      if (isGoogleSignIn) {
        // 1. عرض رسالة نجاح نظيفة للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم تسجيل الدخول بواسطة جوجل بنجاح!"), 
            backgroundColor: Colors.green,
          ),
        );
        
        // 2. 🚀 الطيران الآمن والمباشر (استبدلي HomeScreen بكلاس صفحة الهوم الفعلي عندكِ)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // 🌟 التوجيه المباشر بالكلاس أضمن من الـ Named Routes
          (route) => false,
        );
        return; // 🔥 حاسمة جداً لمنع التطبيق من قراءة الأسطر التالية وعمل كراش!
      }

      // ------------------------------------------------------------------
      // 📝 المسار التقليدي القديم (عند تسجيل حساب جديد بالحقول اليدوية)
      // ------------------------------------------------------------------
      String identity = _identityController.text.trim();
      bool isEmail = identity.contains('@');

      if (isEmail) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationWaitScreen(
              email: identity,
              isForgotPassword: false,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyIdentityScreen(
              identity: identity,
              isForgotPassword: false,
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
  // ... باقي كود الـ child كما هو دون تغيير
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
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
              
                  CustomTextField(
                    label: "First Name",
                    icon: Icons.person_outline,
                    controller: _firstNameController, 
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your first name"; 
                      }
                      return null; 
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Last Name",
                    icon: Icons.family_restroom,
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your last name"; 
                      }
                      return null; // null تعني أن الحقل سليم
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Email or phone number",
                    icon: Icons.email,
                    controller: _identityController, 
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your email or phone number";
                      }
                      return null; 
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your password";
                      }
                      if (value.length < 8) {
                        return "password must be at least 8 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Confirm Password",
                    icon: Icons.lock_reset_outlined,
                    isPassword: true,
                    controller: _confirmPasswordController, 
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
 
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return CustomGoldButton(
                        text: "CREATE ACCOUNT",
                       onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signUpUser(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              identity: _identityController.text,
                             // phone: _phoneController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            );
                          }
                        },
                      );
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialIcon(BuildContext context, String path) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state is AuthLoading) return;
            context.read<AuthCubit>().signInWithGoogleMobile();
          },
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
            child: state is AuthLoading
                ? const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                : Image.asset(
                    path,
                    height: 40,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
          ),
        );
      },
    );
  }
}