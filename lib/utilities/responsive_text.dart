import 'package:flutter/material.dart';

/// Schriftgrößen abhängig von der Bildschirmbreite.
class ResponsiveText {
  /// Skalierungsfaktor: 1.0 bis etwa 393 px Breite, darüber kleiner.
  static double getFontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
