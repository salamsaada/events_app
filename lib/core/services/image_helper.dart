import 'package:eventsapp/models/listing_model.dart';

/// أداة مركزية لاختيار صورة الصالة:
/// - إذا كانت صورة الباك موجودة وشكلها صحيح => نرجعها.
/// - إذا كانت غير موجودة أو غير صالحة => نرجع صورة بديلة ثابتة
///   حسب id الصالة (نفس الصالة = نفس الصورة البديلة دايماً).
class ImageHelper {
  ImageHelper._();

  static const List<String> fallbackImages = [
    'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=1000&q=80', // صالة كلاسيكية
    'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=1000&q=80', // صالة حفلات
    'https://images.unsplash.com/photo-1520854221256-17451cc331bf?auto=format&fit=crop&w=1000&q=80', // تنسيق طاولات فخم
    'https://images.unsplash.com/photo-1530103862676-de8892f07b1a?auto=format&fit=crop&w=1000&q=80', // صالة مع إضاءة
    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?auto=format&fit=crop&w=1000&q=80', // صالة خارجية/طبيعة
    'https://images.unsplash.com/photo-1519225421980-715cb0215aed?auto=format&fit=crop&w=1000&q=80', // صالة أنيقة
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&w=1000&q=80', // تجهيزات زفاف
  ];

  /// يحاول استخراج رابط صورة صالح من عنصر الصالة القادم من الباك.
  /// يرجع null إذا ما في صورة أو الرابط غير صالح (محلي/وهمي).
  static String? extractBackendUrl(ServiceItem item) {
    if (item.images.isEmpty) return null;

    final dynamic first = item.images[0];
    String url;

    if (first is Map) {
      url = (first['url'] ?? '').toString();
    } else if (first is String) {
      url = first;
    } else {
      // إذا الموديل عندك كلاس مخصص للصور بدل Map/String
      // (مثلاً ImageModel فيه property اسمها url)، عدّل هالسطر إلى:
      // url = first.url ?? '';
      url = first.toString();
    }

    final bool isValid = url.isNotEmpty &&
        url.startsWith('http') &&
        !url.contains('localhost') &&
        !url.contains('127.0.0.1') &&
        !url.contains('placeholder') &&
        !url.contains('example');

    return isValid ? url : null;
  }

  /// صورة بديلة ثابتة حسب id الصالة، بحيث كل صالة تاخد نفس الصورة دايماً
  /// وصالتين متتاليتين ما ياخدوا نفس الصورة (توزيع شبه عادل).
  static String getFallbackImage(String id) {
    final int uniqueNum = id.codeUnits.fold(0, (sum, char) => sum + char);
    return fallbackImages[uniqueNum % fallbackImages.length];
  }

  /// الدالة الرئيسية: صورة الباك إذا صالحة، وإلا صورة بديلة.
  /// (تُستخدم في الأماكن اللي بنحتاج فيها رابط نصي فقط، بدون معالجة فشل التحميل)
  static String getSmartImageUrl(ServiceItem item) {
    return extractBackendUrl(item) ?? getFallbackImage(item.id);
  }
}