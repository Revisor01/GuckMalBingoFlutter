import 'package:flutter/foundation.dart';
import '../models/game_config.dart';
import '../models/bingo_item.dart';
import '../data/bingo_items_data.dart';
import '../utilities/audio_player.dart';

/// BingoType für Bingo-Erkennung
class BingoType {
  final String _value;
  const BingoType._(this._value);

  static const rowType = BingoType._('row');
  static const columnType = BingoType._('column');
  static const diagonal1Type = BingoType._('diagonal1');
  static const diagonal2Type = BingoType._('diagonal2');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BingoType &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

/// BingoType mit Index und Factory Methods
class BingoTypeWithIndex {
  final BingoType type;
  final int index;

  BingoTypeWithIndex(this.type, this.index);

  /// Factory methods für einfache Erstellung
  static BingoTypeWithIndex row(int index) =>
      BingoTypeWithIndex(BingoType.rowType, index);
  static BingoTypeWithIndex column(int index) =>
      BingoTypeWithIndex(BingoType.columnType, index);
  static BingoTypeWithIndex diagonal1() =>
      BingoTypeWithIndex(BingoType.diagonal1Type, 0);
  static BingoTypeWithIndex diagonal2() =>
      BingoTypeWithIndex(BingoType.diagonal2Type, 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BingoTypeWithIndex &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          index == other.index;

  @override
  int get hashCode => Object.hash(type, index);
}

/// BingoGameViewModel - Portiert von Swift
/// Verwaltet den kompletten Spielzustand und die Logik
class BingoGameViewModel extends ChangeNotifier {
  GameConfig config;
  List<BingoItem> board = [];
  Set<int> clickedIndices = {};
  int bingoCount = 0;
  bool showText = false;
  bool soundEnabled = true;
  bool showWinMessage = false;
  String winMessage = '';
  bool isFinalVictory = false;
  bool showVictoryDialog = false;
  Set<int> highlightedIndices = {};
  int? blinkingIndex;
  Set<int> blinkingAllIndices = {};

  late GameAudioPlayer _audioPlayer;
  Set<BingoTypeWithIndex> _completedBingos = {};
  bool _isDisposed = false;

  BingoGameViewModel({required this.config}) {
    _audioPlayer = GameAudioPlayer();

    // Generate board immediately for faster loading
    final totalCells = config.gridSize * config.gridSize;
    final itemList = BingoItemsData.itemsFor(
      area: config.area,
      season: config.season,
    );
    board = (itemList..shuffle()).take(totalCells).toList();
  }

  void generateBoard() {
    final totalCells = config.gridSize * config.gridSize;
    final itemList = BingoItemsData.itemsFor(
      area: config.area,
      season: config.season,
    );

    // Ensure board is always regenerated with correct size
    board.clear();
    board = (itemList..shuffle()).take(totalCells).toList();
    notifyListeners();
  }

  void toggleCell(int index) {
    if (clickedIndices.contains(index)) {
      clickedIndices.remove(index);
    } else {
      clickedIndices.add(index);
    }
    _audioPlayer.playClickSound();
    notifyListeners();
    _checkWin();
  }

  void toggleText() {
    showText = !showText;
    notifyListeners();
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
    _audioPlayer.soundEnabled = soundEnabled;
    notifyListeners();
  }

  void resetGame() {
    clickedIndices.clear();
    bingoCount = 0;
    _completedBingos.clear();
    showWinMessage = false;
    showVictoryDialog = false;
    isFinalVictory = false;
    blinkingIndex = null;
    blinkingAllIndices.clear();
    generateBoard();
    notifyListeners();
  }

