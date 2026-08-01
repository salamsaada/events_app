import 'package:dio/dio.dart';
import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:shared_preferences/shared_preferences.dart'; // أضف هذه المكتبة

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = CacheHelper().getData(key: ApiKey.token);

    // جلب اللغة من SharedPreferences باستخدام نفس المفتاح في الـ Cubit
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'ar';

    print("🔍 API REQUEST: ${options.path}");
    print("🔑 TOKEN FROM CACHE: $token");
    print("🌍 LANGUAGE SENT: $languageCode");

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';

    // إضافة Accept-Language للهيدر
    options.headers['Accept-Language'] = languageCode;

    super.onRequest(options, handler);
  }
}
