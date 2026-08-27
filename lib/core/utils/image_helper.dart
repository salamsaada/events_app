import 'package:eventsapp/models/listing_model.dart';
import 'package:eventsapp/core/api/end_ponits.dart'; // مسار ملف الـ EndPoint

class ImageHelper {
  static String getSmartImageUrl(ServiceItem item) {
    final String activeHost = EndPoint.baseUrl.split('/api')[0];

    String? extractValidUrl(List<dynamic>? images) {
      if (images == null || images.isEmpty) return null;
      String url = (images[0] is Map ? images[0]['url'] : images[0].toString());
      if (url.isNotEmpty && url.startsWith('http') && !url.contains('placeholder')) {
        if (url.contains('127.0.0.1:8000') || url.contains('localhost:8000') || url.contains('10.0.2.2:8000')) {
          url = url.replaceAll(RegExp(r'http://(127\.0\.0\.1|localhost|10\.0\.2\.2):8000'), activeHost);
        }
        return url;
      }
      return null;
    }

    // 1. فحص الصورة الأساسية (للصالات والباقات)
    String? finalUrl = extractValidUrl(item.images);

    // 2. فحص الخيارات إذا الأساسية فاضية (للمنتجات متل الطاولات)
    if (finalUrl == null && item.variants.isNotEmpty) {
      for (var variant in item.variants) {
        finalUrl = extractValidUrl(variant.images);
        if (finalUrl != null) break;
      }
    }

    if (finalUrl != null) return finalUrl;

    // 3. الصور الافتراضية
    int uniqueNum = item.id.hashCode.abs();
    if (item.type == 'physical_product') {
      final String title = item.title.toString().toLowerCase();
      if (title.contains('chair') || title.contains('كرسي')) {
        return 'https://images.unsplash.com/photo-1592078615290-033ee584e267?auto=format&fit=crop&w=800&q=80';
      }
      return 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=800&q=80';
    } else if (item.type == 'package') {
      return 'assets/images/photo_2026-08-20_01-44-06.jpg';
    } else {
      List<String> hallImgs = [
        'assets/images/photo_2026-08-20_01-01-38.jpg',
        'assets/images/photo_2026-08-20_01-01-52.jpg',
        'assets/images/photo_2026-08-20_01-05-55.jpg',
      ];
      return hallImgs[uniqueNum % hallImgs.length];
    }
  }
}