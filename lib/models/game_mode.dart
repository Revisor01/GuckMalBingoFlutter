import 'package:flutter/material.dart';

/// GameMode Enum - Portiert von Swift
enum GameMode {
  suche('suche'),
  jagd('jagd');

  final String value;
  const GameMode(this.value);

  /// SF Symbol equivalent in Flutter (Material Icons)
  IconData get icon {
    switch (this) {
      case GameMode.suche:
        return Icons.search;
      case GameMode.jagd:
        return Icons.flag;
    }
  }

  /// Localization key for display name
  String get displayNameKey {
    switch (this) {
      case GameMode.suche:
        return 'gamemodeSucheName';
      case GameMode.jagd:
        return 'gamemodeJagdName';
    }
  }

  /// Localization key for description
  String get descriptionKey {
    switch (this) {
      case GameMode.suche:
        return 'gamemodeSucheDescription';
      case GameMode.jagd:
        return 'gamemodeJagdDescription';
    }
  }

  /// Parse from string value
  static GameMode fromString(String value) {
    return GameMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => GameMode.suche,
    );
  }
}
