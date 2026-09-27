import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/data/bingo_items_data.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/bingo_item.dart';
import 'package:guck_mal_bingo/models/season.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';
import 'package:guck_mal_bingo/views/autumn_effect_widget.dart';

const herbstItems = [
  'itemKuerbis',
  'itemLaub',
  'itemEicheln',
  'itemIgel',
  'itemPilze',
  'itemEichhoernchen',
  'itemSchal',
  'itemApfelkorb',
  'itemEule',
  'itemKakao',
  'itemMuetze',
  'itemHerbstkranz',
];

const halloweenItems = [
  'itemKuerbislaterne',
  'itemGespenst',
  'itemFledermaus',
  'itemHexenhut',
  'itemSpinne',
  'itemTotenkopf',
  'itemSchwarzeKatze',
  'itemZaubertrank',
  'itemSuessigkeiten',
  'itemHexenkessel',
  'itemKostuemDino',
  'itemKostuemGespenst',
  'itemKostuemHexe',
  'itemKostuemPirat',
  'itemKostuemZauberer',
  'itemKostuemMumie',
];

BingoItem _item(String name) =>
    BingoItemsData.allItems.singleWhere((i) => i.name == name);

Set<String> _poolNames(Area area, Season season) =>
    BingoItemsData.itemsFor(area: area, season: season).map((i) => i.name).toSet();

