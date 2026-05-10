import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../generated/app_localizations.dart';

class OrdersChatsSection extends StatelessWidget {
  const OrdersChatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    final headlineColor = theme.colorScheme.onSurface;
    final mutedTextColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    final cardInnerColor = isDark
        ? AppColors.background
        : const Color(0xFFF5F5F5);
    final avatarBackground = isDark
        ? const Color(0xFF231F17)
        : AppColors.primaryGold.withValues(alpha: 0.12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 342,
            padding: const EdgeInsets.all(33),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.activeOrders,
                        style: const TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.myOrders,
                      style: TextStyle(
                        color: headlineColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: cardInnerColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.primaryGold.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 15,
                        decoration: BoxDecoration(
                          color: const Color(0xFF737373),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.corporateDinner,
                              style: TextStyle(
                                color: headlineColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.scheduledDate,
                              style: TextStyle(
                                color: mutedTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: avatarBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 342,
            padding: const EdgeInsets.all(33),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.lastConversations,
                  style: TextStyle(
                    color: headlineColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _ConversationRow(
                  time: AppLocalizations.of(context)!.time1245,
                  name: AppLocalizations.of(context)!.marcusConcierge,
                  message: AppLocalizations.of(context)!.menuCompletedMessage,
                  timeColor: mutedTextColor,
                  nameColor: headlineColor,
                  messageColor: mutedTextColor,
                  avatarBorderColor: const Color(0xFFF9C54D),
                  avatarBackground: avatarBackground,
                  showOnline: true,
                ),
                const SizedBox(height: 24),
                Opacity(
                  opacity: 0.7,
                  child: _ConversationRow(
                    time: AppLocalizations.of(context)!.yesterday,
                    name: AppLocalizations.of(context)!.elenaFlowers,
                    message: AppLocalizations.of(
                      context,
                    )!.orchidProvidedMessage,
                    timeColor: mutedTextColor,
                    nameColor: headlineColor,
                    messageColor: mutedTextColor,
                    avatarBorderColor: AppColors.primaryGold,
                    avatarBackground: isDark
                        ? const Color(0xFF1A1C21)
                        : AppColors.primaryGold.withValues(alpha: 0.08),
                    showOnline: false,
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

class _ConversationRow extends StatelessWidget {
  final String time;
  final String name;
  final String message;
  final Color timeColor;
  final Color nameColor;
  final Color messageColor;
  final Color avatarBorderColor;
  final Color avatarBackground;
  final bool showOnline;

  const _ConversationRow({
    required this.time,
    required this.name,
    required this.message,
    required this.timeColor,
    required this.nameColor,
    required this.messageColor,
    required this.avatarBorderColor,
    required this.avatarBackground,
    required this.showOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(time, style: TextStyle(color: timeColor, fontSize: 10)),
                  Text(name, style: TextStyle(color: nameColor, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.right,
                style: TextStyle(color: messageColor, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: avatarBorderColor, width: 2),
                color: avatarBackground,
              ),
              child: ClipOval(
                child: Container(
                  color: const Color(0xFFD4AF37),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            if (showOnline)
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A1C21),
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
