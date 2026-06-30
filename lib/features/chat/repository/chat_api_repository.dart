import 'package:eventsapp/core/api/api_consumer.dart';

class ChatApiRepository {
  final ApiConsumer apiConsumer; 

  ChatApiRepository(this.apiConsumer);

 Future<String?> initializeChat(String receiverId) async {
  try {
    final response = await apiConsumer.post('chat/initialize', data: {
      'receiver_id': receiverId, 
    });


    if (response != null && response['status'] == 'success') {
      return response['chat_id'].toString();
    }
    
    return null;
  } catch (e) {
    print("❌ فشل الاتصال بـ /api/chat/initialize : $e");
    return null;
  }
}
}