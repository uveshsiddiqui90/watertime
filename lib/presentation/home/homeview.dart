import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watertime/constants/waterprogress_indicator/water_progress.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';
import 'package:watertime/presentation/home/homecontroller.dart';

class HomeView extends StatelessWidget {
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final WaterController waterController = Get.put(WaterController());

   HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<WaterController>().updateConsumedAmount(100.0); 
    Get.find<WaterController>().updateTargetAmount(10000.0); 
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
         Column(
           children: [
             WaterTrackerWidget(),
             InkWell(
              onTap: () {
                print("Get all scheduled notifications");
                homecontroller.getAllNotificationDetails();               
                 },
               child: Container(
                 width: MediaQuery.of(context).size.width-50,
                 height: 100,
                  decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.blueAccent.shade100,
                 ),
               ),
             ),
           ],
         ),

            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                decoration: BoxDecoration(color: Colors.red.shade100),
                child: Obx(
                  () => ListView.builder(
                    itemCount: homecontroller.waterRemindList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
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
                                  "${homecontroller.waterRemindList[index].time}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${homecontroller.waterRemindList[index].waterML} ml',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                homecontroller.waterRemindList.removeAt(index);
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
            Positioned(
              bottom: 50,
              left: 20,
              child: Container(
                width: 50,
                height: 50,
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
                          height: 500,
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
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
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildTimePicker(context, homecontroller),
                                  // SizedBox(width: 20),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      controller: homecontroller
                                          .waterMLController
                                          .value,
                                      decoration: InputDecoration(
                                        labelText: 'Add ml',
                                        labelStyle: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 13,
                                        ),

                                        // This gives just the bottom border
                                        border: UnderlineInputBorder(),
                                        // Optional: Customize the border color
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
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
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
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
                        barrierColor: Colors
                            .black54, // Optional: semi-transparent background
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
    );
  }

  Widget buildTimePicker(BuildContext context, Homecontroller homecontroller) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select Time',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
              final formattedTime = DateFormat('hh : mm a').format(time);
              homecontroller.getSelectedTime.value = formattedTime;
              homecontroller.timeFornotification.value = time;
              print(
                "Value of time ${homecontroller.timeFornotification.value}",
              );
            },
            isForce2Digits: true,
          ),
        ],
      ),
    );
  }
}
