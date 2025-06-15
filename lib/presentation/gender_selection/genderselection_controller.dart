import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import '../routes/app_pages.dart';

class GenderselectionController extends GetxController {

  RxBool isMaleSelected = false.obs;
  RxBool isFemaleSelected = false.obs;
  RxString genderSelection = ''.obs;
  var db = AppDatabase();
  RxString userName = ''.obs;


Future<void> saveGenderAndNavigate() async {
  
   if (genderSelection.isEmpty) {
    Get.snackbar('Error', 'Please select your Gender');
    return;
  }
  final insertedId = await db.insertUser(userName.value,gender:genderSelection.value, );
print("ENter 1");
  if (insertedId > 0) 
  {
    Get.offAllNamed(AppRoutes.WEIGHT); 
    db.getLatestUser().then((user) {
      if (user != null) {
        print('Latest user loaded gender: ${(user.gender)}))');
        print('Latest user loaded name: ${(user.name)}))');
        print('Latest user loaded weight: ${(user.weight)}))');
        }});
    }
    
   else 
  {
    Get.snackbar('Error', 'Failed to save user');
  }
}




  // Controller logic goes here
  @override
  void onInit() {
    super.onInit();
    db.getLatestUser().then((user) {
      if (user != null) {
        print('Latest user loaded gender: ${(user.gender)}))');
        print('Latest user loaded name: ${(user.name)}))');
        print('Latest user loaded weight: ${(user.weight)}))');
         userName.value = user.name??'';
        }
        
        });
        print("value of userName is: ${userName.value}");
       
    }
    
    // Initialization code
  

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