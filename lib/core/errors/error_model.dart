class ErrorModel {
  final int? status; // أصبح اختياري لأن لارافل لا يرسله دائماً في الـ Body
  final String errorMessage;

  ErrorModel({this.status, required this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    String message = '';

    // 1. محاولة جلب الرسالة الرئيسية من مفتاح 'message'
    if (jsonData.containsKey('message') && jsonData['message'] != null) {
      message = jsonData['message'].toString();
    }
    // 2. إذا لم يجد message، يبحث داخل حقل errors ويجلب أول خطأ
    else if (jsonData.containsKey('errors') && jsonData['errors'] is Map) {
      Map<String, dynamic> errors = Map<String, dynamic>.from(
        jsonData['errors'],
      );
      if (errors.isNotEmpty) {
        var firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        }
      }
    }

    return ErrorModel(
      status: jsonData['status'], // قد يكون null ولن يسبب مشكلة
      errorMessage: message,
    );
  }
}
