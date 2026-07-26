import 'package:flutter/material.dart';
import 'package:personal_portfolio/model/experience.dart';
import 'package:personal_portfolio/sections/experience/widget/experience_card.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/portfolio_data.dart';

class ExperienceSection extends StatefulWidget {
  final Function(VoidCallback)? onRegisterReset;

  const ExperienceSection({super.key, this.onRegisterReset});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with WidgetsBindingObserver {
  final GlobalKey _sectionKey = GlobalKey();
  bool _sectionAnimated = false;
  int _experienceResetKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _checkSectionVisibility();
          _startPeriodicVisibilityCheck();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_sectionAnimated) {
              _checkSectionVisibility();
            }
          });
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.onRegisterReset != null) {
        widget.onRegisterReset!(resetAnimations);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void resetAnimations() {
    setState(() {
      _sectionAnimated = false;
      _experienceResetKey++;
    });
    _checkSectionVisibility();
    _startPeriodicVisibilityCheck();
  }

  void _startPeriodicVisibilityCheck() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && !_sectionAnimated) {
        _checkSectionVisibility();
        _startPeriodicVisibilityCheck();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted && !_sectionAnimated) {
      _checkSectionVisibility();
    }
  }

  double _getVisibilityThreshold(bool isMobile) {
    if (isMobile) {
      return 0.20;
    }
    return 0.32;
  }

  void _checkSectionVisibility() {
    if (!mounted || _sectionAnimated) return;

    final context = _sectionKey.currentContext;
    if (context == null || !context.mounted) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final widgetSize = renderBox.size;
      final screenSize = MediaQuery.of(context).size;
      final screenHeight = screenSize.height;
      final isMobile = screenSize.width < 768;

      final viewportTop = 0.0;
      final viewportBottom = screenHeight;

      final widgetTop = position.dy;
      final widgetBottom = widgetTop + widgetSize.height;

      final visibleTop = widgetTop.clamp(viewportTop, viewportBottom);
      final visibleBottom = widgetBottom.clamp(viewportTop, viewportBottom);
      final visibleHeight = (visibleBottom - visibleTop).clamp(
        0.0,
        widgetSize.height,
      );

      if (widgetSize.height > 0) {
        final visibilityPercentage = visibleHeight / widgetSize.height;
        final isInViewport =
            widgetBottom > viewportTop && widgetTop < viewportBottom;
        final threshold = _getVisibilityThreshold(isMobile);
        final shouldBeAnimated =
            isInViewport && visibilityPercentage >= threshold;

        if (shouldBeAnimated && !_sectionAnimated && mounted) {
          setState(() {
            _sectionAnimated = true;
          });
        }
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            _checkSectionVisibility();
          }
        });
      }
    });

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification ||
            notification is ScrollStartNotification) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_sectionAnimated) {
              _checkSectionVisibility();
            }
          });
        }
        return false;
      },
      child: Container(
        key: _sectionKey,
        width: double.infinity,
        constraints: BoxConstraints(minHeight: size.height),
        color: AppColors.background,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: isMobile ? 60 : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXPERIENCE', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 16),
            Text('My Career Journey', style: AppTextStyles.heading2(context)),
            const SizedBox(height: 60),
            _buildExperiencesList(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildExperiencesList(BuildContext context, bool isMobile) {
    final experiences = PortfolioData.experiences
        .map((exp) => Experience.fromMap(exp))
        .toList();

    return isMobile
        ? SizedBox(
            key: ValueKey(_experienceResetKey),
            child: Column(
              children: experiences
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: ExperienceCard(
                        key: ValueKey(
                          'exp_${_experienceResetKey}_${entry.key}',
                        ),
                        experience: entry.value,
                        isLast: entry.key == experiences.length - 1,
                        isMobile: true,
                        index: entry.key,
                        shouldAnimate: _sectionAnimated,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : SizedBox(
            key: ValueKey(_experienceResetKey),
            child: Column(
              children: experiences
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ExperienceCard(
                        key: ValueKey(
                          'exp_${_experienceResetKey}_${entry.key}',
                        ),
                        experience: entry.value,
                        isLast: entry.key == experiences.length - 1,
                        isMobile: false,
                        index: entry.key,
                        shouldAnimate: _sectionAnimated,
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
