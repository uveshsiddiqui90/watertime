import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watertime/model/waterremind_model.dart';
import 'package:watertime/services/notification_service.dart';


class Homecontroller extends GetxController
{

 RxString getSelectedTime = ''.obs;   
 RxString waterML = ''.obs;   
 RxList<WaterRemindModel> waterRemindList = <WaterRemindModel>[].obs;
 Rx<TextEditingController> waterMLController = TextEditingController().obs;
 RxInt nextId = 1.obs;
 Rx<DateTime> timeFornotification = DateTime.now().obs;
 double targetAmount = 2000.0;
 double consumedAmountuser = 800.0;

  
  @override
  void onInit() {
    super.onInit();
    // Initialize the notification service
    NotificationService.initialize();
    // Set initial consumed amount
  }

  // Function to set the selected time
  void setSelectedTime(String time) {
    getSelectedTime.value = time;
  }

  // Function to set the amount of water in ML
  void setWaterML(String ml) {
    waterML.value = ml;
  }

  // Function to add a new water reminder

 addWaterRemind() {
    if (waterMLController.value.text.isNotEmpty) {
      WaterRemindModel waterRemind = WaterRemindModel(
        time: getSelectedTime.value,
        waterML: waterMLController.value.text,
        timeOfDay:timeFornotification.value.isAfter(DateTime.now())
            ? TimeOfDay.fromDateTime(timeFornotification.value)
            : TimeOfDay.now(),
        id: nextId.value++, 
      );
      waterRemindList.add(waterRemind);
      waterRemindList.refresh();
      
      _scheduleNotification(waterRemind);
    
      waterMLController.value.clear();
      getSelectedTime.value = '';
    } else {
      Get.snackbar('Error', 'Please enter the amount of water in ML');
    }
   }

   Future<void> _scheduleNotification(WaterRemindModel reminder) async {
    await NotificationService.scheduleWaterReminder(
      id: reminder.id!, // Using the model's ID
      time: reminder.timeOfDay!, // Using TimeOfDay from model
      amount: reminder.waterML!, // Using amount from model
    );
    
  }


  void removeReminder(int id) {
    waterRemindList.removeWhere((r) => r.id == id);
    NotificationService.cancelReminder(id);
  }

    @override
  void onClose() {
    NotificationService.cancelAllReminders();
    super.onClose();
  }

  void clearWaterRemindList() {
    waterRemindList.clear();
  }

  Future<void> testNotification() async {
  // First request permissions
  final granted = await NotificationService.requestPermissions();
  
  if (granted) {
    await NotificationService.showTestNotification();
    Get.snackbar('Success', 'Test notification sent');
  } else {
    Get.snackbar('Error', 'Notification permission denied');
    // Optionally open app settings
    // await openAppSettings();
  }
}

 RxDouble totalWater = 2.0.obs;

 void addWater(double amount) {
    totalWater.value += amount;
    if (totalWater.value > 3.0) {
      totalWater.value = 3.0;
    }
  }


}