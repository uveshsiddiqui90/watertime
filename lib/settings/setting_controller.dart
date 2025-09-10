import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';

class SettingController extends GetxController {

  Rx<TextEditingController> nameTxt = TextEditingController().obs;
  Rx<TextEditingController> weightTxt = TextEditingController().obs;
 
  final RxString selectedGender = ''.obs;
  
  final RxInt userWeight= 70.obs; // Default age
  var db = AppDatabase();

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
    print("User gender: ${user.gender}");
    if(user.gender =='Male')
    {
      selectedGender.value = 'male';
      }else{
        selectedGender.value = 'female';
      }

  }
}

void editUser() async {
 // final insertedId = await db.insertUser(name);
}



}