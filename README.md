# Guck mal! – Reise Bingo

Eine Bingo-App für Kinder und Familien auf Reisen. Auf einem Raster stehen Dinge, die es unterwegs zu entdecken gibt — wer sie sieht, tippt sie an.

Live im App Store und bei Google Play (Package `de.revisor.guckmalreisebingo`), aktuell in Version 2.0.2 (Build 38).

## Features

- 🎮 **Drei Spielmodi**: Suche (unbegrenzt), Jagd (Ziel-Bingos 1–5), Sprint (auf Zeit, jeder auf dem eigenen Gerät)
- 🗺️ **7 Bereiche**: Autobahn, Land, Stadt, Zug, Kirche, Zuhause, Zoo
- 🌸 **Saisonale Items**: eigene Sets für Frühling/Sommer und Herbst/Winter
- 🐣 **Oster-Special**: Oster-Theme mit Blütenblatt-Effekt, Osterdatum wird berechnet
- 🎄 **Weihnachts-Special** (1. Dez – 6. Jan): Schneefall, Weihnachts-Theme, Glocken-Sounds, saisonale Items
- 🌍 **6 Sprachen**: Deutsch, Englisch, Spanisch, Französisch, Italienisch, Niederländisch
- ♿ **Barrierefrei**: Semantics-Labels für Screenreader
- 📱 **iOS und Android**

## Technologie

- Flutter 3.44 / Dart, MVVM-Architektur
- Zustand über `ChangeNotifier` + Provider (`SeasonService`, `ThemeNotifier`)
- Spielstand-Persistenz via `flutter_secure_storage`
- Keine externe Datenerhebung — bewusst kein Crash-Reporting, da Kinder-App

## Struktur

```
lib/
├── main.dart              NavigationCoordinator: Mode → [Ziel] → Kategorie → [Saison] → Bereich → Größe → Spiel
├── models/                GameConfig, BingoItem, Area, Season, GameMode, Themes
├── viewmodels/            ChangeNotifier-ViewModels
├── views/                 Screens und Widgets
├── data/                  bingo_items_data.dart — alle Bingo-Items
├── utilities/             Audio, Farben, responsive Texte, Lokalisierung
└── l10n/                  ARB-Dateien (Template: app_de.arb)
```

## Lokale Entwicklung

```bash
flutter pub get
flutter run

flutter test              # Tests
flutter analyze           # Statische Analyse
flutter gen-l10n          # nach Änderungen an den ARB-Dateien
```

Debug-Builds laufen ohne weitere Einrichtung. Für **Android-Release-Builds** wird
`android/key.properties` samt Keystore erwartet — beides ist bewusst nicht im Repo.
Ohne diese Dateien greift der Fallback auf die Debug-Signatur; für eigene Builds
legst du einen eigenen Keystore an. Für **iOS-Release-Builds** brauchst du dein
eigenes Apple-Developer-Signing.

Nach neuen Items zusätzlich den Generator laufen lassen, nie die Extension von Hand editieren:

```bash
dart run tool/generate_l10n_extension.dart
```

## Release

Versionsnummer steht in `pubspec.yaml` (`version: X.Y.Z+BUILD`) und ist die einzige Quelle — iOS liest sie von dort, nichts wird im Xcode-Projekt hartkodiert.

```bash
# 1. Version in pubspec.yaml bumpen, dann iOS-Config regenerieren (sonst baut Xcode die alte Version):
flutter build ios --config-only --no-codesign

# 2. Builds
flutter build ipa --release      # iOS → App Store Connect
flutter build appbundle --release # Android → Google Play
```

Die Build-Nummer muss **immer höher** sein als die höchste je zu App Store Connect hochgeladene — auch als die von verworfenen oder abgelaufenen Builds. iOS nutzt manuelles Signing mit dem GuckMal-AppStore-Profil.

Bei jedem Versionssprung: CHANGELOG-Eintrag, Git-Tag `vX.Y.Z` und GitHub-Release mit dem CHANGELOG-Abschnitt als Release Notes.

## Bekannte Stolpersteine

**iOS-Codesigning-Fehler „resource fork, Finder information, or similar detritus not allowed":**

```bash
xattr -cr ios assets
flutter clean && flutter pub get
# In Xcode: Clean Build Folder (Cmd+Shift+K), dann Archive
```

**Grafiken** (Store-Screenshots, Marketing-Material) gehören nicht in dieses Repo, sondern in `der Grafikablage` (Projekt `guckmal.json`).

## Lizenz

**Quelloffen zur Einsicht — Nutzung nur mit schriftlicher Erlaubnis.**
Der vollständige Text steht in [LICENSE](LICENSE), eine englische Übersetzung
in [LICENSE.en.md](LICENSE.en.md) (maßgeblich ist die deutsche Fassung).

- **Ohne Weiteres erlaubt:** lesen, herunterladen, studieren, zu Lern- und
  Prüfzwecken auf eigenen Geräten ausführen, Fehler melden, darüber berichten.
- **Braucht eine Vereinbarung:** der Betrieb für echte Nutzer:innen, die
  Weitergabe an Dritte und in App Stores, die Verwendung von Teilen des Codes
  in anderer Software.
- Grafiken, Sounds und der Name „Guck mal!“ sind nicht mitlizenziert.

## Autor

© 2025–2026 Simon Luthe / Revisor
