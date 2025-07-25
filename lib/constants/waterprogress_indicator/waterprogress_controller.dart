import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class WaterController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Reactive variables
  final RxDouble targetAmount = 0.0.obs;
  final RxDouble consumedAmount = 0.0.obs;

  // Animation controller
  late AnimationController waveController;

  @override
  void onInit() {
    super.onInit();
    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // keeps the wave animating
  }

  @override
  void onClose() {
    waveController.dispose();
    super.onClose();
  }

  // Percentage of water consumed (0.0 to 1.0)
  double get percentage =>
      (consumedAmount.value / targetAmount.value).clamp(0.0, 1.0);

  // Update consumed amount
  void updateConsumedAmount(double amount) {
    consumedAmount.value = amount.clamp(0, targetAmount.value);
  }

  // Add to current water amount
  void addToConsumedAmount(double amount) {
    consumedAmount.value =
        (consumedAmount.value + amount).clamp(0, targetAmount.value);
  }

  // Update target goal
  void updateTargetAmount(double amount) {
    targetAmount.value = amount;
    if (consumedAmount.value > targetAmount.value) {
      consumedAmount.value = targetAmount.value;
    }
  }

  // Creates the wave path animation
  Path getWavePath(Size size, double waveValue) {
    final baseHeight = size.height * (1 - percentage);
    final waveHeight = size.height * 0.05;
    final path = Path();

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = baseHeight +
          math.sin((x / size.width * 3 * math.pi) +
                  (waveValue * 2 * math.pi)) *
              waveHeight;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }
}
