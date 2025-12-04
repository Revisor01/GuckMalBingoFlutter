import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug Utilities für Testing
///
/// Hier können Debug-Variablen gesetzt werden, die das Verhalten der App
/// für Testing-Zwecke überschreiben.

/// Debug-Datum für Weihnachts-Items Testing
///
/// Wenn != null, wird dieses Datum statt DateTime.now() verwendet.
/// Damit können wir testen, ob die Weihnachts-Items ab 1. Dezember erscheinen.
///
/// Beispiel: DateTime(2025, 12, 2) simuliert den 2. Dezember 2025
/// Im Release-Mode wird immer das echte Systemdatum verwendet.
DateTime? debugOverrideDate = kReleaseMode ? null : null;

/// Gibt das aktuelle Datum zurück - entweder das Debug-Datum oder das echte Datum
/// Im Release-Mode wird immer das echte Systemdatum verwendet.
DateTime getCurrentDate() {
  if (kReleaseMode) return DateTime.now();
  return debugOverrideDate ?? DateTime.now();
}

/// Prüft, ob aktuell Weihnachtszeit ist (1. Dezember - 6. Januar)
/// Wird für Schneefalleffekt und Weihnachts-Sounds verwendet
bool isChristmasSeason() {
  final now = getCurrentDate();
  // Dezember (ab 1.12.)
  if (now.month == 12) return true;
  // Januar (bis 6.1.)
  if (now.month == 1 && now.day <= 6) return true;
  return false;
}

/// Schneefall-Einstellung als ValueNotifier für reaktives UI
final snowfallEnabledNotifier = ValueNotifier<bool>(true);

/// Lade Schneefall-Einstellung aus SharedPreferences
Future<void> loadSnowfallSetting() async {
  final prefs = await SharedPreferences.getInstance();
  snowfallEnabledNotifier.value = prefs.getBool('snowfallEnabled') ?? true;
}

/// Speichere Schneefall-Einstellung
Future<void> setSnowfallEnabled(bool enabled) async {
  snowfallEnabledNotifier.value = enabled;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('snowfallEnabled', enabled);
}

/// Prüft ob Schneefall angezeigt werden soll
bool shouldShowSnowfall() {
  return isChristmasSeason() && snowfallEnabledNotifier.value;
}
