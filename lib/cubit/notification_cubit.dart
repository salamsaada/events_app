import 'package:eventsapp/models/notification_model.dart';
import 'package:eventsapp/repositories/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final ApiConsumer _api;
  final NotificationRepository _repository; 

  NotificationCubit(this._api, this._repository) : super(NotificationInitial());

  // 1. الدالة الخاصة بكِ لإرسال التوكن (كما هي)
  Future<void> uploadDeviceToken() async {
    emit(NotificationSubmittingToken());
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        print("🤖 جاري إرسال التوكن إلى السيرفر: $fcmToken");

        await _api.post(
          "/device-token", 
          data: {
            "device_token": fcmToken,
          },
        );

        //emit(NotificationTokenSubmittedSuccess());
        print("✔️ تم حفظ التوكن في السيرفر بنجاح ديناميكي!");
      } else {
        emit(NotificationTokenSubmittedFailure("فشل جلب التوكن من الفايربيز"));
      }
    } catch (e) {
      emit(NotificationTokenSubmittedFailure(e.toString()));
    }
  }

  // 2. دالة جلب الإشعارات من السيرفر
  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  // 3. دالة تحديد الإشعار كمقروء (بالتحديث المحلي السلس)
  Future<void> markAsRead(String id) async {
    if (state is NotificationsLoaded) {
      final currentNotifications = (state as NotificationsLoaded).notifications;
      final updatedList = currentNotifications.map((notif) {
        if (notif.id == id) {
          return NotificationModel(
            id: notif.id,
            title: notif.title,
            body: notif.body,
            isRead: true, 
            createdAt: notif.createdAt,
            data: notif.data,
          );
        }
        return notif; 
      }).toList();

      emit(NotificationsLoaded(updatedList));

      try {
        await _repository.markAsRead(id);
      } catch (e) {
        print("Error marking as read silently: $e");
      }
    }
  }
}