abstract class NotificationState {}

class NotificationInitial extends NotificationState {}
class NotificationSubmittingToken extends NotificationState {}
class NotificationTokenSubmittedSuccess extends NotificationState {}
class NotificationTokenSubmittedFailure extends NotificationState {
  final String errorMessage;
  NotificationTokenSubmittedFailure(this.errorMessage);
}