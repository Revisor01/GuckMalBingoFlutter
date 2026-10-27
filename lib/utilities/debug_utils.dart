import 'package:flutter/foundation.dart';

/// Ersatzdatum zum Testen saisonaler Inhalte; im Release immer das echte Datum.
DateTime? debugOverrideDate = kReleaseMode ? null : null;

/// Das aktuelle Datum oder im Debug-Modus [debugOverrideDate].
DateTime getCurrentDate() {
  if (kReleaseMode) return DateTime.now();
  return debugOverrideDate ?? DateTime.now();
}

/// Ob Weihnachtszeit ist (1. Dezember bis 6. Januar).
bool isChristmasSeason() {
  final now = getCurrentDate();
  // Dezember (ab 1.12.)
  if (now.month == 12) return true;
  // Januar (bis 6.1.)
  if (now.month == 1 && now.day <= 6) return true;
  return false;
}

/// Ostersonntag des Jahres nach Meeus/Jones/Butcher.
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


/// Ob Herbstzeit ist (1. September bis 15. November), wie bei den Herbst-Items.
bool isAutumnSeason() {
  final now = getCurrentDate();
  final date = now.month * 100 + now.day;
  return date >= 901 && date <= 1115;
}

/// Ob Halloween-Zeit ist (15. Oktober bis 2. November).
bool isHalloweenSeason() {
  final now = getCurrentDate();
  final date = now.month * 100 + now.day;
  return date >= 1015 && date <= 1102;
}
