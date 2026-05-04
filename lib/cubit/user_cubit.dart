import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial());
  final UserRepository userRepository;
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

  String? emailController;
  void setEmailController(String email) {
    emailController = email;
  }

  String? passwordController;
  void setPasswordController(String password) {
    passwordController = password;
  }

  String? confirmPasswordController;
  void setConfirmPasswordController(String password) {
    confirmPasswordController = password;
  }

  String? firstName;
  void setFirstName(String name) {
    firstName = name;
  }

  void signUp() async {
    emit(SignUpLoading());

    final response = await userRepository.signUp(
      name1: firstName!, // تأكد من توفير قيمة افتراضية إذا لم يتم تعيين الاسم
      name2:
          'hassssss ', // يمكنك تعديل هذا إذا كان لديك حقل last_name في الواجهة
      email: emailController!,
      password: passwordController!,
      confirmPassword: confirmPasswordController!,
      // تم إزالة phone و profilePic بناءً على الكود السابق
    );

    response.fold(
      (errMessage) => emit(SignUpFailure(errMessage: errMessage)),
      (authModel) => emit(SignUpSuccess(message: authModel.message)),
    );
  }

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
