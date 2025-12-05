import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/debug_utils.dart';

/// BackgroundTheme Enum - Portiert von Swift
/// Verschiedene Farbthemen für Hintergrund-Gradients
enum BackgroundTheme {
  lightBlue('lightBlue', 'themeLightblue'),
  bluePurple('bluePurple', 'themeBluepurple'),
  pinkRed('pinkRed', 'themePinkred'),
  deepBlue('deepBlue', 'themeDeepblue'),
  pinkYellow('pinkYellow', 'themePinkyellow'),
  greenMint('greenMint', 'themeGreenmint'),
  christmas('christmas', 'themeChristmas'); // Weihnachts-Theme

  final String value;
  final String displayNameKey;

  const BackgroundTheme(this.value, this.displayNameKey);

  /// Light Mode Gradient
  LinearGradient get gradient {
    switch (this) {
      case BackgroundTheme.lightBlue:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(135, 206, 250, 1.0), // Hellblau
            Color.fromRGBO(102, 173, 237, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.bluePurple:
        return LinearGradient(
          colors: [
            _hexToColor('#667EEA'),
            _hexToColor('#764BA2'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.pinkRed:
        return LinearGradient(
          colors: [
            _hexToColor('#F093FB'),
            _hexToColor('#F5576C'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.deepBlue:
        return LinearGradient(
          colors: [
            _hexToColor('#2575FC'),
            _hexToColor('#6A11CB'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.pinkYellow:
        return LinearGradient(
          colors: [
            _hexToColor('#FA709A'),
            _hexToColor('#FEE140'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.greenMint:
        return LinearGradient(
          colors: [
            _hexToColor('#11998E'),
            _hexToColor('#38EF7D'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.christmas:
        return LinearGradient(
          colors: [
            _hexToColor('#0d1b2a'), // Tiefes Mitternachtsblau
            _hexToColor('#1b263b'), // Dunkles Nachtblau
            _hexToColor('#722f37'), // Elegantes Burgundy
          ],
          stops: const [0.0, 0.4, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  /// Dark Mode Gradient (dunklere Varianten)
  LinearGradient get darkGradient {
    switch (this) {
      case BackgroundTheme.lightBlue:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(64, 102, 140, 1.0),
            Color.fromRGBO(51, 89, 128, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.bluePurple:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(64, 77, 128, 1.0),
            Color.fromRGBO(77, 51, 102, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.pinkRed:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(128, 77, 115, 1.0),
            Color.fromRGBO(122, 51, 77, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.deepBlue:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(26, 77, 128, 1.0),
            Color.fromRGBO(64, 13, 102, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.pinkYellow:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(128, 77, 89, 1.0),
            Color.fromRGBO(140, 115, 51, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.greenMint:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(13, 89, 77, 1.0),
            Color.fromRGBO(38, 115, 89, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case BackgroundTheme.christmas:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(8, 15, 25, 1.0), // Sehr dunkles Mitternachtsblau
            Color.fromRGBO(15, 22, 35, 1.0), // Dunkles Nachtblau
            Color.fromRGBO(60, 25, 30, 1.0), // Dunkles Burgundy
          ],
          stops: [0.0, 0.4, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  /// Adaptive Gradient basierend auf Brightness
  LinearGradient adaptiveGradient(Brightness brightness) {
    return brightness == Brightness.dark ? darkGradient : gradient;
  }

  /// Helper: Hex String zu Color
  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// From String
  static BackgroundTheme fromString(String value) {
    return BackgroundTheme.values.firstWhere(
      (theme) => theme.value == value,
      orElse: () => BackgroundTheme.lightBlue,
    );
  }

  /// Lade gespeichertes Theme (Christmas-Theme als Default in der Weihnachtszeit)
  static Future<BackgroundTheme> loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Weihnachts-Special: Christmas-Theme als Default wenn noch kein Theme gespeichert
      final defaultTheme = isChristmasSeason() ? 'christmas' : 'lightBlue';
      final themeName = prefs.getString('backgroundTheme') ?? defaultTheme;

      // Migration: alte deutsche Namen auf neue englische Namen mappen
      const migrationMap = {
        'Himmelblau': 'lightBlue',
        'Meeresgrün': 'lightBlue',
        'Abendsonne': 'lightBlue',
        'Dschungel': 'lightBlue',
        'Nachtmodus': 'lightBlue',
        'turquoise': 'lightBlue',
        'sunset': 'lightBlue',
        'forest': 'lightBlue',
        'pinkPurple': 'lightBlue',
      };

      if (migrationMap.containsKey(themeName)) {
        final newName = migrationMap[themeName]!;
        await prefs.setString('backgroundTheme', newName);
        return BackgroundTheme.fromString(newName);
      }

      return BackgroundTheme.fromString(themeName);
    } catch (e) {
      // Fallback bei SharedPreferences-Fehler
      return isChristmasSeason() ? BackgroundTheme.christmas : BackgroundTheme.lightBlue;
    }
  }

  /// Speichere Theme
  Future<void> save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backgroundTheme', value);
    } catch (e) {
      // Speicherfehler ignorieren - Theme ist bereits im RAM
    }
  }
}
