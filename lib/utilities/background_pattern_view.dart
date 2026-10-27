import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/area.dart';
import '../models/background_theme.dart';

/// Dekorative Hintergrund-Icons; Herbst und Halloween bringen eigene Symbole mit.
class BackgroundPatternView extends StatefulWidget {
  final Area? area;
  final BackgroundTheme? theme;

  const BackgroundPatternView({super.key, this.area, this.theme});

  @override
  State<BackgroundPatternView> createState() => _BackgroundPatternViewState();
}

class _BackgroundPatternViewState extends State<BackgroundPatternView> {
  Size? _lastSize;
  Area? _lastArea;
  BackgroundTheme? _lastTheme;
  List<_IconPosition> _cachedPositions = [];

  List<BackgroundSymbol> get symbols =>
      widget.theme?.patternSymbols ??
      icons.map((icon) => BackgroundSymbol.icon(icon)).toList();

  List<IconData> get icons {
    if (widget.area != null) {
      switch (widget.area!) {
        case Area.autobahn:
          return [
            Icons.directions_car,
            Icons.local_shipping,
            Icons.local_gas_station,
            Icons.air,
            Icons.forest,
            Icons.route,
          ];
        case Area.land:
          return [
            Icons.forest,
            Icons.pedal_bike,
            Icons.eco,
            Icons.home,
            Icons.flutter_dash, // bird equivalent
            Icons.wb_sunny,
          ];
        case Area.stadt:
          return [
            Icons.apartment,
            Icons.pedal_bike,
            Icons.directions_car,
            Icons.directions_bus,
            Icons.forest,
            Icons.directions_walk,
          ];
        case Area.zug:
          return [
            Icons.train,
            Icons.confirmation_number,
            Icons.directions_walk,
            Icons.luggage,
            Icons.local_cafe,
            Icons.menu_book,
          ];
        case Area.kirche:
          return [
            Icons.add, // cross equivalent
            Icons.notifications,
            Icons.menu_book,
            Icons.local_fire_department,
            Icons.account_balance,
            Icons.access_time,
          ];
        case Area.zuHause:
          return [
            Icons.weekend, // sofa
            Icons.bed,
            Icons.light,
            Icons.tv,
            Icons.local_cafe,
            Icons.menu_book,
          ];
        case Area.zoo:
          return [
            Icons.pets,
            Icons.flutter_dash, // hare equivalent
            Icons.flutter_dash, // bird
            Icons.flutter_dash, // tortoise
            Icons.flutter_dash, // lizard
            Icons.eco,
          ];
      }
    } else {
      // Alle Icons für Start/Auswahl-Seiten
      return [
        Icons.directions_car,
        Icons.local_shipping,
        Icons.pedal_bike,
        Icons.train,
        Icons.forest,
        Icons.home,
        Icons.apartment,
        Icons.wb_sunny,
        Icons.cloud,
        Icons.air,
        Icons.flutter_dash,
        Icons.eco,
        Icons.add,
        Icons.notifications,
        Icons.menu_book,
        Icons.local_fire_department,
        Icons.pets,
        Icons.weekend,
        Icons.light,
        Icons.tv,
        Icons.local_cafe,
        Icons.directions_walk,
        Icons.flight,
        Icons.directions_bus,
      ];
    }
  }

  /// Gibt gecachte Positionen zurück oder berechnet neu bei Größen-/Area-Änderung
  List<_IconPosition> _getPositions(double width, double height) {
    final newSize = Size(width, height);
    if (newSize != _lastSize ||
        widget.area != _lastArea ||
        widget.theme != _lastTheme ||
        _cachedPositions.isEmpty) {
      _cachedPositions = _generatePositions(width, height);
      _lastSize = newSize;
      _lastArea = widget.area;
      _lastTheme = widget.theme;
    }
    return _cachedPositions;
  }

  /// Generiere random verteilte Icons
  List<_IconPosition> _generatePositions(double width, double height) {
    final positions = <_IconPosition>[];

    // Sicherstellen, dass Dimensionen groß genug sind
    if (width <= 80 || height <= 80) {
      return positions;
    }

    final rng = math.Random(42); // Seeded für konsistente Positionen
    final symbols = this.symbols;

    const minDistance = 110.0; // Mindestabstand zwischen Icons
    const maxAttempts = 200; // Max Versuche pro Icon
    const targetCount = 30; // Angestrebte Icon-Anzahl

    for (int i = 0; i < targetCount; i++) {
      int attempts = 0;
      bool placed = false;

      while (attempts < maxAttempts && !placed) {
        final x = 40 + rng.nextDouble() * (width - 80);
        final y = 40 + rng.nextDouble() * (height - 80);

        // Prüfe ob genug Abstand zu allen anderen Icons
        bool hasSpace = true;
        for (final existing in positions) {
          final dx = x - existing.x;
          final dy = y - existing.y;
          final distance = math.sqrt(dx * dx + dy * dy);

          if (distance < minDistance) {
            hasSpace = false;
            break;
          }
        }

        if (hasSpace) {
          final symbol = symbols[i % symbols.length];
          final rotation = -20 + rng.nextDouble() * 40;
          positions.add(_IconPosition(
            x: x,
            y: y,
            symbol: symbol,
            rotation: rotation,
          ));
          placed = true;
        }

        attempts++;
      }
    }

    return positions;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final positions = _getPositions(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return IgnorePointer(
          child: Stack(
            children: positions
                .map((pos) => Positioned(
                      left: pos.x - 22.5, // Center icon (45/2)
                      top: pos.y - 22.5,
                      child: Transform.rotate(
                        angle: pos.rotation * math.pi / 180,
                        child: _buildSymbol(pos.symbol),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _IconPosition {
  final double x;
  final double y;
  final BackgroundSymbol symbol;
  final double rotation;

  _IconPosition({
    required this.x,
    required this.y,
    required this.symbol,
    required this.rotation,
  });
}

const _symbolSize = 45.0;
final _symbolColor = Colors.white.withValues(alpha: 0.2);

Widget _buildSymbol(BackgroundSymbol symbol) {
  final assetPath = symbol.assetPath;
  if (assetPath == null) {
    return Icon(
      symbol.icon,
      size: _symbolSize,
      color: _symbolColor,
      weight: 100, // thin
    );
  }
  // Weiße Silhouette, eingefärbt wie die Icons
  return Image.asset(
    assetPath,
    width: _symbolSize,
    height: _symbolSize,
    fit: BoxFit.contain,
    color: _symbolColor,
    colorBlendMode: BlendMode.srcIn,
  );
}
