import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/model/waterremind_model.dart';
import 'package:watertime/services/notification_service.dart';
import 'package:drift/drift.dart' as drift;


class Homecontroller extends GetxController
{

 RxString getSelectedTime = ''.obs;   
 RxString waterML = ''.obs;   
 RxList<WaterRemindModel> waterRemindList = <WaterRemindModel>[].obs;
 Rx<TextEditingController> waterMLController = TextEditingController().obs;
 RxInt nextId = 1.obs;
 Rx<DateTime> timeFornotification = DateTime.now().obs;
 double targetAmount = 2000.0;
 double consumedAmountuser = 800.0;
 var db = AppDatabase();

  
  @override
  void onInit() {
    super.onInit();
    // Initialize the notification service
    NotificationService.initialize();
    getAllRemindersfromDatabase(); 
     // Update next reminder every minute
    Timer.periodic(Duration(minutes: 1), (timer) {
    update(); // Triggers UI rebuild
  });
    // Set initial consumed amount
  }

  // Function to set the selected time
  void setSelectedTime(String time) {
    getSelectedTime.value = time;
  }

  // Function to set the amount of water in ML
  void setWaterML(String ml) {
    waterML.value = ml;
  }

  // Function to add a new water reminder

 addWaterRemind() async{
    if (waterMLController.value.text.isNotEmpty) {
      WaterRemindModel waterRemind = WaterRemindModel(
        time: getSelectedTime.value,
        waterML: waterMLController.value.text,
        timeOfDay:timeFornotification.value.isAfter(DateTime.now())
            ? TimeOfDay.fromDateTime(timeFornotification.value)
            : TimeOfDay.now(),
        id: nextId.value++, 
      );
     
    await db.insertReminder(RemindersCompanion(
    userId: drift.Value(1),
    title: drift.Value('Drink Water'),
    body: drift.Value('Time to stay hydrated!'),
    scheduledTime: drift.Value(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        (timeFornotification.value.isAfter(DateTime.now())
                ? TimeOfDay.fromDateTime(timeFornotification.value)
                : TimeOfDay.now()).hour,
        (timeFornotification.value.isAfter(DateTime.now())
                ? TimeOfDay.fromDateTime(timeFornotification.value)
                : TimeOfDay.now()).minute,
      ),
    ),
    reminderId: drift.Value(nextId.value++), 
    time: drift.Value(waterRemind.timeOfDay!.format(Get.context!)), // Use format method to get "HH:mm AM/PM"
    waterML: drift.Value(waterMLController.value.text),           // ✅ New field
  ));
   
   final reminders = await db.getAllReminders();
    waterRemindList.clear();
    for (var reminder in reminders) {
      waterRemindList.add(WaterRemindModel(
        time: reminder.scheduledTime.toString(),
        waterML: reminder.waterML,
        timeOfDay: TimeOfDay(hour: reminder.scheduledTime.hour, minute: reminder.scheduledTime.minute),
        id: reminder.id,
        isActive: reminder.isActive,
      ));

       // Sort the list
      waterRemindList.sort((a, b) {
      final aMinutes = a.timeOfDay!.hour * 60 + a.timeOfDay!.minute;
      final bMinutes = b.timeOfDay!.hour * 60 + b.timeOfDay!.minute;
      return aMinutes.compareTo(bMinutes);
    });
/// 🔄 Get latest reminder from DB (trustable)
    final allReminders = await db.getAllReminders();
    final newReminder = allReminders.last;

   waterRemindList.refresh();
      
      //_scheduleNotification(waterRemind);
      scheduleNotificationFromDB(newReminder);
      waterMLController.value.clear();

      

    }
 } 
    else {
      Get.snackbar('Error', 'Please enter the amount of water in ML');
    }
   }

   Future<void> _scheduleNotification(WaterRemindModel reminder) async {
    await NotificationService.scheduleWaterReminder(
      id: reminder.id!, // Using the model's ID
      time: reminder.timeOfDay!, // Using TimeOfDay from model
      amount: reminder.waterML!, // Using amount from model
    );
    
  }


