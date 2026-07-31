import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/models/notification_model.dart';

class NotificationRepository {
  final ApiConsumer apiConsumer;

  NotificationRepository({required this.apiConsumer});

  // جلب كل الإشعارات المحفوظة للسيرفر
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiConsumer.get('notifications');
    // البيانات قادمة داخل Paginate من لارافيل
    final List dataList = response['data'] ?? response; 
    return dataList.map((item) => NotificationModel.fromJson(item)).toList();
  }

  // تحديث حالة الإشعار إلى مقروء
  Future<void> markAsRead(String id) async {
    await apiConsumer.patch('notifications/$id/read');
  }
}