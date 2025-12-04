# Changelog

## Version 1.1.0+4 (Dezember 2025)

### Weihnachts-Special
- **Schneefalleffekt**: Sanfter Schneefall-Overlay während der Weihnachtszeit (1. Dez - 6. Jan)
- **Schneefall-Toggle**: Ein/Aus-Schalter in der Theme-Auswahl
- **Weihnachts-Theme**: Neues grün-rotes Farbthema "Weihnachten"
- **Weihnachts-Sounds**:
  - Bingo: Normale Sounds + 6 Weihnachts-Glocken (zufällig gemischt)
  - Victory: Spezielle Weihnachts-Victory-Sounds
- **Weihnachts-Items**: Neue saisonale Items (Weihnachtsmarkt, Weihnachtsdeko, etc.)

### Bugfixes
- **Theme-Auswahl**: Theme wird jetzt korrekt auf allen Seiten angewendet (nicht mehr automatisch Weihnachts-Theme überall)
- **Parental Gate**: Dialog ist jetzt durch Runterziehen oder Tippen außerhalb schließbar
- **Sound beim Verlassen**: Musik stoppt sofort beim Verlassen des Spiels
- **Weihnachtsdeko-Icon**: Korrigiertes Bild (war identisch mit Weihnachtsmarkt)

### Android
- **Adaptive Icons**: Korrekte Android 8+ Icons mit weißem Hintergrund
- **Native Splash**: Weißer Splash-Screen ohne Flutter-Logo
- **App-Icon**: Korrektes App-Icon aus iOS-Vorlage
- **Package-Name**: `de.revisor.guckmalreisebingo`
- **Release-Signierung**: Konfiguriert für Play Store

### iOS
- **Native Splash**: Konfiguriert via flutter_native_splash
- **Pods**: Aktualisiert und synchronisiert

### Technische Änderungen
- `flutter_native_splash` Package hinzugefügt
- `ValueNotifier` für reaktiven Schneefall-Toggle
- Lokalisierung: "Schneefall" in 6 Sprachen (DE, EN, ES, FR, IT, NL)
- MainActivity nach `de.revisor.guckmalreisebingo` verschoben

---

## Version 1.0.0 (November 2025)

- Initiales Release
- Flutter-Port der iOS Swift App
- 6 Sprachen unterstützt
- 206 Bingo-Items
