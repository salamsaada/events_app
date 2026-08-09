import 'package:eventsapp/core/widgets/filter_button.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/chats/chat_list_screen.dart';
import 'package:eventsapp/screens/chats/chat_screen.dart';
// استدعاء ملف الفلتر الخاص بك
import 'package:eventsapp/screens/filters/filter_section.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/cubit/notification_cubit.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../../core/widgets/common/hero_carousel.dart';
import '../../core/widgets/common/newsletter_section.dart';
import '../../core/widgets/common/orders_chats_section.dart';
import '../../core/widgets/common/search_section.dart';
import '../../core/widgets/common/services_section.dart';
import '../../core/widgets/common/top_app_bar.dart';
import '../chat/chat_page.dart';
import '../orders/orders_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _openFilterSheet() {
    // 🚀 التعديل الجذري: استخدام showDialog لفتح النافذة المنبثقة
    showDialog(
      context: context,
      builder: (context) {
        // 💡 ملاحظة: إذا قمتِ بتغيير اسم الكلاس داخل ملف filter_section.dart 
        // إلى FilterSection، فاكتبي هنا FilterSection() بدلاً من FilterDialogWidget()
        return const FilterDialogWidget(); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMainContent(),
          const TopBar(),
          _buildBottomNavigation(),
          _buildFloatingActionButton(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 80, bottom: 100),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // 💡 تلميح: داخل الـ SearchSection تأكدي أن الـ TextField يرسل قيمة البحث أيضاً للـ Cubit
            const SearchSection(),
            FilterButton(onTap: _openFilterSheet), 
            const HeroCarousel(),
            const SizedBox(height: 48),
            const ServicesSection(),
            const SizedBox(height: 48),
            const OrdersChatsSection(),
            const SizedBox(height: 48),
            const NewsletterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      left: 24, 
      bottom: 96,
      child: FloatingActionButton(
        onPressed: () {
          // منطق إضافة حدث جديد
        },
        backgroundColor: colorScheme.primary, 
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }

  void _onItemSelected(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ChatListScreen(), 
        ),
      );
      return;
    }

    if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersPage()));
      return;
    }

    if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
      return; 
    }
  }
}