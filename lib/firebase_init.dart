import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:wera_f2/firebase_options.dart'; // Missing file can be generated using the flutterfire command
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/server_query.dart';

void firebaseInit() async {
  return; // Enable Firebase by removing this line

  final GlobalController global = Get.find();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken;

  if (kIsWeb) {
    await messaging.requestPermission(provisional: true);
    fcmToken = await messaging.getToken(vapidKey: global.vapid!);
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    await FlutterNotificationChannel.registerNotificationChannel(
      name: 'Main',
      description: 'Event updates',
      id: 'updates',
      importance: NotificationImportance.IMPORTANCE_HIGH,
    );

    fcmToken = await messaging.getToken();
  }

  if (fcmToken != null) {
    await query(
      link: "fcm-token",
      type: RequestType.post,
      params: {
        "user_id": global.userId!,
        "fcm_token": fcmToken,
      }
    );
  }
}