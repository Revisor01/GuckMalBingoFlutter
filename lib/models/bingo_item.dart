import 'package:uuid/uuid.dart';
import 'area.dart';
import 'season.dart';
import '../utilities/debug_utils.dart';

/// BingoItem Class - Portiert von Swift
class BingoItem {
  final String id;
  final String emoji;
  final String name;
  final String? imageName;
  final String? sfSymbolName;
  final String? sfSymbolWeight;
  final String? sfSymbolColor;
  final List<Area> areas;
  final List<Season>? seasons;
  final int? availableFromMonth;
  final int? availableFromDay;
  final int? availableToMonth;
  final int? availableToDay;

  BingoItem({
    String? id,
    required this.emoji,
    required this.name,
    this.imageName,
    this.sfSymbolName,
    this.sfSymbolWeight,
    this.sfSymbolColor,
    required this.areas,
    this.seasons,
    this.availableFromMonth,
    this.availableFromDay,
    this.availableToMonth,
    this.availableToDay,
  }) : id = id ?? const Uuid().v4();

  /// Check if this item is currently available based on date
  bool isAvailableNow() {
    if (availableFromMonth == null ||
        availableFromDay == null ||
        availableToMonth == null ||
        availableToDay == null) {
      // If no date restrictions, item is always available
      return true;
    }

    // Use debug date if set, otherwise use real date
    final now = getCurrentDate();
    final currentMonth = now.month;
    final currentDay = now.day;

    // Create comparable date values (month * 100 + day)
    final currentDate = currentMonth * 100 + currentDay;
    final fromDate = availableFromMonth! * 100 + availableFromDay!;
    final toDate = availableToMonth! * 100 + availableToDay!;

    // Handle date ranges that span across year boundary (e.g., Dec 1 to Jan 6)
    if (fromDate <= toDate) {
      // Normal range within same year
      return currentDate >= fromDate && currentDate <= toDate;
    } else {
      // Range spans year boundary
      return currentDate >= fromDate || currentDate <= toDate;
    }
  }

  /// Equality check (ohne id)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BingoItem) return false;

    return name == other.name &&
        emoji == other.emoji &&
        imageName == other.imageName;
  }

  @override
  int get hashCode => Object.hash(name, emoji, imageName);

  /// Copy with
  BingoItem copyWith({
    String? id,
    String? emoji,
    String? name,
    String? imageName,
    String? sfSymbolName,
    String? sfSymbolWeight,
    String? sfSymbolColor,
    List<Area>? areas,
    List<Season>? seasons,
    int? availableFromMonth,
    int? availableFromDay,
    int? availableToMonth,
    int? availableToDay,
  }) {
    return BingoItem(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      imageName: imageName ?? this.imageName,
      sfSymbolName: sfSymbolName ?? this.sfSymbolName,
      sfSymbolWeight: sfSymbolWeight ?? this.sfSymbolWeight,
      sfSymbolColor: sfSymbolColor ?? this.sfSymbolColor,
      areas: areas ?? this.areas,
      seasons: seasons ?? this.seasons,
      availableFromMonth: availableFromMonth ?? this.availableFromMonth,
      availableFromDay: availableFromDay ?? this.availableFromDay,
      availableToMonth: availableToMonth ?? this.availableToMonth,
      availableToDay: availableToDay ?? this.availableToDay,
    );
  }

  /// JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'name': name,
      'imageName': imageName,
      'sfSymbolName': sfSymbolName,
      'sfSymbolWeight': sfSymbolWeight,
      'sfSymbolColor': sfSymbolColor,
      'areas': areas.map((a) => a.value).toList(),
      'seasons': seasons?.map((s) => s.value).toList(),
      'availableFromMonth': availableFromMonth,
      'availableFromDay': availableFromDay,
      'availableToMonth': availableToMonth,
      'availableToDay': availableToDay,
    };
  }

  /// JSON Deserialization
  factory BingoItem.fromJson(Map<String, dynamic> json) {
    return BingoItem(
      emoji: json['emoji'] as String,
      name: json['name'] as String,
      imageName: json['imageName'] as String?,
      sfSymbolName: json['sfSymbolName'] as String?,
      sfSymbolWeight: json['sfSymbolWeight'] as String?,
      sfSymbolColor: json['sfSymbolColor'] as String?,
      areas: (json['areas'] as List<dynamic>)
          .map((a) => Area.fromString(a as String))
          .toList(),
      seasons: json['seasons'] != null
          ? (json['seasons'] as List<dynamic>)
              .map((s) => Season.fromString(s as String))
              .toList()
          : null,
      availableFromMonth: json['availableFromMonth'] as int?,
      availableFromDay: json['availableFromDay'] as int?,
      availableToMonth: json['availableToMonth'] as int?,
      availableToDay: json['availableToDay'] as int?,
    );
  }
}
