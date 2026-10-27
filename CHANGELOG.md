# Changelog

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog 1.1.0](https://keepachangelog.com/de/1.1.0/),
und dieses Projekt folgt [Semantic Versioning 2.0.0](https://semver.org/lang/de/).

## [Unreleased]

### Geändert
- Neue Lizenz: Der Quelltext ist öffentlich einsehbar, damit Eltern nachprüfen können, was die App tut. Selbst bauen, nutzen und weitergeben braucht eine schriftliche Erlaubnis

### Sonstiges
- iOS-Builds entstehen in Xcode Cloud; der Release-Knopf auf GitHub startet sie und wartet darauf.
- Die iOS-Fassung kann in Xcode Cloud gebaut und ausgeliefert werden; die Abhängigkeiten sind dafür auf feste Versionen eingefroren

## [2.1.0] — 2026-09-27

### Hinzugefügt
- Herbst-Special vom 1. September bis 15. November: zwölf neue Herbst-Items wie Kürbis, Igel, Eichhörnchen, Pilze und buntes Laub
- Halloween-Special vom 15. Oktober bis 2. November: zehn Halloween-Items wie Kürbislaterne, Fledermaus und Hexenhut sowie sechs Kostüme zum Entdecken
- Fallende Herbstblätter als Effekt; zur Halloween-Zeit fliegen zwischendurch Fledermäuse und Gespenster durchs Bild
- Herbst-Theme mit warmem Laubverlauf und Herbst-Symbolen im Hintergrund
- Halloween-Theme als Nachthimmel mit Kürbisglühen, Fledermäusen, Gespenstern und Mond im Hintergrund
- Schalter für den Herbst-Effekt in der Theme-Auswahl

### Geändert
- Zu Beginn von Herbst, Halloween, Weihnachten und Ostern wechselt die App einmal automatisch ins passende Theme und schaltet den Saison-Effekt ein; nach der Saison kommt das vorher gewählte Theme zurück

- Android: randlose Darstellung jetzt auf allen unterstützten Android-Versionen

### Behoben
- Im App Store werden jetzt alle sechs Sprachen der App angezeigt, bisher stand dort nur Deutsch

### Sonstiges
- Android: geringerer Speicherbedarf und bessere Leistung durch gründlichere Optimierung beim Bauen der App
- Absturzberichte von Android-Geräten lassen sich jetzt vollständig auswerten
- Aufräumarbeiten am Projekt und an der Build-Einrichtung

## [2.0.2] — 2026-07-30

Ausgeliefert als Build 38 (App Store + Google Play).

### Geändert
- Dependency-Updates für Flutter-3.44-Kompatibilität (41 Pakete aktualisiert)
- Settings-Footer exakt nach `app-branding-pattern.md`: Schriftgrößen und Deckkraft 1:1 mit der SwiftUI-Referenz
- Onboarding-Reihenfolge und -Texte überarbeitet
- Modus-Seite scrollbar, Sprint- und Modus-Texte gekürzt

### Behoben
- SF-Symbol `bird` statt `flutter_dash` im Settings-Footer

### Entfernt
- Auto-Modus (immersiver Großbildmodus) wieder entfernt — die Entscheidung fiel für echtes CarPlay statt einer Zwischenlösung

## [2.0.1] — 2026-04-15

Ausgeliefert als Build 33.

### Geändert
- **Duell → Sprint**: Spielmodus vollständig umbenannt — ARB-Keys in 6 Sprachen, `GameMode.sprint`, Dateien, Klassen, Tests, Store-Listings und Marketing-Copy
- Onboarding zeigt eine Motion-Demo statt der bisherigen Duell-Erklärseite
- Sprint-Texte in der Lokalisierung präzisiert

### Hinzugefügt
- Sprint-State-API mit Migration bestehender `duell`-Spielstände

### Behoben
- Android-`signingConfigs` gegen fehlende `key.properties` abgesichert
- Dedizierter Audio-Slot für den Bingo-Victory-Sound

## [2.0.0] — 2026-04-13

Ausgeliefert als Build 29 (iOS-Release; Android zunächst zurückgestellt).

### Hinzugefügt
- `PrivacyInfo.xcprivacy` für die App-Store-Compliance
- Vollständige Store-Assets: 48 Marketing-Poster und Screenshots, Google-Play-Feature-Graphics (DE + EN), Listings in App Store Connect und Google Play

### Behoben
- Doppelter ARB-Key `resumeGameBackToStart` entfernt
- `clearSavedGameState` aus `DuellGameView.dispose()` entfernt
- Privacy-Policy-URL-Fallback und illustrative Onboarding-Punktzahlen dokumentiert

## [1.8.1] — 2026-04-10

Ausgeliefert als Build 28.

### Hinzugefügt
- Eigene Duell-Onboarding-Seite mit Zwei-Geräte-Visualisierung

## [1.8.0] — 2026-04-10

Ausgeliefert als Build 27.

### Hinzugefügt
- Rating-Button auf der Info-Seite, abgesichert hinter dem Parental Gate
- Locale-abhängiger Privacy-Policy-Link
- Kindgerechte Spielmodus-Beschreibungen in 6 Sprachen
- Geteilte Widgets `SharedGameHeader` und `SharedToggleButtons` für Bingo- und Duell-View

### Behoben
- Spielstand wird nach einem Victory nicht mehr fälschlicherweise als "Weiterspielen" angeboten
- Spielstand wird beim aktiven Zurücknavigieren gelöscht
- iOS-Version wird aus `pubspec.yaml` gelesen statt im Xcode-Projekt hartkodiert
- Victory-Sound-Race-Condition behoben, Skip-Zähler aus dem Victory-Dialog entfernt
- Jagd-Flow identisch zu Duell: Zielanzahl als letzter Schritt
- Jagd-Beschreibung korrigiert — jeder spielt auf dem eigenen Gerät
- `AudioPlayer`-Injection und echte Fallback-Queue im `DuellGameViewModel`

### Entfernt
- Label "Deine Bingos" über der Punkte-Anzeige
- Spielmodus-Untertitel auf den Selection-Screens
- Tote Datei `localization_helper.dart`

## [1.6.0] — 2026-04-04

Ausgeliefert als Build 26.

### Geändert
- `SharedPreferences` durch `flutter_secure_storage` ersetzt (inklusive Duell-State)
- `DescriptionItem` als öffentliches Widget extrahiert und in beiden Views genutzt
- Deprecated Enum-Cases `Season.sommer` / `Season.winter` entfernt

### Hinzugefügt
- Generator-Skript für die l10n-Extension (`tool/generate_l10n_extension.dart`)

### Behoben
- Xcode-Versionen mit `pubspec.yaml` synchronisiert, `RunnerTests`-Bundle-ID und `MinimumOSVersion` korrigiert
- Rekursives `Future.delayed` im Onboarding durch `Timer.periodic` ersetzt

### Sonstiges
- `O(n)`-`indexOf` beim Speichern des Spielstands durch `O(1)`-Map-Lookup ersetzt

## [1.5.0] — 2026-03-28

Ausgeliefert als Build 22.

### Hinzugefügt
- Spielstand-Persistenz: speichern, fortsetzen und löschen
- `SeasonService` als `ChangeNotifier` mit Provider-Anbindung
- Barrierefreiheit: `Semantics`-Labels für die Selection-Views
- Oster-Victory und gecachte Saison-Prüfungen

### Geändert
- Unveränderliches `GameConfig` und zentrale `AppPreferences`
- Einzelner `AudioPlayer` durch einen Pool von 3 im Round-Robin ersetzt
- `Future.delayed` durch abbrechbare Timer im ViewModel ersetzt
- ViewModel-State-Felder privat mit Gettern
- Sechs Button-Klassen zu einem einheitlichen `AppButton` zusammengeführt
- `RepaintBoundary` für Saison-Effekte

### Behoben
- `_reconstructBingos` aktualisiert `_bingoCount` aus `_completedBingos`

### Entfernt
- Sentry-Crash-Reporting wieder entfernt — keine externe Datenerhebung in einer Kinder-App

## [1.4.0] — 2026-03-27

Ausgeliefert als Build 21.

### Hinzugefügt
- **Oster-Special**: Oster-Theme, Blütenblatt-Effekt und saisonale Integration
- 17 Oster- und Frühlings-Items, lokalisiert in 6 Sprachen
- Berechnung des Osterdatums und `isEasterSeason()`
- `ThemeNotifier` — alle Views nutzen jetzt zentrales Theming

### Geändert
- Edge-to-Edge-Migration auf Android SDK 36
- Selection-Views auf `_BaseSelectionView` konsolidiert
- Nunito-Schrift lokal gebündelt, `google_fonts`-Abhängigkeit entfernt

### Behoben
- Doppelter `itemKatze`-Eintrag entfernt, der Items doppelt auf dem Raster zeigte
- Defensive Board-Generierung mit expliziter Kopie vor dem Mischen
- Blink-Animation über einen Generation-Counter abbrechbar
- `SnowfallPainter.shouldRepaint` vergleicht jetzt den Fortschritt

### Entfernt
- Ungenutzte Felder: `playerName` aus `GameConfig`, `sfSymbol`/`id` aus `BingoItem`, `uuid`-Abhängigkeit

## [1.2.0] — 2025-12-09

Ausgeliefert als Build 19.

### Hinzugefügt
- Onboarding-Tutorial für neue Spielerinnen und Spieler, mit rotierendem Bingo-Raster
- Barrierefreiheit: Unterstützung für Screenreader
- `CFBundleLocalizations` für den App Store

### Geändert
- Alle Bilder nach WebP konvertiert — App-Größe um 62 % reduziert
- Fade-Transition verhindert das weiße Aufblitzen beim Navigieren

### Behoben
- Schneefall-Animation ist jetzt frame-raten-unabhängig und läuft flüssiger
- Android-URL-Launcher korrigiert
- Verschlüsselungs-Compliance-Dialog wird übersprungen

## [1.1.0] — 2025-12-04

Ausgeliefert als Build 4.

### Hinzugefügt
- **Weihnachts-Special** (1. Dez – 6. Jan): Schneefall-Overlay mit Ein/Aus-Schalter, grün-rotes Weihnachts-Theme, Weihnachts-Glocken und Victory-Sounds, saisonale Items (Weihnachtsmarkt, Weihnachtsdeko und weitere)
- Android: adaptive Icons für Android 8+, nativer Splash-Screen ohne Flutter-Logo, Release-Signierung für den Play Store
- iOS: nativer Splash via `flutter_native_splash`

### Behoben
- Theme wird korrekt auf allen Seiten angewendet — nicht mehr überall automatisch das Weihnachts-Theme
- Parental Gate lässt sich durch Runterziehen oder Tippen außerhalb schließen
- Musik stoppt sofort beim Verlassen des Spiels
- Weihnachtsdeko-Icon korrigiert (war identisch mit dem Weihnachtsmarkt-Icon)

### Geändert
- Package-Name auf `de.revisor.guckmalreisebingo`, `MainActivity` entsprechend verschoben
- `ValueNotifier` für den reaktiven Schneefall-Schalter
- Lokalisierung "Schneefall" in 6 Sprachen (DE, EN, ES, FR, IT, NL)

## [1.0.0] — 2025-11-25

### Hinzugefügt
- Initiales Release: Flutter-Port der iOS-Swift-App
- 206 Bingo-Items
- 6 Sprachen (DE, EN, ES, FR, IT, NL)

[Unreleased]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v2.0.2...v2.1.0
[2.0.2]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.8.1...v2.0.0
[1.8.1]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.8.0...v1.8.1
[1.8.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.6.0...v1.8.0
[1.6.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.3.0...v1.4.0
[1.2.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Revisor01/GuckMalBingoFlutter/compare/v1.0.0...v1.1.0
