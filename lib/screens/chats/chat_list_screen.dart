import 'package:eventsapp/core/api/api_consumer.dart';
import 'package:eventsapp/features/chat/repository/chat_api_repository.dart';
import 'package:eventsapp/features/chat/repository/chat_repository.dart';
import 'package:eventsapp/features/chat/repository/planners_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/chat_cubit.dart';
import 'package:eventsapp/screens/chats/chat_screen.dart';
import 'package:eventsapp/core/theme/app_text_styles.dart';
// تأكدي من استيراد الموديل الصحيح
import 'package:eventsapp/models/planner_model.dart'; 

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        // تأكدي أنكِ عاملة import لهذين الـ Repositories في الأعلى
        ChatRepository(), 
        ChatApiRepository(context.read<ApiConsumer>()),
        PlannersRepository(apiConsumer: context.read<ApiConsumer>()),
      )..getProviders(), // 👈 هنا نطلب البيانات مرة واحدة فقط عند فتح الشاشة!
      
      child: const ChatListContent(), // هنا نستدعي التصميم تبعك
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
        
        // هنا أضفنا BlocBuilder للاستماع لحالة الـ API
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            
            // 1. حالة التحميل
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // 2. حالة الخطأ
            if (state is ChatError) {
              return Center(child: Text(state.message));
            }

            // 3. حالة النجاح (البيانات وصلت)
            if (state is ChatLoaded) {
              final List<PlannerModel> allProviders = state.providers;

              // الفرز الذكي محلياً
              final companies = allProviders.where((p) => p.type == 'company').toList();
              final freelancers = allProviders.where((p) => p.type == 'freelancer').toList();

              return TabBarView(
                children: [
                  _buildChatList(context, companies),
                  _buildChatList(context, freelancers),
                ],
              );
            }

            // حالة ابتدائية أو غير معروفة
            return const Center(child: Text("ابدأ جلب المحادثات..."));
          },
        ),
      ),
    );
  }

  // تم تعديل الدالة لتستقبل List<PlannerModel> بدلاً من Map
  Widget _buildChatList(BuildContext context, List<PlannerModel> items) {
    final theme = Theme.of(context);
    
    // معالجة حالة القائمة الفارغة بشكل أنيق
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
        final isCompany = item.type == 'company'; // نعتمد على حقل type الآن

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
              // أخذ الحرف الأول من الاسم بأمان
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
              // 1. نبدأ المحادثة في الخلفية
              context.read<ChatCubit>().startChat(item.id);
              
              // 2. ننتقل لشاشة المحادثة
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    myId: "01kw52txy4g70cfrakre683ptp", 
                    receiverId: item.id,
                    receiverName: item.name,
                    receiverRole: item.role,
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