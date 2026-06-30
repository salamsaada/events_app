part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

// 1. هذه الحالة أضفناها عشان واجهة قائمة المحادثات (Providers)
class ChatLoaded extends ChatState {
  final List<PlannerModel> providers;
  ChatLoaded(this.providers);
}

// 2. هذه الحالة تبعك الأساسية تركناها عشان واجهة الشات من جوا (الرسائل)
class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatMessagesLoaded(this.messages);
}

// 3. غيرنا كلمة error لـ message عشان تتطابق مع الواجهة اللي عملناها
class ChatError extends ChatState {
  final String message; 
  ChatError(this.message);
}