import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/home/homeview.dart';
import 'package:watertime/presentation/routes/app_pages.dart';
import 'package:watertime/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); 
  await NotificationService.requestPermissions();
  await NotificationService.initialize();
  final db = AppDatabase(); 
  Get.put<AppDatabase>(db);
 // MyApp.deleteDbFile(); // Delete old DB file if exists
 MyApp.rescheduleAllNotifications();
  runApp( MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();




class MyApp extends StatelessWidget 
{
   MyApp({super.key});
 var db = AppDatabase(); // Database instance

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
           initialRoute: AppRoutes.HOME,  //AppRoutes.BOARDING,
           getPages: AppPages.routes,
           theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          debugShowCheckedModeBanner: false,
          home:  HomeView()//BoardingView(),
       ),
       );
      });
    
  }

  static deleteDbFile() async {
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

  print("🔁 All reminders rescheduled from DB");
}



}
