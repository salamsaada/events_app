import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/models/listing_model.dart'; // استيراد ServiceItem الشامل

class FavoritesRepository {
  final ApiConsumer apiConsumer;

  FavoritesRepository({required this.apiConsumer});

  // 1. دالة التبديل (إضافة / إزالة)
  Future<bool> toggleFavorite(String listingId) async {
    final response = await apiConsumer.post('favorites/$listingId/toggle');
    return response['data']['favorited'];
  }

  // 2. دالة جلب المفضلة تُرجع ServiceItem مباشرة
  Future<List<ServiceItem>> getFavorites() async {
    final response = await apiConsumer.get('favorites');
    final List favoritesList = response['data']['data'];
    return favoritesList.map((item) => ServiceItem.fromJson(item)).toList();
  }
}