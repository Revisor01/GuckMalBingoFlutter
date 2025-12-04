import 'dart:math';
import 'package:flutter/material.dart';

class SnowfallWidget extends StatefulWidget {
  final Widget child;
  final int snowflakeCount;
  final bool enabled;

  const SnowfallWidget({
    super.key,
    required this.child,
    this.snowflakeCount = 50,
    this.enabled = true,
  });

  @override
  State<SnowfallWidget> createState() => _SnowfallWidgetState();
}

class _SnowfallWidgetState extends State<SnowfallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Snowflake> _snowflakes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    // Nur starten wenn enabled
    if (widget.enabled) {
      _controller.repeat();
    }

    _snowflakes = List.generate(
      widget.snowflakeCount,
      (index) => Snowflake(),
    );
  }

  @override
  void didUpdateWidget(SnowfallWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Controller pausieren/fortsetzen wenn enabled sich ändert
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
                return CustomPaint(
                  painter: SnowfallPainter(
                    snowflakes: _snowflakes,
                    animation: _controller,
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

class Snowflake {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double swingAmplitude;
  late double swingSpeed;
  late double initialPhase;

  Snowflake() {
    final random = Random();
    x = random.nextDouble();
    y = random.nextDouble();
    size = 2 + random.nextDouble() * 4; // 2-6 pixels
    speed = 0.0003 + random.nextDouble() * 0.0007; // Super langsam: 0.0003-0.001
    swingAmplitude = 0.005 + random.nextDouble() * 0.01; // Sanfteres Schwingen
    swingSpeed = 0.3 + random.nextDouble() * 0.5; // Langsameres Schwingen
    initialPhase = random.nextDouble() * 2 * pi;
  }

  void update(double progress, Size size) {
    // Move down
    y = (y + speed) % 1.0;

    // Swing horizontally
    final swingOffset =
        sin(progress * swingSpeed * 2 * pi + initialPhase) * swingAmplitude;
    x = (x + swingOffset) % 1.0;
  }
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final Animation<double> animation;

  SnowfallPainter({
    required this.snowflakes,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    for (var snowflake in snowflakes) {
      snowflake.update(animation.value, size);

      final dx = snowflake.x * size.width;
      final dy = snowflake.y * size.height;

      canvas.drawCircle(
        Offset(dx, dy),
        snowflake.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SnowfallPainter oldDelegate) => true;
}
