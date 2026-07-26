// import 'dart:math' as math;
// import 'package:flutter/material.dart';

// class SimpleParticles extends StatefulWidget {
//   const SimpleParticles({super.key});

//   @override
//   State<SimpleParticles> createState() => _SimpleParticlesState();
// }

// class _SimpleParticlesState extends State<SimpleParticles>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final List<SimpleParticle> _particles = [];
//   final int _totalParticles = 5000; // Fewer particles to easily track

//   @override
//   void initState() {
//     super.initState();
//     // 1. Create a game loop heartbeat that never stops ticker ticking
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat();
//     _controller.addListener(
//       () => setState(() {}),
//     ); // Redraw screen on every heartbeat
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // 2. Spawn particles once we know the screen size
//         if (_particles.isEmpty) {
//           final random = math.Random();
//           for (int i = 0; i < _totalParticles; i++) {
//             _particles.add(
//               SimpleParticle(
//                 x: random.nextDouble() * constraints.maxWidth,
//                 y: random.nextDouble() * constraints.maxHeight,
//                 vx: (random.nextDouble() - 0.5) * 1, // Horizontal speed
//                 vy: (random.nextDouble() - 0.5) * 1, // Vertical speed
//               ),
//             );
//           }
//         }

//         // 3. Draw them on screen
//         return CustomPaint(
//           painter: SimpleParticlePainter(
//             particles: _particles,
//             size: constraints.biggest,
//           ),
//           size: Size.infinite,
//         );
//       },
//     );
//   }
// }

// // 4. The data model holding position and speed blueprint
// class SimpleParticle {
//   double x, y, vx, vy;
//   SimpleParticle({
//     required this.x,
//     required this.y,
//     required this.vx,
//     required this.vy,
//   });

//   void move(Size size) {
//     x += vx; // Move right/left
//     y += vy; // Move up/down

//     // Bounce off Left/Right walls
//     if (x < 0 || x > size.width) vx = -vx;
//     // Bounce off Top/Bottom walls
//     if (y < 0 || y > size.height) vy = -vy;
//   }
// }

// // 5. The artist that paints the circles
// class SimpleParticlePainter extends CustomPainter {
//   final List<SimpleParticle> particles;
//   final Size size;
//   SimpleParticlePainter({required this.particles, required this.size});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.blue;

//     for (var particle in particles) {
//       particle.move(size); // Step 1: Update position data
//       canvas.drawCircle(
//         Offset(particle.x, particle.y),
//         1.5,
//         paint,
//       ); // Step 2: Render it
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // Always redraw
// }

import 'dart:math' as math;
import 'package:flutter/material.dart';

class RingOrbitParticles extends StatefulWidget {
  const RingOrbitParticles({super.key});

  @override
  State<RingOrbitParticles> createState() => _RingOrbitParticlesState();
}

