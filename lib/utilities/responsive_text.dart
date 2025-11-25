import 'package:flutter/material.dart';

/// Responsive Text Utilities
/// Passt Font-Größen basierend auf Screen-Größe an
class ResponsiveText {
  /// Berechnet einen Skalierungsfaktor basierend auf der Screen-Breite
  /// Auf größeren Screens (iPhone 16e, 6.7") → kleinere Fonts (0.95)
  /// Auf normalen Screens (iPhone 15, 6.1") → normale Fonts (1.0)
  static double getFontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // iPhone 15: ~393px → scale 1.0
    // iPhone 16e: ~430px → scale 0.95
    if (width > 420) {
      return 0.95; // Größere Screens: kleinere Fonts
    } else if (width > 400) {
      return 0.97;
    }
    return 1.0; // Standard
  }

  /// Skaliert eine Font-Größe responsiv
  static double scaledFontSize(BuildContext context, double baseSize) {
    return baseSize * getFontScale(context);
  }
}
