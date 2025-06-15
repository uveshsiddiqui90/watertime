import 'package:get/get.dart';
import 'package:watertime/presentation/home/homecontroller.dart';


class Homebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Homecontroller>(
      () => Homecontroller(),
    );
  }
}
