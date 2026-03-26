import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';

void main() {
  group('isChristmasSeason', () {
    tearDown(() {
      debugOverrideDate = null;
    });

    test('returns true on December 1', () {
      debugOverrideDate = DateTime(2025, 12, 1);
      expect(isChristmasSeason(), isTrue);
    });

    test('returns true on December 25', () {
      debugOverrideDate = DateTime(2025, 12, 25);
      expect(isChristmasSeason(), isTrue);
    });

    test('returns true on December 31', () {
      debugOverrideDate = DateTime(2025, 12, 31);
      expect(isChristmasSeason(), isTrue);
    });

    test('returns true on January 1', () {
      debugOverrideDate = DateTime(2025, 1, 1);
      expect(isChristmasSeason(), isTrue);
    });

    test('returns true on January 6', () {
      debugOverrideDate = DateTime(2025, 1, 6);
      expect(isChristmasSeason(), isTrue);
    });

    test('returns false on January 7', () {
      debugOverrideDate = DateTime(2025, 1, 7);
      expect(isChristmasSeason(), isFalse);
    });

    test('returns false on November 30', () {
      debugOverrideDate = DateTime(2025, 11, 30);
      expect(isChristmasSeason(), isFalse);
    });

    test('returns false on July 15', () {
      debugOverrideDate = DateTime(2025, 7, 15);
      expect(isChristmasSeason(), isFalse);
    });

    test('returns false on February 1', () {
      debugOverrideDate = DateTime(2025, 2, 1);
      expect(isChristmasSeason(), isFalse);
    });
  });
}
