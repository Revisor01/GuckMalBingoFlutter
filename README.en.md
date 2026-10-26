<p align="center">
  <img src="ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-Guck-mal.png" alt="Guck mal!" width="128" height="128">
</p>

<h1 align="center">Guck mal! – Travel Bingo</h1>

<p align="center">
  Bingo for children and families on the road: who spots the cow,<br>
  the bridge or the church tower first?
</p>

<p align="center">
  <a href="README.md">Deutsch</a> · <b>English</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS%20%C2%B7%20Android-blue" alt="Platform">
  <img src="https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/license-source%20available-lightgrey" alt="License">
</p>

## What it is about

Long car rides, train journeys, waiting times: Guck mal! (German for "Look!")
turns the view out of the window into a game. A grid shows things to discover
along the way. Whoever spots one taps it; a full row is a bingo.

The app is made for children. It needs no account, no ads, no tracking and no
internet connection.

## Features

- **Three game modes:** Search without time pressure, Hunt for a target of one
  to five bingos, Sprint against the clock, everyone on their own device
- **Seven places:** motorway, countryside, town, train, church, home, zoo
- **Around 250 things to discover**, each with a picture and chosen by season:
  spring and summer, autumn and winter
- **Holidays:** special things, colours and effects for Easter, autumn,
  Halloween and Christmas
- **Six languages:** German, English, Spanish, French, Italian, Dutch
- **Accessible:** labels for screen readers

## Installation

[**App Store**](https://apps.apple.com/app/id6755447380) ·
[**Google Play**](https://play.google.com/store/apps/details?id=de.revisor.guckmalreisebingo)

The app costs a one-time €0.99. There are no in-app purchases and no
subscription.

## Why the source code is open

Parents should be able to check what an app does on their children's device.
This is the complete source code of the app as it is in the stores. Anyone who
programs, or knows someone who does, can verify what the privacy section below
says.

## Privacy

- **No data leaves the device.** The app sends nothing to any server, not even
  to the developer. There is no analytics, no crash reporting and no ad network.
- **No permissions:** no location, camera, microphone or contacts.
- **Stored on the device only:** the current game and the settings.
- Links in the settings (privacy policy, imprint, rating) open in the browser
  or store only after a tap.

The full privacy policy is on
[simonluthe.de](https://simonluthe.de/apps/guckmal/privacy/).

## Versions

What changed when is listed in [CHANGELOG.md](CHANGELOG.md) (in German). The
[releases](https://github.com/Revisor01/GuckMalBingoFlutter/releases) summarise
each version.

## Structure

Flutter app for iOS and Android from one codebase.

```
lib/
├── main.dart     flow: mode → [target] → category → [season] → place → size → game
├── models/       game configuration, things, places, seasons, modes, themes
├── viewmodels/   game logic
├── views/        screens
├── data/         all things to discover, with translations
├── utilities/    sound, colours, texts, languages
└── l10n/         translations of the interface
```

To follow along on your own computer (the license allows this for learning and
testing):

```bash
flutter pub get
flutter test
flutter run
```

## Contributing

Bug reports and suggestions are welcome as an [issue](../../issues/new/choose).
Please report security issues privately as described in
[SECURITY.md](SECURITY.md). Pull requests are welcome;
[CONTRIBUTING.md](CONTRIBUTING.md) explains what applies to the rights in your
contribution.

## License

**Source available for inspection — use only with written permission.**
The full text is in [LICENSE](LICENSE), an English translation in
[LICENSE.en.md](LICENSE.en.md) (the German version is legally binding).

- **Permitted without further ado:** reading, downloading, studying, running on
  your own devices for learning and testing, reporting bugs, writing about it.
- **Requires an agreement:** using a build of your own in everyday life,
  including within your own family, passing on your own builds, including in
  app stores, and using parts of the code in other software. To play, use the
  app from the store.
- Pictures, sounds and the name "Guck mal!" are not licensed.

## Contact

Pastor Simon Luthe · [mail@simonluthe.de](mailto:mail@simonluthe.de) ·
[simonluthe.de](https://simonluthe.de)
