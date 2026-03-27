import 'package:flutter/material.dart';

/// Season Enum - Portiert von Swift
enum Season {
  fruehling_sommer('fruehling_sommer'),
  herbst_winter('herbst_winter');

  final String value;
  const Season(this.value);

  /// SF Symbol equivalent in Flutter (Material Icons)
  IconData get icon {
    switch (this) {
      case Season.fruehling_sommer:
        return Icons.wb_sunny;
      case Season.herbst_winter:
        return Icons.ac_unit;
    }
  }

  /// Localization key for display name
  String get displayNameKey {
    switch (this) {
      case Season.fruehling_sommer:
        return 'seasonFruehlingSommer';
      case Season.herbst_winter:
        return 'seasonHerbstWinter';
    }
  }

  /// Nur die neuen Jahreszeiten für die UI
  static List<Season> get mainCases => [
        Season.fruehling_sommer,
        Season.herbst_winter,
      ];

  /// Emoji
  String get emoji {
    switch (this) {
      case Season.fruehling_sommer:
        return '🌸☀️';
      case Season.herbst_winter:
        return '🍂❄️';
    }
  }

  /// Parse from string value
  static Season fromString(String value) {
    return Season.values.firstWhere(
      (season) => season.value == value,
      orElse: () => Season.fruehling_sommer,
    );
  }
}
