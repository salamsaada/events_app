import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 100),
              child: Column(
                children: const [
                  SizedBox(height: 70),
                  SearchSection(),
                  SizedBox(height: 48),
                  HeroCarousel(),
                  SizedBox(height: 48),
                  ServicesSection(),
                  SizedBox(height: 48),
                  OrdersChatsSection(),
                  SizedBox(height: 48),
                  NewsletterSection(),
                ],
              ),
            ),
          ),
          const TopBar(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNavigation(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
            ),
          ),
          Positioned(
            left: 24,
            bottom: 96,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFFF9C54D),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemSelected(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ChatPage()));
      return;
    }
    if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const OrdersPage()));
      return;
    }
    if (index == 3) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
      return;
    }
  }
}
