import 'package:flutter/foundation.dart';
import 'app_preferences.dart';
import 'debug_utils.dart';

/// SeasonService — zentraler ChangeNotifier für saisonalen State.
///
/// Ersetzt verstreute globale Variablen (cachedIsChristmas, cachedIsEaster)
/// und ValueNotifier (snowfallEnabledNotifier, easterEffectEnabledNotifier).
/// Erweiterbar für zukünftige Jahreszeiten (z.B. Halloween).
class SeasonService extends ChangeNotifier {
  late bool _isChristmas;
  late bool _isEaster;
  late bool _snowfallEnabled;
  late bool _easterEffectEnabled;

  SeasonService() {
    _initSeasons();
  }

  void _initSeasons() {
    _isChristmas = isChristmasSeason();
    _isEaster = isEasterSeason();
    _snowfallEnabled = AppPreferences.instance.snowfallEnabled;
    _easterEffectEnabled = AppPreferences.instance.easterEffectEnabled;
  }

  bool get isChristmas => _isChristmas;
  bool get isEaster => _isEaster;
  bool get snowfallEnabled => _snowfallEnabled;
  bool get easterEffectEnabled => _easterEffectEnabled;

  /// Schneefall soll angezeigt werden wenn Weihnachtszeit UND Schneefall aktiviert
  bool get shouldShowSnowfall => _isChristmas && _snowfallEnabled;

  /// Oster-Effekt soll angezeigt werden wenn Osterzeit UND Oster-Effekt aktiviert
  bool get shouldShowEasterEffect => _isEaster && _easterEffectEnabled;

  /// Schneefall-Einstellung setzen, persistieren und Listeners benachrichtigen
  Future<void> setSnowfallEnabled(bool enabled) async {
    _snowfallEnabled = enabled;
    await AppPreferences.instance.setSnowfallEnabled(enabled);
    notifyListeners();
  }

  /// Oster-Effekt-Einstellung setzen, persistieren und Listeners benachrichtigen
  Future<void> setEasterEffectEnabled(bool enabled) async {
    _easterEffectEnabled = enabled;
    await AppPreferences.instance.setEasterEffectEnabled(enabled);
    notifyListeners();
  }
}
