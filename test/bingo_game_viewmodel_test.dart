import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/models/game_config.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/season.dart';
import 'package:guck_mal_bingo/viewmodels/bingo_game_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guck_mal_bingo/utilities/app_preferences.dart';
import 'package:guck_mal_bingo/data/bingo_items_data.dart';
import 'package:guck_mal_bingo/utilities/debug_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BingoGameViewModel._checkWin (via toggleCell)', () {
    late BingoGameViewModel vm;

    setUp(() {
      vm = BingoGameViewModel(
        config: GameConfig(
          area: Area.autobahn,
          season: Season.fruehling_sommer,
          gridSize: 4,
          targetBingos: 3,
        ),
      );
    });

    test('detects row bingo when entire row is clicked', () {
      // Click entire first row (indices 0, 1, 2, 3)
      for (int i = 0; i < 4; i++) {
        vm.toggleCell(i);
      }
      expect(vm.bingoCount, 1);
    });

    test('detects column bingo when entire column is clicked', () {
      // Click entire first column (indices 0, 4, 8, 12)
      for (int i = 0; i < 4; i++) {
        vm.toggleCell(i * 4);
      }
      expect(vm.bingoCount, 1);
    });

    test('detects diagonal1 bingo (top-left to bottom-right)', () {
      // Click diagonal (indices 0, 5, 10, 15)
      for (int i = 0; i < 4; i++) {
        vm.toggleCell(i * 4 + i);
      }
      expect(vm.bingoCount, 1);
    });

    test('detects diagonal2 bingo (top-right to bottom-left)', () {
      // Click anti-diagonal (indices 3, 6, 9, 12)
      for (int i = 0; i < 4; i++) {
        vm.toggleCell(i * 4 + (3 - i));
      }
      expect(vm.bingoCount, 1);
    });

    test('does not count bingo for incomplete row', () {
      // Click only 3 of 4 in first row
      vm.toggleCell(0);
      vm.toggleCell(1);
      vm.toggleCell(2);
      expect(vm.bingoCount, 0);
    });

    test('detects multiple bingos', () {
      // Complete first row
      for (int i = 0; i < 4; i++) {
        vm.toggleCell(i);
      }
      expect(vm.bingoCount, 1);

      // Complete second row
      for (int i = 4; i < 8; i++) {
        vm.toggleCell(i);
      }
      expect(vm.bingoCount, 2);
    });

    test('does not double-count same bingo after unchecking and rechecking', () {
      // Complete first row
      for (int i = 0; i < 4; i++) {
        vm.toggleCell(i);
      }
      expect(vm.bingoCount, 1);

      // Uncheck one cell
      vm.toggleCell(0);
      // Re-check it — this is the same bingo, should not increment
      vm.toggleCell(0);
      expect(vm.bingoCount, 1);
    });
  });

  group('BingoGameViewModel persistence (fromSavedState / saveGameState)', () {
    setUpAll(() async {
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
      await AppPreferences.init();
    });

    setUp(() {
      debugOverrideDate = DateTime(2026, 6, 15); // Neutrales Datum
      FlutterSecureStorage.setMockInitialValues({});
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      debugOverrideDate = null;
    });

    test('fromSavedState with boardIndices restores correct board items', () {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);
      final boardItems = BingoItemsData.allItems.take(9).toList();
      final boardIndices = boardItems.map((item) => BingoItemsData.allItems.indexOf(item)).toList();

      final state = {
        'boardIndices': boardIndices,
        'clickedIndices': <int>[],
        'bingoCount': 0,
        'config': config.toJson(),
      };

      final vm = BingoGameViewModel.fromSavedState(state);
      expect(vm.board.length, 9);
      expect(vm.board, equals(boardItems));
    });

    test('fromSavedState restores clickedIndices correctly', () {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);
      final boardIndices = List.generate(9, (i) => i);

      final state = {
        'boardIndices': boardIndices,
        'clickedIndices': [0, 4, 8],
        'bingoCount': 0,
        'config': config.toJson(),
      };

      final vm = BingoGameViewModel.fromSavedState(state);
      expect(vm.clickedIndices, equals({0, 4, 8}));
    });

    test('fromSavedState with old board format (migration fallback)', () {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);
      final boardItems = BingoItemsData.allItems.take(9).toList();

      final state = {
        'board': boardItems.map((item) => item.toJson()).toList(),
        'clickedIndices': [1, 2],
        'bingoCount': 0,
        'config': config.toJson(),
      };

      final vm = BingoGameViewModel.fromSavedState(state);
      expect(vm.board.length, 9);
      expect(vm.clickedIndices, equals({1, 2}));
    });

    test('fromSavedState with complete row sets highlightedIndices and bingoCount', () {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);
      final boardIndices = List.generate(9, (i) => i);

      final state = {
        'boardIndices': boardIndices,
        'clickedIndices': [0, 1, 2], // Komplette erste Zeile bei 3x3
        'bingoCount': 0,
        'config': config.toJson(),
      };

      final vm = BingoGameViewModel.fromSavedState(state);
      expect(vm.bingoCount, 1);
      expect(vm.highlightedIndices, containsAll([0, 1, 2]));
    });

    test('fromSavedState with empty clickedIndices has no bingos', () {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);
      final boardIndices = List.generate(9, (i) => i);

      final state = {
        'boardIndices': boardIndices,
        'clickedIndices': <int>[],
        'bingoCount': 0,
        'config': config.toJson(),
      };

      final vm = BingoGameViewModel.fromSavedState(state);
      expect(vm.bingoCount, 0);
      expect(vm.highlightedIndices, isEmpty);
    });

    test('saveGameState + loadGameState round-trip', () async {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);
      final vm = BingoGameViewModel(config: config);
      vm.toggleCell(0);
      vm.toggleCell(1);

      vm.saveGameState();

      final loaded = AppPreferences.instance.loadGameState();
      expect(loaded, isNotNull);
      expect(loaded!['boardIndices'], isA<List>());
      expect((loaded['boardIndices'] as List).length, 9);
      expect(loaded['clickedIndices'], containsAll([0, 1]));

      final vm2 = BingoGameViewModel.fromSavedState(loaded);
      expect(vm2.board.length, vm.board.length);
      expect(vm2.clickedIndices, equals(vm.clickedIndices));
    });

    test('fromSavedState filters out invalid indices', () {
      final config = GameConfig(area: Area.autobahn, season: Season.fruehling_sommer, gridSize: 3);

      final state = {
        'boardIndices': [0, 1, 2, 3, 4, 5, 6, 7, -1], // -1 ist ungueltig
        'clickedIndices': <int>[],
        'bingoCount': 0,
        'config': config.toJson(),
      };

      final vm = BingoGameViewModel.fromSavedState(state);
      expect(vm.board.length, 8); // -1 wird herausgefiltert
    });
  });
}
