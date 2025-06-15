import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watertime/presentation/activity/activity_controller.dart';

// ignore: must_be_immutable
class ActivityView extends GetView<ActivityController> {
   ActivityView({super.key});

  ActivityController activityController = Get.put(ActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgimg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Activity Screen',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
              ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                onTap: () {
                   activityController.getUser();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Nextt',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )   
    
            ],
          ),
            ),
      )
    );
  }
}