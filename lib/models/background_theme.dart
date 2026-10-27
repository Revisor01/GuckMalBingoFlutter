import 'package:flutter/material.dart';
import '../utilities/app_preferences.dart';
import '../utilities/debug_utils.dart';

/// Farbthemen für den Hintergrund-Verlauf.
enum BackgroundTheme {
  lightBlue('lightBlue', 'themeLightblue'),
  bluePurple('bluePurple', 'themeBluepurple'),
  pinkRed('pinkRed', 'themePinkred'),
  deepBlue('deepBlue', 'themeDeepblue'),
  pinkYellow('pinkYellow', 'themePinkyellow'),
  greenMint('greenMint', 'themeGreenmint'),
  christmas('christmas', 'themeChristmas'), // Weihnachts-Theme
  easter('easter', 'themeEaster'), // Oster-Theme
  autumn('autumn', 'themeAutumn'), // Herbst-Theme
  halloween('halloween', 'themeHalloween'); // Halloween-Theme

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
            _hexToColor('#c41e3a'), // Weihnachtsmann-Rot (Cardinal Red)
            _hexToColor('#a31621'), // Klassisches Weihnachtsrot
            _hexToColor('#7b1113'), // Tiefes Weihnachtsrot
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case BackgroundTheme.easter:
        return LinearGradient(
          colors: [
            _hexToColor('#C06080'), // Gedämpftes Rosa oben
            _hexToColor('#D4917A'), // Warmes Rosé-Mitte
            _hexToColor('#E8C4A0'), // Helles Sandgelb unten
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case BackgroundTheme.autumn:
        return LinearGradient(
          colors: [
            _hexToColor('#E0892A'), // Kürbisorange oben
            _hexToColor('#C4562A'), // Rostrot
            _hexToColor('#7E3A1E'), // Kastanienbraun unten
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case BackgroundTheme.halloween:
        return LinearGradient(
          colors: [
            _hexToColor('#2A1B4D'), // Nachtviolett oben
            _hexToColor('#56286E'), // Hexenlila
            _hexToColor('#D2601A'), // Kürbisglühen unten
          ],
          stops: const [0.0, 0.6, 1.0],
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
            Color.fromRGBO(140, 20, 40, 1.0), // Gedämpftes Weihnachtsrot
            Color.fromRGBO(100, 15, 25, 1.0), // Dunkles Weihnachtsrot
            Color.fromRGBO(70, 10, 15, 1.0), // Tiefes Weihnachtsrot
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case BackgroundTheme.easter:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(120, 60, 80, 1.0), // Gedämpftes Dunkelrosa
            Color.fromRGBO(130, 80, 70, 1.0), // Warmes Dunkelrosé
            Color.fromRGBO(140, 110, 90, 1.0), // Dunkles Sand
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case BackgroundTheme.autumn:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(120, 66, 22, 1.0), // Gedämpftes Kürbisorange
            Color.fromRGBO(100, 42, 20, 1.0), // Dunkles Rost
            Color.fromRGBO(60, 28, 14, 1.0), // Tiefes Kastanienbraun
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case BackgroundTheme.halloween:
        return const LinearGradient(
          colors: [
            Color.fromRGBO(20, 12, 40, 1.0), // Mitternacht
            Color.fromRGBO(50, 22, 66, 1.0), // Dunkles Lila
            Color.fromRGBO(120, 52, 14, 1.0), // Glimmendes Orange
          ],
          stops: [0.0, 0.6, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  /// Saisonale Themes werden nur in ihrer Saison zur Auswahl angeboten
  bool isSelectable({
    required bool isChristmas,
    required bool isEaster,
    required bool isAutumn,
    required bool isHalloween,
  }) {
    switch (this) {
      case BackgroundTheme.christmas:
        return isChristmas;
      case BackgroundTheme.easter:
        return isEaster;
      case BackgroundTheme.autumn:
        return isAutumn;
      case BackgroundTheme.halloween:
        return isHalloween;
      default:
        return true;
    }
  }

  /// Eigene Hintergrund-Symbole des Themes; null = die normalen Bereichs-Icons
  List<BackgroundSymbol>? get patternSymbols {
    switch (this) {
      case BackgroundTheme.autumn:
        return const [
          BackgroundSymbol.asset('herbst_ahorn'),
          BackgroundSymbol.asset('herbst_eichhoernchen'),
          BackgroundSymbol.asset('herbst_eiche'),
          BackgroundSymbol.asset('herbst_kuerbis'),
          BackgroundSymbol.asset('herbst_pappel'),
          BackgroundSymbol.asset('herbst_igel'),
          BackgroundSymbol.asset('herbst_kastanie'),
          BackgroundSymbol.asset('herbst_pilze'),
          BackgroundSymbol.asset('herbst_birke'),
          BackgroundSymbol.asset('herbst_eule'),
        ];
      case BackgroundTheme.halloween:
        return const [
          BackgroundSymbol.asset('halloween_fledermaus'),
          BackgroundSymbol.asset('halloween_kuerbis'),
          BackgroundSymbol.icon(Icons.dark_mode),
          BackgroundSymbol.asset('halloween_gespenst'),
          BackgroundSymbol.asset('halloween_spinne'),
          BackgroundSymbol.icon(Icons.star),
          BackgroundSymbol.asset('halloween_hexenhut'),
          BackgroundSymbol.asset('halloween_katze'),
          BackgroundSymbol.asset('halloween_totenkopf'),
          BackgroundSymbol.asset('halloween_kessel'),
        ];
      default:
        return null;
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

  /// Saisonale Themes (Weihnachten, Ostern, Herbst, Halloween)
  bool get isSeasonal =>
      this == BackgroundTheme.christmas ||
      this == BackgroundTheme.easter ||
      this == BackgroundTheme.autumn ||
      this == BackgroundTheme.halloween;

  /// Das Theme der laufenden Saison oder null; Halloween hat Vorrang vor Herbst.
  static BackgroundTheme? currentSeasonalTheme() {
    if (isChristmasSeason()) return BackgroundTheme.christmas;
    if (isEasterSeason()) return BackgroundTheme.easter;
    if (isHalloweenSeason()) return BackgroundTheme.halloween;
    if (isAutumnSeason()) return BackgroundTheme.autumn;
    return null;
  }

  /// Schlüssel je Saison und Jahr (z. B. 'autumn-2026'); Januar-Weihnachten zählt zum Vorjahr.
  static String seasonKey(BackgroundTheme theme, DateTime date) {
    final year = theme == BackgroundTheme.christmas && date.month == 1 ? date.year - 1 : date.year;
    return '${theme.value}-$year';
  }

  /// Lädt das Theme beim Start und schaltet zu Saisonbeginn um, danach zurück auf die eigene Wahl.
  static BackgroundTheme loadSavedTheme() {
    final prefs = AppPreferences.instance;
    final saved = _migratedSavedTheme(prefs);
    final season = currentSeasonalTheme();

    if (season != null) {
      final key = seasonKey(season, getCurrentDate());
      if (prefs.seasonThemeApplied != key) {
        // Nur nicht-saisonale Wahl merken, sonst geht sie bei Herbst → Halloween → Herbst verloren.
        if (saved == null || !saved.isSeasonal) {
          prefs.setThemeBeforeSeason((saved ?? BackgroundTheme.lightBlue).value);
        }
        prefs.setBackgroundTheme(season.value);
        prefs.setSeasonThemeApplied(key);
        _enableEffectFor(season, prefs);
        return season;
      }
      return saved ?? season;
    }

    if (saved != null && saved.isSeasonal) {
      final restored = BackgroundTheme.fromString(prefs.themeBeforeSeason ?? 'lightBlue');
      prefs.setBackgroundTheme(restored.value);
      return restored;
    }
    return saved ?? BackgroundTheme.lightBlue;
  }

  static void _enableEffectFor(BackgroundTheme season, AppPreferences prefs) {
    switch (season) {
      case BackgroundTheme.christmas:
        prefs.setSnowfallEnabled(true);
      case BackgroundTheme.easter:
        prefs.setEasterEffectEnabled(true);
      case BackgroundTheme.autumn:
      case BackgroundTheme.halloween:
        prefs.setAutumnEffectEnabled(true);
      default:
        break;
    }
  }

  /// Gespeichertes Theme lesen, alte deutsche Namen migrieren
  static BackgroundTheme? _migratedSavedTheme(AppPreferences prefs) {
    final themeName = prefs.backgroundThemeRaw;
    if (themeName == null) return null;

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
      prefs.setBackgroundTheme(newName);
      return BackgroundTheme.fromString(newName);
    }

    return BackgroundTheme.fromString(themeName);
  }

  /// Speichere Theme
  Future<void> save() async {
    await AppPreferences.instance.setBackgroundTheme(value);
  }
}

/// Ein Symbol im Hintergrundmuster: Material-Icon oder Silhouette aus assets/images/patterns/.
class BackgroundSymbol {
  final IconData? icon;
  final String? assetName;

  const BackgroundSymbol.icon(IconData this.icon) : assetName = null;
  const BackgroundSymbol.asset(String this.assetName) : icon = null;

  String? get assetPath =>
      assetName == null ? null : 'assets/images/patterns/$assetName.webp';
}
