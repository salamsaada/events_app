import 'package:eventsapp/cache/cache_helper.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/features/chat/repository/chat_api_repository.dart';
import 'package:eventsapp/features/chat/repository/chat_repository.dart';
import 'package:eventsapp/features/chat/repository/planners_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/chat_cubit.dart';
import 'package:eventsapp/screens/chats/chat_screen.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
import 'package:eventsapp/models/planner_model.dart'; 

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        ChatRepository(), 
        ChatApiRepository(context.read<ApiConsumer>()),
        PlannersRepository(apiConsumer: context.read<ApiConsumer>()),
      )..getProviders(), 
      
      child: const ChatListContent(), 
    );
  }
}

class ChatListContent extends StatelessWidget {
  const ChatListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("Conversations", 
            style: AppTextStyles.mainTitle.copyWith(color: theme.textTheme.titleLarge?.color)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            labelColor: theme.primaryColor,
            unselectedLabelColor: theme.hintColor,
            indicatorColor: theme.primaryColor,
            tabs: const [
              Tab(text: "Companies"),
              Tab(text: "Freelancers"),
            ],
          ),
        ),
        
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is ChatError) {
              return Center(child: Text(state.message));
            }

            if (state is ChatLoaded) {
              final List<PlannerModel> allProviders = state.providers;

              final companies = allProviders.where((p) => p.type == 'company').toList();
              final freelancers = allProviders.where((p) => p.type == 'freelancer').toList();

              return TabBarView(
                children: [
                  // 🌟 هنا استخدمنا الكلاس الجديد الذي يحفظ الحالة
                  KeepAliveChatList(items: companies),
                  KeepAliveChatList(items: freelancers),
                ],
              );
            }

            return const Center(child: Text("ابدأ جلب المحادثات..."));
          },
        ),
      ),
    );
  }
}

// 🌟 الكلاس الجديد: StatefulWidget لمنع الشاشة من التدمير
class KeepAliveChatList extends StatefulWidget {
  final List<PlannerModel> items;
  
  const KeepAliveChatList({super.key, required this.items});

  @override
  State<KeepAliveChatList> createState() => _KeepAliveChatListState();
}

// 🌟 هنا ندمج AutomaticKeepAliveClientMixin
class _KeepAliveChatListState extends State<KeepAliveChatList> with AutomaticKeepAliveClientMixin {
  
  // 🌟 تفعيل خاصية الاحتفاظ بالحالة
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // 🌟 هذا السطر ضروري جداً لكي يعمل الـ Mixin
    super.build(context);

    final items = widget.items;
    final theme = Theme.of(context);
    
    if (items.isEmpty) {
      return Center(
        child: Text(
          "لا يوجد مزودين متاحين حالياً",
          style: AppTextStyles.bodyGrey,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final isCompany = item.type == 'company'; 

        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: isCompany 
                  ? theme.primaryColor.withOpacity(0.2) 
                  : Colors.blue.withOpacity(0.2),
              child: Text(
                item.name.isNotEmpty ? item.name[0].toUpperCase() : '?', 
                style: TextStyle(
                  color: isCompany ? theme.primaryColor : Colors.blue, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name, 
                    style: AppTextStyles.sectionTitle.copyWith(color: theme.textTheme.titleMedium?.color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isCompany ? theme.primaryColor.withOpacity(0.15) : Colors.blue.withOpacity(0.15), 
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(
                    isCompany ? "OFFICIAL" : "INDIE", 
                    style: TextStyle(
                      fontSize: 8, 
                      color: isCompany ? theme.primaryColor : Colors.blue, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ],
            ),
            subtitle: Text(item.role, style: AppTextStyles.bodyGrey.copyWith(color: theme.hintColor)),
            onTap: () {
              // 1. سحب الـ ID الخاص بالمستخدم من الكاش
              final String currentUserId =
                  CacheHelper().getData(key: 'my_id') ?? "";

              // 2. الانتقال لشاشة المحادثة مع إعطائها "كيوبيت جديد" خاص بها!
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    // 🌟 إنشاء نسخة جديدة تماماً من الكيوبيت لهذه المحادثة فقط
                    create: (context) =>
                        ChatCubit(
                          ChatRepository(),
                          ChatApiRepository(context.read<ApiConsumer>()),
                          PlannersRepository(
                            apiConsumer: context.read<ApiConsumer>(),
                          ),
                        )..startChat(
                          item.id.toString(),
                        ), // 🌟 نستدعي startChat هنا للنسخة الجديدة

                    child: ChatScreen(
                      myId: currentUserId,
                      receiverId: item.id.toString(),
                      receiverName: item.name,
                      receiverRole: item.role,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}