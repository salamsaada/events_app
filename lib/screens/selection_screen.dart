import 'dart:async'; // 🌟 لاستخدام StreamSubscription وإغلاق البث بأمان
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/auth/user_register_screen.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart'; 
import 'package:eventsapp/core/widgets/common/choice_card_widget.dart';
import 'package:eventsapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart'; 

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  // 🌟 تعريف كائن المكتبة ومستمع البث
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks(); // تهيئة المكتبة
    initDeepLinks(); // 🚀 تشغيل الرادار فور ولادة الشاشة ليرصد رابط الجيميل
  }

  // 🌟 دالة الاستماع والتقاط الروابط العميقة
  Future<void> initDeepLinks() async {
    try {
      // 1. معالجة الرابط إذا كان التطبيق مغلقاً تماماً وتم فتحه عبر رابط الجيميل (Cold Start)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && mounted) {
        _handleIncomingLink(initialUri.toString());
      }

      // 2. الاستماع للروابط الحية إذا كان التطبيق معلقاً في الخلفية (Background / Foreground)
      _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
        if (mounted) {
          _handleIncomingLink(uri.toString());
        }
      }, onError: (err) {
        // معالجة الخطأ إن وجد أثناء البث
      });
    } catch (e) {
      // معالجة الأخطاء غير المتوقعة
    }
  }

  // 🔍 فحص محتوى الرابط واتخاذ قرار التوجيه الفوري لشاشة الـ Login
  void _handleIncomingLink(String link) {
    if (link.contains('verify-email')) {
      
      // 🚀 الانتقال الحاسم لشاشة الـ UserLogInScreen وتصفير الذاكرة لمنع العودة للخلف
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const UserLogInScreen()),
        (route) => false,
      );

      // إظهار السناكبر الأخضر الفخم لتأكيد نجاح التفعيل التلقائي للمستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "تم تفعيل حسابك بنجاح! يرجى تسجيل الدخول الآن ببريدك الإلكتروني ✨",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    // 🌟 تنظيف الذاكرة وإغلاق الرادار لحماية بطارية الهاتف وأدائه من الـ Memory Leak
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            children: [
              Text(
                l10n.selectionChooseDestination,
                style: AppTextStyles.goldSubtitle,
              ),
              const SizedBox(height: 10),

              Text(
                l10n.selectionBeginJourney,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 40),

              buildChoiceCard(
                context,
                title: l10n.selectionUserTitle,
                description: l10n.selectionUserDescription,
                imagePath: "assets/images/Screenshot 2026-04-21 162329.png",
                buttonText: l10n.selectionJoinTheGala,
                destination: const UserRegisterScreen(), 
              ),

              buildChoiceCard(
                context,
                title: l10n.selectionGuestExplorerTitle,
                description: l10n.selectionGuestExplorerDescription,
                imagePath: "assets/images/Screenshot 2026-04-21 162404.png",
                buttonText: l10n.selectionExploreAsGuest,
                isPreferred: false,
                destination: const HomePage(), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}