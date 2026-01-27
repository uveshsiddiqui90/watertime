import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:watertime/constants/app_color.dart';
import 'package:watertime/constants/app_image.dart';
import 'package:watertime/constants/waterprogress_indicator/water_progress.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/home/homecontroller.dart';
import 'package:watertime/presentation/routes/app_pages.dart';

class HomeView extends StatelessWidget 
{
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final WaterController waterController = Get.put(WaterController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var db = AppDatabase();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) 
    {
      waterController.updateConsumedAmount(homecontroller.waterConsumed.value.toDouble());
      waterController.updateTargetAmount(homecontroller.targetAmount.value.toDouble());
    });
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 150.h,
          child: DrawerHeader(
            decoration: BoxDecoration(
               gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
            ),
            ),
            curve: Curves.easeInOut,
            child: Padding(
              padding:  EdgeInsets.only(top: 20.h),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Card(
           shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
       elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),

          child: ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Get.toNamed(AppRoutes.USERHISTORY);
            },
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
       elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Get.toNamed(AppRoutes.SETTING);

         },
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
       elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('LogOut'),
            onTap: () {
              homecontroller.deleteDbFile();

                         },
          ),
        ),

      ],
    ),
  ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                right: 20.w,
                top: 20.h,
                child: InkWell(
                  onTap: () 
                  {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(Icons.settings, size: 30, color: Colors.blueAccent,))),
              
              Column(
                
                children: [
                  WaterLevelWidget(),
                  SizedBox(height: 20.h),
                   Obx(
                     () {
                       final now = homecontroller.currentTime.value; 
                       final nextReminder = homecontroller.getNextReminder(homecontroller.waterRemindList);
                       
                           if (nextReminder != null) {
                           DateTime  reminderTime = DateTime(
                               now.year,
                               now.month,
                               now.day,
                               nextReminder.timeOfDay!.hour,
                               nextReminder.timeOfDay!.minute,
                             );
                   
                             if (reminderTime.isBefore(now)) {
                               reminderTime = reminderTime.add(Duration(days: 1));
                             }
                            
                              }
                        return Container(
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(                          
                          child: Padding(
                            padding:  EdgeInsets.only(top: 15.h),
                            child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text.rich(
                                 TextSpan(
                              children: [
                                  TextSpan(
                                 text: "Hello ${homecontroller.userName.toUpperCase()}", // Heading part
                                 style: TextStyle(
                                   fontSize: 18.sp,
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w700,
                                   color: Color(0xFF2F80ED),
                                   // Royal Blue (Heading)
                                 ),),
                               
                               TextSpan(
                                 text: "\nTap + to Log your Next Glass 💧",
                                 style: TextStyle(
                                   fontSize: 15.sp,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.indigoAccent,
                                   fontStyle: FontStyle.italic

                                   
                                    
                                 ),
                               ),
                                                           ],
                                                         ),
                                                         textAlign: TextAlign.center,
                                                       ),
                                                    
                              SizedBox(height: 10.h),
                              homecontroller.waterRemindList.isEmpty ? SizedBox():
                              Text(
                                homecontroller.waterRemindList.isEmpty
                                    ? ""
                                    :
                                                    
                                "${nextReminder?.timeOfDay!.format(context)} - ${nextReminder?.waterML} ml",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                )),
                              SizedBox(height: 10.h),
                              homecontroller.waterRemindList.isEmpty ? SizedBox():
                              Text(
                                "In ${homecontroller.getTimeRemaining(nextReminder?.timeOfDay?? TimeOfDay.now())}",
                             
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              
                            ],
                            ),
                          ),
                        ),
                                               );
                     
                     
                    }),

                    SizedBox(height: 20.h),

                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200.h,
                        decoration: BoxDecoration(
                        
                      //  color: Colors.orange,
                       gradient: LinearGradient(
                      colors: [
                        Color(0xFFE0F7FA), // Soft Light Cyan
                        Color(0xFFB2EBF2), // Aqua Tint
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                        ),
                       child: Center(
                          child: IconButton(onPressed: (){
                             
                             if(homecontroller.waterConsumed.value < homecontroller.targetAmount.value)
                             {
                              homecontroller.addWater(200); // You should have this function
                              db.updateConsumedAmount(200);
                              homecontroller.playAddWaterAnimation(200);
                              homecontroller.showLottie.value = true;
                              Future.delayed(const Duration(seconds: 3), () {
                                homecontroller.showLottie.value = false;
                              });

                              }else{
                                homecontroller.playGoalCompletedAnimation();

                              } 
                                


                              

                                                 
                          }, icon: Image.asset(AppImage.addwater, width: 200.w, height: 200.h
                         ),
                         
                          
                  
              ))))],
               ),
               

                     waterAddedAnimation(),
                    
                     achievementAnimateion()
                   

                   
  
  
  ],
          ),
        ),
      ),
    );
  }

  Widget buildTimePicker(BuildContext context, Homecontroller homecontroller) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          SizedBox(height: 20),
          TimePickerSpinner(
            is24HourMode: false,
            time: DateTime.now(),
            itemWidth: 60,
            itemHeight: 80,
            alignment: Alignment.center,
            isShowSeconds: false,
            normalTextStyle: TextStyle(fontSize: 24, color: Colors.grey[400]),
            highlightedTextStyle: TextStyle(
              fontSize: 32,
              color: Colors.blue[800],
              fontWeight: FontWeight.w600,
            ),
            spacing: 20,
            minutesInterval: 1, 
            onTimeChange: (time) {          
               final formattedTime = DateFormat('hh : mm a').format(time);
              homecontroller.getSelectedTime.value = formattedTime;
              homecontroller.timeFornotification.value = time;
              }
      )
        ]));
  }


 


Widget floatingText(String text) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 800),
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, -30 * value),
        child: Opacity(
          opacity: 1 - value,
          child: Text(
            text,

            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontStyle: FontStyle.italic,

            ),
          ),
        ),
      );
    },
  );
}



Widget achievementAnimateion() {

  return Obx(() {
  if (!homecontroller.showGoalAnimation.value) {
    return const SizedBox.shrink();
  }

  return Positioned.fill(
    child: IgnorePointer(
      ignoring: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // dark overlay
          Container(color: Colors.black.withOpacity(0.35)),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎉 CONFETTI / SUCCESS LOTTIE
              Lottie.asset(
                'assets/lottie/lottie_animate.json',
                fit: BoxFit.cover,
                repeat: false,
              ),

              const SizedBox(height: 16),

              // 🏆 TEXT
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Text(
                      'Daily Goal Completed 🎉',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
});

            
}


Widget waterAddedAnimation() {
  return Obx(() {
    if (!homecontroller.showLottie.value) {
      return const SizedBox.shrink();
    }

  return Positioned.fill(
    child: IgnorePointer(
      ignoring: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // dark overlay
          Container(color: Colors.black.withOpacity(0.35)),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎉 CONFETTI / SUCCESS LOTTIE
              Lottie.asset(
                'assets/lottie/lottie_animate.json',
                fit: BoxFit.cover,
                repeat: false,
              ),

              const SizedBox(height: 16),

              // 🏆 TEXT
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Text(
                      'Water Added 200 ml 🎉',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
});

}
}