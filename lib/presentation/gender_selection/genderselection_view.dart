import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/presentation/gender_selection/genderselection_controller.dart';

class GenderselectionView extends GetView<GenderselectionController> {
  const GenderselectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Text("Select Your Gender",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  )),
                  SizedBox(height: 20),
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
                                              color: Colors.blueAccent,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/male_avtar.png'),
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
                                          controller.genderSelection.value = 'male';
                                        },
                        child: Container(
                          width: 25.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            color: controller.isMaleSelected.value ? Colors.black : Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                       Text("Male",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
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
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/female_avtar.png'),
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
                          controller.genderSelection.value = 'female';
                        },
                        child: Container(
                          width: 25.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            color:controller.isFemaleSelected.value == true ? Colors.black:  Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                       Text("Female",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          )),
                 
                    ],
                  ),
                 
                        ],),
                          ]),
               ),
               SizedBox(height: 30.h),
              InkWell(
                onTap: () {
                  print("1");
                      controller.saveGenderAndNavigate();
                //  controller.gotoWeightView();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Nextt',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        
                      ),
                    ),
                  ),
                ),
              )
       ])
       
       
       )));
        
  }}