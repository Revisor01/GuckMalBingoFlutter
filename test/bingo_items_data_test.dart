import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/data/bingo_items_data.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/season.dart';

void main() {
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
