import 'package:get/get.dart';
import 'package:watertime/database/app_database.dart';
import 'boarding_controller.dart';

class BoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoardingController>(
      () => BoardingController(Get.find<AppDatabase>()),
    );
  }
}
