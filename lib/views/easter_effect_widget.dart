import 'dart:math';
import 'package:flutter/material.dart';

class EasterEffectWidget extends StatefulWidget {
  final Widget child;
  final int petalCount;
  final bool enabled;

  const EasterEffectWidget({
    super.key,
    required this.child,
    this.petalCount = 30,
    this.enabled = true,
  });

  @override
  State<EasterEffectWidget> createState() => _EasterEffectWidgetState();
}

class _EasterEffectWidgetState extends State<EasterEffectWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<FallingPetal> _petals;
  double _lastProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    if (widget.enabled) {
      _controller.repeat();
    }

    _petals = List.generate(
      widget.petalCount,
      (index) => FallingPetal(),
    );
  }

  @override
  void didUpdateWidget(EasterEffectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final currentProgress = _controller.value;
                var deltaProgress = currentProgress - _lastProgress;
                if (deltaProgress < 0) {
                  deltaProgress += 1.0;
                }
                final deltaTime = deltaProgress * 60.0;
                _lastProgress = currentProgress;

                return CustomPaint(
                  painter: EasterPetalPainter(
                    petals: _petals,
                    progress: currentProgress,
                    deltaTime: deltaTime,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class FallingPetal {
  late double baseX;
  late double y;
  late double size;
  late double speed;
  late double swingAmplitude;
  late double swingSpeed;
  late double initialPhase;
  late double opacity;
  late double rotation;
  late double rotationSpeed;
  late Color color;

  static final List<Color> _petalColors = [
    const Color(0xFFFF69B4), // Kräftiges Pink
    const Color(0xFFFF6347), // Tomatenrot
    const Color(0xFFFF8C00), // Dunkelorange
    const Color(0xFFFFD700), // Gold
    const Color(0xFF9370DB), // Lila
    const Color(0xFF00CED1), // Türkis
    const Color(0xFF32CD32), // Limettengrün
    const Color(0xFFFF1493), // Deep Pink
  ];

  FallingPetal() {
    _init();
  }

  void _init() {
    final random = Random();
    baseX = random.nextDouble();
    y = random.nextDouble();
    size = 3 + random.nextDouble() * 4;
    speed = 0.008 + random.nextDouble() * 0.006;
    swingAmplitude = 0.015 + random.nextDouble() * 0.02;
    swingSpeed = 0.3 + random.nextDouble() * 0.4;
    initialPhase = random.nextDouble() * 2 * pi;
    opacity = 0.5 + random.nextDouble() * 0.4;
    rotation = random.nextDouble() * 2 * pi;
    rotationSpeed = 0.5 + random.nextDouble() * 1.5;
    color = _petalColors[random.nextInt(_petalColors.length)];
  }

  double getX(double progress) {
    final swingOffset =
        sin(progress * swingSpeed * 2 * pi + initialPhase) * swingAmplitude;
    return (baseX + swingOffset).clamp(0.0, 1.0);
  }

  void update(double deltaTime, double progress) {
    y += speed * deltaTime;
    rotation += rotationSpeed * deltaTime * 0.1;

    if (y > 1.0) {
      _init();
      y = -0.05;
    }
  }
}

class EasterPetalPainter extends CustomPainter {
  final List<FallingPetal> petals;
  final double progress;
  final double deltaTime;

  EasterPetalPainter({
    required this.petals,
    required this.progress,
    required this.deltaTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var petal in petals) {
      petal.update(deltaTime, progress);

      final dx = petal.getX(progress) * size.width;
      final dy = petal.y * size.height;

      if (dy >= 0) {
        canvas.save();
        canvas.translate(dx, dy);
        canvas.rotate(petal.rotation);

        final paint = Paint()
          ..color = petal.color.withValues(alpha: petal.opacity)
          ..style = PaintingStyle.fill;

        // Blütenblatt-Form (Ellipse)
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: petal.size,
          height: petal.size * 1.6,
        );
        canvas.drawOval(rect, paint);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(EasterPetalPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
