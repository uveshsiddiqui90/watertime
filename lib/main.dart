import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watertime/constants/pref_helper.dart';
import 'package:watertime/constants/theme.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/routes/app_pages.dart';
import 'package:watertime/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:watertime/services/reset_service/resetservice.dart';


void callback() {
  NotificationService.backgroundCallback();
}




void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); 
  await NotificationService.requestPermissions();
  await NotificationService.initialize();
  final db = AppDatabase(); 
  Get.put<AppDatabase>(db);
 // MyApp.deleteDbFile(); // Delete old DB file if exists
 MyApp.rescheduleAllNotifications();
 ResetService.scheduleMidnightReset();
  
  int step = await PrefHelper.getStep();

  String initialRoute;
  if (step == 1) {
    initialRoute = AppRoutes.BOARDING;     // Name Screen
  } else if (step == 2) {
    initialRoute = AppRoutes.GENDERSELECTION;   // Gender Screen
  } else if (step == 3) {
    initialRoute = AppRoutes.WEIGHT;   // Weight Screen
  } else {
    initialRoute = AppRoutes.HOME;     // Home Screen
  }
 runApp(MyApp(initialRoute: initialRoute,));
 print("🚀 App started with initial route: $initialRoute");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();


class MyApp extends StatelessWidget 
{
  final String initialRoute;
   const MyApp({super.key, required this.initialRoute});
 static final db = AppDatabase(); // Database instance

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return ScreenUtilInit(
      designSize: Size(360, 690), // Yeh tumhara base design size hota hai (jaise Figma/Adobe XD ka)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) 
      {
        return MediaQuery(
         data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0),),
         child: GetMaterialApp(
           title: 'Flutter Demo',
           initialRoute: initialRoute,//AppRoutes.BOARDING, 
           getPages: AppPages.routes,
          //  theme: ThemeData(
          //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // ),
          theme: waterTheme,
          debugShowCheckedModeBanner: false,
          //home: BoardingView()  
          ),
       );
      });
    
  }

  static Future<void> ensureUserExists() async {
  final user = await db.getLatestUser();
  if (user == null) {
    await db.insertUser("Test User", gender: "Male", weight: 70.0,consumedAmount: 200.0);
  }else {
    print("User already exists: ${user.name}");
  }
}

  static deleteDbFile() async 
  {
  final dir = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(dir.path, 'app.sqlite'));
  if (await dbFile.exists()) {
    await dbFile.delete();
    print("🔥 Deleted old DB");
  } else {
    print("📁 DB already deleted");
  }
}

static Future<void> rescheduleAllNotifications() async {
  var db = AppDatabase(); // Get the database instance
  final reminders = await db.getAllReminders();

  for (var reminder in reminders) {
    // TimeOfDay convert
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
}

static resetConsumedAmountTask() async {
  final db = AppDatabase();
  await db.updateConsumedAmount(0.0);
  print("✅ Consumed amount reset at midnight");
}


static scheduleMidnightReset() {
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1); // next 12:00 AM

  AndroidAlarmManager.oneShotAt(
      midnight,
    0, // unique id
    resetConsumedAmountTask,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}


static Future<void> forceMidnightTest() async {
  final db = AppDatabase();

  // ✅ Save "current" consumed amount into history (pretend it's yesterday)
  final user = await db.getLatestUser();
  if (user != null) {
    await db.addDailyHistory(user.consumedAmount ?? 0.0);
  }

  // ✅ Reset consumed amount
  await db.updateConsumedAmount(0.0, reset: true);

  print("🚀 Force midnight test done: History updated & amount reset");
}

}
