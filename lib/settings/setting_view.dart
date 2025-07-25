import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/widgets.dart';
import 'package:watertime/settings/setting_controller.dart';

class SettingView extends StatelessWidget {
  
  final SettingController settingController = Get.put(SettingController());

  SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
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
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),

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
               border: OutlineInputBorder(),
               prefixIcon: Icon(Icons.monitor_weight),
                           
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
              label: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async{
                await settingController.db.insertUser(settingController.nameTxt.value.text,
                weight: double.tryParse(settingController.weightTxt.value.text),
                gender: settingController.selectedGender.value.isNotEmpty ? settingController.selectedGender.value : ''
                );

                Get.back();
           
              },
            ),

      ],),
            
          
          
    ),
    );
    
  }
}
