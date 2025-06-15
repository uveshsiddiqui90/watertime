import 'package:get/get.dart';
import 'package:watertime/presentation/weight_measure/weight_controller.dart';

class WeightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeightController>( () => WeightController(),);
  }
}
