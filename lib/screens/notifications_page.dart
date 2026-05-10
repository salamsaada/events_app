import 'package:eventsapp/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _items = List.generate(
    6,
    (i) => {'id': i, 'type': i % 3, 'time': '${i + 1}', 'unread': i % 3 == 0},
  );

  String _title(AppLocalizations l10n, int id, int type) {
    switch (type) {
      case 0:
        return l10n.notificationReservationUpdated(id + 1);
      case 1:
        return l10n.notificationNewMessage(id + 1);
      default:
        return l10n.notificationReminder(id + 1);
    }
  }

  String _body(AppLocalizations l10n, int type) {
    switch (type) {
      case 0:
        return l10n.notificationBookingChanged;
      case 1:
        return l10n.notificationConciergeMessage;
      default:
        return l10n.notificationUpcomingEvent;
    }
  }

  void _markAllRead() {
    setState(() {
      for (var it in _items) {
        it['unread'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              l10n.notificationsMarkAllRead,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(child: Text(l10n.notificationsNoItems))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _items[index];

                return Dismissible(
                  key: ValueKey(item['id']),
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    color: Colors.redAccent,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() => _items.removeAt(index));
                  },
                  child: ListTile(
                    tileColor: item['unread']
                        ? theme.colorScheme.primary.withOpacity(0.06)
                        : null,
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(
                        0.12,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      _title(l10n, item['id'] as int, item['type'] as int),
                    ),
                    subtitle: Text(_body(l10n, item['type'] as int)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${item['time']}${l10n.notificationsHourSuffix}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (item['unread'])
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      setState(() => item['unread'] = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_body(l10n, item['type'] as int)),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
