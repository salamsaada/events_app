import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial());
  final UserRepository userRepository;

  // 🚀 أضفنا Future هنا لكي يستطيع الـ RefreshIndicator انتظارها
  // 🚀 أضفنا Future هنا لكي يستطيع الـ RefreshIndicator انتظارها
  Future<void> getListing({
    int? page, 
    String? type, 
    String? categoryId,
    // 🚀 استقبال الفلاتر الجديدة من الواجهة
    String? search,
    String? minPrice,
    String? maxPrice,
    String? capacity,
    String? rating,
    String? date,
    String? location,
  }) async {
    emit(GetListingLoading()); 

    final response = await userRepository.getlisting(
      type: type,
      categoryId: categoryId,
      // 🚀 تمرير الفلاتر للـ Repository
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      capacity: capacity,
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
    emit(CreateBookingLoading()); // إصدار حالة التحميل

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
          emit(CreateBookingFailure(errMessage: errMessage)), // حالة الفشل
      (bookingResponse) => emit(
        CreateBookingSuccess(bookingResponse: bookingResponse),
      ), // حالة النجاح
    );
  }

  void getMyBookings() async {
    emit(GetBookingsLoading()); // إصدار حالة التحميل

    final response = await userRepository
        .getMyBookings(); // استدعاء الدالة من الـ Repository

    response.fold(
      (errMessage) =>
          emit(GetBookingsFailure(errMessage: errMessage)), // حالة الفشل
      (bookingsResponse) => emit(
        GetBookingsSuccess(bookingsResponse: bookingsResponse),
      ), // حالة النجاح
    );
  }

  //Sign in Form key
  // GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  // //Sign in email
  // TextEditingController signInEmail = TextEditingController();
  // //Sign in password
  // TextEditingController signInPassword = TextEditingController();
  // //Sign Up Form key
  // GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  // //Profile Pic
  // XFile? profilePic;
  // //Sign up name
  // TextEditingController signUpName = TextEditingController();
  // //Sign up phone number
  // TextEditingController signUpPhoneNumber = TextEditingController();
  // //Sign up email
  // TextEditingController signUpEmail = TextEditingController();
  // //Sign up password
  // TextEditingController signUpPassword = TextEditingController();
  // //Sign up confirm password
  // TextEditingController confirmPassword = TextEditingController();
  // SignInModel? user;

  // void uploadProfilePic(XFile image) {
  //   profilePic = image;
  //   emit(UploadProfilePic());
  // }

  // String? emailController;
  // void setEmailController(String email) {
  //   emailController = email;
  // }

  // String? passwordController;
  // void setPasswordController(String password) {
  //   passwordController = password;
  // }

  // String? confirmPasswordController;
  // void setConfirmPasswordController(String password) {
  //   confirmPasswordController = password;
  // }

  // String? firstName;
  // void setFirstName(String name) {
  //   firstName = name;
  // }

  // void signUp() async {
  //   emit(SignUpLoading());

  //   final response = await userRepository.signUp(
  //     name1: firstName!, // تأكد من توفير قيمة افتراضية إذا لم يتم تعيين الاسم
  //     name2:
  //         'hassssss ', // يمكنك تعديل هذا إذا كان لديك حقل last_name في الواجهة
  //     email: emailController!,
  //     password: passwordController!,
  //     confirmPassword: confirmPasswordController!,
  //     // تم إزالة phone و profilePic بناءً على الكود السابق
  //   );

  //   response.fold(
  //     (errMessage) => emit(SignUpFailure(errMessage: errMessage)),
  //     (authModel) => emit(SignUpSuccess(message: authModel.message)),
  //   );
  // }

  // signIn() async {
  //   emit(SignInLoading());
  //   final response = await userRepository.signIn(
  //     email: signInEmail.text,
  //     password: signInPassword.text,
  //   );
  //   response.fold(
  //     (errMessage) => emit(SignInFailure(errMessage: errMessage)),
  //     (signInModel) => emit(SignInSuccess()),
  //   );
  // }

  // getUserProfile() async {
  //   emit(GetUserLoading());
  //   final response = await userRepository.getUserProfile();
  //   response.fold(
  //     (errMessage) => emit(GetUserFailure(errMessage: errMessage)),
  //     (user) => emit(GetUserSuccess(user: user)),
  //   );
  // }
}
