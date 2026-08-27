class PaymentStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed'; // 🚀 تم التعديل لتتطابق مع الباك إند
  static const String failed = 'failed';
  static const String refunded = 'refunded';

  /// الحالات يلي فيها زر "رفع إيصال الدفع" لازم يكون معطّل/مخفي
  static const List<String> blockedStates = [pending, confirmed, refunded];
}