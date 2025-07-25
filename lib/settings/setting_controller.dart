import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
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
  print('user data retrieved: ${user}');
  if (user != null) {
    nameTxt.value.text = user.name ?? '';
    weightTxt.value.text = user.weight?.toString() ?? '';
    userWeight.value = user.weight?.toInt() ?? 70; // Default weight if null
    if(user.gender =='male'){
      selectedGender.value = 'male';
      }else{
        selectedGender.value = 'female';
      }

    print('User data retrieved:${user.weight}');
    print('User data retrieved:${user.gender}');
    print(user.name);  // name, weight, gender etc.
  }
}

void editUser() async {
 // final insertedId = await db.insertUser(name);
}



}