// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:watertime/services/notification_service.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📩 Background message: ${message.notification?.title}");
// }


// class FCMService {
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   /// Call this ONCE at app start
//   static Future<void> init() async {
//     // 🔐 Permission (Android 13+)
//     await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // 📲 Token
//     final token = await _fcm.getToken();
//     log("🔥 FCM TOKEN: $token");

//     // 🔄 Token refresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       log("🔁 FCM Token refreshed: $newToken");
//       // TODO: backend ko update bhejna
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print("📲 Foreground message received");

//   if (message.notification != null) {
//     NotificationService.showInstantNotification(
//       title: message.notification!.title ?? "Water Time",
//       body: message.notification!.body ?? "Drink water 💧",
//     );
//   }
// });
//   }

//   static Future<void> subscribeToAllUsers() async {
//     await FirebaseMessaging.instance.subscribeToTopic('all_users');
//     print("✅ Subscribed to all_users topic");
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:watertime/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.notification?.title}");
}




class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// 🔥 CALL ONLY AFTER runApp()
  static Future<void> init() async {
    try {
      // 🔐 Permission
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // ⚠️ TOKEN FETCH WITH TIMEOUT
      final token = await _fcm
          .getToken()
          .timeout(const Duration(seconds: 5));

      debugPrint("🔥 FCM TOKEN: $token");

      // 🔄 Token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("🔁 Token refreshed: $newToken");
      });

      // 📲 Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          NotificationService.showInstantNotification(
            title: message.notification!.title ?? "Water Time",
            body: message.notification!.body ?? "Drink water 💧",
          );
        }
      });
    } catch (e) {
      // ⚠️ NET OFF → SILENT FAIL
      debugPrint("⚠️ FCM init failed (offline): $e");
    }
  }

  /// 📡 Topic subscribe (SAFE)
  static Future<void> subscribeToAllUsers() async {
    try {
      await FirebaseMessaging.instance
          .subscribeToTopic('all_users')
          .timeout(const Duration(seconds: 5));

      debugPrint("✅ Subscribed to all_users");
    } catch (e) {
      debugPrint("⚠️ Topic subscribe skipped (offline)");
    }
  }
}

