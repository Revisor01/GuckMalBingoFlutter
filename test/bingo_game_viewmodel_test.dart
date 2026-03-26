import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/models/bingo_item.dart';
import 'package:guck_mal_bingo/models/game_config.dart';
import 'package:guck_mal_bingo/models/area.dart';
import 'package:guck_mal_bingo/models/season.dart';
import 'package:guck_mal_bingo/viewmodels/bingo_game_viewmodel.dart';

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
}
