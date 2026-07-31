import 'package:eventsapp/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

// --- حالات إرسال التوكن ---
class NotificationSubmittingToken extends NotificationState {}
class NotificationTokenSubmittedSuccess extends NotificationState {}
class NotificationTokenSubmittedFailure extends NotificationState {
  final String errorMessage;
  NotificationTokenSubmittedFailure(this.errorMessage);
}

// --- حالات جلب الإشعارات ---
class NotificationsLoading extends NotificationState {}
class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationsLoaded(this.notifications);
}
class NotificationsError extends NotificationState {
  final String message;
  NotificationsError(this.message);
}