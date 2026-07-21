import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/cubit/chat_cubit.dart';
import 'package:eventsapp/core/theme/app_colors.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/features/chat/repository/chat_api_repository.dart';
import 'package:eventsapp/features/chat/repository/chat_repository.dart';
import 'package:eventsapp/features/chat/repository/planners_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String myId;
  final String receiverId;
  final String receiverName;
  final String receiverRole;

  const ChatScreen({
    super.key,
    required this.myId,
    required this.receiverId,
    required this.receiverName,
    this.receiverRole = "Royal Planner",
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        ChatRepository(),
        ChatApiRepository(context.read<ApiConsumer>()),
        PlannersRepository(apiConsumer: context.read<ApiConsumer>()),
      )..startChat(receiverId),
      child: ChatScreenContent(
        myId: myId,
        receiverId: receiverId,
        receiverName: receiverName,
      ),
    );
  }
}

class ChatScreenContent extends StatefulWidget {
  final String myId;
  final String receiverId;
  final String receiverName;

  const ChatScreenContent({super.key, required this.myId, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // 🌟 الحل الجذري: نحدد الـ ID الفعلي هنا. 
    // إذا كان الـ ID القادم من الـ Navigator فارغاً، نسحبه من الكاش فوراً.
    final String effectiveMyId = widget.myId.isNotEmpty 
        ? widget.myId 
        : (CacheHelper().getData(key: 'my_id') ?? "").toString();

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(widget.receiverName, 
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.primaryGold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGold),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) return const Center(child: CircularProgressIndicator());
                if (state is ChatError) return Center(child: Text(state.message));
                
                if (state is ChatMessagesLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];

                      // 🌟 استخدمنا effectiveMyId للمقارنة لضمان الثبات
                      final isMe = msg.senderId.toString().trim() == effectiveMyId.trim();
                      
                      final time = msg.timestamp != null
                          ? "${msg.timestamp!.hour}:${msg.timestamp!.minute.toString().padLeft(2, '0')}"
                          : "";

                      return Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isMe ? AppColors.primaryGold : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                                bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                              ),
                            ),
                            child: Text(msg.text, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          _buildInputBar(context, effectiveMyId), // مررنا الـ ID الفعلي هنا أيضاً
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, String currentMyId) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.background : Colors.white, 
        border: Border(top: BorderSide(color: AppColors.primaryGold.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "اكتب رسالتك...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryGold),
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isNotEmpty) {
                // 🌟 نستخدم currentMyId هنا لضمان إرسال الرسالة بالـ ID الصحيح دائماً
                context.read<ChatCubit>().sendMessage(
                  chatId: context.read<ChatCubit>().activeChatId!,
                  senderId: currentMyId, 
                  receiverId: widget.receiverId,
                  text: text,
                );
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}