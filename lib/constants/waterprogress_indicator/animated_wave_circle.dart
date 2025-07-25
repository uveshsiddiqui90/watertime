import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedWaveCircle extends StatefulWidget {
  final double percentage; // 0.0 to 1.0

  const AnimatedWaveCircle({super.key, required this.percentage});

  @override
  State<AnimatedWaveCircle> createState() => _AnimatedWaveCircleState();
}

class _AnimatedWaveCircleState extends State<AnimatedWaveCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return ClipOval(
            child: CustomPaint(
              painter: WavePainter(
                animationValue: _waveController.value,
                percentage: widget.percentage,
              ),
            ),
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double percentage;

  WavePainter({required this.animationValue, required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    double waveHeight = 10;
    double waveSpeed = animationValue * 2 * pi;
    double baseHeight = size.height * (1 - percentage);

    path.moveTo(0, size.height);

    for (double x = 0.0; x <= size.width; x++) {
      double y = waveHeight * sin((x / size.width * 2 * pi) + waveSpeed) + baseHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
