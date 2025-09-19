import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_store.dart';
import 'package:run_it/run_it.dart';

class CFirebaseFcmHandler {
  String fcmDeviceNotificationTokenStoreKey = '9FYQ0AELPKyIvpt2e8dKfsN4ymcgjLvGngbB';
  String vapidKey = "BMmZi6lCcJKaXDuimSLC4kEhPzOqCLm34S6-AaOILNzrnQVlKfL5U2N3y4e32dDqsJR1CY0sWFfX0cnmsWIfbmY";

  String? get getDeviceToken => CStore.prefs.getString(fcmDeviceNotificationTokenStoreKey);

  static Future<void> mainInit() async {
    if (UserMv.isLoggedin) {
      await CFirebaseFcmHandler().reInit();
    }
  }

  Future<void> reInit() async {
    if (UserMv.isLoggedin) {
      FirebaseMessaging.instance
          .getToken(vapidKey: vapidKey)
          .then(
            (deviceToken) {
              Logger().t(["FCM DEVICE TOKEN", deviceToken]);
              if (deviceToken.isNotNull) _storeDeviceToken(deviceToken!);
            },
            onError: (err) {
              if (kDebugMode) Logger().e(["FCM DEVICE TOKEN ERROR", err]);
            },
          );

      // LISTEN TO DEVICE TOKEN CHANGE UPDATE.
      FirebaseMessaging.instance.onTokenRefresh
          .listen((fcmToken) {
            // Note: This callback is fired at each app startup and whenever a new
            // token is generated.
            if (kDebugMode) Logger().i(["FCM TOKEN REFRESHED:", fcmToken]);
            if (UserMv.isLoggedin) _storeDeviceToken(fcmToken);
          })
          .onError((err) {
            // Error getting token.
            Logger().e(["FCM TOKEN REFRESH ERROR:", err]);
          });
    }
  }

  void _storeDeviceToken(String deviceToken) {
    String? currentDeviceToken = getDeviceToken;
    if (currentDeviceToken != deviceToken && UserMv.isLoggedin) {
      Map<String, dynamic> params = {'loginToken': CApi.loginToken, 'fcmDeviceToken': deviceToken};
      var req = CApi.request.post('/fcm_notification/jT0kNSwVh', data: params);
      req.then((res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // STORE TOKEN TO LOCAL STORE
          CStore.prefs.setString(fcmDeviceNotificationTokenStoreKey, deviceToken);
        }
      }, onError: (e) {});
    }
  }

  void startListenOnMessageEvents() {
    FirebaseMessaging.onMessage.listen((message) {
      Logger().i({
        "type": 'ON MESSAGE',
        'message_title': message.notification?.title,
        'message_body': message.notification?.body,
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Logger().i({
        "type": 'ON MESSAGE APP OPENED',
        'message_title': message.notification?.title,
        'message_body': message.notification?.body,
      });
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      Logger().i({
        "type": 'ON BACKGROUND MESSAGE',
        'message_title': message.notification?.title,
        'message_body': message.notification?.body,
      });
    });
  }
}
