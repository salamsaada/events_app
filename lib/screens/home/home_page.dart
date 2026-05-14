import 'package:eventsapp/core/widgets/filter_button.dart';
import 'package:eventsapp/generated/app_localizations.dart';
import 'package:eventsapp/screens/filters/filter_section.dart';
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

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: const FilterSection(),
            ),
          );
        },
      ),
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
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
    }
    if (index == 1 || index == 2) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pageWillBeAvailable)));
    }
  }
}