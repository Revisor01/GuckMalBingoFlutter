# Guck mal! – Travel Bingo

[Deutsch](README.md) · **English**

A bingo app for children and families on the road. The grid shows things to
spot along the way; whoever sees one taps it.

Available on the App Store and Google Play (package
`de.revisor.guckmalreisebingo`). What changed in which version is in the
[CHANGELOG](CHANGELOG.md) (in German, following
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)).

## Features

- **Three game modes**: Look (unlimited), Hunt (target bingos 1–5), Sprint
  (against the clock, everyone on their own device)
- **7 areas**: motorway, countryside, city, train, church, home, zoo
- **Seasonal items**: separate sets for spring/summer and autumn/winter
- **Easter special**: Easter theme with falling petals, the date of Easter is
  calculated
- **Christmas special** (1 Dec – 6 Jan): snowfall, Christmas theme, bell
  sounds, seasonal items
- **6 languages**: German, English, Spanish, French, Italian, Dutch
- **Accessible**: semantics labels for screen readers
- **iOS and Android**

## Technology

- Flutter 3.44 / Dart, MVVM architecture
- State via `ChangeNotifier` + Provider (`SeasonService`, `ThemeNotifier`)
- Game state persisted with `flutter_secure_storage`
- No external data collection — deliberately no crash reporting, since it is
  an app for children

## Structure

```
lib/
├── main.dart              NavigationCoordinator: mode → [target] → category → [season] → area → size → game
├── models/                GameConfig, BingoItem, Area, Season, GameMode, themes
├── viewmodels/            ChangeNotifier view models
├── views/                 screens and widgets
├── data/                  bingo_items_data.dart — all bingo items
├── utilities/             audio, colours, responsive text, localisation
└── l10n/                  ARB files (template: app_de.arb)
```

## Building it yourself

```bash
flutter pub get
flutter run

flutter test              # tests
flutter analyze           # static analysis
flutter gen-l10n          # after changing the ARB files
```

Debug builds run without further setup. **Android release builds** expect
`android/key.properties` and a keystore — both are deliberately not in the
repository. Without them the build falls back to the debug signature; for your
own builds, create your own keystore. **iOS release builds** need your own
Apple Developer signing.

After adding new items, run the generator; never edit the extension by hand:

```bash
dart run tool/generate_l10n_extension.dart
```

The version number lives only in `pubspec.yaml` (`version: X.Y.Z+BUILD`).

## Contributing

Bug reports and suggestions are welcome as an
[issue](../../issues/new/choose). Please report security issues privately as
described in [SECURITY.md](SECURITY.md). See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

**Source available for inspection — any use beyond that needs written
permission.** The full text is in [LICENSE](LICENSE), an English translation
in [LICENSE.en.md](LICENSE.en.md) (the German version is legally binding).

- **Allowed without asking:** reading, downloading, studying, running it on
  your own devices for learning and review, reporting bugs, writing about it.
- **Needs an agreement:** running it for real users, passing it on to others
  or into app stores, using parts of the code in other software.
- Graphics, sounds and the name “Guck mal!” are not licensed.

## Author

© 2025–2026 Simon Luthe / Revisor
