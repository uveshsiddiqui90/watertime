import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/widgets.dart';
import 'package:watertime/presentation/home/homecontroller.dart';
import 'package:watertime/settings/setting_controller.dart';

class SettingView extends StatelessWidget {
  
  final SettingController settingController = Get.put(SettingController());
  final Homecontroller homecontroller  = Get.put(Homecontroller());

  SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            /// 👤 Name Input
            TextField(
              controller: settingController.nameTxt.value,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: Icon(Icons.person_2_outlined),
              ),
              onChanged: (String name){
                homecontroller.userName.value = name;
              },
            ),
            SizedBox(height: 16),

            /// ⚖️ Weight Input
            TextField(
             controller: settingController.weightTxt.value,
             keyboardType: TextInputType.number,
             readOnly: true, // Make it read-only to prevent manual input
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => WeightPickerDialog(initialWeight: settingController.userWeight.toInt(),),
                );
              },
              
                           //  enabled: false,
             decoration: InputDecoration(
               labelText: 'Weight (kg)',
                prefixIcon: Icon(Icons.fitness_center_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                
                           
             ),
                           ),
            SizedBox(height: 20.h),
  /// 🚻 Gender Selection
            Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
            
                          Row(children: [
                            GestureDetector(
                              onTap: (){
                               settingController.selectedGender.value = 'male';
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: settingController.selectedGender.value == 'male' ? Colors.blue : Colors.transparent,
                                  border: Border.all(
                                    width: 1
                                ),
                              ),
                              child: Center(
                                 child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: settingController.selectedGender.value =='male' ? Colors.white : Colors.transparent,
                              ),
                            ))),
                            SizedBox(width: 5.w,),
                            
                            Text("Male", style: TextStyle(fontSize: 16)),
                           ],),
                          Row(children: [
                            InkWell(
                              onTap: (){
                                settingController.selectedGender.value = 'female';
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color:settingController.selectedGender.value == 'female' ? Colors.blue : Colors.transparent,
                                  border: Border.all(
                                    width: 1
                                ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                     size: 16,
                        color: settingController.selectedGender.value =='female' ? Colors.white : Colors.transparent,
                    ),
                  )
                    
                    ),
                    
            ),
            SizedBox(width: 5.w,),
                Text("Female", style: TextStyle(fontSize: 16)),
            
            ]  ),
                
              ],)),


                SizedBox(height: 24),
             

            /// ✅ Save Button
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save Changess'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async{
                // await settingController.db.insertUser(settingController.nameTxt.value.text,
                // weight: double.tryParse(settingController.weightTxt.value.text),
                // gender: settingController.selectedGender.value.isNotEmpty ? settingController.selectedGender.value : ''
                // );
                await settingController.db.updateUserData(
                  settingController.userId.value,
                  name:  settingController.nameTxt.value.text,
                  weight: double.tryParse(settingController.weightTxt.value.text),
                  gender: settingController.selectedGender.value.isNotEmpty ? settingController.selectedGender.value : ''
                );
                settingController.updateTagetAmount();

                Get.back();
           
              },
            ),

      ],),
            
          
          
    ),
    );
    
  }
}
