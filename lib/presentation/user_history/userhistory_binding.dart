import 'package:get/get.dart';
import 'package:watertime/presentation/user_history/userhistory_controller.dart';


class UserhistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserhistoryController>(
      () => UserhistoryController(),
    );
  }
}
