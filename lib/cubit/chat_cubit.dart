import 'dart:async';
import 'package:eventsapp/features/chat/models/message_model.dart';
import 'package:eventsapp/features/chat/repository/planners_repository.dart';
import 'package:eventsapp/models/planner_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/features/chat/repository/chat_repository.dart';
import 'package:eventsapp/features/chat/repository/chat_api_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _firebaseRepo;
  final ChatApiRepository _apiRepo;
  final PlannersRepository _plannersRepo;

  static const String botId = "support_bot_id"; 
  
  String? activeChatId; 
  StreamSubscription? _messagesSubscription;

  ChatCubit(this._firebaseRepo, this._apiRepo, this._plannersRepo) : super(ChatInitial());

  Future<void> startChat(String receiverId) async {
    emit(ChatLoading());
    final chatId = await _apiRepo.initializeChat(receiverId);
    if (chatId != null) {
      activeChatId = chatId;
      listenToMessages(chatId: chatId);
    } else {
      emit(ChatError("فشل في تهيئة المحادثة"));
    }
  }

  void listenToMessages({required String chatId}) {
    _messagesSubscription?.cancel();
    _messagesSubscription = _firebaseRepo
        .getMessagesStream(chatId) 
        .listen((messagesList) {
      emit(ChatMessagesLoaded(messagesList));
    }, onError: (error) {
      emit(ChatError(error.toString()));
    });
  }

  Future<void> sendMessage({
    required String chatId, 
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    try {
      await _firebaseRepo.sendMessage(
        chatId: chatId, 
        senderId: senderId,
        receiverId: receiverId,
        text: text,
      );

      // 2. التحقق من حالة الطرف الآخر (هل هو موجود أم لا؟)
      // ملاحظة: تأكدي من إضافة دالة isUserOnline في الـ ChatRepository الخاص بك
      bool isReceiverOnline = await _firebaseRepo.isUserOnline(receiverId);

      // 3. إذا كان الطرف الآخر "أوفلاين"، يعمل البوت. إذا كان "أونلاين"، لا يفعل البوت شيئاً
      if (!isReceiverOnline) {
        _generateAutomatedResponse(chatId: chatId, userId: senderId, userMessage: text);
      }

    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  // 🌟 دالة الرد التلقائي (البوت)
  void _generateAutomatedResponse({
  required String chatId,
  required String userId,
  required String userMessage,
}) async {
  await Future.delayed(const Duration(seconds: 1));

  final Map<String, String> responses = {
    "مرحبا": "أهلاً بك! كيف يمكننا مساعدتك في Aura Events اليوم؟",
    "hi": "Hello! How can we help you with Aura Events today?",
    "حجز": "يمكنك حجز موعدك بسهولة من خلال تبويب 'الحجوزات' في التطبيق.",
    "سعر": "تختلف أسعارنا بناءً على نوع الخدمة. يمكنك الاطلاع على الباقات في قسم 'الخدمات'.",
    "شكرا": "عفواً، نحن في الخدمة دائماً! هل تحتاج لأي مساعدة أخرى؟",
  };

  String finalResponse = "عذراً، لم أفهم طلبك جيداً. سأقوم بتحويل رسالتك للفريق المختص وسيردون عليك قريباً.";

  String lowerMessage = userMessage.toLowerCase();

  for (var entry in responses.entries) {
    if (lowerMessage.contains(entry.key.toLowerCase())) {
      finalResponse = entry.value;
      break; 
    }
  }

  // 4. إرسال الرد
  await _firebaseRepo.sendMessage(
    chatId: chatId,
    senderId: botId,
    receiverId: userId,
    text: finalResponse,
  );
}

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }

  Future<void> getProviders() async {
    emit(ChatLoading());
    try {
      final providersList = await _plannersRepo.getPlanners(); 
      emit(ChatLoaded(providersList));
    } catch (e) {
      emit(ChatError("حدث خطأ أثناء جلب المزودين: ${e.toString()}"));
    }
  }
}