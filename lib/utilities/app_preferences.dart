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
}
