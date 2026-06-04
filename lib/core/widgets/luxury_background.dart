import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LuxuryBackground extends StatelessWidget {
  const LuxuryBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBackground,
            AppColors.secondaryBackground,
            AppColors.midnightBlue,
            AppColors.primaryBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _LuxuryStreakPainter())),
          child,
        ],
      ),
    );
  }
}

class _LuxuryStreakPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gold = Paint()
      ..color = AppColors.goldMetallic.withValues(alpha: 0.10)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final blue = Paint()
      ..color = const Color(0xFF223B73).withValues(alpha: 0.12)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 5; i++) {
      final y = size.height * (0.12 + i * 0.18);
      final path = Path()
        ..moveTo(-size.width * 0.1, y)
        ..cubicTo(
          size.width * 0.25,
          y - 38,
          size.width * 0.62,
          y + 54,
          size.width * 1.08,
          y - 18,
        );
      canvas.drawPath(path, i.isEven ? gold : blue);
    }

    final diagonal = Paint()
      ..color = AppColors.softGold.withValues(alpha: 0.05)
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.92, -20),
      Offset(size.width * 0.18, size.height * 0.46),
      diagonal,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
