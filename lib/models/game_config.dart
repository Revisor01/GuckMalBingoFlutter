import 'game_mode.dart';
import 'category_theme.dart';
import 'season.dart';
import 'area.dart';

/// Einstellungen eines Spiels.
class GameConfig {
  final GameMode gameMode;
  final CategoryTheme categoryTheme;
  final Season season;
  final Area area;
  final int gridSize;
  final int targetBingos;

  GameConfig({
    this.gameMode = GameMode.suche,
    this.categoryTheme = CategoryTheme.reise,
    this.season = Season.fruehling_sommer,
    this.area = Area.autobahn,
    this.gridSize = 5,
    this.targetBingos = 3,
  });

  /// Copy with
  GameConfig copyWith({
    GameMode? gameMode,
    CategoryTheme? categoryTheme,
    Season? season,
    Area? area,
    int? gridSize,
    int? targetBingos,
  }) {
    return GameConfig(
      gameMode: gameMode ?? this.gameMode,
      categoryTheme: categoryTheme ?? this.categoryTheme,
      season: season ?? this.season,
      area: area ?? this.area,
      gridSize: gridSize ?? this.gridSize,
      targetBingos: targetBingos ?? this.targetBingos,
    );
  }

  /// JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'gameMode': gameMode.value,
      'categoryTheme': categoryTheme.value,
      'season': season.value,
      'area': area.value,
      'gridSize': gridSize,
      'targetBingos': targetBingos,
    };
  }

  /// JSON Deserialization
  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      gameMode: GameMode.fromString(json['gameMode'] as String? ?? 'suche'),
      categoryTheme: CategoryTheme.fromString(
          json['categoryTheme'] as String? ?? 'reise'),
      season:
          Season.fromString(json['season'] as String? ?? 'fruehling_sommer'),
      area: Area.fromString(json['area'] as String? ?? 'autobahn'),
      gridSize: json['gridSize'] as int? ?? 5,
      targetBingos: json['targetBingos'] as int? ?? 3,
    );
  }
}