  void _checkWin() {
    Set<BingoTypeWithIndex> currentBingos = {};
    Set<int> allBingoIndices = {};
    Map<BingoTypeWithIndex, List<int>> bingoTypeToIndices = {};

    // Zeilen prüfen
    for (int i = 0; i < config.gridSize; i++) {
      bool rowComplete = true;
      List<int> rowIndices = [];
      for (int j = 0; j < config.gridSize; j++) {
        final index = i * config.gridSize + j;
        rowIndices.add(index);
        if (!clickedIndices.contains(index)) {
          rowComplete = false;
          break;
        }
      }
      if (rowComplete) {
        final bingoType = BingoTypeWithIndex.row(i);
        currentBingos.add(bingoType);
        bingoTypeToIndices[bingoType] = rowIndices;
        allBingoIndices.addAll(rowIndices);
      }
    }

    // Spalten prüfen
    for (int i = 0; i < config.gridSize; i++) {
      bool colComplete = true;
      List<int> colIndices = [];
      for (int j = 0; j < config.gridSize; j++) {
        final index = j * config.gridSize + i;
        colIndices.add(index);
        if (!clickedIndices.contains(index)) {
          colComplete = false;
          break;
        }
      }
      if (colComplete) {
        final bingoType = BingoTypeWithIndex.column(i);
        currentBingos.add(bingoType);
        bingoTypeToIndices[bingoType] = colIndices;
        allBingoIndices.addAll(colIndices);
      }
    }

    // Diagonale 1 prüfen (\)
    bool diag1Complete = true;
    List<int> diag1Indices = [];
    for (int i = 0; i < config.gridSize; i++) {
      final index = i * config.gridSize + i;
      diag1Indices.add(index);
      if (!clickedIndices.contains(index)) {
        diag1Complete = false;
        break;
      }
    }
    if (diag1Complete) {
      final bingoType = BingoTypeWithIndex.diagonal1();
      currentBingos.add(bingoType);
      bingoTypeToIndices[bingoType] = diag1Indices;
      allBingoIndices.addAll(diag1Indices);
    }

    // Diagonale 2 prüfen (/)
    bool diag2Complete = true;
    List<int> diag2Indices = [];
    for (int i = 0; i < config.gridSize; i++) {
      final index = i * config.gridSize + (config.gridSize - 1 - i);
      diag2Indices.add(index);
      if (!clickedIndices.contains(index)) {
        diag2Complete = false;
        break;
      }
    }
    if (diag2Complete) {
      final bingoType = BingoTypeWithIndex.diagonal2();
      currentBingos.add(bingoType);
      bingoTypeToIndices[bingoType] = diag2Indices;
      allBingoIndices.addAll(diag2Indices);
    }

    // Update highlighted indices
    highlightedIndices = allBingoIndices;

    // Finde neue Bingos
    final newBingos = currentBingos.difference(_completedBingos);

    if (newBingos.isNotEmpty) {
      // Sammle alle Indices der neuen Bingos
      List<int> newBingoIndices = [];
      for (final bingoType in newBingos) {
        if (bingoTypeToIndices.containsKey(bingoType)) {
          newBingoIndices.addAll(bingoTypeToIndices[bingoType]!);
        }
      }

      // Update
      _completedBingos = currentBingos;
      bingoCount = currentBingos.length;

      // Starte Animation mit allen Indices der neuen Bingos
      if (newBingoIndices.isNotEmpty) {
        _startBlinkAnimation(newBingoIndices);
      }

      if (config.gameMode.value == 'jagd' && bingoCount >= config.targetBingos) {
        _showVictory(count: bingoCount, isFinal: true);
      } else {
        _showVictory(count: bingoCount, isFinal: false);
      }
    } else if (currentBingos.length < _completedBingos.length) {
      // Bingo wurde zurückgenommen
      _completedBingos = currentBingos;
      bingoCount = currentBingos.length;
      blinkingIndex = null;
      blinkingAllIndices.clear();
    }

    // Bei Suche-Modus: Prüfen ob gesamtes Feld voll ist
    if (config.gameMode.value == 'suche' && !showVictoryDialog) {
      final totalCells = config.gridSize * config.gridSize;
      if (clickedIndices.length == totalCells) {
        _audioPlayer.playVictorySound();
        isFinalVictory = true;
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 500), () {
          if (_isDisposed) return;
          showVictoryDialog = true;
          notifyListeners();
        });
      }
    }

    notifyListeners();
  }

  void _startBlinkAnimation(List<int> indices) {
    Future(() async {
      // Sequenziell durch alle Indices blinken (1, 2, 3, 4, 5)
      for (final index in indices) {
        if (_isDisposed) return;
        blinkingIndex = index;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 250)); // 0.25s pro Symbol
        if (_isDisposed) return;
        blinkingIndex = null;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 20)); // 0.02s Pause
      }

      if (_isDisposed) return;
      // Dann alle neuen Bingo-Indices zusammen blinken
      blinkingAllIndices = Set.from(indices);
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400)); // 0.4s alle zusammen
      if (_isDisposed) return;
      blinkingAllIndices.clear();
      notifyListeners();
    });
  }

  void _showVictory({required int count, required bool isFinal}) {
    if (isFinal) {
      _audioPlayer.playVictorySound();
      isFinalVictory = true;
      notifyListeners();

      // Victory Dialog nach kurzer Verzögerung
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isDisposed) return;
        showVictoryDialog = true;
        notifyListeners();
      });
    } else {
      _audioPlayer.playBingoSound(count: count);
      isFinalVictory = false;
      notifyListeners();

      // Zeige visuelle Notification für Bingo - immer nur "BINGO!"
      winMessage = 'BINGO!';
      showWinMessage = true;
      notifyListeners();

      Future.delayed(const Duration(seconds: 2), () {
        if (_isDisposed) return;
        showWinMessage = false;
        notifyListeners();
      });
    }
  }

  /// Stoppt alle Sounds sofort (für Zurück-Navigation)
  void stopAllSounds() {
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _audioPlayer.reset(); // Reset statt dispose - Singleton bleibt am Leben
    super.dispose();
  }
}
