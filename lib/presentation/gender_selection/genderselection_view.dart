import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/app_image.dart';
import 'package:watertime/constants/app_string.dart';
import 'package:watertime/constants/widgets.dart';
import 'package:watertime/presentation/gender_selection/genderselection_controller.dart';

// ignore: must_be_immutable
class GenderselectionView extends GetView<GenderselectionController> {
   GenderselectionView({super.key});

  GenderselectionController genderselectionController = Get.put(GenderselectionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:Container(
        color:Color(0x00f7fbfe), 
        child: mainView(genderselectionController)));
        
  }
  
  
  
  
  
  
  
  
  Widget mainView(GenderselectionController controller) {
    return  Column(
            children: [
        waveWidget(),
        SizedBox(height: 50.h),
        Text(AppString.selectYourGender,
            style: TextStyle(
              fontSize: 36.sp,
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            )),
            SizedBox(height: 40.h),
         Obx(()=>
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                      Column(
                         children: [
                                    Container(
                                      width: 80.w,
                                      height: 80.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(AppImage.maleavtar),
                                          fit: BoxFit.cover,  
                                      ),
                                    ),
                                    ),
                                    SizedBox(height: 10.h),
                                     Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.isMaleSelected.value = true;
                                    controller.isFemaleSelected.value = false;
                                    controller.genderSelection.value = AppString.male;
                                  },
                  child: Container(
                    width: 25.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: controller.isMaleSelected.value ? Colors.indigo : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.indigo,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                 Text(AppString.male,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    )),
           
              ],
            ),
           
                  ],),
                Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(AppImage.femaleavtar),
                          fit: BoxFit.cover,  
                      ),
                    ),
                    ),
                    SizedBox(height: 10.h),
                     Row(
              children: [
                InkWell(
                  onTap: (){
                    controller.isMaleSelected.value = false;
                    controller.isFemaleSelected.value = true;
                    controller.genderSelection.value = AppString.female;
                  },
                  child: Container(
                    width: 25.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color:controller.isFemaleSelected.value == true ? Colors.indigo:  Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.indigo,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                 Text(AppString.female,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    )),
           
              ],
            ),
           
                  ],),
                    ]),
         ),
         SizedBox(height: 50.h),
        InkWell(
          onTap: () {
                           controller.saveGenderAndNavigate();
                    },
          child: Container(
            width: 200.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Center(
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  
                ),
              ),
            ),
          ),
        )
          ]);
  }}