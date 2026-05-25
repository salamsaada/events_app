import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // ⚠️ نصيحة سريعة: تأكدي دائماً من مطابقة هذا الـ IP مع الـ IP الحالي لجهاز الباك إند يوم المناقشة
  final String _baseUrl = "http://192.168.137.31:8000/api";

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
        final response = await Dio().post(
          "$_baseUrl/auth/google/mobile-login",
          data: {"id_token": result.idToken},
        );

        if (response.statusCode == 200) {
          // 🌟 تم التعديل هنا: نرسل تلميح "success_google" في بداية الرسالة لتفهمه الشاشات وتطير للهوم
          emit(AuthSuccess(successMessage: "success_google: تم تسجيل الدخول بجوجل بنجاح!"));
        }
      } on DioException catch (e) {
        _handleDioError(e, "فشل الاتصال بسيرفر جوجل");
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
    String role='organizer',
  }) async {
    emit(AuthLoading());
    try {
      final response = await Dio().post(
        "$_baseUrl/auth/register",
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "identity": identity,
          "password": password,
          "password_confirmation": confirmPassword,
          "role": role,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        String serverMessage = response.data['message'] ?? "تم إنشاء الحساب بنجاح!";
        emit(AuthSuccess(successMessage: serverMessage));
      } else {
        emit(AuthFailure(errorMessage: "فشل إنشاء الحساب، يرجى المحاولة لاحقاً"));
      }
    } on DioException catch (e) {
      _handleDioError(e, "خطأ في التسجيل");
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ غير متوقع: $e"));
    }
  }

  Future<void> signInUser({
    required String identity, 
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await Dio().post(
        "$_baseUrl/auth/login",
        data: {
          "identity": identity, 
          "password": password,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['access_token']; 
        // TODO: حفظ الـ accessToken محلياً لاحقاً عبر SharedPreferences
        emit(AuthSuccess(successMessage: "تم تسجيل الدخول بنجاح!"));
      }
    } on DioException catch (e) {
      _handleDioError(e, "فشل تسجيل الدخول، تأكد من البيانات والتحقق");
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ غير متوقع: $e"));
    }
  }

  // 🌟 دالة طلب الرابط أو الكود المعدلة لتناسب الهاتف والإيميل معاً
  Future<void> requestPasswordReset({required String identity}) async {
    emit(AuthLoading());
    try {
      final response = await Dio().post(
        "$_baseUrl/forgot-password", 
        data: {
          "email": identity, 
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      String serverMessage = response.data['message'] ?? "تم إرسال طلب إعادة التعيين!";
      emit(AuthSuccess(successMessage: serverMessage));
      
    } on DioException catch (e) {
      _handleDioError(e, "حدث خطأ أثناء طلب إعادة تعيين كلمة المرور");
    }
  }

  // 🌟 دالة تأكيد كود الـ OTP الرقمي للهاتف وتغيير كلمة المرور في نفس الوقت
  Future<void> resetPassword({
    required String identity, 
    required String code, 
    required String newPassword,
  }) async {
    emit(AuthLoading());
    try {
      final response = await Dio().post(
        "$_baseUrl/reset-password", 
        data: {
          "email": identity,
          "otp": code,
          "password": newPassword,
          "password_confirmation": newPassword,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      String serverMessage = response.data['message'] ?? "تم تغيير كلمة المرور بنجاح!";
      emit(AuthSuccess(successMessage: serverMessage));
    } on DioException catch (e) {
      _handleDioError(e, "فشل تغيير كلمة المرور، يرجى التأكد من الكود");
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ غير متوقع"));
    }
  }

  Future<void> verifyAccountOtp({required String email, required String code}) async {
    emit(AuthLoading());
    try {
      final response = await Dio().post(
        "$_baseUrl/auth/verify-email-otp", // 🌟 1. تم تعديل الرابط للمسار الجديد
        data: {
          "email": email, // 🌟 2. تم تعديل الحقل ليصبح email بدلاً من phone
          "otp": code,    // 🌟 3. تم تعديل الحقل ليصبح otp بدلاً من code
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      emit(AuthSuccess(successMessage: "تم تفعيل الحساب بنجاح!"));
    } on DioException catch (e) {
      _handleDioError(e, "كود التحقق غير صحيح");
    }
  }
  // دالة معالجة الأخطاء الذكية والموحدة للمشروع لقراءة ردود لارافل
  void _handleDioError(DioException e, String defaultMessage) {
    String serverMessage = defaultMessage;

    if (e.response != null) {
      try {
        final data = e.response?.data;
        if (data is Map) {
          serverMessage = data['message']?.toString() ?? data.toString();
        } else if (data is String) {
          serverMessage = data;
        } else {
          serverMessage = data?.toString() ?? defaultMessage;
        }
      } catch (_) {
        serverMessage = defaultMessage;
      }
      emit(AuthFailure(errorMessage: serverMessage));
    } else {
      emit(AuthFailure(errorMessage: "فشل الاتصال بالسيرفر، تأكد من تشغيل الباك إند والإنترنت بنفس الشبكة"));
    }
  }

  // 🌟 إعادة الدالة لفحص كود الهاتف وحده قبل الانتقال لشاشة التعيين
  // Future<void> verifyForgotPasswordOtp({
  //   required String identity, 
  //   required String code,
  // }) async {
  //   emit(AuthLoading());
  //   try {
  //     // إرسال طلب POST للسيرفر للتحقق من الكود في الكاش
  //     final response = await Dio().post(
  //       "$_baseUrl/reset-password", // تأكدي أن هذا الرابط مطابق تماماً للـ routes في لارافل
  //       data: {
  //       "identity": identity,
  //       "code": code,
  //       },
  //       options: Options(headers: {'Accept': 'application/json'}),
  //     );

  //     // إذا رد السيرفر بـ 200، نطلق حالة النجاح لتطير فلاتر إلى شاشتكِ الجديدة
  //     emit(AuthSuccess(successMessage: "الكود صحيح! يرجى تعيين كلمة المرور الجديدة."));
  //   } on DioException catch (e) {
  //     _handleDioError(e, "الكود غير صحيح أو منتهي الصلاحية");
  //   }
  // }

  Future<void> verifyForgotPasswordOtpOnly({
  required String email, 
  required String otp,
}) async {
  emit(AuthLoading());
  try {
    final response = await Dio().post(
      "$_baseUrl/verify-otp", // 🌟 تأكدي من كتابة الرابط تماماً كما سماه زميلك في الـ api.php
      data: {
        "email": email,
        "otp": otp, // الاسم المتوقع في السيرفر
      },
      options: Options(headers: {'Accept': 'application/json'}),
    );

    // إذا نجح الطلب (كود 200)، نرسل حالة النجاح لكي تفهمها الشاشة وتنتقل
    emit(AuthSuccess(successMessage: "تم التحقق من الرمز بنجاح!"));
  } on DioException catch (e) {
    _handleDioError(e, "رمز التحقق غير صحيح أو منتهي الصلاحية");
  }
}
}