// import 'package:flutter/material.dart';
// import 'package:eventsapp/core/widgets/common/custom_gold_button.dart';
// import 'package:eventsapp/core/widgets/common/text_field_widget.dart';
// import 'package:eventsapp/screens/auth/reset_password_screen.dart'; 

// class EmailVerificationWaitScreen extends StatefulWidget {
//   final String email;
//   final bool isForgotPassword; // 🌟 تحديد المسار: لمعرفة هل المستخدم بحاجة لحقل الـ Token أم لا

//   const EmailVerificationWaitScreen({
//     super.key,
//     required this.email,
//     required this.isForgotPassword,
//   });

//   @override
//   State<EmailVerificationWaitScreen> createState() => _EmailVerificationWaitScreenState();
// }

// class _EmailVerificationWaitScreenState extends State<EmailVerificationWaitScreen> {
//   // 🌟 تعريف ملقط ومتحكم النص الخاص بحقل الـ Token المشفر
//   final TextEditingController _tokenController = TextEditingController();

//   @override
//   void dispose() {
//     _tokenController.dispose(); // تنظيف الذاكرة بشكل سليم عند إغلاق الشاشة
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.mark_email_read_outlined,
//                   size: 100,
//                   color: theme.colorScheme.primary,
//                 ),
//                 const SizedBox(height: 30),
//                 Text(
//                   "تحقق من بريدك الإلكتروني",
//                   style: TextStyle(
//                     color: theme.colorScheme.onSurface,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   "لقد أرسلنا رابط تفعيل آمن إلى الحساب:\n${widget.email}",
//                   style: TextStyle(
//                     color: theme.colorScheme.onSurfaceVariant,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 // 🌟--- التعديل الحاسم والذكي الخاص بمسار نسيان كلمة السر والمناقشة ---
//                 if (widget.isForgotPassword) ...[
//                   const SizedBox(height: 40),
//                   const Divider(thickness: 1),
//                   const SizedBox(height: 20),
                  
//                   Text(
//                     "يرجى نسخ رمز التحقق (Token) من الرابط المرسل لبريدك ولصقه هنا لفتح بوابة التعيين:",
//                     style: TextStyle(
//                       color: theme.colorScheme.primary, 
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // حقل إدخال الـ Token التابع لكِ (الذي يدعم الثيمين تلقائياً الآن)
//                   CustomTextField(
//                     controller: _tokenController,
//                     label: "رمز الـ Token المشفر",
//                     icon: Icons.key_outlined,
//                   ),
//                   const SizedBox(height: 25),
//                   CustomGoldButton(
//                     text: "تأكيد الرمز وتغيير كلمة المرور",
//                     icon: Icons.arrow_forward,
//                     onTap: () {
//                       final token = _tokenController.text.trim();
//                       if (token.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("الرجاء لصق الـ Token المرسل للإيميل أولاً"), 
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                         return;
//                       }
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ResetPasswordScreen(
//                             identity: widget.email, 
//                             code: token,           // رمز الـ Token يحل محل كود الـ OTP
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//                 // 🌟------------------ نهاية التعديل الشرطي ------------------

//                 const SizedBox(height: 40),
                
//                 // نص تذكيري سفلي عام للمستخدمين
//                 Text(
//                   "لم تصلك الرسالة؟ تفقد صندوق الرسائل غير المرغوب فيها (Spam) أو حاول مجدداً بعد قليل.",
//                   style: TextStyle(
//                     color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
//                     fontSize: 12,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }