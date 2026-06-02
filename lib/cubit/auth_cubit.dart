//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:eventsapp/cache/cache_helper.dart'; 
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/api/api_consumer.dart'; 
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiConsumer _api; 

  // الـ Constructor يستقبل الـ api الجاهزة من الـ main
  AuthCubit(this._api) : super(AuthInitial());

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
          final responseData = await _api.post(
            "/auth/google/mobile-login",
            data: {"id_token": result.idToken},
          );

          if (responseData != null) {
            await _saveUserSession(responseData);
            emit(AuthSuccess(successMessage: "success_google: تم تسجيل الدخول بجوجل بنجاح!"));
          }
        } catch (e) {
          emit(AuthFailure(errorMessage: "فشل الاتصال بسيرفر جوجل"));
        }
      } else {
        emit(AuthFailure(errorMessage: "تم إلغاء تسجيل الدخول"));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ: $e"));
    }
  }

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
      final responseData = await _api.post(
        "/auth/register", 
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "identity": identity.trim(),
          "password": password,
          "password_confirmation": confirmPassword, 
          "role": role,
        },
      );

      String serverMessage = responseData[ApiKey.message] ?? "تم إنشاء الحساب بنجاح!";
      emit(AuthSuccess(successMessage: serverMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> signInUser({
    required String identity, 
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final responseData = await _api.post(
        "/auth/login", 
        data: {
          "identity": identity, 
          "password": password,
        },
      );

      await _saveUserSession(responseData); 

      emit(AuthSuccess(successMessage: "تم تسجيل الدخول بنجاح!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: "فشل تسجيل الدخول، تأكد من البيانات والتحقق"));
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
      emit(AuthFailure(errorMessage: "حدث خطأ أثناء طلب إعادة تعيين كلمة المرور"));
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
        data: {"email": email, "otp": otp},
      );

      emit(AuthSuccess(successMessage: "تم التحقق من الرمز بنجاح!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: "رمز التحقق غير صحيح أو منتهي الصلاحية"));
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
      emit(AuthFailure(errorMessage: "فشل تغيير كلمة المرور، يرجى التأكد من الكود"));
    }
  }

  // 7️⃣ تفعيل الحساب عبر كود الإيميل
  Future<void> verifyAccountOtp({
    required String email, 
    required String code,
  }) async {
    emit(AuthLoading());
    try {
      final responseData = await _api.post(
        "/auth/verify-email-otp", 
        data: {
          "email": email, 
          "otp": code,    
        },
      );

      await _saveUserSession(responseData);

      emit(AuthSuccess(successMessage: "تم تفعيل الحساب بنجاح عبر الإيميل!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: "كود التحقق غير صحيح"));
    }
  }

  // 8️⃣ دالة تفعيل الحساب عبر كود الواتساب
  Future<void> verifyWhatsAppOtp({
    required String phone, 
    required String code,
  }) async {
    emit(AuthLoading());
    try {
      final responseData = await _api.post(
        "/auth/verify-otp", 
        data: {
          "phone": phone,
          "code": code,
        },
      );

      await _saveUserSession(responseData);

      emit(AuthSuccess(successMessage: "تم تفعيل الحساب بنجاح عبر واتساب!"));
    } catch (e) {
      emit(AuthFailure(errorMessage: "كود التحقق غير صحيح أو انتهت صلاحيته"));
    }
  }

  Future<void> _saveUserSession(dynamic responseData) async {
    if (responseData is Map) {
      final dataPart = responseData['data'] ?? responseData;
      final accessToken = dataPart['access_token'];

      if (accessToken != null) {
        // الحفظ داخل كلاس زميلكِ باستخدام المفتاح الموحد ليلقطه الـ Interceptor تلقائياً
        await CacheHelper().saveData(key: ApiKey.token, value: accessToken);
        await CacheHelper().saveData(key: "is_logged_in", value: true);
      }
    }
  }
}