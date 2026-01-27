import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/main.dart';
import 'package:watertime/model/waterremind_model.dart';
import 'package:watertime/presentation/routes/app_pages.dart';
import 'package:watertime/services/fcm_service.dart';
import 'package:watertime/services/notification_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as p;

class Homecontroller extends GetxController
{

 RxString getSelectedTime = ''.obs;   
 RxString waterML = ''.obs;   
 RxList<WaterRemindModel> waterRemindList = <WaterRemindModel>[].obs;
 Rx<TextEditingController> waterMLController = TextEditingController().obs;
 RxInt nextId = 1.obs;
 Rx<DateTime> timeFornotification = DateTime.now().obs;
 RxInt targetAmount = 0.obs;
 var db = AppDatabase();
 RxString userName = ''.obs;
 RxDouble waterConsumed = 0.0.obs;
 WaterController waterController = Get.put(WaterController());
 Rx<DateTime> currentTime = DateTime.now().obs;  // 🔥 Add this
 RxInt reminderId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the notification service
    NotificationService.initialize();
    getAllRemindersfromDatabase(); 
    getUserData();
     // Update next reminder every minute
     getConsumedAmount();
     
    Timer.periodic(Duration(minutes: 1), (timer) {
    update(); // Triggers UI rebuild
  });
  ever(currentTime, (_) {}); // just to trigger Obx rebuild
    Stream.periodic(Duration(seconds: 1), (_) => DateTime.now())
        .listen((now) {
      currentTime.value = now;
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
// addWaterRemind() async {
//   if (waterMLController.value.text.isEmpty) {
//     Get.snackbar(
//       'Error',
//       'Please enter the amount of water in ML',
//       snackPosition: SnackPosition.TOP,
//     );
//     return;
//   }

//   final now = DateTime.now();
//   final selected = timeFornotification.value;

//   // Adjust scheduledTime to next day if selected time is before now
//   DateTime scheduledTime = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     selected.hour,
//     selected.minute,
//   );

//   if (!scheduledTime.isAfter(now)) {
//     // Add 1 day if selected time is earlier than now
//     scheduledTime = scheduledTime.add(Duration(days: 1));
//   }

//   // Double-check: Scheduled time must still be in future
//   if (!scheduledTime.isAfter(now)) {
//     Get.snackbar(
//       'Invalid Time',
//       'Please select a valid future time',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//     );
//     return;
//   }

//   WaterRemindModel waterRemind = WaterRemindModel(
//     time: getSelectedTime.value,
//     waterML: waterMLController.value.text,
//     timeOfDay: TimeOfDay.fromDateTime(scheduledTime),
//     id: nextId.value++,
//   );

//   await db.insertReminder(RemindersCompanion(
//     userId: drift.Value(1),
//     title: drift.Value('Drink Water'),
//     body: drift.Value('Time to stay hydrated!'),
//     scheduledTime: drift.Value(scheduledTime),
//     reminderId: drift.Value(nextId.value++),
//     time: drift.Value(waterRemind.timeOfDay!.format(Get.context!)),
//     waterML: drift.Value(waterMLController.value.text),
//   ));

//   final reminders = await db.getAllReminders();
//   waterRemindList.clear();

//   for (var reminder in reminders) {
//     waterRemindList.add(WaterRemindModel(
//       time: reminder.scheduledTime.toString(),
//       waterML: reminder.waterML,
//       timeOfDay: TimeOfDay(
//         hour: reminder.scheduledTime.hour,
//         minute: reminder.scheduledTime.minute,
//       ),
//       id: reminder.id,
//       isActive: reminder.isActive,
//     ));
//   }

//   // Sort reminders by time
//   waterRemindList.sort((a, b) {
//     final aMinutes = a.timeOfDay!.hour * 60 + a.timeOfDay!.minute;
//     final bMinutes = b.timeOfDay!.hour * 60 + b.timeOfDay!.minute;
//     return aMinutes.compareTo(bMinutes);
//   });

//   waterRemindList.refresh();

//   final newReminder = reminders.last;
//   scheduleNotificationFromDB(newReminder);

//   waterMLController.value.clear();
// }

// Function to add a new water reminder
addWaterRemind() async {
  if (waterMLController.value.text.isEmpty) {
    Get.snackbar(
      'Error',
      'Please enter the amount of water in ML',
      snackPosition: SnackPosition.TOP,
    );
    return;
  }

  final now = DateTime.now();
  final selected = timeFornotification.value;

  // Adjust scheduledTime to next day if selected time is before now
  DateTime scheduledTime = DateTime(
    now.year,
    now.month,
    now.day,
    selected.hour,
    selected.minute,
  );

  if (!scheduledTime.isAfter(now)) {
    // Add 1 day if selected time is earlier than now
    scheduledTime = scheduledTime.add(Duration(days: 1));
  }

  // Double-check: Scheduled time must still be in future
  if (!scheduledTime.isAfter(now)) {
    Get.snackbar(
      'Invalid Time',
      'Please select a valid future time',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
    );
    return;
  }
 // reminderId.value = nextId.value++;

  WaterRemindModel waterRemind = WaterRemindModel(
    time: getSelectedTime.value,
    waterML: waterMLController.value.text,
    timeOfDay: TimeOfDay.fromDateTime(scheduledTime),
    //id: reminderId.value
  );

  // await db.insertReminder(RemindersCompanion(
  //   userId: drift.Value(1),
  //   title: drift.Value('Drink Water'),
  //   body: drift.Value('Time to stay hydrated!'),
  //   scheduledTime: drift.Value(scheduledTime),
  //   reminderId: drift.Value(reminderId.value),
  //   time: drift.Value(waterRemind.timeOfDay!.format(Get.context!)),
  //   waterML: drift.Value(waterMLController.value.text),
  // ));

  final id = await db.into(db.reminders).insert(
    RemindersCompanion(
      userId: drift.Value(1),
      title: drift.Value('Drink Water'),
      body: drift.Value('Time to stay hydrated!'),
      scheduledTime: drift.Value(scheduledTime),
      // ❌ reminderId save nahi karna
      time: drift.Value(waterRemind.timeOfDay!.format(Get.context!)),
      waterML: drift.Value(waterMLController.value.text),
    ),
  );


  final reminders = await db.getAllReminders();
  waterRemindList.clear();

  for (var reminder in reminders) {
    waterRemindList.add(WaterRemindModel(
      time: reminder.scheduledTime.toString(),
      waterML: reminder.waterML,
      timeOfDay: TimeOfDay(
        hour: reminder.scheduledTime.hour,
        minute: reminder.scheduledTime.minute,
      ),
      id: reminder.id,
      isActive: reminder.isActive,
    ));
  }

  // ✅ FIXED SORTING (future reminders first, past ones shifted to next day)
  waterRemindList.sort((a, b) {
    final now = DateTime.now();

    final aDT = DateTime(now.year, now.month, now.day, a.timeOfDay!.hour, a.timeOfDay!.minute);
    final aAdjusted = aDT.isBefore(now) ? aDT.add(Duration(days: 1)) : aDT;

    final bDT = DateTime(now.year, now.month, now.day, b.timeOfDay!.hour, b.timeOfDay!.minute);
    final bAdjusted = bDT.isBefore(now) ? bDT.add(Duration(days: 1)) : bDT;

    return aAdjusted.compareTo(bAdjusted);
  });

  waterRemindList.refresh();

  final newReminder = reminders.last;
  scheduleNotificationFromDB(newReminder);

  waterMLController.value.clear();
}





WaterRemindModel? getNextReminder(List<WaterRemindModel> reminders) {
  final now = DateTime.now();

  final upcoming = reminders.where((reminder) {
    final reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminder.timeOfDay?.hour ?? 0,
      reminder.timeOfDay?.minute ?? 0,
    );

    final adjustedTime = reminderTime.isBefore(now)
        ? reminderTime.add(Duration(days: 1))
        : reminderTime;

    return adjustedTime.isAfter(now);
  }).toList();

  if (upcoming.isEmpty) return null;

  upcoming.sort((a, b) {
    final aDT = DateTime(now.year, now.month, now.day, a.timeOfDay!.hour, a.timeOfDay!.minute);
    final bDT = DateTime(now.year, now.month, now.day, b.timeOfDay!.hour, b.timeOfDay!.minute);

    final aAdjusted = aDT.isBefore(now) ? aDT.add(Duration(days: 1)) : aDT;
    final bAdjusted = bDT.isBefore(now) ? bDT.add(Duration(days: 1)) : bDT;

    return aAdjusted.compareTo(bAdjusted);
  });

  return upcoming.first;
}




Future<void> scheduleNotification(WaterRemindModel reminder) async {

    await NotificationService.scheduleWaterReminder(
      id: reminder.id!, // Using the model's ID
      time: reminder.timeOfDay!, // Using TimeOfDay from model
      amount: reminder.waterML!, // Using amount from model
    );
    print("Scheduling notification for ID: ${reminder.id}, Time: ${reminder.timeOfDay}, Amount: ${reminder.waterML}");


   final now = DateTime.now();
        final scheduledDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          reminder.timeOfDay!.hour,
          reminder.timeOfDay!.minute,
        );

        final finalSchedule = scheduledDateTime.isBefore(now)
            ? scheduledDateTime.add(Duration(days: 1))
            : scheduledDateTime;

        await AndroidAlarmManager.oneShotAt(
          finalSchedule,
          reminder.id!,
          callback,
          exact: true,
          wakeup: true,
          rescheduleOnReboot: true,
        );

  }


Future<void> scheduleNotificationFromDB(Reminder reminder) async 
{
  final time = TimeOfDay(
    hour: reminder.scheduledTime.hour,
    minute: reminder.scheduledTime.minute,
   );

  await NotificationService.scheduleWaterReminder(
    id:  reminder.id,  //reminder.reminderId ?? reminder.id,
    time: time,
    amount: reminder.waterML,
  );
}


