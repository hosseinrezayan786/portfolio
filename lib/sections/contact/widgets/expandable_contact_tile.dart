import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class ExpandableContactTile extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;
  final bool isRealMobile;

  const ExpandableContactTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
    this.isRealMobile = false,
  });

  @override
  State<ExpandableContactTile> createState() => _ExpandableContactTileState();
}

class _ExpandableContactTileState extends State<ExpandableContactTile>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _rotationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    if (widget.isRealMobile) {
      _expandController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    if (widget.isRealMobile) return;
    _expandController.forward();
    _rotationController.repeat();
  }

  void _onHoverEnd() {
    if (widget.isRealMobile) return;
    _expandController.reverse();
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    const double collapsedWidth = 130.0;
    const double expandedWidth = 280.0;
    const double borderRadius = 12.0;
    const Color bgColor = Color(0xFF1E293B);

    if (widget.isRealMobile) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: AppTextStyles.bodySmall(
                        context,
                      ).copyWith(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: AppTextStyles.bodySmall(
                        context,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => _onHoverStart(),
      onExit: (_) => _onHoverEnd(),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_expandAnimation, _rotationController]),
          builder: (context, child) {
            final currentWidth =
                collapsedWidth +
                (_expandAnimation.value * (expandedWidth - collapsedWidth));
            final isHovered = _expandAnimation.value > 0;
            final currentBorderWidth = isHovered ? 3.0 : 1.0;

            return CustomPaint(
              painter: isHovered
                  ? RotatingBorderPainter(
                      rotation: _rotationController.value,
                      borderRadius: borderRadius,
                      borderWidth: currentBorderWidth,
                      gradientColors: [
                        bgColor,
                        bgColor,
                        AppColors.primary,
                        AppColors.primary,
                        bgColor,
                        bgColor,
                      ],
                      gradientStops: const [0.0, 0.6, 0.7, 0.85, 0.95, 1.0],
                    )
                  : null,
              child: Container(
                width: currentWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: 12 + (_expandAnimation.value * 4),
                  vertical: 10 + (_expandAnimation.value * 8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: isHovered
                      ? null
                      : Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: AppColors.primaryLight,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.label,
                          style: AppTextStyles.bodySmall(context),
                        ),
                      ],
                    ),
                    SizeTransition(
                      sizeFactor: _expandAnimation,
                      axisAlignment: -1.0,
                      child: Opacity(
                        opacity: _expandAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.value,
                            style: AppTextStyles.bodySmall(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RotatingBorderPainter extends CustomPainter {
  final double rotation;
  final double borderRadius;
  final double borderWidth;
  final List<Color> gradientColors;
  final List<double> gradientStops;

  static const double _twoPi = 2 * 3.14159265359;

  RotatingBorderPainter({
    required this.rotation,
    required this.borderRadius,
    required this.borderWidth,
    required this.gradientColors,
    required this.gradientStops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final gradientRect = Rect.fromCenter(
      center: center,
      width: size.width * 1.5,
      height: size.height * 1.5,
    );
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(borderWidth / 2),
      Radius.circular(borderRadius - borderWidth / 2),
    );
    final gradient = SweepGradient(
      center: Alignment.center,
      colors: gradientColors,
      stops: gradientStops,
      transform: GradientRotation(rotation * _twoPi),
    );
    final paint = Paint()
      ..shader = gradient.createShader(gradientRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant RotatingBorderPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.borderWidth != borderWidth;
  }
}
