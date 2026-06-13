import 'package:eventsapp/models/listing_model.dart';
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