  void deleteNotification(int id) {
    print("Deleting notification with ID: $id");
    print("Current reminders before deletion: ${waterRemindList.map((r) => r.id).toList()}");
    waterRemindList.removeWhere((r) => r.id == id);
    NotificationService.cancelReminder(id);
    AndroidAlarmManager.cancel(id);        
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






String formatTime(TimeOfDay? time) {
  if (time == null) return '--:--';

  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';

  return '${hour.toString().padLeft(2, '0')}:$minute $period';
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
    waterConsumed.value += amount;
    waterController.updateConsumedAmount(waterConsumed.value);
    print('Water added: $amount ml, Total: ${waterConsumed.value} ml');
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

int calculateWaterTarget({required double weightInKg, required String gender}) 
{
  if (gender.toLowerCase() == 'male') {
    return (weightInKg * 35).round(); // ml
  } else {
    return (weightInKg * 31).round(); // ml
  }
}

RxDouble userWeight = 70.0.obs; 
RxString selectedGender = ''.obs;

 Future<void> getUserData() async {
  final user = await db.getLatestUser();  // or getUserById(1)
  print('user data retrieved: $user');
  if (user != null) {
    userName.value = user.name ?? '';
    userWeight.value = user.weight ?? 70.0; // Default weight if null
    
    if(user.gender =='male'){
      selectedGender.value = 'male';
      }else{
        selectedGender.value = 'female';
      }

    print('User data retrieved:${user.weight}');
    print('User data retrieved:${user.gender}');
    print(user.name);  // name, weight, gender etc.
  }
  print("value of calculate water Target: ${calculateWaterTarget(weightInKg: user?.weight??70.0, gender: user?.gender??'')}");
 
  targetAmount.value = calculateWaterTarget(
    weightInKg: user?.weight ?? 70.0,
    gender: user?.gender??''

  );

  waterController.updateConsumedAmount(0.0);
  waterController.updateTargetAmount(targetAmount.value.toDouble());
  
}



void waterConsumedToday(String waterIntake) async {
  
  double totalConsumed = double.parse(waterIntake); 
  print('Total water consumed today: $totalConsumed ml');
  }



Future<double> getConsumedAmount() async {
  final user = await db.getLatestUser();

  print('Consumed Amount: ${user?.consumedAmount}');
  waterConsumed.value = user?.consumedAmount ?? 0.0;
  waterController.updateConsumedAmount(waterConsumed.value);
  return user?.consumedAmount ?? 0.0;
}


Future<void> clearHistory() async {
  final user = await db.getLatestUser();
  if (user != null) {
    await (db.update(db.users)..where((u) => u.id.equals(user.id))).write(
      UsersCompanion(
       historyJson: drift.Value(jsonEncode([]) as String?),// history empty
      ),
    );
  }
}

 Future<void> deleteDbFile() async 
  {
  final dir = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(dir.path, 'app.sqlite'));
  if (await dbFile.exists()) {
    await dbFile.delete().then((_) {
      print("entered delete db file");

      clearPrefData();
      Get.offAllNamed(AppRoutes.BOARDING);
      
    });
    print("🔥 Deleted old DB");
  } else {
    print("📁 DB already deleted");
  }
}

  Future<void> clearPrefData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // saara local data remove karega
  }



