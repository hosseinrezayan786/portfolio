// import 'package:flutter/material.dart';
// import 'package:personal_portfolio/model/skill.dart';
// import 'package:personal_portfolio/sections/skill/widgets/skill_card.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/text_styles.dart';
// import '../../../constants/portfolio_data.dart';

// class SkillsSection extends StatelessWidget {
//   const SkillsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isMobile = size.width < 768;

//     return Container(
//       width: double.infinity,
//       constraints: BoxConstraints(minHeight: size.height),
//       color: AppColors.backgroundLight,
//       padding: EdgeInsets.symmetric(
//         horizontal: isMobile ? 20 : 60,
//         vertical: isMobile ? 60 : 100,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('SKILLS', style: AppTextStyles.sectionTitle(context)),
//           const SizedBox(height: 16),
//           Text('What I Can Do', style: AppTextStyles.heading2(context)),
//           const SizedBox(height: 60),
//           _buildSkillsGrid(context, isMobile),
//         ],
//       ),
//     );
//   }

//   Widget _buildSkillsGrid(BuildContext context, bool isMobile) {
//     final skills = PortfolioData.skills
//         .map((skill) => Skill.fromMap(skill))
//         .toList();

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isMobile ? 2 : 4,
//         crossAxisSpacing: 24,
//         mainAxisSpacing: 24,
//         childAspectRatio: 1.1,
//       ),
//       itemCount: skills.length,
//       itemBuilder: (context, index) {
//         return SkillCard(skill: skills[index]);
//       },
//     );
//   }
// }
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:personal_portfolio/model/skill.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/colors.dart';
import '../../constants/portfolio_data.dart';
import '../../constants/text_styles.dart';

class SkillsSection extends StatefulWidget {
  final void Function(VoidCallback)? onRegisterReset;

