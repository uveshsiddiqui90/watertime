import 'package:get/get.dart';
import 'package:watertime/presentation/activity/activity_controller.dart';


class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(
      () => ActivityController(),
    );
  }
}
