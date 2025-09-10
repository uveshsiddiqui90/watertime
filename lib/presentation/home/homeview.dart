import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watertime/constants/app_color.dart';
import 'package:watertime/constants/waterprogress_indicator/water_progress.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';
import 'package:watertime/presentation/home/homecontroller.dart';
import 'package:watertime/presentation/routes/app_pages.dart';

class HomeView extends StatelessWidget 
{
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final WaterController waterController = Get.put(WaterController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              AppRoutes.SETTING;
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
                        child: Padding(
                         padding:  EdgeInsets.all(homecontroller.waterRemindList.isEmpty? 20.0:8.0),
                         child: Center(                          
                           child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                             children: [
                                 TextSpan(
                                text: "Hello ${homecontroller.userName.toUpperCase()}, ", // Heading part
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F80ED),
                                  
                                   // Royal Blue (Heading)
                                ),
                                
                              ),
                              TextSpan(
                                text: homecontroller.waterRemindList.isEmpty
                                    ? "No Reminder Set" // Subtitle if empty
                                    : "Next Reminder", // Subtitle if not empty
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF555555),
                                  
                                   
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
                        child: Obx(
                          () => ListView.builder(
                            itemCount: homecontroller.waterRemindList.length,
                            itemBuilder: (context, index) {
                              if (index >= homecontroller.waterRemindList.length) {
                                return SizedBox.shrink();
                              }
                              final reminder = homecontroller.waterRemindList[index];
                              
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 80.h,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(
                                        0,
                                        3,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        homecontroller.formatTime(homecontroller.waterRemindList[index].timeOfDay),
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          '${homecontroller.waterRemindList[index].waterML} ml',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        homecontroller.deleteNotification(reminder.id!);
                                        homecontroller.db.deleteReminder(reminder.id!);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  
                ],
              ),
              
              Positioned(
                bottom: 50.h,
                left: 20.w,
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 30),
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            height: 600.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Add Water Intake",
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.textColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: AppColor.textColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    buildTimePicker(context, homecontroller),
                                    // SizedBox(width: 20),
                                    SizedBox(
                                      width: 70,
                                      child: TextField(
                                        controller: homecontroller.waterMLController.value,
                                        decoration: InputDecoration(
                                          labelText: 'Add ml',
                                          labelStyle: TextStyle(
                                            color: AppColor.textColor,
                                            fontSize: 13,
                                          ),
        
                                          // This gives just the bottom border
                                          border: UnderlineInputBorder(),
                                          // Optional: Customize the border color
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.indigo,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          homecontroller.waterML.value = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColor.buttonColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                  

                                          if (homecontroller.waterML.value.isEmpty) {
                                            Get.snackbar(
                                              "Error",
                                              "Please enter water intake amount",
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.redAccent,
                                              colorText: const Color.fromRGBO(255, 255, 255, 1),
                                              duration: const Duration(seconds: 2),
                                            );
                                            return;
                                          }
                                                homecontroller.addWaterRemind();
                                          Get.back();
                                    },
                                        child: Text(
                                          'Add Intake',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barrierColor: Colors.black54, // Optional: semi-transparent background
                          isDismissible: true, // Can close by tapping outside
                          enableDrag: true, // Can swipe down to close
                        );
                      },
                    ),
                  ),
                ),
              ),
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
  }
            
          
