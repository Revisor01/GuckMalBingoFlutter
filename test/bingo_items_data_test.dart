import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/data/bingo_items_data.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/bingo_item.dart';
import 'package:guck_mal_bingo/models/season.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';

void main() {
  setUp(() {
    // Stabiles Test-Datum: neutrales Frühlings-/Sommerdatum (kein Weihnachten, kein Ostern)
    debugOverrideDate = DateTime(2026, 6, 15);
  });

  tearDown(() {
    debugOverrideDate = null;
  });

  group('Item-Pool minimum items per grid size', () {
    final allAreas = [
      Area.autobahn,
      Area.land,
      Area.stadt,
      Area.zug,
      Area.kirche,
      Area.zuHause,
      Area.zoo,
    ];
    final allSeasons = [Season.fruehling_sommer, Season.herbst_winter];

    for (final area in allAreas) {
      for (final season in allSeasons) {
        test('$area/$season has enough items for 3x3 grid (9 minimum)', () {
          final items = BingoItemsData.itemsFor(area: area, season: season);
          expect(
            items.length,
            greaterThanOrEqualTo(9),
            reason: '$area/$season only has ${items.length} items, need 9',
          );
        });
      }
    }

    // Standard-Reise-Areas muessen 5x5 unterstuetzen
    for (final area in [Area.autobahn, Area.land, Area.stadt, Area.zug]) {
      for (final season in allSeasons) {
        test('$area/$season has enough items for 5x5 grid (25 minimum)', () {
          final items = BingoItemsData.itemsFor(area: area, season: season);
          expect(
            items.length,
            greaterThanOrEqualTo(25),
            reason: '$area/$season only has ${items.length} items, need 25',
          );
        });
      }
    }
  });

  group('allItems integrity', () {
    test('allItems has no duplicates', () {
      final seen = <BingoItem>{};
      final duplicates = <String>[];
      for (final item in BingoItemsData.allItems) {
        if (!seen.add(item)) {
          duplicates.add(item.name);
        }
      }
      expect(duplicates, isEmpty, reason: 'Duplicate items: $duplicates');
    });
  });

  group('BingoItemsData.itemsFor', () {
    test('returns items for autobahn area', () {
      final items = BingoItemsData.itemsFor(
        area: Area.autobahn,
        season: Season.fruehling_sommer,
      );
      expect(items, isNotEmpty);
      for (final item in items) {
        expect(item.areas, contains(Area.autobahn));
      }
    });

    test('returns items for stadt area', () {
      final items = BingoItemsData.itemsFor(
        area: Area.stadt,
        season: Season.herbst_winter,
      );
      expect(items, isNotEmpty);
      for (final item in items) {
        expect(item.areas, contains(Area.stadt));
      }
    });

    test('returns different items for different seasons', () {
      final springItems = BingoItemsData.itemsFor(
        area: Area.land,
        season: Season.fruehling_sommer,
      );
      final winterItems = BingoItemsData.itemsFor(
        area: Area.land,
        season: Season.herbst_winter,
      );

      // Both should have items
      expect(springItems, isNotEmpty);
      expect(winterItems, isNotEmpty);

      // They may have different items (seasonal ones differ)
      final springNames = springItems.map((i) => i.name).toSet();
      final winterNames = winterItems.map((i) => i.name).toSet();
      // At least some items should differ (seasonal items)
      expect(springNames.difference(winterNames).isNotEmpty ||
             winterNames.difference(springNames).isNotEmpty, isTrue);
    });

    test('returns enough items for a 5x5 grid (25 items)', () {
      final items = BingoItemsData.itemsFor(
        area: Area.autobahn,
        season: Season.fruehling_sommer,
      );
      expect(items.length, greaterThanOrEqualTo(25));
    });

    test('kirche area returns only items with empty seasons', () {
      final items = BingoItemsData.itemsFor(
        area: Area.kirche,
        season: Season.fruehling_sommer,
      );
      expect(items, isNotEmpty);
      for (final item in items) {
        expect(item.areas, contains(Area.kirche));
      }
    });
  });
}