class _RingOrbitParticlesState extends State<RingOrbitParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RingParticle> _particles = [];
  Offset? _fingerPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_particles.isEmpty) {
          final random = math.Random();
          for (int i = 0; i < 40; i++) {
            _particles.add(
              RingParticle(
                x: random.nextDouble() * constraints.maxWidth,
                y: random.nextDouble() * constraints.maxHeight,
                // سرعت اولیه بسیار بسیار آهسته (شناور مثل پر)
                vx: (random.nextDouble() - 0.5) * 0.4,
                vy: (random.nextDouble() - 0.5) * 0.4,
              ),
            );
          }
        }

        return GestureDetector(
          onPanUpdate: (details) =>
              setState(() => _fingerPosition = details.localPosition),
          onPanEnd: (_) => setState(() => _fingerPosition = null),
          child: CustomPaint(
            painter: RingPainter(
              particles: _particles,
              fingerPosition: _fingerPosition,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class RingParticle {
  double x, y, vx, vy;
  RingParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });

  void update(Size size, Offset? finger) {
    if (finger != null) {
      // ۱. محاسبه فاصله تا انگشت
      double dx = finger.dx - x;
      double dy = finger.dy - y;
      double distance = math.sqrt(dx * dx + dy * dy);
      double angle = math.atan2(dy, dx);

      // اندازه دقیق حلقه انگشتر (۳۰ پیکسل فاصله از مرکز انگشت)
      double targetRadius = 30.0;

      // ۲. نیروی جذب: ذرات را مجبور می‌کند دقیقاً روی خط حلقه بایستند
      double error = distance - targetRadius;
      double pullForce =
          error * 0.05; // اگر دور باشند سریع می‌آیند، نزدیک باشند آرام می‌شوند

      vx += math.cos(angle) * pullForce;
      vy += math.sin(angle) * pullForce;

      // ۳. حرکت چرخشی بسیار آرام و نرم روی بدنه حلقه
      double slowOrbitSpeed = 0.4;
      vx += math.cos(angle + math.pi / 2) * slowOrbitSpeed;
      vy += math.sin(angle + math.pi / 2) * slowOrbitSpeed;

      // ترمز شدید در زمان لمس برای جلوگیری از شلوغ‌کاری و چرخش بزرگ
      vx *= 0.85;
      vy *= 0.85;
    } else {
      // وقتی انگشت نیست، ذرات خیلی نرم و آهسته شناور می‌مانند
      vx *= 0.99;
      vy *= 0.99;

      // اگر خیلی متوقف شدند، یک تکان بسیار کوچک به آن‌ها بدهد
      if (vx.abs() < 0.1) vx += (math.Random().nextDouble() - 0.5) * 0.1;
      if (vy.abs() < 0.1) vy += (math.Random().nextDouble() - 0.5) * 0.1;
    }

    // اعمال حرکت
    x += vx;
    y += vy;

    // برخورد به دیوارها
    if (x < 0 || x > size.width) vx = -vx;
    if (y < 0 || y > size.height) vy = -vy;
  }
}

class RingPainter extends CustomPainter {
  final List<RingParticle> particles;
  final Offset? fingerPosition;
  RingPainter({required this.particles, required this.fingerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      particle.update(size, fingerPosition);
      canvas.drawCircle(Offset(particle.x, particle.y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class OrbitParticles extends StatefulWidget {
  const OrbitParticles({super.key});

  @override
  State<OrbitParticles> createState() => _OrbitParticlesState();
}

class _OrbitParticlesState extends State<OrbitParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SmartParticle> _particles = [];
  Offset? _fingerPosition; // ذخیره موقعیت انگشت شما

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ساخت ذرات برای اولین بار
        if (_particles.isEmpty) {
          final random = math.Random();
          for (int i = 0; i < 1500; i++) {
            _particles.add(
              SmartParticle(
                x: random.nextDouble() * constraints.maxWidth,
                y: random.nextDouble() * constraints.maxHeight,
                vx: (random.nextDouble() - 0.5) * 2,
                vy: (random.nextDouble() - 0.5) * 2,
              ),
            );
          }
        }

        // گوش دادن به لمس صفحه توسط کاربر
        return GestureDetector(
          onPanUpdate: (details) =>
              setState(() => _fingerPosition = details.localPosition),
          onPanEnd: (_) => setState(() => _fingerPosition = null),
          child: CustomPaint(
            painter: OrbitPainter(
              particles: _particles,
              fingerPosition: _fingerPosition,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

// مدل ذره با هوش چرخش

class SmartParticle {
  double x, y, vx, vy;
  SmartParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });

  void update(Size size, Offset? finger) {
    if (finger != null) {
      // ۱. محاسبه فاصله و زاویه تا انگشت
      double dx = finger.dx - x;
      double dy = finger.dy - y;
      double distance = math.sqrt(dx * dx + dy * dy);

      if (distance > 5) {
        // اگر خیلی نزدیک نیستند حرکت کنند
        // ۲. زاویه مستقیم به سمت انگشت
        double angle = math.atan2(dy, dx);

        // ۳. نیروی کشش به سمت مرکز (جاذبه)
        double pullForce = 0.5;
        vx += math.cos(angle) * pullForce;
        vy += math.sin(angle) * pullForce;

        // ۴. جادوی اصلی: اضافه کردن نیروی چرخش (۹۰ درجه اختلاف با زاویه اصلی)
        double orbitForce = 1.5;
        vx += math.cos(angle + math.pi / 2) * orbitForce;
        vy += math.sin(angle + math.pi / 2) * orbitForce;
      }
    }

    // سرعت ذرات را کمی محدود می‌کنیم تا مثل موشک فرار نکنند!
    vx *= 0.95;
    vy *= 0.95;

    // حرکت معمولی
    x += vx;
    y += vy;

    // برخورد به دیواره‌ها (اگر انگشت روی صفحه نباشد)
    if (x < 0 || x > size.width) vx = -vx;
    if (y < 0 || y > size.height) vy = -vy;
  }
}

// نقاش ذرات
class OrbitPainter extends CustomPainter {
  final List<SmartParticle> particles;
  final Offset? fingerPosition;
  OrbitPainter({required this.particles, required this.fingerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromARGB(255, 0, 149, 255);

    for (var particle in particles) {
      particle.update(size, fingerPosition);
      canvas.drawCircle(Offset(particle.x, particle.y), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class KaabaOrbitParticles extends StatefulWidget {
  const KaabaOrbitParticles({super.key});

  @override
  State<KaabaOrbitParticles> createState() => _KaabaOrbitParticlesState();
}

class _KaabaOrbitParticlesState extends State<KaabaOrbitParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<KaabaParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_particles.isEmpty) {
          final random = math.Random();
          for (int i = 0; i < 2000; i++) {
            // اختصاص یک لایه/مدار مشخص به هر ذره (بین ۲۰ تا ۷۰ پیکسل فاصله از مرکز)
            double personalRadius = 20.0 + random.nextInt(6) * 10.0;

            _particles.add(
              KaabaParticle(
                x: random.nextDouble() * constraints.maxWidth,
                y: random.nextDouble() * constraints.maxHeight,
                vx: (random.nextDouble() - 0.5) * 0.3,
                vy: (random.nextDouble() - 0.5) * 0.3,
                targetRadius: personalRadius, // مدار اختصاصی ذره
              ),
            );
          }
        }

        return GestureDetector(
          onPanUpdate: (details) => setState(
            () => KaabaParticle.fingerPosition = details.localPosition,
          ),
          onPanEnd: (_) => setState(() => KaabaParticle.fingerPosition = null),
          child: CustomPaint(
            painter: KaabaPainter(particles: _particles),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class KaabaParticle {
  double x, y, vx, vy;
  final double targetRadius; // شعاع مداری که این ذره باید در آن طواف کند
  static Offset? fingerPosition; // موقعیت انگشت به صورت مشترک

  KaabaParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.targetRadius,
  });

  void update(Size size) {
    if (fingerPosition != null) {
      double dx = fingerPosition!.dx - x;
      double dy = fingerPosition!.dy - y;
      double distance = math.sqrt(dx * dx + dy * dy);
      double angle = math.atan2(dy, dx);

      // ۱. حفظ فاصله بر اساس لایه اختصاصی (این کار مانع چسبیدن همه به یک نقطه می‌شود)
      double error = distance - targetRadius;
      double pullForce = error * 0.08;

      vx += math.cos(angle) * pullForce;
      vy += math.sin(angle) * pullForce;

      // ۲. حرکت چرخشی بسیار آرام و منظم در جهت طواف
      double orbitSpeed = 0.35;
      vx += math.cos(angle + math.pi / 2) * orbitSpeed;
      vy += math.sin(angle + math.pi / 2) * orbitSpeed;

      // کنترل سرعت برای حفظ نظم صف‌ها
      vx *= 0.1;
      vy *= 0.1;
    } else {
      // حرکت شناور و بسیار آرام در زمان عدم لمس صفحه
      vx *= 0.98;
      vy *= 0.98;
      if (vx.abs() < 0.05) vx += (math.Random().nextDouble() - 0.5) * 0.1;
      if (vy.abs() < 0.05) vy += (math.Random().nextDouble() - 0.5) * 0.1;
    }

    x += vx;
    y += vy;

    // دیواره‌ها
    if (x < 0 || x > size.width) vx = -vx;
    if (y < 0 || y > size.height) vy = -vy;
  }
}

class KaabaPainter extends CustomPainter {
  final List<KaabaParticle> particles;
  KaabaPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      particle.update(size);

      // برای قشنگی بیشتر: ذرات ردیف‌های نزدیک‌تر کم‌رنگ‌تر و دورتر پررنگ‌تر می‌شوند
      double opacity = (particle.targetRadius / 70.0).clamp(0.4, 1.0);
      paint.color = const Color.fromARGB(255, 0, 255, 251);
      // paint.color = const Color.fromARGB(255, 0, 255, 251).withValues(alpha: opacity);

      canvas.drawCircle(Offset(particle.x, particle.y), 3.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
