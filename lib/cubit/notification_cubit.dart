import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/core/api/api_consumer.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final ApiConsumer _api;

  NotificationCubit(this._api) : super(NotificationInitial());

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

        emit(NotificationTokenSubmittedSuccess());
        print("✔️ تم حفظ التوكن في السيرفر بنجاح ديناميكي!");
      } else {
        emit(NotificationTokenSubmittedFailure("فشل جلب التوكن من الفايربيز"));
      }
    } catch (e) {
      emit(NotificationTokenSubmittedFailure(e.toString()));
    }
  }
}