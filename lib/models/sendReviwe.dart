class SendReviewModel {
  final String message;

  SendReviewModel({required this.message});

  factory SendReviewModel.fromJson(Map<String, dynamic> json) {
    return SendReviewModel(
      // إذا لم يجد مفتاح message في الـ JSON، سيضع نص افتراضي
      message: json['message'] ?? 'تم إرسال التقييم بنجاح',
    );
  }
}
