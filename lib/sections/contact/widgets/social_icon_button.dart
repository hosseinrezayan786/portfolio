import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class SocialIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color brandColor;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.brandColor,
  });

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isActive => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          widget.onTap();
          setState(() => _isPressed = false);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isActive ? widget.brandColor : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isActive
                  ? widget.brandColor
                  : AppColors.primary.withValues(alpha: 0.3),
              width: _isActive ? 2 : 1,
            ),
            boxShadow: _isActive
                ? [
                    BoxShadow(
                      color: widget.brandColor.withValues(alpha: 0.6),
                      blurRadius: 18,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: widget.brandColor.withValues(alpha: 0.9),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: _isActive ? Colors.white : AppColors.primaryLight,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
