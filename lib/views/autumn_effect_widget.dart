import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Fallende Blätter, zu Halloween auch Fledermäuse und Gespenster.
class AutumnEffectWidget extends StatefulWidget {
  final Widget child;
  final int leafCount;
  final bool enabled;
  final bool withHalloweenVisitors;

  const AutumnEffectWidget({
    super.key,
    required this.child,
    this.leafCount = 18,
    this.enabled = true,
    this.withHalloweenVisitors = false,
  });

  static const leafAssets = [
    'assets/images/effects/blatt_1.webp',
    'assets/images/effects/blatt_2.webp',
    'assets/images/effects/blatt_3.webp',
    'assets/images/effects/blatt_4.webp',
    'assets/images/effects/blatt_5.webp',
    'assets/images/effects/blatt_6.webp',
  ];
  static const batAsset = 'assets/images/effects/fledermaus.webp';
  static const ghostAsset = 'assets/images/effects/gespenst.webp';

  @override
  State<AutumnEffectWidget> createState() => _AutumnEffectWidgetState();
}

class _AutumnEffectWidgetState extends State<AutumnEffectWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _random = Random();
  final _frame = ValueNotifier<int>(0);
  late List<FallingLeaf> _leaves;
  final List<HalloweenVisitor> _visitors = [];
  List<ui.Image>? _leafImages;
  ui.Image? _batImage;
  ui.Image? _ghostImage;
  Duration _lastElapsed = Duration.zero;
  double _nextVisitorIn = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _leaves = List.generate(
      widget.leafCount,
      (_) => FallingLeaf(_random, spreadOverScreen: true),
    );
    _nextVisitorIn = HalloweenVisitor.nextSpawnDelay(_random, first: true);
    _loadImages();
    if (widget.enabled) _ticker.start();
  }

  Future<void> _loadImages() async {
    try {
      final leaves = await Future.wait(
        AutumnEffectWidget.leafAssets.map(_decode),
      );
      final bat = await _decode(AutumnEffectWidget.batAsset);
      final ghost = await _decode(AutumnEffectWidget.ghostAsset);
      if (!mounted) return;
      setState(() {
        _leafImages = leaves;
        _batImage = bat;
        _ghostImage = ghost;
      });
    } catch (e) {
      // Ohne Grafiken bleibt der Effekt einfach aus – die App läuft normal weiter
      debugPrint('AutumnEffect: Grafiken konnten nicht geladen werden: $e');
    }
  }

  static Future<ui.Image> _decode(String asset) async {
    final data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void _onTick(Duration elapsed) {
    // Nach Pause/Resume keinen großen Sprung machen
    final dt = ((elapsed - _lastElapsed).inMicroseconds / 1e6).clamp(0.0, 0.1);
    _lastElapsed = elapsed;

    for (final leaf in _leaves) {
      leaf.update(dt, _random);
    }

    if (widget.withHalloweenVisitors) {
      _nextVisitorIn -= dt;
      if (_nextVisitorIn <= 0 && _visitors.isEmpty) {
        _visitors.add(HalloweenVisitor.spawn(_random));
        _nextVisitorIn = HalloweenVisitor.nextSpawnDelay(_random);
      }
    }
    for (final visitor in _visitors) {
      visitor.update(dt);
    }
    _visitors.removeWhere((v) => v.isDone);

    _frame.value++;
  }

  @override
  void didUpdateWidget(AutumnEffectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _lastElapsed = Duration.zero;
        _ticker.start();
      } else {
        _ticker.stop();
      }
    }
    if (!widget.withHalloweenVisitors) _visitors.clear();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    _leafImages?.forEach((i) => i.dispose());
    _batImage?.dispose();
    _ghostImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leafImages = _leafImages;
    if (!widget.enabled || leafImages == null) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: RepaintBoundary(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AutumnEffectPainter(
                  repaint: _frame,
                  leaves: _leaves,
                  visitors: _visitors,
                  leafImages: leafImages,
                  batImage: _batImage,
                  ghostImage: _ghostImage,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Ein fallendes Blatt. Positionen sind relativ zur Bildschirmgröße (0..1).
class FallingLeaf {
  late int imageIndex;
  late double baseX;
  late double y;
  late double size;
  late double fallSpeed;
  late double swingAmplitude;
  late double swingSpeed;
  late double swingPhase;
  late double rotation;
  late double rotationSpeed;
  late double flipPhase;
  late double flipSpeed;
  late double opacity;
  double _time = 0;

  FallingLeaf(Random random, {bool spreadOverScreen = false}) {
    _reset(random);
    y = spreadOverScreen ? random.nextDouble() : -0.08;
  }

  void _reset(Random random) {
    imageIndex = random.nextInt(AutumnEffectWidget.leafAssets.length);
    baseX = random.nextDouble();
    y = -0.08;
    size = 22 + random.nextDouble() * 18;
    fallSpeed = 0.035 + random.nextDouble() * 0.035; // ~15-30 s pro Bildschirm
    swingAmplitude = 0.02 + random.nextDouble() * 0.04;
    swingSpeed = 0.25 + random.nextDouble() * 0.35;
    swingPhase = random.nextDouble() * 2 * pi;
    rotation = random.nextDouble() * 2 * pi;
    rotationSpeed = (random.nextBool() ? 1 : -1) * (0.3 + random.nextDouble() * 0.9);
    flipPhase = random.nextDouble() * 2 * pi;
    flipSpeed = 0.8 + random.nextDouble() * 1.6;
    opacity = 0.75 + random.nextDouble() * 0.2;
  }

  double get x => baseX + sin(_time * swingSpeed * 2 * pi + swingPhase) * swingAmplitude;

  /// Horizontale Stauchung für das Taumeln (nie ganz 0, sonst verschwindet das Blatt)
  double get flipScale {
    final c = cos(flipPhase);
    return c.sign * max(c.abs(), 0.25);
  }

  void update(double dt, Random random) {
    _time += dt;
    y += fallSpeed * dt;
    rotation += rotationSpeed * dt;
    flipPhase += flipSpeed * dt;
    if (y > 1.08) _reset(random);
  }
}

enum HalloweenVisitorType { bat, ghost }

/// Fledermaus oder Gespenst, das einmal quer über den Bildschirm zieht.
class HalloweenVisitor {
  final HalloweenVisitorType type;
  final bool leftToRight;
  final double baseY;
  final double duration;
  final double size;
  double age = 0;

  HalloweenVisitor({
    required this.type,
    required this.leftToRight,
    required this.baseY,
    required this.duration,
    required this.size,
  });

  factory HalloweenVisitor.spawn(Random random) {
    final isBat = random.nextBool();
    return HalloweenVisitor(
      type: isBat ? HalloweenVisitorType.bat : HalloweenVisitorType.ghost,
      leftToRight: random.nextBool(),
      baseY: 0.12 + random.nextDouble() * 0.45,
      duration: isBat ? 4.5 + random.nextDouble() * 2 : 8 + random.nextDouble() * 3,
      size: isBat ? 60 + random.nextDouble() * 16 : 64 + random.nextDouble() * 18,
    );
  }

  /// Pause bis zum nächsten Besuch (Sekunden). Der erste kommt etwas früher.
  static double nextSpawnDelay(Random random, {bool first = false}) =>
      first ? 5 + random.nextDouble() * 5 : 12 + random.nextDouble() * 16;

  double get progress => (age / duration).clamp(0.0, 1.0);
  bool get isDone => age >= duration;

  /// Etwas über den Rand hinaus starten und enden, damit nichts aufploppt
  double get x {
    final p = leftToRight ? progress : 1 - progress;
    return -0.15 + p * 1.3;
  }

  double get y {
    switch (type) {
      case HalloweenVisitorType.bat:
        return baseY + sin(age * 5) * 0.025;
      case HalloweenVisitorType.ghost:
        return baseY + sin(age * 1.6) * 0.03;
    }
  }

  /// Flügelschlag der Fledermaus (vertikale Stauchung)
  double get flapScale =>
      type == HalloweenVisitorType.bat ? 0.55 + 0.45 * sin(age * 16).abs() : 1.0;

  /// Gespenst blendet sanft ein und aus
  double get opacity {
    if (type == HalloweenVisitorType.bat) return 1.0;
    const fade = 0.15;
    if (progress < fade) return 0.85 * progress / fade;
    if (progress > 1 - fade) return 0.85 * (1 - progress) / fade;
    return 0.85;
  }

  void update(double dt) => age += dt;
}

class AutumnEffectPainter extends CustomPainter {
  final List<FallingLeaf> leaves;
  final List<HalloweenVisitor> visitors;
  final List<ui.Image> leafImages;
  final ui.Image? batImage;
  final ui.Image? ghostImage;

  AutumnEffectPainter({
    required Listenable repaint,
    required this.leaves,
    required this.visitors,
    required this.leafImages,
    required this.batImage,
    required this.ghostImage,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.medium;

    for (final leaf in leaves) {
      final image = leafImages[leaf.imageIndex];
      final dx = leaf.x * size.width;
      final dy = leaf.y * size.height;
      paint.color = Colors.white.withValues(alpha: leaf.opacity);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(leaf.rotation);
      canvas.scale(leaf.flipScale, 1);
      _drawCentered(canvas, image, leaf.size, paint);
      canvas.restore();
    }

    for (final visitor in visitors) {
      final image = visitor.type == HalloweenVisitorType.bat ? batImage : ghostImage;
      if (image == null) continue;
      paint.color = Colors.white.withValues(alpha: visitor.opacity);

      canvas.save();
      canvas.translate(visitor.x * size.width, visitor.y * size.height);
      canvas.scale(1, visitor.flapScale);
      _drawCentered(canvas, image, visitor.size, paint);
      canvas.restore();
    }
  }

  /// Zeichnet das Bild zentriert, längste Seite = [longest] logische Pixel
  void _drawCentered(Canvas canvas, ui.Image image, double longest, Paint paint) {
    final w = image.width.toDouble();
    final h = image.height.toDouble();
    final scale = longest / max(w, h);
    final dst = Rect.fromCenter(center: Offset.zero, width: w * scale, height: h * scale);
    canvas.drawImageRect(image, Rect.fromLTWH(0, 0, w, h), dst, paint);
  }

  @override
  bool shouldRepaint(AutumnEffectPainter oldDelegate) =>
      oldDelegate.leafImages != leafImages ||
      oldDelegate.batImage != batImage ||
      oldDelegate.ghostImage != ghostImage;
}
