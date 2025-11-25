import 'package:flutter/material.dart';
import 'area.dart';

/// CategoryTheme Enum - Portiert von Swift
enum CategoryTheme {
  reise('reise'),
  besondereOrte('besondere_orte');

  final String value;
  const CategoryTheme(this.value);

  /// SF Symbol equivalent in Flutter (Material Icons)
  IconData get icon {
    switch (this) {
      case CategoryTheme.reise:
        return Icons.directions_car;
      case CategoryTheme.besondereOrte:
        return Icons.location_on;
    }
  }

  /// Localization key for display name
  String get displayNameKey {
    switch (this) {
      case CategoryTheme.reise:
        return 'categoryReise';
      case CategoryTheme.besondereOrte:
        return 'categoryBesondereOrte';
    }
  }

  /// Localization key for description
  String get descriptionKey {
    switch (this) {
      case CategoryTheme.reise:
        return 'categoryReiseDescription';
      case CategoryTheme.besondereOrte:
        return 'categoryBesondereOrteDescription';
    }
  }

  /// Zugehörige Areas
  List<Area> get areas {
    switch (this) {
      case CategoryTheme.reise:
        return [Area.autobahn, Area.land, Area.stadt, Area.zug];
      case CategoryTheme.besondereOrte:
        return [Area.kirche, Area.zuHause, Area.zoo];
    }
  }

  /// Hat diese Kategorie Jahreszeiten?
  bool get hasSeasons {
    switch (this) {
      case CategoryTheme.reise:
        return true;
      case CategoryTheme.besondereOrte:
        return false;
    }
  }

  /// Parse from string value
  static CategoryTheme fromString(String value) {
    return CategoryTheme.values.firstWhere(
      (theme) => theme.value == value,
      orElse: () => CategoryTheme.reise,
    );
  }
}
