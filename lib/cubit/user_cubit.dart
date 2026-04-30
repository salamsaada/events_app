import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/user_state.dart';
import 'package:eventsapp/models/sign_in_model.dart';
import 'package:eventsapp/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial());
  final UserRepository userRepository;
  //Sign in Form key
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  //Sign Up Form key
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  //Profile Pic
  XFile? profilePic;
  //Sign up name
  TextEditingController signUpName = TextEditingController();
  //Sign up phone number
  TextEditingController signUpPhoneNumber = TextEditingController();
  //Sign up email
  TextEditingController signUpEmail = TextEditingController();
  //Sign up password
  TextEditingController signUpPassword = TextEditingController();
  //Sign up confirm password
  TextEditingController confirmPassword = TextEditingController();
  SignInModel? user;

  void uploadProfilePic(XFile image) {
    profilePic = image;
    emit(UploadProfilePic());
  }

  // signUp() async {
  //   emit(SignUpLoading());
  //   final response = await userRepository.signUp(
  //     name: signUpName.text,
  //     phone: signUpPhoneNumber.text,
  //     email: signUpEmail.text,
  //     password: signUpPassword.text,
  //     confirmPassword: confirmPassword.text,
  //     profilePic: profilePic!,
  //   );
  //   response.fold(
  //     (errMessage) => emit(SignUpFailure(errMessage: errMessage)),
  //     (signUpModel) => emit(SignUpSuccess(message: signUpModel.message)),
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
