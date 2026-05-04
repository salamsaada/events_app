import 'package:dartz/dartz.dart';
import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/errors/exceptions.dart';

import 'package:eventsapp/models/sign_up_model.dart';

class UserRepository {
  final ApiConsumer api;

  UserRepository({required this.api});

  Future<Either<String, AuthResponseModel>> signUp({
    required String name1,
    required String name2,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signUp,
        data: {
          ApiKey.name1: name1,
          ApiKey.name2: name2,
          ApiKey.email: email,
          ApiKey.password: password,
          ApiKey.confirmPassword: confirmPassword,
          // ApiKey.phone: phone,
          // ApiKey.profilePic: await uploadImageToAPI(profilePic),
        },
      );

      final authModel = AuthResponseModel.fromJson(response);

      // حفظ التوكن في التخزين المحلي
      await CacheHelper().saveData(
        key: ApiKey.token,
        value: authModel.accessToken,
      );

      return Right(authModel);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  // 2. فانكشن تسجيل الدخول (Sign In)
  Future<Either<String, AuthResponseModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signIn,
        data: {ApiKey.email: email, ApiKey.password: password},
      );

      final authModel = AuthResponseModel.fromJson(response);

      // حفظ التوكن
      await CacheHelper().saveData(
        key: ApiKey.token,
        value: authModel.accessToken,
      );

      return Right(authModel);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}
