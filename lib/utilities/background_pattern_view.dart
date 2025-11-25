import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/area.dart';

/// BackgroundPatternView - Portiert von Swift
/// Zeigt dekorative Icons im Hintergrund
class BackgroundPatternView extends StatelessWidget {
  final Area? area;

  const BackgroundPatternView({super.key, this.area});

  List<IconData> get icons {
    if (area != null) {
      switch (area!) {
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

  /// Generiere random verteilte Icons
  List<_IconPosition> _generatePositions(double width, double height) {
    final positions = <_IconPosition>[];

    // Sicherstellen, dass Dimensionen groß genug sind
    if (width <= 80 || height <= 80) {
      return positions;
    }

    final rng = math.Random(42); // Seeded für konsistente Positionen

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
          final icon = icons[i % icons.length];
          final rotation = -20 + rng.nextDouble() * 40;
          positions.add(_IconPosition(
            x: x,
            y: y,
            icon: icon,
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
        final positions = _generatePositions(
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
                        child: Icon(
                          pos.icon,
                          size: 45,
                          color: Colors.white.withOpacity(0.2),
                          weight: 100, // thin
                        ),
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
  final IconData icon;
  final double rotation;

  _IconPosition({
    required this.x,
    required this.y,
    required this.icon,
    required this.rotation,
  });
}
