import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventsapp/features/chat/models/message_model.dart'; 

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة إرسال الرسالة إلى الفايربيز 
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('chats')
        .doc(chatId) 
        .collection('messages')
        .add(message.toJson());

    await _firestore.collection('chats').doc(chatId).set({
      'last_message': text,
      'last_message_time': FieldValue.serverTimestamp(),
      'sender_id': senderId,
    }, SetOptions(merge: true));
  }

  //  دالة الاستماع اللحظي للرسائل 
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();
    });
  }
}