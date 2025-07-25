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
import 'package:watertime/services/notification_service.dart';

class HomeView extends StatelessWidget 
{
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final WaterController waterController = Get.put(WaterController());
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) 
    {
      waterController.updateConsumedAmount(180.0);
      waterController.updateTargetAmount(homecontroller.targetAmount.value.toDouble());
    });
    return Scaffold(
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
                  onTap: () {
                    Get.toNamed(AppRoutes.SETTING); // Navigate to settings page
                  },
                  child: Icon(Icons.settings, size: 30, color: Colors.blueAccent,))),
              Column(
                
                children: [
                  WaterLevelWidget(),
                  SizedBox(height: 20.h),
                   Obx(
                     () {
                       final nextReminder = homecontroller.getNextReminder(homecontroller.waterRemindList);
                       
                           if (nextReminder != null) {
                             final now = DateTime.now();
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
                            
                            final remaining = reminderTime?.difference(now);
                              }
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                           decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.indigo ),
                                                 child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(children: [
                             SizedBox(height: 5.h),
                             Text(
                               homecontroller.waterRemindList.isEmpty
                                   ? "Hello ${homecontroller.userName.toUpperCase()}, No Reminders Set"
                                   : 
                               "Hello ${homecontroller.userName.toUpperCase()}, Next Reminder",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     fontSize: 15.sp,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.white)),
                             SizedBox(height: 10.h),
                             Text(
                               homecontroller.waterRemindList.isEmpty
                                   ? "Click on add button to Set your first reminder."
                                   :
                               //"${DateFormat('hh:mm a').format(DateTime(0, 1, 1, nextReminder?.timeOfDay?.hour ?? 0, nextReminder?.timeOfDay?.minute ?? 0))} - ${nextReminder?.waterML} ML",
                               "${nextReminder?.timeOfDay!.format(context)} - ${nextReminder?.waterML} ml",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 15.sp,
                               )),
                             SizedBox(height: 10.h),
                             homecontroller.waterRemindList.isEmpty ? SizedBox():
                             Text(
                               "In ${homecontroller.getTimeRemaining(nextReminder?.timeOfDay?? TimeOfDay.now())} minutes",
                             //  "In ${nextReminder?.timeOfDay?.hour} hrs ${nextReminder?.timeOfDay?.minute} mins",
                               style: TextStyle(
                                 fontSize: 16,
                                 color: Colors.white,
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
                       decoration: BoxDecoration(color: Colors.red.shade100),
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
            minutesInterval: 1, // Only show :00, :05, :10 etc.
            onTimeChange: (time) {
              //  final now = DateTime.now();

              //           // User ne pick kiya hua time: aaj ki date ke sath
              //           DateTime selectedDateTime = DateTime(
              //             now.year,
              //             now.month,
              //             now.day,
              //             time.hour,
              //             time.minute,
              //           );

              //           // Agar selected time `now` se pehle ya 12 ghante se aage hai, toh +1 day mat karna
              //           Duration difference = selectedDateTime.difference(now);

              //           if (difference.inMinutes < 0 || difference.inHours > 12) {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(
              //                 content: Text("Please select a time within the next 12 hours ⏰"),
              //                 backgroundColor: Colors.redAccent,
              //                 duration: Duration(seconds: 2),
              //               ),
              //             );
              //             return;
              //           }

              //           homecontroller.timeFornotification.value = selectedDateTime;
              //           homecontroller.getSelectedTime.value =
              //               DateFormat('hh : mm a').format(selectedDateTime);

              //old          
               final formattedTime = DateFormat('hh : mm a').format(time);
              homecontroller.getSelectedTime.value = formattedTime;
              homecontroller.timeFornotification.value = time;
              
              print(
                "Value of time ${homecontroller.timeFornotification.value}",
              );
              
             
                                    
                                    }
                                    
                                    
                                    )
                                    
              ]));
  }


              
            }
            
          
