import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/widgets.dart';
import 'package:watertime/presentation/weight_measure/weight_controller.dart';

class WeightView extends GetView<WeightController>{
   WeightView({super.key});
WeightController weightController = Get.put(WeightController());
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
                'Please Select Your Weight',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
              ),
                      ),
                      SizedBox(height: 20.h),
                      WeightInput(),
                       SizedBox(height: 30.h),
                      InkWell(
                onTap: () {
                   controller.saveWeightandNavigate();
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
                      'Next',
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
      ));
  }
}