import 'package:eventsapp/models/booking_model.dart';
import 'package:eventsapp/models/getModelsReviews.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/models/listing_rating_model.dart';
import 'package:eventsapp/models/myBookings_model.dart';
import 'package:eventsapp/models/planner_model.dart';
import 'package:eventsapp/models/sendReviwe.dart';
import 'package:eventsapp/models/user_model.dart';

class UserState {}

final class UserInitial extends UserState {}

final class SignInSuccess extends UserState {}

// final class UploadProfilePic extends UserState {}

final class SignInLoading extends UserState {}

final class SignInFailure extends UserState {
  final String errMessage;

  SignInFailure({required this.errMessage});
}

final class SignUpSuccess extends UserState {
  final String message;

  SignUpSuccess({required this.message});
}

final class SignUpLoading extends UserState {}

final class SignUpFailure extends UserState {
  final String errMessage;

  SignUpFailure({required this.errMessage});
}

// final class GetUserSuccess extends UserState {
//   final UserModel user;

//   GetUserSuccess({required this.user});
// }

final class GetUserLoading extends UserState {}

final class GetUserFailure extends UserState {
  final String errMessage;

  GetUserFailure({required this.errMessage});
}

final class GetListingLoading extends UserState {}

final class GetListingSuccess extends UserState {
  final ListingResponse listingResponse;
  GetListingSuccess({required this.listingResponse});
}

final class GetListingFailure extends UserState {
  final String errMessage;
  GetListingFailure({required this.errMessage});
}

final class CreateBookingLoading extends UserState {}

final class CreateBookingSuccess extends UserState {
  final BookingResponse bookingResponse;
  CreateBookingSuccess({required this.bookingResponse});
}

final class CreateBookingFailure extends UserState {
  final String errMessage;
  CreateBookingFailure({required this.errMessage});
}

// 1. حالة التحميل (جاري جلب الحجوزات)
final class GetBookingsLoading extends UserState {}

// 2. حالة النجاح (تم جلب الحجوزات بنجاح)
final class GetBookingsSuccess extends UserState {
  final BookingResponsee
  bookingsResponse; // نمرر الكلاس الذي يحتوي على List<BookingData>
  GetBookingsSuccess({required this.bookingsResponse});
}

// 3. حالة الفشل (حدث خطأ أثناء جلب الحجوزات)
final class GetBookingsFailure extends UserState {
  final String errMessage;
  GetBookingsFailure({required this.errMessage});
}

//حالات البروفايدر
class GetProvidersLoading extends UserState {}

class GetProvidersSuccess extends UserState {
  final List<dynamic> providers;
  GetProvidersSuccess({required this.providers});
}

class GetProvidersFailure extends UserState {
  final String errMessage;
  GetProvidersFailure({required this.errMessage});
}

class GetProviderDetailsLoading extends UserState {}

class GetProviderDetailsSuccess extends UserState {
  final PlannerModel providerDetails; // 🚀 تعديل النوع هنا
  GetProviderDetailsSuccess({required this.providerDetails});
}

class GetProviderDetailsFailure extends UserState {
  final String errMessage;
  GetProviderDetailsFailure({required this.errMessage});
}

//حالات الدفع
class UploadProofLoading extends UserState {}

class UploadProofSuccess extends UserState {
  final String message;
  UploadProofSuccess(this.message);
}

class UploadProofFailure extends UserState {
  final String errMessage;
  UploadProofFailure(this.errMessage);
}

class GetListingDetailsLoading extends UserState {}

class GetListingDetailsSuccess extends UserState {
  final ServiceItem listing;
  GetListingDetailsSuccess({required this.listing});
}

class GetListingDetailsFailure extends UserState {
  final String errMessage;
  GetListingDetailsFailure({required this.errMessage});
}

class SendRatingLoading extends UserState {}

class SendRatingSuccess extends UserState {
  final SendReviewModel message; // تم تصحيح النوع
  SendRatingSuccess({required this.message});
}

class SendRatingFailure extends UserState {
  final String errMessage;
  SendRatingFailure({required this.errMessage});
}

class CancelBookingLoading extends UserState {}

class CancelBookingSuccess extends UserState {
  final String message;
  CancelBookingSuccess({required this.message});
}

class CancelBookingFailure extends UserState {
  final String errMessage;
  CancelBookingFailure({required this.errMessage});
}

// حالة التحميل (جاري جلب التقييمات)
class GetReviewsLoading extends UserState {}

// حالة النجاح (تم جلب التقييمات بنجاح)
class GetReviewsSuccess extends UserState {
  final ReviewsResponsee
  reviewsResponse; // ✨ نستخدم الموديل الذي أنشأناه سابقاً
  GetReviewsSuccess({required this.reviewsResponse});
}

// حالة الفشل (فشل جلب التقييمات)
class GetReviewsFailure extends UserState {
  final String errMessage;
  GetReviewsFailure({required this.errMessage});
}


class GetListingRatingsLoading extends UserState {}

class GetListingRatingsSuccess extends UserState {
  final ListingRatingsResponse ratingsResponse;
  GetListingRatingsSuccess(this.ratingsResponse);
}

class GetListingRatingsFailure extends UserState {
  final String errMessage;
  GetListingRatingsFailure(this.errMessage);
}


class GetProviderQrCodeLoading extends UserState {}

class GetProviderQrCodeSuccess extends UserState {
  final String qrUrl;
  GetProviderQrCodeSuccess(this.qrUrl);
}

class GetProviderQrCodeFailure extends UserState {
  final String errMessage;
  GetProviderQrCodeFailure(this.errMessage);
}
