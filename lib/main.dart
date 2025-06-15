import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/boarding/boarding_view.dart';
import 'package:watertime/presentation/routes/app_pages.dart';
import 'package:watertime/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); 
  await NotificationService.requestPermissions();
  await NotificationService.initialize();
  final db = AppDatabase(); 
  Get.put<AppDatabase>(db);
  runApp(const MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();




class MyApp extends StatelessWidget {
  const MyApp({super.key});
 

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
           initialRoute: AppRoutes.BOARDING,
           getPages: AppPages.routes,
           theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          debugShowCheckedModeBanner: false,
          home:  BoardingView(),
               ),
       );
      });
    
  }

}
