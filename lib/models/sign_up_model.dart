import 'package:eventsapp/core/api/end_ponits.dart';

class AuthResponseModel {
  final String message;
  final String accessToken;
  final String tokenType;

  AuthResponseModel({
    required this.message,
    required this.accessToken,
    required this.tokenType,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json[ApiKey.message],
      accessToken: json[ApiKey.accessToken],
      tokenType: json[ApiKey.tokenType],
    );
  }
}
