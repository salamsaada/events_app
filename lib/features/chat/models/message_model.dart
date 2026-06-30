import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'] ?? json['senderId'] ?? '',
      receiverId: json['receiver_id'] ?? json['receiverId'] ?? '',
      
      text: json['text'] ?? json['message_text'] ?? json['message'] ?? '',
      
      timestamp: _parseTimestamp(json['timestamp'] ?? json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text, 
      'message_text': text, 
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  static DateTime _parseTimestamp(dynamic timeValue) {
    if (timeValue == null) return DateTime.now();
    
    if (timeValue is Timestamp) {
      return timeValue.toDate();
    }
    
    if (timeValue is String) {
      return DateTime.tryParse(timeValue) ?? DateTime.now();
    }
    
    return DateTime.now();
  }
}