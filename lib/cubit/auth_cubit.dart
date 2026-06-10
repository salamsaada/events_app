//import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:eventsapp/cache/cache_helper.dart'; 
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/api/api_consumer.dart'; 
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiConsumer _api; 
  final CacheHelper _cache;

  AuthCubit(this._api, this._cache) : super(AuthInitial());

  String _handleInlineError(dynamic error) {
    String message = "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.";
    
    if (error is DioException) {
      // 1. فحص إذا كان هناك رد حقيقي قادم من لارافل بداخل الـ Data وبصيغة Map
      if (error.response != null && error.response!.data != null && error.response!.data is Map) {
        final Map<String, dynamic> responseData = error.response!.data;

        if (responseData['message'] != null) {
          return responseData['message'].toString();
        } 
        // 3. إذا أرسل لارافل حقل 'errors' الخاص بالفاليديشن (مثل: الباسورد قصير)
        else if (responseData['errors'] != null && responseData['errors'] is Map) {
          Map<String, dynamic> errors = responseData['errors'];
          if (errors.isNotEmpty) {
            var firstErrorList = errors.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              return firstErrorList.first.toString();
            } else {
              return firstErrorList.toString();
            }
          }
        }
      } 
      // 4. في حال انقطع الإنترنت تماماً ولم يصل أي رد من السيرفر
      else if (error.type != DioExceptionType.badResponse) {
        return "تعذر الاتصال بالسيرفر، يرجى التحقق من شبكة الإنترنت.";
      }
    }
    
    return message;
  }

 // تسجيل الدخول عبر جوجل للموبايل (معدلة لإرسال توكن الإشعارات)
  Future<void> signInWithGoogleMobile() async {
    emit(AuthLoading());
    try {
      final appAuth = const FlutterAppAuth();

      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          '45320069047-hsglkfoe70gvltgroni6e5ggert8v72m.apps.googleusercontent.com',
          'com.example.eventsapp:/oauth2redirect',
          issuer: 'https://accounts.google.com',
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      if (result != null && result.idToken != null) {
        try {
          String? fcmToken;
          try {
            fcmToken = await FirebaseMessaging.instance.getToken();
            print("FCM Token Fetched For Google Login: $fcmToken");
          } catch (e) {
            print("Error fetching FCM token during Google login: $e");
          }

          final responseData = await _api.post(
            "/auth/google/mobile-login",
            data: {
              "id_token": result.idToken,
              if (fcmToken != null) "device_token": fcmToken, 
            },
          );

          if (responseData != null) {
            await _saveUserSession(responseData);
            emit(AuthSuccess(successMessage: "success_google: تم تسجيل الدخول بجوجل بنجاح!"));
          }
        } catch (e) {
          emit(AuthFailure(errorMessage: _handleInlineError(e)));
        }
      } else {
        emit(AuthFailure(errorMessage: "تم إلغاء تسجيل الدخول"));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ أثناء الاتصال بجوجل"));
    }
  }

 // 2️⃣ إنشاء حساب مستخدم جديد (معدلة لإرسال توكن الإشعارات)
  Future<void> signUpUser({
    required String firstName,
    required String lastName,
    required String identity,
    required String password,
    required String confirmPassword,
    String role = 'organizer',
  }) async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("FCM Token Fetched Successfully: $fcmToken");
      } catch (e) {
        // حماية التطبيق من الانهيار لو كانت خدمات جوجل غير مدعومة في المحاكي
        print("Error fetching FCM token during registration: $e");
      }

      final responseData = await _api.post(
        "/auth/register", 
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "identity": identity.trim(),
          "password": password,
          "password_confirmation": confirmPassword, 
          "role": role,
          if (fcmToken != null) "device_token": fcmToken, 
        },
      );

      String serverMessage = responseData[ApiKey.message] ?? "تم إنشاء الحساب بنجاح!";
      emit(AuthSuccess(successMessage: serverMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 3️⃣ تسجيل دخول المستخدم التقليدي (معدلة لإرسال توكن الإشعارات)
  Future<void> signInUser({
    required String identity, 
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("Error fetching FCM token during login: $e");
      }

      final responseData = await _api.post(
        "/auth/login", 
        data: {
          "identity": identity, 
          "password": password,
          if (fcmToken != null) "device_token": fcmToken,
        },
      );

      await _saveUserSession(responseData); 

      emit(AuthSuccess(successMessage: "تم تسجيل الدخول بنجاح!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 4️⃣ طلب نسيان كلمة المرور
  Future<void> requestPasswordReset({required String identity}) async {
    emit(AuthLoading());
    try {
      final responseData = await _api.post(
        "/forgot-password", 
        data: {
          "email": identity, 
        },
      );

      String serverMessage = responseData[ApiKey.message] ?? "تم إرسال طلب إعادة التعيين!";
      emit(AuthSuccess(successMessage: serverMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 5️⃣ التحقق من الـ OTP لنسيان كلمة المرور
  Future<void> verifyForgotPasswordOtpOnly({
    required String email,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      await _api.post(
        "/verify-otp",
        data: {
          "email": email, 
          "otp": otp
        },
      );

      emit(AuthSuccess(successMessage: "تم التحقق من الرمز بنجاح!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 6️⃣ تعيين كلمة المرور الجديدة
  Future<void> resetPassword({
    required String identity, 
    required String code, 
    required String newPassword,
  }) async {
    emit(AuthLoading());
    try {
      final responseData = await _api.post(
        "/reset-password", 
        data: {
          "email": identity,
          "otp": code,
          "password": newPassword,
          "password_confirmation": newPassword,
        },
      );

      String serverMessage = responseData[ApiKey.message] ?? "تم تغيير كلمة المرور بنجاح!";
      emit(AuthSuccess(successMessage: serverMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 7️⃣ تفعيل الحساب عبر كود الإيميل
  Future<void> verifyAccountOtp({
    required String email, 
    required String code,
  }) async {
    emit(AuthLoading());
    try {
      // 🌟 1. جلب توكن الجهاز من الفايربيز بشكل آمن محصن بـ try-catch
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("✔️ [OTP] FCM Token fetched: $fcmToken");
      } catch (e) {
        print("⚠️ [OTP] Failed to get FCM Token: $e");
      }

      // 🌟 2. إرسال طلب التحقق مع حقل الـ device_token الجديد للسيرفر
      final responseData = await _api.post(
        "/auth/verify-email-otp", 
        data: {
          "email": email, 
          "otp": code,
          if (fcmToken != null) "device_token": fcmToken, // 👈 قمنا بتغييرها هنا لـ device_token لتطابق الباكيند
        },
      );

      await _saveUserSession(responseData);

      emit(AuthSuccess(successMessage: "تم تفعيل الحساب بنجاح عبر الإيميل!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 8️⃣ تفعيل الحساب عبر كود الواتساب
  Future<void> verifyWhatsAppOtp({
    required String phone, 
    required String code,
  }) async {
    emit(AuthLoading());
    try {
      // 🌟 1. جلب توكن الجهاز من الفايربيز بشكل آمن محصن بـ try-catch
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("✔️ [WhatsApp OTP] FCM Token fetched: $fcmToken");
      } catch (e) {
        print("⚠️ [WhatsApp OTP] Failed to get FCM Token: $e");
      }

      // 🌟 2. إرسال طلب التحقق مع حقل الـ device_token الجديد للسيرفر
      final responseData = await _api.post(
        "/auth/verify-otp", 
        data: {
          "identity": phone,
          "code": code,
          if (fcmToken != null) "device_token": fcmToken, // 👈 قمنا بتمريره هنا باسم device_token ليطابق السيرفر
        },
      );

      await _saveUserSession(responseData);

      emit(AuthSuccess(successMessage: "تم تفعيل الحساب بنجاح عبر واتساب!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

  // 9️⃣ دالة تسجيل الخروج المتكاملة مع الفايربيز ولارافل
  Future<void> logOut() async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("Firebase token fetch failed: $e");
      }

      await _api.post(
        "/auth/logout", 
        data: {
          if (fcmToken != null) "device_token": fcmToken,
        },
      );

      // مسح الـ Access Token محلياً من الهاتف
      await _cache.removeData(key: ApiKey.token); 

      emit(AuthInitial());
    } catch (e) {
      // حزام أمان محلي: لو تعطلت الشبكة، يتم إجبار مسح الكاش لضمان طرد المستخدم بأمان
      await _cache.removeData(key: ApiKey.token);
      emit(AuthInitial());
    }
  }

  // 🔟 دالة حفظ بيانات الجلسة محلياً بالـ Cache الموحد لضمان الـ Auto-Login المستقبلي
  Future<void> _saveUserSession(dynamic responseData) async {
    if (responseData is Map) {
      final dataPart = responseData['data'] ?? responseData;
      final accessToken = dataPart['access_token'];

      if (accessToken != null) {
        await _cache.saveData(key: ApiKey.token, value: accessToken);
        await _cache.saveData(key: "is_logged_in", value: true);
      }
    }
  }
}