  RxBool showLottie = false.obs;

void playLottie() {
  showLottie.value = true;

  Future.delayed(const Duration(seconds: 2), () {
    showLottie.value = false;
  });
}



  final addedML = 0.obs;

  void playAddWaterAnimation(int ml) {
    addedML.value = ml;
    showLottie.value = true;

    // auto hide after animation
    Future.delayed(const Duration(seconds: 3), () {
      showLottie.value = false;
    });
  }

final showGoalAnimation = false.obs;
void playGoalCompletedAnimation() {
    showGoalAnimation.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      showGoalAnimation.value = false;
    });
  }


  Future<void> _initFCMAfterUI() async {
    try {
      await Firebase.initializeApp();

      await FCMService.init();
      await FCMService.subscribeToAllUsers();

      debugPrint("✅ FCM initialized safely after UI");
    } catch (e) {
      debugPrint("⚠️ FCM skipped (offline / error): $e");
    }
  }

  @override
  void onReady() {
    super.onReady();

    // 🔥 UI ke baad FCM init
    Future.delayed(const Duration(seconds: 2), () async {
      await _initFCMAfterUI();
    });
  }


String getGreetingText(double percent) 
{
  if (percent == 0) return "Let’s start your hydration today 💧";
  if (percent < 50) return "Good progress, keep sipping 💙";
  if (percent < 100) return "Almost there! Stay hydrated 🚀";
  return "Goal achieved! Amazing job 🏆";
}

}

