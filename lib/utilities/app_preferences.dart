import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Zentrale Preferences-Klasse — verschlüsselter Storage mit In-Memory-Cache.
/// Migration von SharedPreferences erfolgt automatisch beim ersten Start.
class AppPreferences {
  static late final AppPreferences instance;
  final FlutterSecureStorage _storage;

  // In-Memory-Cache für synchrone Getter (SecureStorage ist async)
  final Map<String, String?> _cache = {};

  static const _migratedKey = '_migrated_to_secure';

  AppPreferences._(this._storage);

  static Future<void> init() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    final prefs = AppPreferences._(storage);
    await prefs._migrateFromSharedPreferences();
    await prefs._loadCache();
    instance = prefs;
  }

  /// Migration: Liest alte SharedPreferences, schreibt in SecureStorage, markiert als migriert
  Future<void> _migrateFromSharedPreferences() async {
    final alreadyMigrated = await _storage.read(key: _migratedKey);
    if (alreadyMigrated == 'true') return;

    final oldPrefs = await SharedPreferences.getInstance();

    // Bool-Werte migrieren
    for (final key in ['snowfallEnabled', 'easterEffectEnabled', 'hasSeenOnboarding']) {
      final val = oldPrefs.getBool(key);
      if (val != null) {
        await _storage.write(key: key, value: val.toString());
      }
    }

    // String-Werte migrieren
    for (final key in ['backgroundTheme', 'savedGameState']) {
      final val = oldPrefs.getString(key);
      if (val != null) {
        await _storage.write(key: key, value: val);
      }
    }

    await _storage.write(key: _migratedKey, value: 'true');
  }

  /// Lädt alle bekannten Keys in den Cache für synchronen Zugriff
  Future<void> _loadCache() async {
    for (final key in ['snowfallEnabled', 'easterEffectEnabled', 'hasSeenOnboarding', 'backgroundTheme', 'savedGameState']) {
      _cache[key] = await _storage.read(key: key);
    }
  }

  // --- Synchrone Getter lesen aus Cache, Setter aktualisieren Cache + Storage ---

  // Snowfall
  bool get snowfallEnabled => _cache['snowfallEnabled'] != 'false'; // Default true
  Future<void> setSnowfallEnabled(bool value) async {
    _cache['snowfallEnabled'] = value.toString();
    await _storage.write(key: 'snowfallEnabled', value: value.toString());
  }

  // Easter Effect
  bool get easterEffectEnabled => _cache['easterEffectEnabled'] != 'false'; // Default true
  Future<void> setEasterEffectEnabled(bool value) async {
    _cache['easterEffectEnabled'] = value.toString();
    await _storage.write(key: 'easterEffectEnabled', value: value.toString());
  }

  // Background Theme
  String? get backgroundThemeRaw => _cache['backgroundTheme'];
  Future<void> setBackgroundTheme(String value) async {
    _cache['backgroundTheme'] = value;
    await _storage.write(key: 'backgroundTheme', value: value);
  }

  // Onboarding
  bool get hasSeenOnboarding => _cache['hasSeenOnboarding'] == 'true';
  Future<void> setHasSeenOnboarding(bool value) async {
    _cache['hasSeenOnboarding'] = value.toString();
    await _storage.write(key: 'hasSeenOnboarding', value: value.toString());
  }

  // Game State Persistence
  static const _keyGameState = 'savedGameState';

  bool get hasSavedGameState => _cache[_keyGameState] != null;

  Future<void> saveGameState(Map<String, dynamic> state) async {
    final json = jsonEncode(state);
    _cache[_keyGameState] = json;
    await _storage.write(key: _keyGameState, value: json);
  }

  Map<String, dynamic>? loadGameState() {
    final json = _cache[_keyGameState];
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      clearGameState();
      return null;
    }
  }

  Future<void> clearGameState() async {
    _cache.remove(_keyGameState);
    await _storage.delete(key: _keyGameState);
  }

  // Duell Game State Persistence
  static const _keyDuellState = 'savedDuellState';

  bool get hasSavedDuellState => _prefs.getString(_keyDuellState) != null;

  Future<void> saveDuellState(Map<String, dynamic> state) async {
    await _prefs.setString(_keyDuellState, jsonEncode(state));
  }

  Map<String, dynamic>? loadDuellState() {
    final json = _prefs.getString(_keyDuellState);
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      clearDuellState();
      return null;
    }
  }

  Future<void> clearDuellState() async {
    await _prefs.remove(_keyDuellState);
  }
}
