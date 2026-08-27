import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial());
  final UserRepository userRepository;

  Future<void> getListing({
    int? page,
    String? type,
    String? categoryId,
    // ✨ التعديل هنا: استخدام title بدلاً من search
    String? title,
    String? minPrice,
    String? maxPrice,
    String? capacityMin,
    String? capacityMax,
    String? rating,
    String? date,
    String? location,
  }) async {
    emit(GetListingLoading());

    final response = await userRepository.getlisting(
      type: type,
      categoryId: categoryId,
      // ✨ التعديل هنا: إرسال المتغير title
      title: title,
      minPrice: minPrice,
      maxPrice: maxPrice,
      capacityMin: capacityMin,
      capacityMax: capacityMax,
      rating: rating,
      date: date,
      location: location,
    );

    response.fold(
      (errMessage) => emit(GetListingFailure(errMessage: errMessage)),
      (listingResponse) =>
          emit(GetListingSuccess(listingResponse: listingResponse)),
    );
  }

  void createBooking({
    String? providerId,
    required String listingId,
    String? listingVariantId,
    String? listingSlotId,
    required String bookingType,
    required int quantity,
    String? bookedDate,
    String? bookedStartTime,
    String? customerNotes,
    // 🚀 التعديل: إضافة بارامتر المنتجات المخصصة
    List<Map<String, dynamic>>? customItems,
    List<String>? customFreelancers,
  }) async {
    emit(CreateBookingLoading());

    final response = await userRepository.createBooking(
      providerId: providerId,
      listingId: listingId,
      listingVariantId: listingVariantId,
      listingSlotId: listingSlotId,
      bookingType: bookingType,
      quantity: quantity,
      bookedDate: bookedDate,
      bookedStartTime: bookedStartTime,
      customerNotes: customerNotes,
      customItems: customItems, // 🚀 التمرير للـ Repository
      customFreelancers: customFreelancers,
    );

    response.fold(
          (errMessage) => emit(CreateBookingFailure(errMessage: errMessage)),
          (bookingResponse) =>
          emit(CreateBookingSuccess(bookingResponse: bookingResponse)),
    );
  }

  void getMyBookings() async {
    emit(GetBookingsLoading());

    final response = await userRepository.getMyBookings();

    response.fold(
      (errMessage) => emit(GetBookingsFailure(errMessage: errMessage)),
      (bookingsResponse) =>
          emit(GetBookingsSuccess(bookingsResponse: bookingsResponse)),
    );
  }

  // 🚀 إضافة بارامتر name
  Future<void> getProviders({String? name}) async {
    emit(GetProvidersLoading());

    try {
      // ✨ تمرير المتغير للـ Repository
      final response = await userRepository.getAllProviders(name: name);

      response.fold(
        (errMessage) => emit(GetProvidersFailure(errMessage: errMessage)),
        (providersData) => emit(GetProvidersSuccess(providers: providersData)),
      );
    } catch (e) {
      emit(GetProvidersFailure(errMessage: e.toString()));
    }
  }

  Future<void> getProviderDetails(String id) async {
    emit(GetProviderDetailsLoading());

    final response = await userRepository.getProviderDetails(id);

    response.fold(
      (errMessage) => emit(GetProviderDetailsFailure(errMessage: errMessage)),
      (details) => emit(
        GetProviderDetailsSuccess(providerDetails: details),
      ), // details هنا أصبحت PlannerModel
    );
  }

  Future<void> uploadProof({
    required String bookingId,
    required String filePath,
    required String amount, // 👈 أضيفي المبلغ هنا
  }) async {
    emit(UploadProofLoading());

    final response = await userRepository.uploadPaymentProof(
      bookingId: bookingId,
      filePath: filePath,
      amount: amount, // 👈 مرريه للـ Repository
    );

    response.fold(
      (errMessage) => emit(UploadProofFailure(errMessage)),
      (successMessage) => emit(UploadProofSuccess(successMessage)),
    );
  }

  Future<void> getListingDetails(String id) async {
    emit(GetListingDetailsLoading());

    final response = await userRepository.getListingDetails(id);

    response.fold(
      (errMessage) => emit(GetListingDetailsFailure(errMessage: errMessage)),
      (listing) => emit(GetListingDetailsSuccess(listing: listing)),
    );
  }

  Future<void> sendRating({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    // 1. إصدار حالة التحميل
    emit(SendRatingLoading());

    // 2. استدعاء الـ Repository وإرسال البيانات
    final result = await userRepository.submitReview(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    );

    // 3. 🛡️ التحقق من أن الـ Cubit لا يزال مفتوحاً (لم يتم إغلاقه من الصفحة)
    if (isClosed) return;

    // 4. معالجة الرد (نجاح أو فشل)
    result.fold(
      (errMessage) => emit(SendRatingFailure(errMessage: errMessage)),
      (messageModel) => emit(SendRatingSuccess(message: messageModel)),
    );
  }

  Future<void> cancelBooking(String bookingId) async {
    emit(CancelBookingLoading());

    final result = await userRepository.cancelBooking(bookingId);
    if (isClosed) return;

    result.fold(
      (errMessage) => emit(CancelBookingFailure(errMessage: errMessage)),
      (message) => emit(CancelBookingSuccess(message: message)),
    );
  }

  Future<void> getProviderReviews(String id, {int page = 1}) async {
    // إصدار حالة التحميل
    emit(GetReviewsLoading());

    // استدعاء الـ Repository وتمرير الـ ID ورقم الصفحة
    final response = await userRepository.getProviderReviews(
      providerId: id,
      page: page,
    );

    // التحقق من أن الـ Cubit لا يزال مفتوحاً
    if (isClosed) return;

    // معالجة الرد
    response.fold(
      (errMessage) => emit(GetReviewsFailure(errMessage: errMessage)),
      (reviews) => emit(GetReviewsSuccess(reviewsResponse: reviews)),
    );
  }

  Future<void> getListingRatings(List<String> listingIds) async {
  emit(GetListingRatingsLoading());
  final response = await userRepository.getListingRatings(listingIds);
  response.fold(
    (errMessage) => emit(GetListingRatingsFailure(errMessage)),
    (ratingsResponse) => emit(GetListingRatingsSuccess(ratingsResponse)),
  );
}


Future<void> getProviderQrCode(String providerId) async {
  emit(GetProviderQrCodeLoading());
  final response = await userRepository.getProviderQrCode(providerId);
  response.fold(
    (errMessage) => emit(GetProviderQrCodeFailure(errMessage)),
    (qrUrl) => emit(GetProviderQrCodeSuccess(qrUrl)),
  );
}

}
