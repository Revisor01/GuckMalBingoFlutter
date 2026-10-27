import 'package:flutter/material.dart';

/// Spielmodi.
enum GameMode {
  suche('suche'),
  jagd('jagd'),
  sprint('sprint');

  final String value;
  const GameMode(this.value);

  /// SF Symbol equivalent in Flutter (Material Icons)
  IconData get icon {
    switch (this) {
      case GameMode.suche:
        return Icons.search;
      case GameMode.jagd:
        return Icons.flag;
      case GameMode.sprint:
        return Icons.speed;
    }
  }

  /// Localization key for display name
  String get displayNameKey {
    switch (this) {
      case GameMode.suche:
        return 'gamemodeSucheName';
      case GameMode.jagd:
        return 'gamemodeJagdName';
      case GameMode.sprint:
        return 'gamemodeSprintName';
    }
  }

  /// Localization key for description
  String get descriptionKey {
    switch (this) {
      case GameMode.suche:
        return 'gamemodeSucheDescription';
      case GameMode.jagd:
        return 'gamemodeJagdDescription';
      case GameMode.sprint:
        return 'gamemodeSprintDescription';
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
