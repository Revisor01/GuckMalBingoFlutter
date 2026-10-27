import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/models/background_theme.dart';
import 'package:guck_mal_bingo/utilities/app_preferences.dart';
import 'package:guck_mal_bingo/utilities/background_pattern_view.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _selectable(
  BackgroundTheme theme, {
  bool christmas = false,
  bool easter = false,
  bool autumn = false,
  bool halloween = false,
}) =>
    theme.isSelectable(
      isChristmas: christmas,
      isEaster: easter,
      isAutumn: autumn,
      isHalloween: halloween,
    );

void main() {
  group('BackgroundTheme.isSelectable', () {
    test('autumn only in autumn', () {
      expect(_selectable(BackgroundTheme.autumn), isFalse);
      expect(_selectable(BackgroundTheme.autumn, autumn: true), isTrue);
      expect(_selectable(BackgroundTheme.autumn, halloween: true), isFalse);
    });

    test('halloween only in the Halloween window', () {
      expect(_selectable(BackgroundTheme.halloween), isFalse);
      expect(_selectable(BackgroundTheme.halloween, autumn: true), isFalse);
      expect(_selectable(BackgroundTheme.halloween, autumn: true, halloween: true), isTrue);
    });

    test('christmas and easter keep their seasons', () {
      expect(_selectable(BackgroundTheme.christmas), isFalse);
      expect(_selectable(BackgroundTheme.christmas, christmas: true), isTrue);
      expect(_selectable(BackgroundTheme.easter), isFalse);
      expect(_selectable(BackgroundTheme.easter, easter: true), isTrue);
    });

    test('regular themes are always selectable', () {
      for (final theme in [
        BackgroundTheme.lightBlue,
        BackgroundTheme.bluePurple,
        BackgroundTheme.pinkRed,
        BackgroundTheme.deepBlue,
        BackgroundTheme.pinkYellow,
        BackgroundTheme.greenMint,
      ]) {
        expect(_selectable(theme), isTrue, reason: theme.value);
      }
    });
  });

  group('BackgroundTheme.patternSymbols', () {
    test('autumn and halloween bring their own symbols, all assets exist', () {
      for (final theme in [BackgroundTheme.autumn, BackgroundTheme.halloween]) {
        final symbols = theme.patternSymbols!;
        expect(symbols.length, 10, reason: theme.value);
        for (final symbol in symbols.where((s) => s.assetPath != null)) {
          expect(File(symbol.assetPath!).existsSync(), isTrue, reason: symbol.assetPath);
        }
      }
    });

    test('autumn uses only silhouettes, halloween adds moon and star icons', () {
      expect(BackgroundTheme.autumn.patternSymbols!.where((s) => s.icon != null), isEmpty);
      expect(
        BackgroundTheme.halloween.patternSymbols!.map((s) => s.icon).whereType<IconData>(),
        [Icons.dark_mode, Icons.star],
      );
    });

    test('all other themes keep the area icons', () {
      for (final theme in BackgroundTheme.values) {
        if (theme == BackgroundTheme.autumn || theme == BackgroundTheme.halloween) continue;
        expect(theme.patternSymbols, isNull, reason: theme.value);
      }
    });

    test('fromString round-trips the new themes', () {
      expect(BackgroundTheme.fromString('autumn'), BackgroundTheme.autumn);
      expect(BackgroundTheme.fromString('halloween'), BackgroundTheme.halloween);
    });
  });

  group('BackgroundTheme.loadSavedTheme – Saisonwechsel', () {
    // late final: einmal initialisieren, vor jedem Test den Cache leeren.
    setUpAll(() async {
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
      await AppPreferences.init();
    });

    setUp(() => AppPreferences.instance.debugClearCache());

    tearDown(() {
      debugOverrideDate = null;
    });

    AppPreferences prefs() => AppPreferences.instance;

    BackgroundTheme startAt(DateTime date) {
      debugOverrideDate = date;
      return BackgroundTheme.loadSavedTheme();
    }

    test('fresh install in July → lightBlue, nothing applied', () {
      expect(startAt(DateTime(2026, 7, 15)), BackgroundTheme.lightBlue);
      expect(prefs().seasonThemeApplied, isNull);
    });

    test('autumn start switches to autumn, remembers own theme, enables effect', () async {
      await prefs().setBackgroundTheme('greenMint');
      await prefs().setAutumnEffectEnabled(false);

      expect(startAt(DateTime(2026, 9, 1)), BackgroundTheme.autumn);
      expect(prefs().backgroundThemeRaw, 'autumn');
      expect(prefs().themeBeforeSeason, 'greenMint');
      expect(prefs().seasonThemeApplied, 'autumn-2026');
      expect(prefs().autumnEffectEnabled, isTrue);
    });

    test('own choice within the season is kept on the next start', () async {
      startAt(DateTime(2026, 9, 1));
      await prefs().setBackgroundTheme('pinkRed');
      await prefs().setAutumnEffectEnabled(false);

      expect(startAt(DateTime(2026, 9, 20)), BackgroundTheme.pinkRed);
      expect(prefs().autumnEffectEnabled, isFalse);
    });

    test('full year: autumn → halloween → autumn → own theme → christmas → own theme → easter', () async {
      await prefs().setBackgroundTheme('deepBlue');

      expect(startAt(DateTime(2026, 9, 5)), BackgroundTheme.autumn);
      expect(startAt(DateTime(2026, 10, 15)), BackgroundTheme.halloween);
      expect(prefs().seasonThemeApplied, 'halloween-2026');
      expect(startAt(DateTime(2026, 11, 3)), BackgroundTheme.autumn);
      expect(prefs().seasonThemeApplied, 'autumn-2026');
      // Seasonal → seasonal overwrites nothing: own choice still known
      expect(prefs().themeBeforeSeason, 'deepBlue');

      expect(startAt(DateTime(2026, 11, 16)), BackgroundTheme.deepBlue);
      expect(prefs().backgroundThemeRaw, 'deepBlue');

      await prefs().setSnowfallEnabled(false);
      expect(startAt(DateTime(2026, 12, 1)), BackgroundTheme.christmas);
      expect(prefs().snowfallEnabled, isTrue);
      expect(prefs().seasonThemeApplied, 'christmas-2026');

      expect(startAt(DateTime(2027, 1, 7)), BackgroundTheme.deepBlue);

      // Ostern 2027: 28. März → Saison ab 14. März
      await prefs().setEasterEffectEnabled(false);
      expect(startAt(DateTime(2027, 3, 20)), BackgroundTheme.easter);
      expect(prefs().easterEffectEnabled, isTrue);
      expect(startAt(DateTime(2027, 4, 1)), BackgroundTheme.deepBlue);
    });

    test('christmas season in January belongs to the previous year – no second switch', () async {
      startAt(DateTime(2026, 12, 1));
      await prefs().setBackgroundTheme('greenMint');

      expect(startAt(DateTime(2027, 1, 3)), BackgroundTheme.greenMint);
      expect(prefs().seasonThemeApplied, 'christmas-2026');
    });

    test('next year the same season switches again', () async {
      startAt(DateTime(2026, 9, 1));
      await prefs().setBackgroundTheme('pinkYellow');
      startAt(DateTime(2026, 12, 20)); // Weihnachten dazwischen
      await prefs().setBackgroundTheme('pinkYellow');
      startAt(DateTime(2027, 7, 1));

      expect(startAt(DateTime(2027, 9, 1)), BackgroundTheme.autumn);
      expect(prefs().seasonThemeApplied, 'autumn-2027');
    });

    test('seasonal theme without remembered own theme falls back to lightBlue', () async {
      await prefs().setBackgroundTheme('halloween');
      expect(startAt(DateTime(2026, 7, 15)), BackgroundTheme.lightBlue);
      expect(prefs().backgroundThemeRaw, 'lightBlue');
    });

    test('old German theme names are still migrated', () async {
      await prefs().setBackgroundTheme('Himmelblau');
      expect(startAt(DateTime(2026, 7, 15)), BackgroundTheme.lightBlue);
      expect(prefs().backgroundThemeRaw, 'lightBlue');
    });

    test('seasonKey', () {
      expect(BackgroundTheme.seasonKey(BackgroundTheme.autumn, DateTime(2026, 9, 1)), 'autumn-2026');
      expect(BackgroundTheme.seasonKey(BackgroundTheme.christmas, DateTime(2026, 12, 24)), 'christmas-2026');
      expect(BackgroundTheme.seasonKey(BackgroundTheme.christmas, DateTime(2027, 1, 6)), 'christmas-2026');
    });

    test('currentSeasonalTheme: halloween wins inside autumn', () {
      debugOverrideDate = DateTime(2026, 10, 20);
      expect(BackgroundTheme.currentSeasonalTheme(), BackgroundTheme.halloween);
      debugOverrideDate = DateTime(2026, 10, 14);
      expect(BackgroundTheme.currentSeasonalTheme(), BackgroundTheme.autumn);
      debugOverrideDate = DateTime(2026, 8, 31);
      expect(BackgroundTheme.currentSeasonalTheme(), isNull);
    });
  });

  group('BackgroundPatternView', () {
    Future<void> pumpPattern(WidgetTester tester, BackgroundTheme? theme) =>
        tester.pumpWidget(MaterialApp(
          home: SizedBox(
            width: 400,
            height: 800,
            child: BackgroundPatternView(theme: theme),
          ),
        ));

    testWidgets('without theme: only icons, no silhouettes', (tester) async {
      await pumpPattern(tester, null);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('halloween: silhouettes plus moon/star icons', (tester) async {
      await pumpPattern(tester, BackgroundTheme.halloween);
      expect(find.byType(Image), findsWidgets);
      final icons = tester.widgetList<Icon>(find.byType(Icon)).map((i) => i.icon).toSet();
      expect(icons, {Icons.dark_mode, Icons.star});
    });

    testWidgets('autumn: only silhouettes', (tester) async {
      await pumpPattern(tester, BackgroundTheme.autumn);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('switching the theme replaces the symbols', (tester) async {
      await pumpPattern(tester, null);
      expect(find.byType(Image), findsNothing);
      await pumpPattern(tester, BackgroundTheme.autumn);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Icon), findsNothing);
    });
  });
}
