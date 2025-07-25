import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/app_color.dart';
import 'package:watertime/constants/app_string.dart';
import 'package:watertime/constants/widgets.dart';
import 'package:watertime/presentation/weight_measure/weight_controller.dart';

// ignore: must_be_immutable
class WeightView extends GetView<WeightController>{
   WeightView({super.key});
WeightController weightController = Get.put(WeightController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.backgroundColor, // Transparent background
        child: mainView()
      ));
  }


  Widget mainView(){
    return SingleChildScrollView(
      
      child: Column(
             children: [
              waveWidget(),
              SizedBox(height: 30.h),
          Text(
            AppString.selectYourWeight,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34.sp,
              color: AppColor.textColor,
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
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColor.buttonColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  AppString.next,
                  style: TextStyle(
                    color: AppColor.buttontxtColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )   
        ],
      ),
    );
  }
}