void main() {
  tearDown(() {
    debugOverrideDate = null;
  });

  group('isAutumnSeason (1.9. - 15.11.)', () {
    test('false on August 31', () {
      debugOverrideDate = DateTime(2026, 8, 31);
      expect(isAutumnSeason(), isFalse);
    });
    test('true on September 1', () {
      debugOverrideDate = DateTime(2026, 9, 1);
      expect(isAutumnSeason(), isTrue);
    });
    test('true on November 15', () {
      debugOverrideDate = DateTime(2026, 11, 15);
      expect(isAutumnSeason(), isTrue);
    });
    test('false on November 16', () {
      debugOverrideDate = DateTime(2026, 11, 16);
      expect(isAutumnSeason(), isFalse);
    });
  });

  group('isHalloweenSeason (15.10. - 2.11.)', () {
    test('false on October 14', () {
      debugOverrideDate = DateTime(2026, 10, 14);
      expect(isHalloweenSeason(), isFalse);
    });
    test('true on October 15', () {
      debugOverrideDate = DateTime(2026, 10, 15);
      expect(isHalloweenSeason(), isTrue);
    });
    test('true on October 31', () {
      debugOverrideDate = DateTime(2026, 10, 31);
      expect(isHalloweenSeason(), isTrue);
    });
    test('true on November 2', () {
      debugOverrideDate = DateTime(2026, 11, 2);
      expect(isHalloweenSeason(), isTrue);
    });
    test('false on November 3', () {
      debugOverrideDate = DateTime(2026, 11, 3);
      expect(isHalloweenSeason(), isFalse);
    });
  });

  group('Herbst-Items', () {
    test('exactly 12 autumn items exist', () {
      expect(herbstItems.map(_item).length, 12);
    });

    for (final name in herbstItems) {
      test('$name: available 1.9. and 15.11., not 31.8. and 16.11.', () {
        final item = _item(name);
        debugOverrideDate = DateTime(2026, 9, 1);
        expect(item.isAvailableNow(), isTrue);
        debugOverrideDate = DateTime(2026, 11, 15);
        expect(item.isAvailableNow(), isTrue);
        debugOverrideDate = DateTime(2026, 8, 31);
        expect(item.isAvailableNow(), isFalse);
        debugOverrideDate = DateTime(2026, 11, 16);
        expect(item.isAvailableNow(), isFalse);
      });
    }
  });

  group('Halloween-Items', () {
    test('exactly 16 Halloween items exist (10 symbols + 6 costumes)', () {
      expect(halloweenItems.map(_item).length, 16);
    });

    for (final name in halloweenItems) {
      test('$name: available 15.10. and 2.11., not 14.10. and 3.11.', () {
        final item = _item(name);
        debugOverrideDate = DateTime(2026, 10, 15);
        expect(item.isAvailableNow(), isTrue);
        debugOverrideDate = DateTime(2026, 11, 2);
        expect(item.isAvailableNow(), isTrue);
        debugOverrideDate = DateTime(2026, 10, 14);
        expect(item.isAvailableNow(), isFalse);
        debugOverrideDate = DateTime(2026, 11, 3);
        expect(item.isAvailableNow(), isFalse);
      });
    }
  });

  group('Item-Pool je Datum', () {
    test('mid-September: autumn items in both seasons, no Halloween items', () {
      debugOverrideDate = DateTime(2026, 9, 20);
      for (final season in [Season.fruehling_sommer, Season.herbst_winter]) {
        final names = _poolNames(Area.land, season);
        expect(names, contains('itemKuerbis'));
        expect(names, contains('itemIgel'));
        expect(names, isNot(contains('itemKuerbislaterne')));
        expect(names, isNot(contains('itemKostuemHexe')));
      }
    });

    test('October 31: autumn and Halloween items together', () {
      debugOverrideDate = DateTime(2026, 10, 31);
      final names = _poolNames(Area.stadt, Season.herbst_winter);
      expect(names, contains('itemLaub'));
      expect(names, contains('itemKuerbislaterne'));
      expect(names, contains('itemKostuemPirat'));
    });

    test('July: none of the new items', () {
      debugOverrideDate = DateTime(2026, 7, 15);
      final names = _poolNames(Area.zuHause, Season.fruehling_sommer);
      for (final name in [...herbstItems, ...halloweenItems]) {
        expect(names, isNot(contains(name)));
      }
    });
  });

  group('Asset- und Übersetzungs-Integrität', () {
    test('every item image exists in assets/images', () {
      final missing = BingoItemsData.allItems
          .where((i) => i.imageName != null)
          .where((i) => !File('assets/images/${i.imageName}.webp').existsSync())
          .map((i) => i.imageName)
          .toList();
      expect(missing, isEmpty);
    });

    test('new item icons are 1024x1024 WebP like all other icons', () {
      for (final name in [...herbstItems, ...halloweenItems]) {
        final bytes = File('assets/images/${_item(name).imageName}.webp').readAsBytesSync();
        expect(ascii.decode(bytes.sublist(8, 12)), 'WEBP', reason: name);
        // VP8X-Header: Breite/Höhe minus 1 als 24-bit little endian ab Byte 24
        final width = 1 + bytes[24] + (bytes[25] << 8) + (bytes[26] << 16);
        final height = 1 + bytes[27] + (bytes[28] << 8) + (bytes[29] << 16);
        expect([width, height], [1024, 1024], reason: name);
      }
    });

    test('every new item has a German name in the template', () {
      final arb = jsonDecode(File('lib/l10n/app_de.arb').readAsStringSync()) as Map;
      for (final name in [...herbstItems, ...halloweenItems, 'settingsAutumnEffect']) {
        expect(arb[name], isA<String>(), reason: name);
      }
    });

    test('effect sprites exist', () {
      for (final asset in [
        ...AutumnEffectWidget.leafAssets,
        AutumnEffectWidget.batAsset,
        AutumnEffectWidget.ghostAsset,
      ]) {
        expect(File(asset).existsSync(), isTrue, reason: asset);
      }
    });
  });

  group('FallingLeaf', () {
    test('respawns above the screen after falling out at the bottom', () {
      final random = Random(1);
      final leaf = FallingLeaf(random);
      expect(leaf.y, -0.08);
      leaf.y = 1.079;
      leaf.update(0.1, random); // >= 0.035/s * 0.1 s = 0.0035 → über 1.08
      expect(leaf.y, -0.08);
    });

    test('flip scale never collapses below 0.25', () {
      final random = Random(2);
      final leaf = FallingLeaf(random);
      for (var i = 0; i < 500; i++) {
        leaf.update(1 / 60, random);
        expect(leaf.flipScale.abs(), greaterThanOrEqualTo(0.25));
      }
    });
  });

  group('HalloweenVisitor', () {
    HalloweenVisitor visitor(HalloweenVisitorType type, {bool leftToRight = true}) =>
        HalloweenVisitor(
          type: type,
          leftToRight: leftToRight,
          baseY: 0.3,
          duration: 10,
          size: 64,
        );

    test('crosses the whole screen from left to right', () {
      final v = visitor(HalloweenVisitorType.bat);
      expect(v.x, closeTo(-0.15, 1e-9));
      v.update(10);
      expect(v.x, closeTo(1.15, 1e-9));
      expect(v.isDone, isTrue);
    });

    test('crosses from right to left when mirrored', () {
      final v = visitor(HalloweenVisitorType.bat, leftToRight: false);
      expect(v.x, closeTo(1.15, 1e-9));
      v.update(10);
      expect(v.x, closeTo(-0.15, 1e-9));
    });

    test('is not done before its duration', () {
      final v = visitor(HalloweenVisitorType.ghost);
      v.update(9.9);
      expect(v.isDone, isFalse);
    });

    test('ghost fades in and out, bat stays opaque', () {
      final ghost = visitor(HalloweenVisitorType.ghost);
      expect(ghost.opacity, 0.0);
      ghost.update(5);
      expect(ghost.opacity, 0.85);
      ghost.update(5);
      expect(ghost.opacity, 0.0);

      final bat = visitor(HalloweenVisitorType.bat);
      expect(bat.opacity, 1.0);
      bat.update(5);
      expect(bat.opacity, 1.0);
    });

    test('only the bat flaps', () {
      final ghost = visitor(HalloweenVisitorType.ghost)..update(0.37);
      expect(ghost.flapScale, 1.0);
      final bat = visitor(HalloweenVisitorType.bat)..update(0.37);
      expect(bat.flapScale, inInclusiveRange(0.55, 1.0));
      expect(bat.flapScale, isNot(1.0));
    });

    test('spawn delays: first visit after 5-10 s, then every 12-28 s', () {
      final random = Random(3);
      for (var i = 0; i < 100; i++) {
        expect(HalloweenVisitor.nextSpawnDelay(random, first: true), inInclusiveRange(5, 10));
        expect(HalloweenVisitor.nextSpawnDelay(random), inInclusiveRange(12, 28));
      }
    });
  });

  group('AutumnEffectWidget', () {
    testWidgets('disabled: renders only the child, no effect layer', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AutumnEffectWidget(enabled: false, child: Text('Spiel')),
      ));
      expect(find.text('Spiel'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AutumnEffectWidget),
          matching: find.byType(IgnorePointer),
        ),
        findsNothing,
      );
    });
  });
}
