import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:eventsapp/screens/auth/user_log_in_screen.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  // 🌟 تعديل المُشيد ليستقبل الـ GlobalKey الخاص بالـ Navigator بدلاً من GoRouter
  DeepLinkService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  final Dio _dio = Dio(); 

  // الـ IP المحلي المشترك بينك وبين الباك إند
  final String _baseUrl = "http://192.168.1.104:8000/api"; 

  Future<void> init() async {
    // 1. التقاط الرابط إذا كان التطبيق مغلقاً تماماً وضغط المستخدم على الرابط في الإيميل
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      Future.microtask(() => _handleUri(initialUri));
    }

    // 2. الاستماع للروابط القادمة أثناء تشغيل التطبيق في الخلفية (Background)
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

 void _handleUri(Uri uri) async {
  // 🌟 تعديله ليقبل الـ http والـ https ليتطابق تماماً مع ملف المانيفست والباك إند
  if (uri.scheme != 'http' && uri.scheme != 'https' && uri.scheme != 'eventsapp') return;

    // الدخول إذا كان الرابط مخصصاً لتفعيل البريد الإلكتروني
    if (uri.host == 'verify-email' || uri.path.contains('verify-email')) {
      
      String? userId;
      String? hash;

      // الخطة أ: محاولة قراءة البيانات لو جاءت كـ Query Parameters (?id=...)
      userId = uri.queryParameters['id'];
      hash = uri.queryParameters['hash'];

      // الخطة ب: إذا لم يجدها، يقرأها كـ Path Segments (verify-email/id/hash)
      if (userId == null && uri.pathSegments.isNotEmpty) {
        if (uri.pathSegments[0] == 'verify-email' && uri.pathSegments.length > 1) {
          userId = uri.pathSegments[1];
          hash = uri.pathSegments.length > 2 ? uri.pathSegments[2] : '';
        } else {
          userId = uri.pathSegments[0];
          hash = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
        }
      }

      // إذا تم العثور على المعرف بنجاح، نقوم بإرسال طلب التفعيل فوراً
      if (userId != null) {
        await _sendVerificationRequest(userId, hash ?? '');
      }
    }
  }

  Future<void> _sendVerificationRequest(String id, String hash) async {
    try {
      // 📥 إرسال الريكويست المباشر عبر Dio.get لتحديث قاعدة البيانات والتخلص من الـ NULL
      final response = await _dio.get("$_baseUrl/verify-email/$id/$hash");

      if (response.statusCode == 200) {
        print("تفعيل الحساب نجح تلقائياً: ${response.data['message']}");

        // 🌟 التوجيه النظامي باستخدام الـ navigatorKey لفتح شاشة تسجيل الدخول مباشرة
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserLogInScreen(), // تأكدي أن اسم كلاس شاشة اللوجن عندك LoginScreen
          ),
        );
      }
    } on DioException catch (e) {
      print("خطأ أثناء إرسال طلب التفعيل: ${e.message}");
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}