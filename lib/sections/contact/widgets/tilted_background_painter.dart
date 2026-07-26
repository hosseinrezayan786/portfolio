import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class TiltedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surface.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    const horizontalPadding = 60.0;
    const verticalPadding = 100.0;
    final contentWidth = size.width - (horizontalPadding * 2);
    final formStartX = horizontalPadding + (contentWidth * 0.32);
    final diagonalHeight = verticalPadding + 180.0;

    final path = Path();
    path.moveTo(size.width / 1.5, 0);
    path.lineTo(formStartX, diagonalHeight);
    path.lineTo(formStartX, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
