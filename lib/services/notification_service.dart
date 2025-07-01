import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:watertime/database/app_database.dart';
import 'package:watertime/services/notifications/notification_details.dart';


class NotificationService 
{
  static final _notifications = FlutterLocalNotificationsPlugin();

  final AppDatabase _database;

  NotificationService(this._database);


    static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );
    _createNotificationChannel();
  }

  static Future<void> scheduleWaterReminder
  ({
    required int id,
    required TimeOfDay time,
    required String amount,
  }) async {
    print("Scheduling water reminder: $id at ${time.hour}:${time.minute} for $amount ML");

try{
    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }
  print('Scheduling notification for: $scheduledTime');

    await _notifications.zonedSchedule(
      id,
      '💧 Water Reminder',
      'Time to drink $amount water!',
      scheduledTime,
      payload: jsonEncode({ // Important: Set proper payload
      'scheduled_time': scheduledTime.millisecondsSinceEpoch,
    }),
        NotificationDetails(
        android : AndroidNotificationDetails(
          'water_channel_v2',
          'Water Reminders',
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('alarm'),
          priority: Priority.high,
          playSound: true,
          visibility: NotificationVisibility.public,
          additionalFlags: Int32List.fromList(<int>[4]),
          fullScreenIntent: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
 );
print("Notification sucess");
} catch (e) {
    print("Error scheduling notification: $e");
  }
    

  }

  static Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }


   static Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'water_channel_v2',
      'Water Reminders',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
      description: 'Channel for water reminder notifications',
    );
    
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
  
    static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return result ?? false;
    } else if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return false;
  }


static Future<void> showTestNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'water_channel_v2',
    'Water Reminders',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );
  
  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  await _notifications.show(
    999,
    'Test Notification',
    'This is a test notification from your water reminder app',
    const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    ),
  );
}

 static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // // Get specific notification details by ID
  // Future<PendingNotificationRequest?> getNotificationById(int id) async {
  //   final notifications = await getPendingNotifications();
  //   return notifications.firstWhere((n) => n.id == id, orElse: () => null);
  // }

  
  // Get all scheduled notifications with details
 static Future<Map<int, NotificationDetailModel>> getAllScheduledNotifications() async {
    final pending = await getPendingNotifications();
    final Map<int, NotificationDetailModel> notifications = {};
    
    for (var notification in pending) 
    {
      try {
        final payload = notification.payload != null 
            ? jsonDecode(notification.payload!) 
            : {};
            
        final scheduledTime = payload is Map 
            ? (payload['scheduled_time'] as int? ?? 0)
            : 0;
            
        print('Notification ID: ${notification.id}, Scheduled Time: $scheduledTime');

            
        notifications[notification.id] = NotificationDetailModel(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          scheduledTime: scheduledTime > 0
              ? DateTime.fromMillisecondsSinceEpoch(scheduledTime)
              : null,
          reminderId: payload is Map ? payload['reminder_id'] as int? : null,
          waterML: payload is Map ? payload['water_ml'] as String? : null,
        );
      } catch (e) {
        print('Error parsing notification payload: $e');
        notifications[notification.id] = NotificationDetailModel(
          id: notification.id,
          title: notification.title,
          body: notification.body,
        );
      }
    }
    
    return notifications;
  }

static Future<void> deleteAllNotifications() async {
  
  try {
    // Cancel all pending notifications
    await _notifications.cancelAll();
    
    // Clear all delivered notifications (Android only)
    await _notifications.cancelAll(); // This clears delivered notifs on Android
    
    print('All notifications deleted successfully');
  } catch (e) {
    print('Error deleting notifications: $e');
    throw Exception('Failed to delete notifications: $e');
  }
}
  


}
