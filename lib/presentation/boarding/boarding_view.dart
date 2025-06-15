import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/app_image.dart';
import 'package:watertime/constants/app_string.dart';
import 'package:watertime/database/app_database.dart';
import 'boarding_controller.dart';

class BoardingView extends GetView<BoardingController> 
{ 
  BoardingView({super.key});
  final BoardingController boardingController = Get.put(BoardingController(Get.find<AppDatabase>()));

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(
         image: DecorationImage(image: AssetImage(AppImage.background), 
         fit: BoxFit.cover),
        ),
        child: Center(
          child: mainView(controller)
        ),
       ),
    );
  }






Widget mainView(BoardingController controller) {
  return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppString.welcomeMessage,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppString.sipBysipReachyourDailyGoal,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              nameTxtField(),
               SizedBox(height: 20.h),
                InkWell(
                onTap: ()async {
                  boardingController.saveUserAndNavigate(); 
                  },
                child: Container(
                  width: 200.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(child: Text(AppString.getStarted,style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp
                  ),)),
                ),
              ),
            ],
          );
}




  Widget nameTxtField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
             controller: controller.nameController.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your beautiful name',
                hintStyle: TextStyle(
                  color: Colors.blue.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
                prefixIcon:  Icon(Icons.person_outline, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:  BorderSide(color: Colors.blue, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:  BorderSide(color: Colors.blue, width: 2.w),
                ),
                contentPadding:  EdgeInsets.symmetric(
                  horizontal: 20.r,
                  vertical: 18.h,
                ),
              ),
              style:  TextStyle(fontSize: 16.sp),
             // onSubmitted: (_) => controller.saveName(),
            ),
         )] );
    }
}