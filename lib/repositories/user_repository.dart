import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/errors/exceptions.dart';
import 'package:eventsapp/models/booking_model.dart';
import 'package:eventsapp/models/cancelModele.dart';
import 'package:eventsapp/models/getModelsReviews.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/models/myBookings_model.dart';
import 'package:eventsapp/models/planner_model.dart';
import 'package:eventsapp/models/sendReviwe.dart';
import 'package:eventsapp/models/sign_up_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // 🚀 1. إضافة هذه المكتبة من أجل دالة compute

// 🚀 2. إضافة هذه الدالة خارج الكلاس لتعمل في مسار خلفي (Background Isolate)
ListingResponse _parseListingResponseInBackground(Map<String, dynamic> data) {
  return ListingResponse.fromJson(data);
}

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
        },
      );

      final authModel = AuthResponseModel.fromJson(response);

      await CacheHelper().saveData(
        key: ApiKey.token,
        value: authModel.accessToken,
      );

      return Right(authModel);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

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

      await CacheHelper().saveData(
        key: ApiKey.token,
        value: authModel.accessToken,
      );

      return Right(authModel);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, ListingResponse>> getlisting({
    String? type,
    String? categoryId,
    String? title,
    String? minPrice,
    String? maxPrice,
    String? capacityMin,
    String? capacityMax,
    String? rating,
    String? date,
    String? location,
  }) async {
    try {
      final response = await api.get(
        EndPoint.getlisting,
        queryParameters: {
          if (type != null) 'type': type,
          if (categoryId != null) 'category_id': categoryId,
          if (title != null && title.isNotEmpty) 'title': title,
          if (minPrice != null && minPrice.isNotEmpty) 'price_min': minPrice,
          if (maxPrice != null && maxPrice.isNotEmpty) 'price_max': maxPrice,
          if (capacityMin != null && capacityMin.isNotEmpty)
            'capacity_min': capacityMin,
          if (capacityMax != null && capacityMax.isNotEmpty)
            'capacity_max': capacityMax,
          if (rating != null && rating.isNotEmpty) 'rating': rating,
          if (date != null && date.isNotEmpty) 'date': date,
          if (location != null && location.isNotEmpty) 'location': location,
        },
      );

      if (response == null ||
          (response is List && response.isEmpty) ||
          (response is Map && response.isEmpty)) {
        return const Left("لا توجد بيانات حالياً");
      }

      // 🚀 3. تحويل الاستجابة بأمان إلى Map
      final responseMap = response is Map
          ? Map<String, dynamic>.from(response)
          : <String, dynamic>{};

      // 🚀 4. السحر هنا: استخدام compute لفك تشفير البيانات الضخمة بدون تجميد الـ UI
      final serviceResponse = await compute(
        _parseListingResponseInBackground,
        responseMap,
      );

      return Right(serviceResponse);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left("حدث خطأ غير متوقع: $e");
    }
  }

  Future<Either<String, BookingResponse>> createBooking({
    String? providerId,
    required String listingId,
    String? listingVariantId,
    String? listingSlotId,
    required String bookingType,
    required int quantity,
    String? bookedDate,
    String? bookedStartTime,
    String? customerNotes,
  }) async {
    try {
      final response = await api.post(
        EndPoint.createBooking,
        data: {
          ApiKey.provider_id: providerId,
          ApiKey.listing_id: listingId,
          ApiKey.listing_variant_id: listingVariantId,
          ApiKey.listing_slot_id: listingSlotId,
          ApiKey.booking_type: bookingType,
          ApiKey.quantity: quantity,
          ApiKey.booked_date: bookedDate,
          ApiKey.booked_start_time: bookedStartTime,
          ApiKey.customer_notes: customerNotes,
        },
      );

      final bookingResponse = BookingResponse.fromJson(response);

      await CacheHelper().saveData(
        key: ApiKey.lastBookingId,
        value: bookingResponse.data?.id,
      );

      return Right(bookingResponse);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, BookingResponsee>> getMyBookings() async {
    try {
      final response = await api.get(EndPoint.Mybookings);

      if (response == null ||
          (response is List && response.isEmpty) ||
          (response is Map && response.isEmpty)) {
        return const Left("لا يوجد حجوزات حالياً");
      }

      final bookingResponse = BookingResponsee.fromJson(response);

      if (bookingResponse.data.isEmpty) {
        return const Left("لا يوجد حجوزات حالياً");
      }

      return Right(bookingResponse);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left("حدث خطأ غير متوقع: $e");
    }
  }

  Future<Either<String, List<dynamic>>> getAllProviders({String? name}) async {
    try {
      final response = await api.get(
        'providers',
        queryParameters: {if (name != null && name.isNotEmpty) 'name': name},
      );

      if (response == null) {
        return const Left("لا توجد بيانات حالياً");
      }

      List<dynamic> providersData = [];

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        providersData = response['data'];
      } else if (response is List) {
        providersData = response;
      }

      if (providersData.isEmpty) {
        return const Left("لا يوجد مزودين خدمة حالياً");
      }

      return Right(providersData);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left("حدث خطأ غير متوقع: $e");
    }
  }

  Future<Either<String, PlannerModel>> getProviderDetails(String id) async {
    try {
      final response = await api.get('providers/$id');

      if (response == null) {
        return const Left("لا توجد بيانات حالياً");
      }

      final detailsData =
          (response is Map<String, dynamic> && response.containsKey('data'))
          ? response['data']
          : response;

      final planner = PlannerModel.fromJson(detailsData);

      return Right(planner);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left("حدث خطأ غير متوقع: $e");
    }
  }

  Future<Either<String, String>> uploadPaymentProof({
    required String bookingId,
    required String filePath,
    required String amount,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'booking_id': bookingId,
        'amount': amount,
        'proof_file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await api.post('payments/upload-proof', data: formData);

      return Right(response['message'] ?? 'تم استلام الملف بنجاح.');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final serverMessage =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response!.data['message'].toString()
          : 'حدث خطأ غير متوقع، حاول مرة أخرى.';

      return Left('$statusCode|$serverMessage');
    } catch (e) {
      return Left('0|${e.toString()}');
    }
  }

  Future<Either<String, ServiceItem>> getListingDetails(String id) async {
    try {
      final response = await api.get('listings/$id');

      if (response == null) {
        return const Left("لا توجد بيانات لهذا العرض");
      }

      final data = (response is Map && response.containsKey('data'))
          ? response['data']
          : response;

      final listing = ServiceItem.fromJson(Map<String, dynamic>.from(data));
      return Right(listing);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left("حدث خطأ غير متوقع: $e");
    }
  }

  Future<Either<String, SendReviewModel>> submitReview({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await api.post(
        EndPoint.sendReview,
        data: {
          'booking_id': bookingId,
          'rating': rating.toString(),
          'comment': comment ?? 'بدون تعليق',
        },
      );

      // ✅ حالة النجاح
      if (response['success'] == true) {
        return Right(SendReviewModel.fromJson(response));
      }
      // ✅ حالة الفشل (مثل: لقد قمت بتقييم هذا الحجز مسبقاً)
      else {
        final String errorMsg = response['message'] ?? 'حدث خطأ غير معروف';
        return Left(errorMsg); // ← هنا يتم إرسال رسالة السيرفر للحubit
      }
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left('حدث خطأ غير متوقع');
    }
  }

  // في الـ Repository
  Future<Either<String, String>> cancelBooking(String bookingId) async {
    try {
      final response = await api.put(
        // ✅ ملاحظة: اللوج السابق قال Supported methods: PUT
        '${EndPoint.cancelBooking}/$bookingId/cancel',
      );

      final cancelResponse = CancelBookingResponsee.fromJson(response);
      return Right(cancelResponse.message ?? 'تم إلغاء الحجز بنجاح');
    } catch (e) {
      return Left('فشل إلغاء الحجز');
    }
  }

  Future<Either<String, ReviewsResponsee>> getProviderReviews({
    required String providerId,
    int page = 1, // ✨ دعم الصفحات (Pagination)
  }) async {
    try {
      // ✨ استبدل EndPoint.getProviderReviews بالرابط الخاص بك
      // إذا كان الرابط يتطلب إضافة الـ ID في النص مثلاً: '/providers/$providerId/reviews'
      final response = await api.get(
        '${EndPoint.getProviderReviews}/$providerId/reviews',
        queryParameters: {
          'page': page, // ✨ إرسال رقم الصفحة للسيرفر
        },
      );
      // ✅ حالة النجاح
      if (response['success'] == true) {
        return Right(ReviewsResponsee.fromJson(response));
      }
      // ✅ حالة الفشل (مثلاً: مزود الخدمة غير موجود)
      else {
        final String errorMsg =
            response['message'] ?? 'حدث خطأ أثناء جلب التقييمات';
        return Left(errorMsg);
      }
    } on ServerException catch (e) {
      // ✨ نفس أسلوب التقييم في استخراج رسالة الخطأ
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left('حدث خطأ غير متوقع أثناء تحميل التقييمات');
    }
  }
}
