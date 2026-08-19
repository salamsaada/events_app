import 'package:eventsapp/core/api/end_ponits.dart';

class ErrorModels {
  final String message;
  final bool success;
  Map<String, dynamic>? errors;

  ErrorModels({required this.message, required this.success, this.errors});

  factory ErrorModels.fromJson(Map<String, dynamic> json) {
    return ErrorModels(
      message: json[ApiKey.message] ?? 'An unknown error occurred.',
      success: json[ApiKey.success] ?? false,
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : null,
    );
  }
}
