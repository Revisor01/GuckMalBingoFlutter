import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Zentrale Preferences-Klasse — einziger Ort für SharedPreferences.getInstance()
class AppPreferences {
  static late final AppPreferences instance;
  final SharedPreferences _prefs;

  AppPreferences._(this._prefs);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    instance = AppPreferences._(prefs);
  }

  // Snowfall
  bool get snowfallEnabled => _prefs.getBool('snowfallEnabled') ?? true;
  Future<void> setSnowfallEnabled(bool value) => _prefs.setBool('snowfallEnabled', value);

  // Easter Effect
  bool get easterEffectEnabled => _prefs.getBool('easterEffectEnabled') ?? true;
  Future<void> setEasterEffectEnabled(bool value) => _prefs.setBool('easterEffectEnabled', value);

  // Background Theme
  String? get backgroundThemeRaw => _prefs.getString('backgroundTheme');
  Future<void> setBackgroundTheme(String value) => _prefs.setString('backgroundTheme', value);

  // Onboarding
  bool get hasSeenOnboarding => _prefs.getBool('hasSeenOnboarding') ?? false;
  Future<void> setHasSeenOnboarding(bool value) => _prefs.setBool('hasSeenOnboarding', value);

  // Game State Persistence
  static const _keyGameState = 'savedGameState';

  bool get hasSavedGameState => _prefs.getString(_keyGameState) != null;

  Future<void> saveGameState(Map<String, dynamic> state) async {
    await _prefs.setString(_keyGameState, jsonEncode(state));
  }

  Map<String, dynamic>? loadGameState() {
    final json = _prefs.getString(_keyGameState);
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      clearGameState();
      return null;
    }
  }

  Future<void> clearGameState() async {
    await _prefs.remove(_keyGameState);
  }
}
