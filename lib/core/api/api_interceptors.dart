import 'package:dio/dio.dart';
import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/end_ponits.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = CacheHelper().getData(key: ApiKey.token);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }
}
