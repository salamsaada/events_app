import 'package:eventsapp/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String successMessage;
  AuthSuccess({this.successMessage = "تم تسجيل الدخول بنجاح"});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure({required this.errorMessage});
}

class ProfileLoading extends AuthState {}

class ProfileLoaded extends AuthState {
  final UserModel user; 
  ProfileLoaded({required this.user});
}