import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/models/game_config.dart';
import 'package:guck_mal_bingo/models/game_mode.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/season.dart';
import 'package:guck_mal_bingo/viewmodels/duell_game_viewmodel.dart';
import 'package:guck_mal_bingo/utilities/audio_player.dart';

/// Helper: Creates a standard test config for Duell-Modus
GameConfig _testConfig({int targetBingos = 3}) {
  return GameConfig(
    gameMode: GameMode.duell,
    targetBingos: targetBingos,
    area: Area.autobahn,
    season: Season.fruehling_sommer,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Register mock method channel for audioplayers to prevent MissingPluginException
  setUpAll(() {
    const MethodChannel('xyz.luan/audioplayers.global')
        .setMockMethodCallHandler((MethodCall methodCall) async => null);
    const MethodChannel('xyz.luan/audioplayers')
        .setMockMethodCallHandler((MethodCall methodCall) async => null);
  });

  group('DuellGameViewModel', () {
    late DuellGameViewModel vm;

    setUp(() {
      vm = DuellGameViewModel(config: _testConfig());
    });

    // Test 1: markFound() erhoeht score um 1
    // Note: This test runs first and the GameAudioPlayer singleton initializes
    // for the first time here. An async platform channel error fires after
    // the test completes — this is expected behavior matching BingoGameViewModel tests.
    test('markFound() increases score by 1', () {
      final initialScore = vm.score;
      vm.markFound();
      expect(vm.score, initialScore + 1);
    });

    // Test 2: Initialisierung — currentItem ist nicht null
    test('initializes with non-null currentItem from itemsFor()', () {
      expect(vm.currentItem, isNotNull);
    });

    // Test 3: skip() aendert score NICHT, aber currentItem wechselt
    test('skip() does not change score but advances currentItem', () {
      final initialScore = vm.score;
      final initialItem = vm.currentItem;
      int attempts = 0;
      bool itemChanged = false;
      while (attempts < 100) {
        vm.skip();
        attempts++;
        if (vm.currentItem != initialItem) {
          itemChanged = true;
          break;
        }
      }
      expect(vm.score, initialScore);
      expect(itemChanged, isTrue,
          reason: 'currentItem should change after skip() (queue has multiple items)');
    });

    // Test 4: Nach targetBingos markFound()-Aufrufen ist showVictoryDialog true
    test('showVictoryDialog is true after targetBingos markFound() calls', () {
      final config = _testConfig(targetBingos: 3);
      final localVm = DuellGameViewModel(config: config);

      expect(localVm.showVictoryDialog, isFalse);
      for (int i = 0; i < config.targetBingos; i++) {
        localVm.markFound();
      }
      expect(localVm.showVictoryDialog, isTrue);
    });

    // Test 5: resetGame() setzt score auf 0, showVictoryDialog auf false
    test('resetGame() resets score to 0 and showVictoryDialog to false', () {
      final config = _testConfig(targetBingos: 2);
      final localVm = DuellGameViewModel(config: config);

      localVm.markFound();
      localVm.markFound();
      expect(localVm.showVictoryDialog, isTrue);
      expect(localVm.score, 2);

      localVm.resetGame();
      expect(localVm.score, 0);
      expect(localVm.showVictoryDialog, isFalse);
      expect(localVm.currentItem, isNotNull);
    });

    // Test 6: Queue-Zyklus — wenn alle Items durch, startet Queue von vorn (kein RangeError)
    test('queue cycles without RangeError when all items exhausted', () {
      expect(() {
        for (int i = 0; i < 500; i++) {
          vm.skip();
        }
      }, returnsNormally);
      expect(vm.currentItem, isNotNull);
    });

    // Test 7: dismissVictoryDialog() setzt showVictoryDialog auf false
    test('dismissVictoryDialog() sets showVictoryDialog to false', () {
      final config = _testConfig(targetBingos: 1);
      final localVm = DuellGameViewModel(config: config);

      localVm.markFound();
      expect(localVm.showVictoryDialog, isTrue);

      localVm.dismissVictoryDialog();
      expect(localVm.showVictoryDialog, isFalse);
    });
  });
}
