import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class FlareParticle {
  FlareParticle({required this.position, required this.velocity});
  Offset position;
  Offset velocity;
}

class FlarePainter extends CustomPainter {
  FlarePainter({required this.progress, required this.particles});

  final double progress;
  final List<FlareParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress * 2 * math.pi;

    for (int i = 0; i < particles.length; i++) {
      final part = particles[i];
      final pos = Offset(
        size.width * part.position.dx,
        size.height * part.position.dy,
      );

      final baseSize = 100.0 + 40.0 * math.sin(p + i);
      final opacity = 0.2 + 0.08 * math.cos(p + i * 1.3);

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: opacity),
            AppColors.primaryLight.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: pos, radius: baseSize * 1.2))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, baseSize * 0.5)
        ..blendMode = BlendMode.screen;

      canvas.drawCircle(pos, baseSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FlarePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.particles != particles;
  }
}