Future<void> scheduleNotificationFromDB(Reminder reminder) async {
  final time = TimeOfDay(
    hour: reminder.scheduledTime.hour,
    minute: reminder.scheduledTime.minute,
  );

  await NotificationService.scheduleWaterReminder(
    id: reminder.reminderId ?? reminder.id,
    time: time,
    amount: reminder.waterML,
  );
}


  void deleteNotification(int id) {
    waterRemindList.removeWhere((r) => r.id == id);
    NotificationService.cancelReminder(id);
    }

 void getAllRemindersfromDatabase() async {
    final reminders = await db.getAllReminders();
    waterRemindList.clear();
    for (var reminder in reminders) {
      waterRemindList.add(WaterRemindModel(
        time: reminder.scheduledTime.toString(),
        waterML: reminder.waterML ?? '0', // Default to '0' if null
        timeOfDay: TimeOfDay(hour: reminder.scheduledTime.hour, minute: reminder.scheduledTime.minute),
        id: reminder.id,
        isActive: reminder.isActive,
      ));
    }
    waterRemindList.refresh();

   print('Fetched ${waterRemindList.length} reminders from database');

 }
    @override
  void onClose() {
    NotificationService.cancelAllReminders();
    super.onClose();
  }

  void clearWaterRemindList() {
    waterRemindList.clear();
  }



 RxDouble totalWater = 2.0.obs;

 void addWater(double amount) {
    totalWater.value += amount;
    if (totalWater.value > 3.0) {
      totalWater.value = 3.0;
    }
  }

void getAllNotificationDetails() async {
    final notifications = await NotificationService.getAllScheduledNotifications();
    for (var notification in notifications.values) {
      print('Notification ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body},Time: ${notification.scheduledTime} , Reminder ID: ${notification.reminderId}, ${notification.waterML}');
      
      
    }
  }


  

WaterRemindModel? get nextReminder {
  if (waterRemindList.isEmpty) return null;
  
  final now = DateTime.now();
  final currentTime = TimeOfDay.fromDateTime(now);
  
  // Filter active reminders and convert to DateTime for comparison
  final upcomingReminders = waterRemindList.where((reminder) {
    final reminderTime = reminder.timeOfDay;
    final reminderDateTime = DateTime(
      now.year, 
      now.month, 
      now.day, 
      reminderTime!.hour, 
      reminderTime.minute
    );
    return reminderDateTime.isAfter(now) || 
           (reminderTime.hour > currentTime.hour || 
           (reminderTime.hour == currentTime.hour && 
            reminderTime.minute > currentTime.minute));
  }).toList();
  
  if (upcomingReminders.isEmpty) return null;
  
  // Sort to find the earliest one
  upcomingReminders.sort((a, b) {
    final aMinutes = a.timeOfDay!.hour * 60 + a.timeOfDay!.minute;
    final bMinutes = b.timeOfDay!.hour * 60 + b.timeOfDay!.minute;
    return aMinutes.compareTo(bMinutes);
  });
  
  return upcomingReminders.first;
}



String getTimeRemaining(TimeOfDay reminderTime) {
  final now = TimeOfDay.now();
  final nowInMinutes = now.hour * 60 + now.minute;
  final reminderInMinutes = reminderTime.hour * 60 + reminderTime.minute;
  
  var diff = reminderInMinutes - nowInMinutes;
  if (diff < 0) diff += 1440; // Add 24 hours if negative
  
  final hours = diff ~/ 60;
  final minutes = diff % 60;
  
  if (hours > 0) {
    return '$hours h $minutes m';
  } else {
    return '$minutes minutes';
  }
}

void deleteAllReminders() async {
  await db.deleteAllReminders();
  waterRemindList.clear();
  NotificationService.cancelAllReminders();
  Get.snackbar('Success', 'All reminders deleted successfully');


}

}