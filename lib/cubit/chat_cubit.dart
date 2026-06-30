import 'dart:async';
import 'package:eventsapp/features/chat/repository/planners_repository.dart';
import 'package:eventsapp/models/planner_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/features/chat/models/message_model.dart';
import 'package:eventsapp/features/chat/repository/chat_repository.dart';
import 'package:eventsapp/features/chat/repository/chat_api_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _firebaseRepo;
  final ChatApiRepository _apiRepo;
  final PlannersRepository _plannersRepo; // أضيفي هذا
  
  // 🌟 هنا السر: نحفظ الـ ID داخل الـ Cubit
  String? activeChatId; 
  StreamSubscription? _messagesSubscription;

  ChatCubit(this._firebaseRepo, this._apiRepo, this._plannersRepo) : super(ChatInitial());

  Future<void> startChat(String receiverId) async {
    emit(ChatLoading());
    
    final chatId = await _apiRepo.initializeChat(receiverId);
    
    if (chatId != null) {
      activeChatId = chatId; // 🌟 حفظ الـ ID
      listenToMessages(chatId: chatId);
    } else {
      emit( ChatError("فشل في تهيئة المحادثة"));
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
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }


 Future<void> getProviders() async {
    // 1. نخبر الواجهة أننا بدأنا التحميل
    emit(ChatLoading());

    try {
      // 2. التعديل هنا: نستخدم _plannersRepo لأن الدالة موجودة فيه
      final providersList = await _plannersRepo.getPlanners(); 

      // 3. إذا نجح الجلب، نرسل القائمة للواجهة
      emit(ChatLoaded(providersList));

    } catch (e) {
      // 4. في حال حدوث خطأ
      emit(ChatError("حدث خطأ أثناء جلب المزودين: ${e.toString()}"));
    }
  }
}