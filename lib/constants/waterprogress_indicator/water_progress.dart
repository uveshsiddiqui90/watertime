import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watertime/constants/waterprogress_indicator/waterprogress_controller.dart';


class WaterTrackerWidget extends StatelessWidget {
  const WaterTrackerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WaterController controller = Get.put(WaterController());
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Obx(() => Stack(
          alignment: Alignment.center,
          children: [
            // Outer circle
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue[300]!,
                  width: 3,
                ),
              ),
            ),
            
            // Water wave
            SizedBox(
              width: 180,
              height: 180,
              child: ClipOval(
                child: AnimatedBuilder(
                  animation: controller.waveController,
                  builder: (_, child) {
                    return CustomPaint(
                      painter: _WavePainter(
                        waveValue: controller.waveController.value,
                        fillPercentage: controller.percentage,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Text display
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${controller.consumedAmount.value.toInt()}/${controller.targetAmount.value.toInt()} ml',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(controller.percentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double waveValue;
  final double fillPercentage;

  _WavePainter({required this.waveValue, required this.fillPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.lightBlueAccent.withOpacity(0.9),
          Colors.blue[400]!,
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final baseHeight = size.height * (1 - fillPercentage);
    final waveHeight = size.height * 0.05;
    final path = Path();

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = baseHeight + 
          math.sin((x / size.width * 3 * math.pi) + (waveValue * 2 * math.pi)) * waveHeight;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}