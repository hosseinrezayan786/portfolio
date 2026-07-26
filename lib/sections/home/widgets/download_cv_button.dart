import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class DownloadCVButton extends StatefulWidget {
  final VoidCallback onTap;

  const DownloadCVButton({super.key, required this.onTap});

  @override
  State<DownloadCVButton> createState() => _DownloadCVButtonState();
}

class _DownloadCVButtonState extends State<DownloadCVButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _borderController,
          builder: (context, child) {
            return CustomPaint(
              painter: CirclingBorderPainter(
                progress: _borderController.value,
                isHovered: _isHovered,
              ),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: _isHovered ? Colors.white : AppColors.primaryLight,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Text(
                  'Download CV',
                  style: TextStyle(
                    color: _isHovered ? Colors.white : AppColors.primaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CirclingBorderPainter extends CustomPainter {
  final double progress;
  final bool isHovered;

  CirclingBorderPainter({required this.progress, required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(25));

    final basePaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, basePaint);

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;

    final segmentLength = totalLength * 0.8;
    final startDistance = (progress * totalLength) % totalLength;

    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 3.5 : 1.5
      ..strokeCap = StrokeCap.round;

    final extractedPath = _extractPathSegment(
      pathMetrics,
      startDistance,
      segmentLength,
      totalLength,
    );

    final sweepGradient = SweepGradient(
      startAngle: 0,
      endAngle: pi * 4,
      colors: [
        Colors.transparent,
        AppColors.primaryLight.withValues(alpha: 1.3),
        isHovered ? AppColors.primary : AppColors.primaryLight,
        isHovered ? AppColors.primary : AppColors.primaryLight,
        AppColors.primaryLight.withValues(alpha: 0.3),
        Colors.transparent,
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      transform: GradientRotation(progress * pi * 4),
    );

    gradientPaint.shader = sweepGradient.createShader(rect);
    canvas.drawPath(extractedPath, gradientPaint);

    if (isHovered) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
        ..color = AppColors.primary.withValues(alpha: 0.4);
      canvas.drawPath(extractedPath, glowPaint);
    }
  }

  Path _extractPathSegment(
    ui.PathMetric metric,
    double start,
    double length,
    double total,
  ) {
    final path = Path();
    final end = start + length;

    if (end <= total) {
      final extracted = metric.extractPath(start, end);
      path.addPath(extracted, Offset.zero);
    } else {
      final firstPart = metric.extractPath(start, total);
      final secondPart = metric.extractPath(0, end - total);
      path.addPath(firstPart, Offset.zero);
      path.addPath(secondPart, Offset.zero);
    }

    return path;
  }

  @override
  bool shouldRepaint(CirclingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isHovered != isHovered;
  }
}
