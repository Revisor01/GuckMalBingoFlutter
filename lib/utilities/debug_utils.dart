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

/// Berechnet das Datum von Ostersonntag für ein gegebenes Jahr
/// Verwendet den Anonymous Gregorian Algorithmus (Meeus/Jones/Butcher)
DateTime getEasterDate(int year) {
  final a = year % 19;
  final b = year ~/ 100;
  final c = year % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final month = (h + l - 7 * m + 114) ~/ 31;
  final day = ((h + l - 7 * m + 114) % 31) + 1;
  return DateTime(year, month, day);
}

/// Prüft, ob aktuell Osterzeit ist (2 Wochen vor Ostersonntag bis Ostermontag)
bool isEasterSeason() {
  final now = getCurrentDate();
  final easter = getEasterDate(now.year);
  final seasonStart = easter.subtract(const Duration(days: 14));
  final easterMonday = easter.add(const Duration(days: 1));

  // Normalisiere auf Tagesgranularität
  final today = DateTime(now.year, now.month, now.day);
  final start = DateTime(seasonStart.year, seasonStart.month, seasonStart.day);
  final end = DateTime(easterMonday.year, easterMonday.month, easterMonday.day);

  return !today.isBefore(start) && !today.isAfter(end);
}

/// Oster-Effekt-Einstellung als ValueNotifier für reaktives UI
final easterEffectEnabledNotifier = ValueNotifier<bool>(true);

/// Lade Oster-Effekt-Einstellung aus SharedPreferences
Future<void> loadEasterEffectSetting() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    easterEffectEnabledNotifier.value = prefs.getBool('easterEffectEnabled') ?? true;
  } catch (e) {
    easterEffectEnabledNotifier.value = true;
  }
}

/// Speichere Oster-Effekt-Einstellung
Future<void> setEasterEffectEnabled(bool enabled) async {
  easterEffectEnabledNotifier.value = enabled;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('easterEffectEnabled', enabled);
  } catch (e) {
    // Speicherfehler ignorieren
  }
}

/// Prüft ob Oster-Effekt angezeigt werden soll
bool shouldShowEasterEffect() {
  return isEasterSeason() && easterEffectEnabledNotifier.value;
}

/// Schneefall-Einstellung als ValueNotifier für reaktives UI
final snowfallEnabledNotifier = ValueNotifier<bool>(true);

/// Lade Schneefall-Einstellung aus SharedPreferences
Future<void> loadSnowfallSetting() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    snowfallEnabledNotifier.value = prefs.getBool('snowfallEnabled') ?? true;
  } catch (e) {
    // Fallback zu Standard-Wert bei Fehler
    snowfallEnabledNotifier.value = true;
  }
}

/// Speichere Schneefall-Einstellung
Future<void> setSnowfallEnabled(bool enabled) async {
  snowfallEnabledNotifier.value = enabled;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('snowfallEnabled', enabled);
  } catch (e) {
    // Speicherfehler ignorieren, Wert ist bereits im Notifier gesetzt
  }
}

/// Prüft ob Schneefall angezeigt werden soll
bool shouldShowSnowfall() {
  return isChristmasSeason() && snowfallEnabledNotifier.value;
}
