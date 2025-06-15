import 'package:get/get.dart';
import 'package:watertime/presentation/gender_selection/genderselection_controller.dart';

class GenderselectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenderselectionController>(
      () => GenderselectionController(),
    );
  }
}