  const SkillsSection({super.key, this.onRegisterReset});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with TickerProviderStateMixin {
  /// Monotonic time for float motion (no 8s repeat jump from AnimationController).
  double _floatTimeSec = 0;
  late Ticker _floatTicker;
  late final AnimationController _entryController;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;
  late final AnimationController _chipRevealController;

  /// After the stagger: slight brighten, then lerp to greyscale idle.
  late final AnimationController _settleController;
  bool _hasAnimated = false;
  int? _hoveredIndex;
  int? _chipAnimsN;
  int? _chipAnimsCols;
  List<Animation<double>>? _chipRevealAnims;

  /// Horizontal skills grid: center viewport on the middle of the content once (tablet/mobile).
  final ScrollController _skillHScrollController = ScrollController();
  bool _skillHScrollInitialCenterDone = false;
  bool _skillHScrollCenterInFlight = false;

  List<Skill> get _skills =>
      PortfolioData.skills.map((item) => Skill.fromMap(item)).toList();

  static const int _chipStaggerMs = 64;
  static const int _chipFadeMs = 450;
  static const int _chipTailBufferMs = 180;
  static const int _settleTotalMs = 1500;
  static const double _settleBrightenPhase = 0.22;
  static const double _settleColorPeak = 1.12;

  /// Softer accent on tiles while the staggered fade-in is running.
  static const double _revealColorAmount = 0.7;

  /// Every row is exactly five items (the last row may be partial).
  static const int _gridCols = 3;

  /// Min width for five side-by-side tiles (~200px) without overlap; below this, grid scrolls horizontally.
  static const double _minGridWidthFor5Cols = 500.0;

  /// Total time so the last chip can finish a full _chipFadeMs fade.
  int _chipRevealTotalMs(int n) {
    if (n <= 0) return 0;
    if (n == 1) return _chipFadeMs + _chipTailBufferMs;
    return (n - 1) * _chipStaggerMs + _chipFadeMs + _chipTailBufferMs;
  }

  @override
  void initState() {
    super.initState();
    _floatTicker = createTicker((Duration elapsed) {
      if (!mounted) return;
      setState(() {
        _floatTimeSec = elapsed.inMicroseconds / 1e6;
      });
    });
    _floatTicker.start();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entryFade = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
    final n = _skills.length;
    _chipRevealController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _chipRevealTotalMs(n)),
    );
    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _settleTotalMs),
    );
    _chipRevealController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _settleController.forward();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.onRegisterReset != null) {
        widget.onRegisterReset!(resetAnimations);
      }
    });
  }

  void resetAnimations() {
    if (!mounted) return;
    _entryController.reset();
    _chipRevealController.reset();
    _settleController.reset();
    _skillHScrollInitialCenterDone = false;
    _skillHScrollCenterInFlight = false;
    if (_skillHScrollController.hasClients) {
      _skillHScrollController.jumpTo(0);
    }
    setState(() {
      _hasAnimated = false;
      _hoveredIndex = null;
    });
  }

  @override
  void dispose() {
    _floatTicker.dispose();
    _entryController.dispose();
    _chipRevealController.dispose();
    _settleController.dispose();
    _skillHScrollController.dispose();
    super.dispose();
  }

  /// Nudges the horizontal skills strip so the middle of the grid is in view (view only; no animation change).
  void _scheduleInitialSkillHScrollCenter() {
    if (_skillHScrollInitialCenterDone || _skillHScrollCenterInFlight) return;
    _skillHScrollCenterInFlight = true;
    void attempt([int tryCount = 0]) {
      if (!mounted) {
        _skillHScrollCenterInFlight = false;
        return;
      }
      if (!_skillHScrollController.hasClients) {
        if (tryCount < 30) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => attempt(tryCount + 1),
          );
        } else {
          _skillHScrollInitialCenterDone = true;
          _skillHScrollCenterInFlight = false;
        }
        return;
      }
      final m = _skillHScrollController.position.maxScrollExtent;
      if (m > 0) {
        _skillHScrollController.jumpTo(m * 0.5);
      }
      _skillHScrollInitialCenterDone = true;
      _skillHScrollCenterInFlight = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => attempt());
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.25 && !_hasAnimated) {
      _hasAnimated = true;
      _entryController.forward().then((_) {
        if (mounted) _chipRevealController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: isMobile ? 100 : size.height),
        color: AppColors.background,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _entrySlide,
              child: FadeTransition(
                opacity: _entryFade,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SKILLS',
                          style: AppTextStyles.sectionTitle(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tools I Work With',
                          style: AppTextStyles.heading2(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                const cols = _gridCols;
                final rowCount = (_skills.length + cols - 1) ~/ cols;
                final h = (isMobile ? 90.0 : 125.0) * rowCount + 100;
                final useHorizontalGridScroll =
                    constraints.maxWidth < _minGridWidthFor5Cols;
                final canvasW = useHorizontalGridScroll
                    ? _minGridWidthFor5Cols
                    : constraints.maxWidth;
                return AnimatedBuilder(
                  animation: Listenable.merge(<Listenable>[
                    _chipRevealController,
                    _settleController,
                  ]),
                  builder: (context, _) {
                    final n = _skills.length;
                    _syncChipRevealAnimations(n, cols);
                    if (_chipRevealAnims == null ||
                        _chipRevealAnims!.length != n) {
                      return const SizedBox.shrink();
                    }
                    final anims = _chipRevealAnims!;
                    final colorAmount = _colorAmountForSettle;
                    final reveal = List<double>.generate(
                      n,
                      (i) => anims[i].value,
                    );
                    final anchors = _buildAnchors(Size(canvasW, h), n);
                    final nodes = _buildFloatingNodes(anchors);
                    final stack = SizedBox(
                      width: canvasW,
                      height: h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _SkillWebPainter(
                                nodes: nodes,
                                columnCount: cols,
                                reveal: reveal,
                              ),
                            ),
                          ),
                          for (int i = 0; i < n; i++)
                            Positioned(
                              left:
                                  nodes[i].center.dx - nodes[i].size.width / 2,
                              top:
                                  nodes[i].center.dy - nodes[i].size.height / 2,
                              child: IgnorePointer(
                                ignoring: anims[i].value < 0.04,
                                child: FadeTransition(
                                  opacity: anims[i],
                                  child: Transform.scale(
                                    scale: 0.80 + 0.12 * anims[i].value,
                                    alignment: Alignment.center,
                                    child: _SkillNode(
                                      skill: _skills[i],
                                      colorAmount: colorAmount,
                                      isActive: true,
                                      onHoverChange: (hovering) {
                                        setState(() {
                                          _hoveredIndex = hovering ? i : null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                    if (!useHorizontalGridScroll) {
                      return stack;
                    }
                    if (!_skillHScrollInitialCenterDone) {
                      _scheduleInitialSkillHScrollCenter();
                    }
                    return SingleChildScrollView(
                      controller: _skillHScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: stack,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<_NodePosition> _buildFloatingNodes(List<Offset> anchors) {
    // Same ~8s wave period as before, but time never wraps (smooth forever).
    final t = 2 * math.pi * _floatTimeSec / 8.0;
    return List.generate(anchors.length, (index) {
      final amp = 5 + (index % 4);
      final phase = index * 0.85;
      final dy = math.sin(t + phase) * amp;
      final dx = math.cos(t * 0.7 + phase) * 2;
      final skill = _skills[index];
      final hasIcon = hasSkillListIcon(skill.iconKey);
      final size = hasIcon ? const Size(200, 102) : const Size(232, 72);
      return _NodePosition(
        center: Offset(anchors[index].dx + dx, anchors[index].dy + dy),
        size: size,
      );
    });
  }

  List<Offset> _buildAnchors(Size size, int count) {
    if (count == 0) return [];
    final cols = _gridCols;
    final rows = (count + cols - 1) ~/ cols;
    const hMargin = 0.9;
    const vTop = 0.04;
    const vBottom = 0.96;
    return List.generate(count, (index) {
      final col = index % cols;
      final row = index ~/ cols;
      final nx = hMargin + (1.0 - 2 * hMargin) * (col + 0.5) / cols;
      final ny = vTop + (vBottom - vTop) * (row + 0.5) / rows;
      return Offset(size.width * nx, size.height * ny);
    });
  }

  List<int> _zigZagOrder(int count, int cols) {
    if (count == 0) return const [];
    final out = <int>[];
    final rowCount = (count + cols - 1) ~/ cols;
    for (int r = 0; r < rowCount; r++) {
      final start = r * cols;
      final end = (start + cols).clamp(0, count);
      var row = [for (int j = start; j < end; j++) j];
      if (r.isOdd) row = row.reversed.toList();
      out.addAll(row);
    }
    return out;
  }

  /// 0 = greyscale idle, 1 = full accent, >1 = brief brighten. During stagger, muted.
  double get _colorAmountForSettle {
    if (_chipRevealController.isCompleted) {
      return _settleColorMap(_settleController.value);
    }
    return _revealColorAmount;
  }

  /// Maps [p] 0..1: bump toward [_settleColorPeak], then ease down to 0.
  double _settleColorMap(double p) {
    if (p <= _settleBrightenPhase) {
      if (_settleBrightenPhase <= 0) return _settleColorPeak;
      final t = p / _settleBrightenPhase;
      return 1.0 + (_settleColorPeak - 1.0) * t;
    }
    final t2 = (p - _settleBrightenPhase) / (1.0 - _settleBrightenPhase);
    final c = Curves.easeInOutCubic.transform(t2);
    return _settleColorPeak * (1.0 - c);
  }

  /// Rebuilds per-tile [Interval] animations when [n] or [cols] (zig-zag order) changes.
  void _syncChipRevealAnimations(int n, int cols) {
    if (n == 0) {
      _chipAnimsN = 0;
      _chipAnimsCols = cols;
      _chipRevealAnims = [];
      return;
    }
    final total = _chipRevealTotalMs(n);
    if (total <= 0) {
      _chipAnimsN = n;
      _chipAnimsCols = cols;
      _chipRevealAnims = List<Animation<double>>.generate(
        n,
        (_) => const AlwaysStoppedAnimation<double>(1.0),
      );
      return;
    }
    if (_chipAnimsN == n &&
        _chipAnimsCols == cols &&
        _chipRevealAnims != null &&
        _chipRevealAnims!.length == n) {
      return;
    }
    _chipAnimsN = n;
    _chipAnimsCols = cols;
    final d = _chipRevealController.duration;
    if (d == null || d.inMilliseconds != total) {
      _chipRevealController.duration = Duration(milliseconds: total);
    }
    final tMs = total.toDouble();
    final order = _zigZagOrder(n, cols);
    _chipRevealAnims = List<Animation<double>>.generate(n, (i) {
      final k = order.indexOf(i);
      final startNorm = (k * _chipStaggerMs) / tMs;
      final endNorm = (k * _chipStaggerMs + _chipFadeMs) / tMs;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _chipRevealController,
          curve: Interval(
            startNorm.clamp(0.0, 1.0),
            endNorm.clamp(0.0, 1.0),
            curve: Curves.easeInOutCubic,
          ),
        ),
      );
    });
  }
}

class _SkillNode extends StatefulWidget {
  final Skill skill;

  /// 0 = greyscale idle, 1 = full accent, >1 = post-reveal “pop” (brighten).
  final double colorAmount;
  final bool isActive;
  final ValueChanged<bool> onHoverChange;

  const _SkillNode({
    required this.skill,
    required this.colorAmount,
    required this.isActive,
    required this.onHoverChange,
  });

  @override
  State<_SkillNode> createState() => _SkillNodeState();
}

class _SkillNodeState extends State<_SkillNode>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shake;
  final math.Random _rng = math.Random();
  double _restingAngle = 0;
  double _initialAngle = 0;
  double _direction = 1;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shake = CurvedAnimation(parent: _shakeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    if (_shakeController.isAnimating) return;
    _direction = _rng.nextBool() ? 1.0 : -1.0;
    _initialAngle = _restingAngle;
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.skill.accentColor != null
        ? Color(widget.skill.accentColor!)
        : AppColors.primary;
    final hasIcon = hasSkillListIcon(widget.skill.iconKey);
    final hover = widget.isActive || _isHovering;
    final a = _resolvedColorAmount(hover, widget.colorAmount);
    final brightExtra = a > 1.0 ? a - 1.0 : 0.0;
    final t = a.clamp(0.0, 1.0);
    // During settle “pop”, nudge the accent a touch toward white.
    final accentVivid =
        Color.lerp(accent, Colors.white, brightExtra.clamp(0.0, 0.15) * 0.4) ??
        accent;
    final borderColor = Color.lerp(AppColors.textTertiary, accentVivid, t)!;
    final borderAlpha = 0.28 + 0.62 * t + 0.12 * brightExtra;
    final fill = Color.lerp(
      AppColors.surfaceLight,
      Color.alphaBlend(
        accentVivid.withValues(alpha: 0.22),
        AppColors.surfaceLight,
      ),
      t,
    )!;
    final shadowC = Color.lerp(Colors.black, accentVivid, t)!;
    final shadowA = 0.1 + 0.22 * t + 0.2 * brightExtra;
    final blur = 8.0 + 14.0 * t + 6.0 * brightExtra;
    final textPrimaryC = Color.lerp(
      Colors.grey.shade300,
      AppColors.textPrimary,
      t,
    )!;
    final iconColor = Color.lerp(Colors.grey.shade400, accentVivid, t)!;

    return GestureDetector(
      onTap: _triggerShake,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _shake,
        builder: (context, child) {
          final progress = _shake.value;
          final decay = math.exp(-progress * 5.2);
          final swing = _direction * math.sin(progress * 2.5 * math.pi) * decay;
          final angle = _initialAngle + swing;
          if (!_shakeController.isAnimating) {
            _restingAngle = angle;
          }
          final offsetX = angle * 10;
          final rotationAngle = angle * 0.15;
          return Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.rotate(angle: rotationAngle, child: child),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() => _isHovering = true);
            widget.onHoverChange(true);
          },
          onExit: (_) {
            setState(() => _isHovering = false);
            widget.onHoverChange(false);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..translateByDouble(0.0, hover ? -2.0 : 0.0, 0.0, 1.0),
            padding: EdgeInsets.symmetric(
              horizontal: hasIcon ? 20 : 22,
              vertical: hasIcon ? 16 : 18,
            ),

            decoration: BoxDecoration(
              // Opaque fill so web lines never read through the tile; only the gaps show lines.
              color: fill,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: borderColor.withValues(
                  alpha: (hover ? 0.5 : borderAlpha).clamp(0.0, 0.95),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowC.withValues(alpha: shadowA.clamp(0.0, 0.45)),
                  blurRadius: blur,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: !hasIcon
                ? Text(
                    widget.skill.name,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: textPrimaryC,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SkillLeadingIcon(
                        iconKey: widget.skill.iconKey,
                        size: 22,
                        color: iconColor,
                        colorT: t,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        widget.skill.name,
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: textPrimaryC,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Hover / nav active keeps full color; else use parent-driven amount.
  double _resolvedColorAmount(bool hover, double fromParent) {
    if (hover) return 1.0;
    return fromParent;
  }
}

/// True when the skill shows an icon (font/SVG) beside the name.
bool hasSkillListIcon(String? iconKey) {
  if (iconKey == 'vscode' || iconKey == 'cursor') return true;
  return _resolveIcon(iconKey) != null;
}

const List<double> _kLumaGrayscale = <double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

class _SkillLeadingIcon extends StatelessWidget {
  const _SkillLeadingIcon({
    required this.iconKey,
    required this.size,
    required this.color,
    required this.colorT,
  });

  final String? iconKey;
  final double size;
  final Color color;
  final double colorT;

  @override
  Widget build(BuildContext context) {
    switch (iconKey) {
      case 'vscode':
        final picture = SvgPicture.asset(
          'assets/images/skill_vscode.svg',
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
        return SizedBox(
          width: size,
          height: size,
          child: colorT < 0.5
              ? ColorFiltered(
                  colorFilter: const ColorFilter.matrix(_kLumaGrayscale),
                  child: picture,
                )
              : picture,
        );
      case 'cursor':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/skill_cursor.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        );
      default:
        final d = _resolveIcon(iconKey);
        if (d == null) return const SizedBox.shrink();
        return Icon(d, size: size, color: color);
    }
  }
}

class _NodePosition {
  final Offset center;
  final Size size;

  const _NodePosition({required this.center, required this.size});
}

/// Grid edges; opacity follows both endpoints' reveal (lines fade in with chips).
class _SkillWebPainter extends CustomPainter {
  final List<_NodePosition> nodes;
  final int columnCount;
  final List<double> reveal;

  const _SkillWebPainter({
    required this.nodes,
    required this.columnCount,
    required this.reveal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = columnCount;
    final n = nodes.length;
    if (n < 2) return;

    final base = AppColors.textTertiary;
    for (int i = 0; i < n; i++) {
      if (i + 1 < n && (i + 1) % c != 0) {
        final a = (i < reveal.length) ? reveal[i] : 1.0;
        final b = (i + 1 < reveal.length) ? reveal[i + 1] : 1.0;
        final link = a * b;
        if (link < 0.001) continue;
        final p = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.35
          ..strokeCap = StrokeCap.round
          ..color = base.withValues(alpha: 0.55 * link);
        canvas.drawLine(nodes[i].center, nodes[i + 1].center, p);
      }
      if (i + c < n) {
        final a = (i < reveal.length) ? reveal[i] : 1.0;
        final b2 = (i + c < reveal.length) ? reveal[i + c] : 1.0;
        final link = a * b2;
        if (link < 0.001) continue;
        final p = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.35
          ..strokeCap = StrokeCap.round
          ..color = base.withValues(alpha: 0.55 * link);
        canvas.drawLine(nodes[i].center, nodes[i + c].center, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SkillWebPainter oldDelegate) {
    if (oldDelegate.columnCount != columnCount) return true;
    if (oldDelegate.nodes.length != nodes.length) return true;
    if (oldDelegate.reveal.length != reveal.length) return true;
    for (int i = 0; i < nodes.length; i++) {
      if (oldDelegate.nodes[i].center != nodes[i].center) return true;
    }
    for (int i = 0; i < reveal.length; i++) {
      if (i >= oldDelegate.reveal.length) return true;
      if (oldDelegate.reveal[i] != reveal[i]) return true;
    }
    return false;
  }
}

IconData? _resolveIcon(String? key) {
  switch (key) {
    case 'flutter':
      return FontAwesomeIcons.flutter;
    case 'dart':
      return FontAwesomeIcons.code;
    case 'firebase':
      return FontAwesomeIcons.fire;

    case 'database':
      return Icons.storage_rounded;
    case 'sql':
      return Icons.table_chart_rounded;
    case 'api':
      return Icons.settings_ethernet_rounded;
    case 'figma':
      return FontAwesomeIcons.figma;
    case 'git':
      return FontAwesomeIcons.gitAlt;
    case 'github':
      return SimpleIcons.github;
    case 'layerGroup':
      return FontAwesomeIcons.layerGroup;

    case 'link':
      return Icons.hub_rounded;
    // Layered / dependency flow — common metaphor for Clean Architecture
    case 'cleanArchitecture':
      return FontAwesomeIcons.sitemap;

    case 'riverpod':
      return FontAwesomeIcons.droplet;
    case 'postman':
      return SimpleIcons.postman;
    default:
      return null;
  }
}
