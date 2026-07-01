import 'package:dartz/dartz.dart';
import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/errors/exceptions.dart';
import 'package:eventsapp/models/booking_model.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/models/myBookings_model.dart';

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

  Future<Either<String, ListingResponse>> getlisting() async {
    try {
      final response = await api.get(EndPoint.getlisting);

      // 1. التحقق مما إذا كان الرد فارغاً تماماً (null) أو لا يحتوي على بيانات
      if (response == null ||
          (response is List && response.isEmpty) ||
          (response is Map && response.isEmpty)) {
        // نُرجع هذه الرسالة ليتم عرضها في واجهة المستخدم
        return const Left("لا يوجد صالات حالياً");
      }

      final serviceResponse = ListingResponse.fromJson(response);

      // 2. خطوة أمان إضافية: إذا كان السيرفر يرسل المودل ولكن مصفوفة الصالات بداخله فارغة
      // (ملاحظة: استبدلي 'data' باسم المصفوفة الموجودة داخل ListingResponse لديكِ إذا كانت مختلفة)
      /*
      if (serviceResponse.data == null || serviceResponse.data!.isEmpty) {
         return const Left("لا يوجد صالات حالياً");
      }
      */

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

      // حفظ آخر حجز في التخزين المحلي
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
      // تأكد من وجود EndPoint.bookings في ملف end_ponits.dart أو استبدله بالرابط مباشرة
      final response = await api.get(EndPoint.Mybookings);

      // 1. التحقق مما إذا كان الرد فارغاً تماماً (null) أو لا يحتوي على بيانات
      if (response == null ||
          (response is List && response.isEmpty) ||
          (response is Map && response.isEmpty)) {
        // نُرجع هذه الرسالة ليتم عرضها في واجهة المستخدم
        return const Left("لا يوجد حجوزات حالياً");
      }

      final bookingResponse = BookingResponsee.fromJson(response);

      // 2. خطوة أمان إضافية: إذا كان السيرفر يرسل الموديل ولكن مصفوفة الحجوزات بداخله فارغة
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

  // // Function to fetch filtered items (Services or Products) from Laravel
  // Future<Either<String, List<dynamic>>> getFilteredItems({
  //   required String type,
  //   String? city,
  //   int? capacity,
  //   required double maxPrice,
  //   String? style,
  // }) async {
  //   try {
  //     final response = await api.get(
  //       EndPoint.getUserDataEndPoint, // استبدليه بالـ Endpoint الصحيح للفلترة مثلاً "items/filter"
  //       queryParameters: {
  //         'type': type,
  //         if (city != null) 'city': city,
  //         if (capacity != null) 'capacity': capacity,
  //         'max_price': maxPrice,
  //         if (style != null) 'style': style,
  //       },
  //     );

  //     // افترضنا هنا أن السيرفر يرجع قائمة من البيانات
  //     // يمكنك تحويلها لاحقاً لـ List<ItemModel>
  //     return Right(response);
  //   } on ServerException catch (e) {
  //     return Left(e.errModel.errorMessage);
  //   }
  // }
}
