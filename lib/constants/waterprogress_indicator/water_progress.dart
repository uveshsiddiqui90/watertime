import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';


class WaterLevelWidget extends StatelessWidget {
  final WaterController controller = Get.find();

   WaterLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller.waveController,
        builder: (context, child) {
      double waveValue = controller.waveController.value;
      double percent = controller.percentage;
      double consumed = controller.consumedAmount.value;
      double target = controller.targetAmount.value;

      return SizedBox(
        height: 200.h,
        width: 200.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Circle Border
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent, width: 4),
              ),
            ),

            // Inner Wave
            ClipOval(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: _WavePainter(
                  controller: controller,
                  waveValue: waveValue,
                ),
              ),
            ),

            // ML text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${consumed.toInt()}/${target.toInt()} ml",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1)
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${(percent * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D47A1)
                  ),
                ),
              ],
            ),
          ],
        ),
      );
        
    });
  }
}

class _WavePainter extends CustomPainter {
  final WaterController controller;
  final double waveValue;

  _WavePainter({required this.controller, required this.waveValue});

  @override
  void paint(Canvas canvas, Size size) {
    final path = controller.getWavePath(size, waveValue);
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
