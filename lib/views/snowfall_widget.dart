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
  double _lastProgress = 0.0;

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
          child: RepaintBoundary(
            child: IgnorePointer(
              child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Berechne deltaTime (Zeit seit letztem Frame in Sekunden)
                final currentProgress = _controller.value;
                var deltaProgress = currentProgress - _lastProgress;

                // Handle wrap-around wenn Animation von 1.0 auf 0.0 springt
                if (deltaProgress < 0) {
                  deltaProgress += 1.0;
                }

                // deltaProgress ist Anteil von 60 Sekunden, also * 60 für Sekunden
                final deltaTime = deltaProgress * 60.0;
                _lastProgress = currentProgress;

                return CustomPaint(
                  painter: SnowfallPainter(
                    snowflakes: _snowflakes,
                    progress: currentProgress,
                    deltaTime: deltaTime,
                  ),
                );
              },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Snowflake {
  late double baseX; // Ausgangsposition für horizontales Schwingen
  late double y;
  late double size;
  late double speed;
  late double swingAmplitude;
  late double swingSpeed;
  late double initialPhase;
  late double opacity; // Leichte Opazitäts-Variation
  late double speedWobblePhase; // Für leichte Geschwindigkeits-Variation
  late double speedWobbleAmount; // Wie viel Wobble

  Snowflake() {
    _init();
  }

  void _init() {
    final random = Random();
    baseX = random.nextDouble();
    y = random.nextDouble();
    size = 2 + random.nextDouble() * 3; // 2-5 pixels (etwas kleiner)
    speed = 0.015 + random.nextDouble() * 0.01; // Langsam: 0.015-0.025 pro Sekunde
    swingAmplitude = 0.01 + random.nextDouble() * 0.015; // Sehr sanftes Schwingen
    swingSpeed = 0.5 + random.nextDouble() * 0.5; // Langsames Schwingen: 0.5-1 Zyklen pro 60s
    initialPhase = random.nextDouble() * 2 * pi;
    opacity = 0.5 + random.nextDouble() * 0.4; // 0.5-0.9 Opazität
    speedWobblePhase = random.nextDouble() * 2 * pi;
    speedWobbleAmount = 0.1 + random.nextDouble() * 0.1; // 10-20% Geschwindigkeits-Variation
  }

  // Berechnet aktuelle X-Position (oszilliert um baseX)
  double getX(double progress) {
    final swingOffset =
        sin(progress * swingSpeed * 2 * pi + initialPhase) * swingAmplitude;
    return (baseX + swingOffset).clamp(0.0, 1.0);
  }

  // Berechnet aktuelle Geschwindigkeit mit leichtem Wobble
  double getSpeed(double progress) {
    final wobble = sin(progress * 3 * pi + speedWobblePhase) * speedWobbleAmount;
    return speed * (1.0 + wobble);
  }

  void update(double deltaTime, double progress) {
    // Move down mit leichtem Geschwindigkeits-Wobble (frame-rate unabhängig)
    y += getSpeed(progress) * deltaTime;

    // Reset wenn unten angekommen
    if (y > 1.0) {
      _init();
      y = -0.05; // Startet knapp über dem Bildschirm
    }
  }
}

class SnowfallPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double progress; // 0.0 - 1.0 über 60 Sekunden
  final double deltaTime; // Zeit seit letztem Frame in Sekunden

  SnowfallPainter({
    required this.snowflakes,
    required this.progress,
    required this.deltaTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var snowflake in snowflakes) {
      snowflake.update(deltaTime, progress);

      final dx = snowflake.getX(progress) * size.width;
      final dy = snowflake.y * size.height;

      // Nur zeichnen wenn im sichtbaren Bereich
      if (dy >= 0) {
        final paint = Paint()
          ..color = Colors.white.withValues(alpha: snowflake.opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(dx, dy),
          snowflake.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(SnowfallPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
