import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/app_string.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';
import 'package:watertime/database/app_database.dart';

class SettingController extends GetxController {

  Rx<TextEditingController> nameTxt = TextEditingController().obs;
  Rx<TextEditingController> weightTxt = TextEditingController().obs;
 
  final RxString selectedGender = ''.obs;
  RxInt userId = 0.obs; // Store the user ID for updates
  
  final RxInt userWeight= 70.obs; // Default age
  RxInt targetAmount = 0.obs;
  var db = AppDatabase();

  WaterController waterController = Get.find<WaterController>();

  @override
  void onInit() {
    super.onInit();
    print('onInit called in SettingController');
    getUserData();
    // Initialize settings or load from storage if needed
  }

 Future<void> getUserData() async {
  final user = await db.getLatestUser();  // or getUserById(1)
  if (user != null) {
    nameTxt.value.text = user.name?.capitalizeFirst ?? '';
    weightTxt.value.text = user.weight != null ? user.weight!.round().toString() : '';
    
    //user.weight.toString() ?? '';
    userWeight.value = user.weight?.toInt() ?? 70; // Default weight if null
    userId.value = user.id; // Store the user ID for later updates
    print("value of user gender ${user.gender}");
    if(user.gender == AppString.male)
    {
      selectedGender.value = AppString.male;
      }else{
        selectedGender.value = AppString.female;
      }

  }
}

void editUser() async {
 // final insertedId = await db.insertUser(name);
}

int calculateWaterTarget({required double weightInKg, required String gender}) 
{
     
    if(gender == AppString.male){
       return (weightInKg * 35).round(); // ml
    }else{
       return (weightInKg * 31).round(); // ml
    }
}




void updateTagetAmount() {
  targetAmount.value = calculateWaterTarget(
    weightInKg: weightTxt.value.text.isNotEmpty ? double.tryParse(weightTxt.value.text) ?? 70 : 70,
    gender: selectedGender.value

  );

 // waterController.updateConsumedAmount(0.0);
  waterController.updateTargetAmount(targetAmount.value.toDouble());
  
  }

}