import 'package:flutter/material.dart';

/// AppColors - Portiert von Swift
/// Alle Farben und Gradients der App
class AppColors {
  // Hauptfarben - Türkis-Grün matt
  static const Color primary = Color.fromRGBO(95, 211, 188, 1.0); // #5FD3BC
  static const Color primaryLight = Color.fromRGBO(127, 224, 204, 1.0); // #7FE0CC
  static const Color primaryDark = Color.fromRGBO(74, 184, 158, 1.0); // #4AB89E

  // Grün für richtige Antworten (Matteres, angenehmeres Grün)
  static const Color successGreen = Color.fromRGBO(51, 166, 102, 1.0); // RGB(0.20, 0.65, 0.40)
  static const Color successGreenLight = Color.fromRGBO(64, 179, 115, 1.0); // RGB(0.25, 0.70, 0.45)
  static const Color successGreenDark = Color.fromRGBO(38, 140, 89, 1.0); // RGB(0.15, 0.55, 0.35)

  // Orange für Bingo-Nachrichten (Warmes, freundliches Orange)
  static const Color bingoOrange = Color.fromRGBO(255, 157, 46, 1.0); // #FF9D2E
  static const Color bingoOrangeDark = Color.fromRGBO(235, 133, 26, 1.0);

  // Jahreszeiten-Gradients
  static const LinearGradient summer = LinearGradient(
    colors: [
      Color.fromRGBO(255, 235, 59, 0.8), // Yellow
      Color.fromRGBO(255, 152, 0, 0.7), // Orange
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient winter = LinearGradient(
    colors: [
      Color.fromRGBO(33, 150, 243, 0.7), // Blue
      Color.fromRGBO(0, 188, 212, 0.6), // Cyan
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gebiete-Gradients
  static final LinearGradient autobahnGradient = LinearGradient(
    colors: [
      Colors.blue.withValues(alpha: 0.8),
      Colors.blue.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient landGradient = LinearGradient(
    colors: [
      successGreen.withValues(alpha: 0.8),
      successGreen.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient stadtGradient = LinearGradient(
    colors: [
      Colors.red.withValues(alpha:0.8),
      Colors.red.withValues(alpha:0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient zugGradient = LinearGradient(
    colors: [
      Colors.purple.withValues(alpha:0.8),
      Colors.purple.withValues(alpha:0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Spielmodi-Gradients
  static final LinearGradient sucheGradient = LinearGradient(
    colors: [
      successGreen.withValues(alpha:0.9),
      successGreen.withValues(alpha:0.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient jagdGradient = LinearGradient(
    colors: [
      Colors.orange.withValues(alpha:0.9),
      Colors.orange.withValues(alpha:0.7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Extensions für adaptive Button-Styles
extension AdaptiveButtonStyle on Widget {
  /// Adaptive Button Style für Dark & Light Mode
  Widget adaptiveButtonStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha:0.15)
            : Colors.white.withValues(alpha:0.25),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha:0.1)
                : Colors.black.withValues(alpha:0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: this,
    );
  }

  /// Glass Card Effekt (Material 3 equivalent)
  Widget glassCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: this,
      ),
    );
  }
}
