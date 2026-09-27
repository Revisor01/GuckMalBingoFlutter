import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guck_mal_bingo/utilities/season_service.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';
import 'package:guck_mal_bingo/utilities/app_preferences.dart';

void main() {
  setUpAll(() async {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init();
  });

  group('SeasonService', () {
    setUp(() {
      debugOverrideDate = null;
      // Reset mock values (snowfall + easter enabled = true by default)
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      debugOverrideDate = null;
    });

    test('creates instance without error', () {
      final service = SeasonService();
      expect(service, isNotNull);
    });

    test('initial values reflect current season', () {
      final service = SeasonService();
      expect(service.isChristmas, equals(isChristmasSeason()));
      expect(service.isEaster, equals(isEasterSeason()));
    });

    test('isChristmas true during Christmas season', () {
      debugOverrideDate = DateTime(2025, 12, 25);
      final service = SeasonService();
      expect(service.isChristmas, isTrue);
    });

    test('isChristmas false outside Christmas season', () {
      debugOverrideDate = DateTime(2025, 7, 15);
      final service = SeasonService();
      expect(service.isChristmas, isFalse);
    });

    test('isEaster true during Easter season', () {
      // 2025 Easter Sunday: April 20
      // Season starts 14 days before: April 6
      debugOverrideDate = DateTime(2025, 4, 18);
      final service = SeasonService();
      expect(service.isEaster, isTrue);
    });

    test('isEaster false outside Easter season', () {
      debugOverrideDate = DateTime(2025, 7, 15);
      final service = SeasonService();
      expect(service.isEaster, isFalse);
    });

    test('shouldShowSnowfall true when isChristmas and snowfallEnabled', () {
      debugOverrideDate = DateTime(2025, 12, 25);
      FlutterSecureStorage.setMockInitialValues({'snowfallEnabled': 'true'});
      SharedPreferences.setMockInitialValues({});
      final service = SeasonService();
      expect(service.isChristmas, isTrue);
      expect(service.snowfallEnabled, isTrue);
      expect(service.shouldShowSnowfall, isTrue);
    });

    test('shouldShowSnowfall false when not isChristmas', () {
      debugOverrideDate = DateTime(2025, 7, 15);
      final service = SeasonService();
      expect(service.shouldShowSnowfall, isFalse);
    });

    test('shouldShowEasterEffect true when isEaster and easterEffectEnabled', () {
      debugOverrideDate = DateTime(2025, 4, 18);
      FlutterSecureStorage.setMockInitialValues({'easterEffectEnabled': 'true'});
      SharedPreferences.setMockInitialValues({});
      final service = SeasonService();
      expect(service.isEaster, isTrue);
      expect(service.easterEffectEnabled, isTrue);
      expect(service.shouldShowEasterEffect, isTrue);
    });

    test('shouldShowEasterEffect false when not isEaster', () {
      debugOverrideDate = DateTime(2025, 7, 15);
      final service = SeasonService();
      expect(service.shouldShowEasterEffect, isFalse);
    });

    test('setSnowfallEnabled notifies listeners', () async {
      final service = SeasonService();
      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      await service.setSnowfallEnabled(false);

      expect(notifyCount, greaterThan(0));
      expect(service.snowfallEnabled, isFalse);
    });

    test('setEasterEffectEnabled notifies listeners', () async {
      final service = SeasonService();
      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      await service.setEasterEffectEnabled(false);

      expect(notifyCount, greaterThan(0));
      expect(service.easterEffectEnabled, isFalse);
    });
    test('isAutumn true and isHalloween false in mid-September', () {
      debugOverrideDate = DateTime(2026, 9, 20);
      final service = SeasonService();
      expect(service.isAutumn, isTrue);
      expect(service.isHalloween, isFalse);
    });

    test('isAutumn and isHalloween both true on October 31', () {
      debugOverrideDate = DateTime(2026, 10, 31);
      final service = SeasonService();
      expect(service.isAutumn, isTrue);
      expect(service.isHalloween, isTrue);
    });

    test('isAutumn false in July', () {
      debugOverrideDate = DateTime(2026, 7, 15);
      final service = SeasonService();
      expect(service.isAutumn, isFalse);
      expect(service.isHalloween, isFalse);
      expect(service.shouldShowAutumnEffect, isFalse);
    });

    test('shouldShowAutumnEffect true in autumn with default setting', () {
      debugOverrideDate = DateTime(2026, 10, 1);
      final service = SeasonService();
      expect(service.autumnEffectEnabled, isTrue);
      expect(service.shouldShowAutumnEffect, isTrue);
    });

    test('setAutumnEffectEnabled(false) hides effect, persists and notifies', () async {
      debugOverrideDate = DateTime(2026, 10, 1);
      final service = SeasonService();
      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      await service.setAutumnEffectEnabled(false);

      expect(notifyCount, 1);
      expect(service.autumnEffectEnabled, isFalse);
      expect(service.shouldShowAutumnEffect, isFalse);
      expect(AppPreferences.instance.autumnEffectEnabled, isFalse);

      await service.setAutumnEffectEnabled(true);
      expect(AppPreferences.instance.autumnEffectEnabled, isTrue);
    });
  });
}
