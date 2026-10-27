import 'package:flutter/material.dart';
import 'category_theme.dart';

/// Spielbereiche.
enum Area {
  // Reise-Thema
  autobahn('autobahn'),
  land('land'),
  stadt('stadt'),
  zug('zug'),

  // Besondere Orte
  kirche('kirche'),
  zuHause('zu_hause'),
  zoo('zoo');

  final String value;
  const Area(this.value);

  /// SF Symbol equivalent in Flutter (Material Icons)
  IconData get icon {
    switch (this) {
      case Area.autobahn:
        return Icons.local_shipping; // road.lanes equivalent
      case Area.land:
        return Icons.park; // leaf.fill equivalent
      case Area.stadt:
        return Icons.location_city; // building.2.fill equivalent
      case Area.zug:
        return Icons.train; // train.side.front.car equivalent
      case Area.kirche:
        return Icons.church; // building.columns.fill equivalent
      case Area.zuHause:
        return Icons.home; // house.fill
      case Area.zoo:
        return Icons.pets; // pawprint.fill equivalent
    }
  }

  /// Localization key for display name
  String get displayNameKey {
    switch (this) {
      case Area.autobahn:
        return 'areaAutobahn';
      case Area.land:
        return 'areaLand';
      case Area.stadt:
        return 'areaStadt';
      case Area.zug:
        return 'areaZug';
      case Area.kirche:
        return 'areaKirche';
      case Area.zuHause:
        return 'areaZuHause';
      case Area.zoo:
        return 'areaZoo';
    }
  }

  /// Category theme
  CategoryTheme get category {
    switch (this) {
      case Area.autobahn:
      case Area.land:
      case Area.stadt:
      case Area.zug:
        return CategoryTheme.reise;
      case Area.kirche:
      case Area.zuHause:
      case Area.zoo:
        return CategoryTheme.besondereOrte;
    }
  }

  /// Parse from string value
  static Area fromString(String value) {
    return Area.values.firstWhere(
      (area) => area.value == value,
      orElse: () => Area.autobahn,
    );
  }
}
