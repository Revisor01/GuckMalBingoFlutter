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

  group('BackgroundTheme.loadSavedTheme default by date', () {
    // AppPreferences.instance ist late final → nur einmal initialisieren.
    // Kein Test außer dem letzten speichert ein Theme.
    setUpAll(() async {
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
      await AppPreferences.init();
    });

    tearDown(() {
      debugOverrideDate = null;
    });

    test('September 20 → autumn', () {
      debugOverrideDate = DateTime(2026, 9, 20);
      expect(BackgroundTheme.loadSavedTheme(), BackgroundTheme.autumn);
    });

    test('October 31 → halloween (wins over autumn)', () {
      debugOverrideDate = DateTime(2026, 10, 31);
      expect(BackgroundTheme.loadSavedTheme(), BackgroundTheme.halloween);
    });

    test('November 10 → autumn again', () {
      debugOverrideDate = DateTime(2026, 11, 10);
      expect(BackgroundTheme.loadSavedTheme(), BackgroundTheme.autumn);
    });

    test('December 24 → christmas', () {
      debugOverrideDate = DateTime(2026, 12, 24);
      expect(BackgroundTheme.loadSavedTheme(), BackgroundTheme.christmas);
    });

    test('July → lightBlue', () {
      debugOverrideDate = DateTime(2026, 7, 15);
      expect(BackgroundTheme.loadSavedTheme(), BackgroundTheme.lightBlue);
    });

    // Muss der letzte Test der Gruppe bleiben (speichert ein Theme).
    test('a saved theme wins over the seasonal default', () async {
      debugOverrideDate = DateTime(2026, 10, 31);
      await AppPreferences.instance.setBackgroundTheme('greenMint');
      expect(BackgroundTheme.loadSavedTheme(), BackgroundTheme.greenMint);
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
