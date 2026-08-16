import 'package:eventsapp/models/booking_model.dart';
import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/models/myBookings_model.dart';
import 'package:eventsapp/models/planner_model.dart';
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