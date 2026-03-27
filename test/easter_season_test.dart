import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';

void main() {
  group('getEasterDate', () {
    test('returns correct Easter date for known years', () {
      // Verified against published Easter dates
      expect(getEasterDate(2024), DateTime(2024, 3, 31));
      expect(getEasterDate(2025), DateTime(2025, 4, 20));
      expect(getEasterDate(2026), DateTime(2026, 4, 5));
      expect(getEasterDate(2027), DateTime(2027, 3, 28));
      expect(getEasterDate(2028), DateTime(2028, 4, 16));
      expect(getEasterDate(2029), DateTime(2029, 4, 1));
      expect(getEasterDate(2030), DateTime(2030, 4, 21));
    });
  });

  group('isEasterSeason', () {
    tearDown(() {
      debugOverrideDate = null;
    });

    test('returns true on Easter Sunday 2026 (April 5)', () {
      debugOverrideDate = DateTime(2026, 4, 5);
      expect(isEasterSeason(), isTrue);
    });

    test('returns true on Easter Monday 2026 (April 6)', () {
      debugOverrideDate = DateTime(2026, 4, 6);
      expect(isEasterSeason(), isTrue);
    });

    test('returns true 14 days before Easter 2026 (March 22)', () {
      debugOverrideDate = DateTime(2026, 3, 22);
      expect(isEasterSeason(), isTrue);
    });

    test('returns false 15 days before Easter 2026 (March 20)', () {
      debugOverrideDate = DateTime(2026, 3, 20);
      expect(isEasterSeason(), isFalse);
    });

    test('returns false day after Easter Monday 2026 (April 7)', () {
      debugOverrideDate = DateTime(2026, 4, 7);
      expect(isEasterSeason(), isFalse);
    });

    test('returns false in summer', () {
      debugOverrideDate = DateTime(2026, 7, 15);
      expect(isEasterSeason(), isFalse);
    });

    test('returns true during Easter season for different year (2025)', () {
      // Easter 2025 is April 20, season starts April 6
      debugOverrideDate = DateTime(2025, 4, 10);
      expect(isEasterSeason(), isTrue);
    });

    test('returns false outside Easter season 2025', () {
      debugOverrideDate = DateTime(2025, 4, 5);
      expect(isEasterSeason(), isFalse);
    });
  });
}
