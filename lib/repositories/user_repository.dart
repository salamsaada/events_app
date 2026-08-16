import 'package:dartz/dartz.dart';
import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/core/api/end_ponits.dart';
import 'package:eventsapp/core/errors/exceptions.dart';
import 'package:eventsapp/models/booking_model.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/models/myBookings_model.dart';
import 'package:eventsapp/models/planner_model.dart';
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
    // ✨ التعديل هنا: غيرنا الاسم من search إلى title
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
          // ✨ التعديل هنا: تمرير title بدلاً من search ليتطابق مع الباك إند
          if (title != null && title.isNotEmpty) 'title': title,

          if (minPrice != null && minPrice.isNotEmpty) 'price_min': minPrice,
          if (maxPrice != null && maxPrice.isNotEmpty) 'price_max': maxPrice,
          if (capacityMin != null && capacityMin.isNotEmpty) 'capacity_min': capacityMin,
          if (capacityMax != null && capacityMax.isNotEmpty) 'capacity_max': capacityMax,

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

      final serviceResponse = ListingResponse.fromJson(response);
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

  // 🚀 تعديل الدالة لتستقبل اسم المزود للبحث
  Future<Either<String, List<dynamic>>> getAllProviders({String? name}) async {
    try {
      final response = await api.get(
        'providers',
        // ✨ إضافة المتغير للرابط
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
        },
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
  // 🚀 التعديل: تغيير نوع الإرجاع لـ PlannerModel بدل dynamic
  Future<Either<String, PlannerModel>> getProviderDetails(String id) async {
    try {
      final response = await api.get('providers/$id');

      if (response == null) {
        return const Left("لا توجد بيانات حالياً");
      }

      final detailsData = (response is Map<String, dynamic> && response.containsKey('data')) 
          ? response['data'] 
          : response;

      // ✨ هون سحر الموديل: تمرير البيانات للموديل ليقوم بتنظيفها وترتيبها
      final planner = PlannerModel.fromJson(detailsData);

      return Right(planner);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left("حدث خطأ غير متوقع: $e");
    }
  }
}