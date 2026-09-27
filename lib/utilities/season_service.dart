import 'package:flutter/foundation.dart';
import 'app_preferences.dart';
import 'debug_utils.dart';

/// SeasonService — zentraler ChangeNotifier für saisonalen State.
///
/// Ersetzt verstreute globale Variablen (cachedIsChristmas, cachedIsEaster)
/// und ValueNotifier (snowfallEnabledNotifier, easterEffectEnabledNotifier).
class SeasonService extends ChangeNotifier {
  late bool _isChristmas;
  late bool _isEaster;
  late bool _snowfallEnabled;
  late bool _easterEffectEnabled;
  late bool _isAutumn;
  late bool _isHalloween;
  late bool _autumnEffectEnabled;

  SeasonService() {
    _initSeasons();
  }

  void _initSeasons() {
    _isChristmas = isChristmasSeason();
    _isEaster = isEasterSeason();
    _snowfallEnabled = AppPreferences.instance.snowfallEnabled;
    _easterEffectEnabled = AppPreferences.instance.easterEffectEnabled;
    _isAutumn = isAutumnSeason();
    _isHalloween = isHalloweenSeason();
    _autumnEffectEnabled = AppPreferences.instance.autumnEffectEnabled;
  }

  bool get isChristmas => _isChristmas;
  bool get isEaster => _isEaster;
  bool get snowfallEnabled => _snowfallEnabled;
  bool get easterEffectEnabled => _easterEffectEnabled;
  bool get isAutumn => _isAutumn;
  bool get isHalloween => _isHalloween;
  bool get autumnEffectEnabled => _autumnEffectEnabled;

  /// Schneefall soll angezeigt werden wenn Weihnachtszeit UND Schneefall aktiviert
  bool get shouldShowSnowfall => _isChristmas && _snowfallEnabled;

  /// Oster-Effekt soll angezeigt werden wenn Osterzeit UND Oster-Effekt aktiviert
  bool get shouldShowEasterEffect => _isEaster && _easterEffectEnabled;

  /// Blätter-Effekt soll angezeigt werden wenn Herbstzeit UND Herbst-Effekt aktiviert
  bool get shouldShowAutumnEffect => _isAutumn && _autumnEffectEnabled;

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

  /// Herbst-Effekt-Einstellung setzen, persistieren und Listeners benachrichtigen
  Future<void> setAutumnEffectEnabled(bool enabled) async {
    _autumnEffectEnabled = enabled;
    await AppPreferences.instance.setAutumnEffectEnabled(enabled);
    notifyListeners();
  }
}
