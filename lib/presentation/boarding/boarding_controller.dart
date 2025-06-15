import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/routes/app_pages.dart';

class BoardingController extends GetxController{
  
  
  var db = AppDatabase();
  Rx<TextEditingController> nameController = TextEditingController().obs;
  
  

  // Observable name
  var userName = ''.obs;

  BoardingController(this.db);

 

Future<void> saveUserAndNavigate() async {
  final name = nameController.value.text.trim();


  if (name.isEmpty) {
    Get.snackbar('Error', 'Name cannot be empty');
    return;
  }
  print("value of name is: $name");
  final insertedId = await db.insertUser( name);
  
  if (insertedId > 0) 
  {
    db.getLatestUser().then((user) {
      if (user != null) {
        print('Latest user loaded gender: ${(user.gender)}))');
        print('Latest user loaded name: ${(user.name)}))');
        print('Latest user loaded weight: ${(user.weight)}))');
        }});

    // ✅ User saved successfully
    Get.offAllNamed(AppRoutes.GENDERSELECTION);
   // loadLatestUser();
    nameController.value.clear(); // Clear the text field.....
  } else 
  {
    Get.snackbar('Error', 'Failed to save user');
  }
}


 // Call this to load latest user
  Future<void> loadLatestUser() async {
    final user = await db.getLatestUser();
    if (user != null) {
      userName.value = user.name??'';
    
      print('Latest user loaded: ${userName.value}');
    } else {
      userName.value = 'No user found';
    }
  }
  
  
  // Controller logic goes here
  @override
  void onInit() {
    super.onInit();
    // Initialization code
  }

  @override
  void onReady() {
    super.onReady();
    // Code to run when the controller is ready
  }

  @override
  void onClose() {
    // Cleanup code when the controller is closed
    super.onClose();
  }
}