//import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:eventsapp/models/user_model.dart'; 
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
  if (error is DioException) {
    if (error.response?.data != null) {
      final data = error.response!.data;

      if (data is Map) {
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        
        // 2. البحث عن 'errors' (أخطاء التحقق)
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            var firstKey = errors.keys.first;
            var firstError = errors[firstKey];
            return firstError is List ? firstError.first.toString() : firstError.toString();
          }
        }
      }
    }
    
    if (error.type == DioExceptionType.connectionError || 
        error.type == DioExceptionType.connectionTimeout) {
      return "عذراً، لا يوجد اتصال بالإنترنت.";
    }
  }
  
  return "حدث خطأ غير متوقع. يرجى التأكد من البيانات والمحاولة مجدداً.";
}

  Future<void> signInWithGoogleMobile() async {
    emit(AuthLoading());
    try {
      final appAuth = const FlutterAppAuth();

      final AuthorizationTokenResponse?
      result = await appAuth.authorizeAndExchangeCode(
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
            emit(
              AuthSuccess(
                successMessage: "success_google: تم تسجيل الدخول بجوجل بنجاح!",
              ),
            );
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
      String serverMessage =
          responseData[ApiKey.message] ?? "تم إنشاء الحساب بنجاح!";
      emit(AuthSuccess(successMessage: serverMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

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
        data: {"email": identity},
      );

      String serverMessage =
          responseData[ApiKey.message] ?? "تم إرسال طلب إعادة التعيين!";
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
      await _api.post("/verify-otp", data: {"email": email, "otp": otp});

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

      String serverMessage =
          responseData[ApiKey.message] ?? "تم تغيير كلمة المرور بنجاح!";
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
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("✔️ [OTP] FCM Token fetched: $fcmToken");
      } catch (e) {
        print("⚠️ [OTP] Failed to get FCM Token: $e");
      }

      final responseData = await _api.post(
        "/auth/verify-email-otp",
        data: {
          "email": email,
          "otp": code,
          if (fcmToken != null) "device_token": fcmToken, 
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
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("✔️ [WhatsApp OTP] FCM Token fetched: $fcmToken");
      } catch (e) {
        print("⚠️ [WhatsApp OTP] Failed to get FCM Token: $e");
      }

      final responseData = await _api.post(
        "/auth/verify-otp",
        data: {
          "identity": phone,
          "code": code,
          if (fcmToken != null) "device_token": fcmToken, 
        },
      );

      await _saveUserSession(responseData);

      emit(AuthSuccess(successMessage: "تم تفعيل الحساب بنجاح عبر واتساب!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: _handleInlineError(e)));
    }
  }

 // 9️⃣ دالة تسجيل الخروج
  Future<void> logOut() async {
    emit(AuthLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("Firebase token fetch failed: $e");
      }

      print("📢 الـ FCM Token الذي سنرسله للسيرفر للحذف هو: $fcmToken");

      await _api.post(
        "/auth/logout",
        data: {if (fcmToken != null) "device_token": fcmToken},
      );

      try {
        await FirebaseMessaging.instance.deleteToken();
        print("✔️ FCM Token completely deleted from device storage.");
      } catch (e) {
        print("⚠️ Failed to delete FCM token: $e");
      }

      await _cache.removeData(key: ApiKey.token); 
      await _cache.removeData(key: "is_logged_in"); 

      emit(AuthInitial());
    } catch (e) {
      try {
        await FirebaseMessaging.instance.deleteToken();
      } catch (_) {}
      await _cache.removeData(key: ApiKey.token);
      await _cache.removeData(key: "is_logged_in");
      emit(AuthInitial());
    }
  }


Future<void> getUserProfile() async {
    emit(ProfileLoading());
    try {
      final responseData = await _api.get("/user");
      print("DEBUG: Raw JSON: $responseData"); 

      final user = UserModel.fromJson(responseData);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      print(
        "DEBUG: Error in getUserProfile: $e",
      ); 
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  // 🔟 دالة حفظ بيانات الجلسة محلياً بالـ Cache الموحد لضمان الـ Auto-Login المستقبلي
  Future<void> _saveUserSession(dynamic responseData) async {
    print("DEBUG: ResponseData received: $responseData");

    if (responseData is Map) {
      final accessToken =
          responseData['access_token'] ?? 
          responseData['data']?['access_token'] ?? 
          responseData['token']; 

      if (accessToken != null) {
        await CacheHelper().saveData(key: ApiKey.token, value: accessToken);

        await _cache.saveData(key: ApiKey.token, value: accessToken);
        print("SUCCESS: Token saved successfully: $accessToken");
      } else {
        print("ERROR: Token not found in any of the expected locations!");
      }
    }
  }
}
