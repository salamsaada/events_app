import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/common/bottom_navigation.dart';
import '../home/home_page.dart';
import '../orders/orders_page.dart';
import '../profile/profile_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: 1,
        onItemSelected: (index) => _handleNavigation(context, index),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.background, AppColors.surface]
                : [const Color(0xFFF8F6F2), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: _ChatHeader(theme: theme, l10n: l10n),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    _MessageBubble(
                      isMe: false,
                      name: l10n.marcusConcierge,
                      time: l10n.time1245,
                      text: l10n.menuCompletedMessage,
                    ),
                    const SizedBox(height: 12),
                    _MessageBubble(
                      isMe: true,
                      name: l10n.sarraHarbi,
                      time: l10n.time1245,
                      text: l10n.elenaFlowers,
                    ),
                    const SizedBox(height: 12),
                    _MessageBubble(
                      isMe: false,
                      name: l10n.marcusConcierge,
                      time: l10n.time1245,
                      text: l10n.orchidProvidedMessage,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _Composer(theme: theme, l10n: l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
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

class _ChatHeader extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _ChatHeader({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFB88A1B), Color(0xFFD4AF37)],
              ),
            ),
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  // Use a short localized title if available, else fallback
                  l10n.lastConversations,
                  style: AppTextStyles.subtitle.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.eliteMembershipDesc,
                  style: AppTextStyles.bodyGrey.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String name;
  final String time;
  final String text;

  const _MessageBubble({
    required this.isMe,
    required this.name,
    required this.time,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryGold : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              name,
              style: AppTextStyles.tileTitle.copyWith(
                color: isMe ? Colors.black : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: AppTextStyles.bodyMain.copyWith(
                color: isMe ? Colors.black : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: AppTextStyles.tileCaption.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _Composer({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primaryGold,
          child: const Icon(Icons.send, color: Colors.black),
        ),
      ],
    );
  }
}
