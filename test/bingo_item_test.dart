import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/models/bingo_item.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/season.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';

void main() {
  group('BingoItem.isAvailableNow', () {
    tearDown(() {
      debugOverrideDate = null;
    });

    test('item without date restrictions is always available', () {
      final item = BingoItem(
        emoji: '🚗',
        name: 'testCar',
        areas: [Area.autobahn],
      );
      expect(item.isAvailableNow(), isTrue);
    });

    test('item available in normal date range (March 1 - May 31)', () {
      final item = BingoItem(
        emoji: '🌸',
        name: 'testSpring',
        areas: [Area.land],
        availableFromMonth: 3,
        availableFromDay: 1,
        availableToMonth: 5,
        availableToDay: 31,
      );

      // April 15 — in range
      debugOverrideDate = DateTime(2025, 4, 15);
      expect(item.isAvailableNow(), isTrue);

      // February 28 — before range
      debugOverrideDate = DateTime(2025, 2, 28);
      expect(item.isAvailableNow(), isFalse);

      // June 1 — after range
      debugOverrideDate = DateTime(2025, 6, 1);
      expect(item.isAvailableNow(), isFalse);
    });

    test('item available across year boundary (Dec 1 - Jan 6)', () {
      final item = BingoItem(
        emoji: '🎄',
        name: 'testChristmas',
        areas: [Area.stadt],
        availableFromMonth: 12,
        availableFromDay: 1,
        availableToMonth: 1,
        availableToDay: 6,
      );

      // December 25 — in range
      debugOverrideDate = DateTime(2025, 12, 25);
      expect(item.isAvailableNow(), isTrue);

      // January 3 — in range
      debugOverrideDate = DateTime(2025, 1, 3);
      expect(item.isAvailableNow(), isTrue);

      // January 7 — out of range
      debugOverrideDate = DateTime(2025, 1, 7);
      expect(item.isAvailableNow(), isFalse);

      // November 30 — out of range
      debugOverrideDate = DateTime(2025, 11, 30);
      expect(item.isAvailableNow(), isFalse);
    });

    test('boundary dates are inclusive', () {
      final item = BingoItem(
        emoji: '🌸',
        name: 'testBoundary',
        areas: [Area.land],
        availableFromMonth: 3,
        availableFromDay: 1,
        availableToMonth: 5,
        availableToDay: 31,
      );

      debugOverrideDate = DateTime(2025, 3, 1);
      expect(item.isAvailableNow(), isTrue);

      debugOverrideDate = DateTime(2025, 5, 31);
      expect(item.isAvailableNow(), isTrue);
    });
  });
}
