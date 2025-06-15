import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/routes/app_pages.dart';

class ActivityController extends GetxController {
  // Add your controller logic here
  // For example, you can define variables, methods, and lifecycle methods
 var db = AppDatabase();
 final Map<String, dynamic> args = Get.arguments;


  void navigateToHomeView() {
       Get.offAllNamed(AppRoutes.HOME); 
 }

 getUser(){
   db.getLatestUser().then((user) {
      if (user != null) {
        print('Latest user loaded gender: ${(user.gender)}))');
        print('Latest user loaded name: ${(user.name)}))');
        print('Latest user loaded weight: ${(user.weight)}))');
        }});
 }
  @override
  void onInit() {
    super.onInit();
    print("value of initialWaterGoal is: ${args['initialWaterGoal']}");
    // Initialization logic here
  }

  @override
  void onReady() {
    super.onReady();
    // Logic to run when the controller is ready
  }

  @override
  void onClose() {
    // Cleanup logic here
    super.onClose();
  }
}