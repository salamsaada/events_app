import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final String _baseUrl = "http://192.168.1.102:8000/api";

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
            emit(AuthSuccess(successMessage: "تم تسجيل الدخول بجوجل بنجاح!"));
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
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    try {
      final response = await Dio().post(
        "$_baseUrl/register",
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "password": password,
          "password_confirmation": confirmPassword,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AuthSuccess(successMessage: "تم إنشاء الحساب بنجاح!"));
      }
    } on DioException catch (e) {
      _handleDioError(e, "خطأ في التسجيل");
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ غير متوقع: $e"));
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final response = await Dio().post(
        "$_baseUrl/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        emit(AuthSuccess(successMessage: "تم تسجيل الدخول بنجاح!"));
      }
    } on DioException catch (e) {
      _handleDioError(e, "فشل الدخول");
    } catch (e) {
      emit(AuthFailure(errorMessage: "حدث خطأ غير متوقع: $e"));
    }
  }
void _handleDioError(DioException e, String defaultMessage) {
  String serverMessage = defaultMessage;

  if (e.response != null) {
    try {
      final data = e.response?.data;

      // 1. إذا كان الرد عبارة عن Map (وهو المتوقع من Laravel غالباً)
      if (data is Map) {
        serverMessage = data['message']?.toString() ?? data.toString();
      } 
      // 2. إذا كان الرد نصاً مباشراً
      else if (data is String) {
        serverMessage = data;
      } 
      // 3. أي حالة أخرى (مثل قائمة أخطاء)
      else {
        serverMessage = data?.toString() ?? defaultMessage;
      }
    } catch (_) {
      serverMessage = defaultMessage;
    }

    emit(AuthFailure(errorMessage: serverMessage));
  } else {
    // حالات انقطاع الشبكة أو السيرفر مطفأ
    emit(AuthFailure(errorMessage: "فشل الاتصال بالسيرفر، تأكد من تشغيل الباك إند والإنترنت"));
  }
}
}