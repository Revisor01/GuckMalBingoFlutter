# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Run the app (debug)
flutter run

# Build iOS release
flutter build ios --release

# Build Android APK
flutter build apk --release

# Run tests
flutter test

# Generate localization files
flutter gen-l10n
```

## Architecture

Flutter-App mit MVVM-Architektur für ein Reise-Bingo-Spiel (Kinder/Familien).

### Struktur

- **lib/main.dart** - App-Entry-Point mit `NavigationCoordinator` für den gesamten Navigationsfluss: Mode → [Target if Jagd] → Category → [Season] → Area → Size → Game
- **lib/viewmodels/** - ChangeNotifier-basierte ViewModels (aktuell nur `BingoGameViewModel`)
- **lib/models/** - Datenmodelle: `GameConfig`, `BingoItem`, `Area`, `Season`, `GameMode`, `CategoryTheme`, `BackgroundTheme`
- **lib/views/** - Flutter Widgets/Screens
- **lib/data/bingo_items_data.dart** - Alle 206 Bingo-Items mit Lokalisierung und saisonaler Filterung
- **lib/utilities/** - Hilfsklassen (Audio, Farben, Responsive Text, Lokalisierung)
- **lib/l10n/** - Lokalisierungsdateien (6 Sprachen: DE, EN, ES, FR, IT, NL)

### Spielmodi

- **Suche** - Unbegrenztes Spielen, alle Items finden
- **Jagd** - Ziel-Bingos erreichen (1-5)

### Saisonale Features

- Frühling/Sommer und Herbst/Winter Items
- Weihnachts-Special (1. Dez - 6. Jan): Schneefalleffekt, spezielle Sounds, Weihnachts-Items

### Lokalisierung

ARB-Dateien unter `lib/l10n/`, Template ist `app_de.arb`. Nach Änderungen: `flutter gen-l10n`

## Android

Package-Name: `de.revisor.guckmalreisebingo`

## iOS

Bundle-ID konfiguriert für App Store Release

## Git Workflow

Regelmäßig committen und pushen. Git-Zugangsdaten sind global konfiguriert.

## Bekannte Probleme

### iOS Codesigning-Fehler: "resource fork, Finder information, or similar detritus not allowed"

Lösung:
```bash
xattr -cr ./ios
xattr -cr ./assets
flutter clean
flutter pub get
# In Xcode: Clean Build Folder (Cmd+Shift+K), dann Archive
```
