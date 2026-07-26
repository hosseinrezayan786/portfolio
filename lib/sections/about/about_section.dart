import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/portfolio_data.dart';
import 'widgets/flare_painter.dart';

class AboutSection extends StatefulWidget {
  final Function(VoidCallback)? onRegisterReset;
  final bool isFirstStackingSection;

  const AboutSection({
    super.key,
    this.onRegisterReset,
    this.isFirstStackingSection = false,
  });

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late final AnimationController _flareController;
  late final AnimationController _slideController;
  late final Animation<Offset> _contentSlide;
  late final Animation<Offset> _gifSlide;
  late final Animation<double> _fadeAnimation;
  late final List<FlareParticle> _particles;
  double _lastT = 0;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _flareController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(_tick);
    _resetParticles();
    _flareController.repeat();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _gifSlide = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.onRegisterReset != null) {
        widget.onRegisterReset!(resetAnimations);
      }
    });
  }

  void resetAnimations() {
    setState(() {
      _hasAnimated = false;
    });
    _slideController.reset();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_hasAnimated && mounted) {
      _slideController.forward();
      _hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _flareController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: size.height),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: widget.isFirstStackingSection
              ? const BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                )
              : null,
          boxShadow: widget.isFirstStackingSection
              ? [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.6),
                    blurRadius: 80,
                    spreadRadius: 10,
                    offset: const Offset(0, -25),
                  ),
                  BoxShadow(
                    color: const Color(0xFF1A1A2E).withValues(alpha: 0.7),
                    blurRadius: 50,
                    spreadRadius: 5,
                    offset: const Offset(0, -15),
                  ),
                  BoxShadow(
                    color: const Color(0xFF16213E).withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, -8),
                  ),
                  BoxShadow(
                    color: const Color(0xFF0F0F1A).withValues(alpha: 0.8),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, -3),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.only(
          left: isMobile ? 20 : 60,
          right: isMobile ? 20 : 60,
          top: widget.isFirstStackingSection
              ? (isMobile ? 80 : 100)
              : (isMobile ? 60 : 100),
          bottom: isMobile ? 60 : 100,
        ),
        child: AnimatedBuilder(
          animation: _flareController,
          builder: (context, _) {
            final flareValue = _flareController.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text('ABOUT ME', style: AppTextStyles.sectionTitle(context)),
                const SizedBox(height: 16),
                Text('Who I Am', style: AppTextStyles.heading2(context)),
                const SizedBox(height: 40),
                isMobile
                    ? Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: SlideTransition(
                                position: _gifSlide,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _buildGifContainer(context),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: SlideTransition(
                                position: _contentSlide,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _buildContentBox(
                                    context,
                                    flareProgress: flareValue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: SlideTransition(
                              position: _contentSlide,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildContentBox(
                                  context,
                                  flareProgress: flareValue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            flex: 1,
                            child: SlideTransition(
                              position: _gifSlide,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildGifContainer(context),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _tick() {
    final t =
        _flareController.lastElapsedDuration?.inMilliseconds.toDouble() ?? 0.0;
    final dtMs = (t - _lastT).clamp(0, 32);
    _lastT = t;
    final dt = dtMs / 1000.0;

    for (int i = 0; i < _particles.length; i++) {
      final p = _particles[i];
      p.position += p.velocity * dt;

      if (p.position.dx < 0 || p.position.dx > 1) {
        p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
        p.position = Offset(p.position.dx.clamp(0, 1), p.position.dy);
      }
      if (p.position.dy < 0 || p.position.dy > 1) {
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
        p.position = Offset(p.position.dx, p.position.dy.clamp(0, 1));
      }

      for (int j = i + 1; j < _particles.length; j++) {
        final q = _particles[j];
        final dist2 = (p.position - q.position).distanceSquared;
        const minDist = 0.08;
        if (dist2 < minDist * minDist) {
          final tmp = p.velocity;
          p.velocity = q.velocity;
          q.velocity = tmp;
          final diff = p.position - q.position;
          final len = diff.distance;
          final dir = len == 0 ? const Offset(1, 0) : diff / len;
          p.position += dir * 0.01;
          q.position -= dir * 0.01;
        }
      }
    }
    if (mounted) setState(() {});
  }

  void _resetParticles() {
    final rng = math.Random();
    _particles = List.generate(3, (_) {
      final speed = 0.12 + rng.nextDouble() * 0.12;
      final angle = rng.nextDouble() * 2 * math.pi;
      return FlareParticle(
        position: Offset(rng.nextDouble(), rng.nextDouble()),
        velocity: Offset(math.cos(angle), math.sin(angle)) * speed,
      );
    });
  }

  Widget _buildContentBox(
    BuildContext context, {
    required double flareProgress,
  }) {
    return CustomPaint(
      foregroundPainter: FlarePainter(
        progress: flareProgress,
        particles: _particles,
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          PortfolioData.bio,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: AppColors.textSecondary, height: 1.6, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildGifContainer(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 20,
              left: 38,
              child: Container(
                width: 230,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 3,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.black,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  PortfolioData.aboutImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
