import 'package:eventsapp/cubit/notification_cubit.dart';
import 'package:eventsapp/cubit/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/generated/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          if (state is NotificationsError) {
            return Center(child: Text(state.message));
          } 

          if (state is NotificationsLoaded) {
            final items = state.notifications;

            if (items.isEmpty) {
              return Center(child: Text(l10n.notificationsNoItems));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  tileColor: !item.isRead
                      ? theme.colorScheme.primary.withOpacity(0.06)
                      : null,
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                    child: Icon(
                      Icons.notifications,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.body),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.createdAt.length >= 10 
                            ? item.createdAt.substring(0, 10) 
                            : item.createdAt,
                        style: theme.textTheme.bodySmall,
                      ),
                      if (!item.isRead)
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
                    if (!item.isRead) {
                      context.read<NotificationCubit>().markAsRead(item.id);
                    }
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}