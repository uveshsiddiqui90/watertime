import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import 'package:watertime/presentation/routes/app_pages.dart';


class WeightController extends GetxController 
{
  final RxInt userWeight = 0.obs;
  RxString userName = ''.obs;
  RxString genderSelection = ''.obs;  
  var db = AppDatabase();
  RxDouble baseAmount = 0.0.obs;

 Future<void> saveWeightandNavigate() async {
  
   if (userWeight.value <= 0) {
    Get.snackbar('Error', 'Please select your Weight');
    return;
  }
  final insertedId = await db.insertUser(userName.value,gender:genderSelection.value,weight: userWeight.value.toDouble()); 

  if (insertedId > 0) 
  {
    calculateDailyWaterRequirement();
    if(calculateDailyWaterRequirement() <= 0) {
      Get.snackbar('Error', 'Daily water requirement cannot be zero or negative');
      return;
    }
    
    Get.offAllNamed(AppRoutes.HOME,
    arguments: {'initialWaterGoal': calculateDailyWaterRequirement().toStringAsFixed(1)});
  }
 }


double calculateDailyWaterRequirement() 
{
  baseAmount.value = userWeight.value.toDouble() * 0.033;
  
  // Gender adjustments (men typically need slightly more)
  if (genderSelection.value.toLowerCase() == 'male') {
    return baseAmount.value * 1.1; // 10% more for males
  } else if (genderSelection.value.toLowerCase() == 'female') {
    return baseAmount.value * 0.9; // 10% less for females
  }
  
  return baseAmount.value; // Default if gender not specified
}


@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    db.getLatestUser().then((user) {
      if (user != null) {
        userName.value = user.name??'';
        genderSelection.value = user.gender??'';

        }});
        }
 

  }
