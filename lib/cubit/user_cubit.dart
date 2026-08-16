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
      (listingResponse) => emit(GetListingSuccess(listingResponse: listingResponse)), 
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
    );

    response.fold(
      (errMessage) =>
          emit(CreateBookingFailure(errMessage: errMessage)), 
      (bookingResponse) => emit(
        CreateBookingSuccess(bookingResponse: bookingResponse),
      ), 
    );
  }

  void getMyBookings() async {
    emit(GetBookingsLoading()); 

    final response = await userRepository.getMyBookings(); 

    response.fold(
      (errMessage) =>
          emit(GetBookingsFailure(errMessage: errMessage)), 
      (bookingsResponse) => emit(
        GetBookingsSuccess(bookingsResponse: bookingsResponse),
      ), 
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
      (details) => emit(GetProviderDetailsSuccess(providerDetails: details)), // details هنا أصبحت PlannerModel
    );
  }
}