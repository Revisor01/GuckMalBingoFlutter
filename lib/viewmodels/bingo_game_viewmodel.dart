import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/game_config.dart';
import '../models/game_mode.dart';
import '../models/bingo_item.dart';
import '../data/bingo_items_data.dart';
import '../utilities/audio_player.dart';
import '../utilities/app_preferences.dart';

/// BingoType fuer Bingo-Erkennung
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

  /// Factory methods fuer einfache Erstellung
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
  List<BingoItem> _board = [];
  Set<int> _clickedIndices = {};
  int _bingoCount = 0;
  bool _showText = false;
  bool _soundEnabled = true;
  bool _showWinMessage = false;
  String _winMessage = '';
  bool _isFinalVictory = false;
  bool _showVictoryDialog = false;
  Set<int> _highlightedIndices = {};
  int? _blinkingIndex;
  Set<int> _blinkingAllIndices = {};

  late GameAudioPlayer _audioPlayer;
  Set<BingoTypeWithIndex> _completedBingos = {};
  bool _isDisposed = false;
  int _blinkGeneration = 0;
  Timer? _victoryDialogTimer;
  Timer? _winMessageTimer;
  final List<Timer> _blinkTimers = [];

  // Public getters
  List<BingoItem> get board => _board;
  Set<int> get clickedIndices => _clickedIndices;
  int get bingoCount => _bingoCount;
  bool get showText => _showText;
  bool get soundEnabled => _soundEnabled;
  bool get showWinMessage => _showWinMessage;
  String get winMessage => _winMessage;
  bool get isFinalVictory => _isFinalVictory;
  bool get showVictoryDialog => _showVictoryDialog;
  Set<int> get highlightedIndices => _highlightedIndices;
  int? get blinkingIndex => _blinkingIndex;
  Set<int> get blinkingAllIndices => _blinkingAllIndices;

  BingoGameViewModel({required this.config, GameAudioPlayer? audioPlayer}) {
    _audioPlayer = audioPlayer ?? GameAudioPlayer();
    _soundEnabled = _audioPlayer.soundEnabled;

    final totalCells = config.gridSize * config.gridSize;
    final sourceItems = BingoItemsData.itemsFor(
      area: config.area,
      season: config.season,
    );
    assert(
      sourceItems.length >= totalCells,
      'Zu wenige Items fuer ${config.area}/${config.season}: '
      '${sourceItems.length} verfuegbar, $totalCells benoetigt.',
    );
    final shuffled = List.of(sourceItems)..shuffle();
    _board = shuffled.take(totalCells).toList();
  }

  /// Erstellt ViewModel aus gespeichertem Spielstand
  BingoGameViewModel.fromSavedState(Map<String, dynamic> state,
      {GameAudioPlayer? audioPlayer})
      : config = GameConfig.fromJson(state['config'] as Map<String, dynamic>) {
    _audioPlayer = audioPlayer ?? GameAudioPlayer();
    _soundEnabled = _audioPlayer.soundEnabled;

    if (state.containsKey('boardIndices')) {
      // Neues Format: Index-basiert
      final indices = (state['boardIndices'] as List<dynamic>)
          .map((i) => i as int)
          .toList();
      _board = indices
          .where((i) => i >= 0 && i < BingoItemsData.allItems.length)
          .map((i) => BingoItemsData.allItems[i])
          .toList();
    } else {
      // Altes Format: Volle BingoItem-Objekte (Fallback/Migration)
      _board = (state['board'] as List<dynamic>)
          .map((item) => BingoItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    _clickedIndices = (state['clickedIndices'] as List<dynamic>)
        .map((i) => i as int)
        .toSet();
    _bingoCount = state['bingoCount'] as int? ?? 0;

    // Bingo-Zustand rekonstruieren
    _reconstructBingos();
  }

  void _reconstructBingos() {
    final result = _findAllBingos();
    _completedBingos = result.bingos;
    _bingoCount = _completedBingos.length;

    // Highlight setzen
    _highlightedIndices = result.allIndices;
  }

  /// Shared bingo detection: finds all completed rows, columns, diagonals.
  /// Returns the set of completed bingos and a map of bingo->indices.
  _BingoScanResult _findAllBingos() {
    Set<BingoTypeWithIndex> bingos = {};
    Set<int> allIndices = {};
    Map<BingoTypeWithIndex, List<int>> bingoToIndices = {};

    // Zeilen pruefen
    for (int i = 0; i < config.gridSize; i++) {
      bool complete = true;
      List<int> indices = [];
      for (int j = 0; j < config.gridSize; j++) {
        final idx = i * config.gridSize + j;
        indices.add(idx);
        if (!_clickedIndices.contains(idx)) {
          complete = false;
          break;
        }
      }
      if (complete) {
        final bt = BingoTypeWithIndex.row(i);
        bingos.add(bt);
        bingoToIndices[bt] = indices;
        allIndices.addAll(indices);
      }
    }

    // Spalten pruefen
    for (int i = 0; i < config.gridSize; i++) {
      bool complete = true;
      List<int> indices = [];
      for (int j = 0; j < config.gridSize; j++) {
        final idx = j * config.gridSize + i;
        indices.add(idx);
        if (!_clickedIndices.contains(idx)) {
          complete = false;
          break;
        }
      }
      if (complete) {
        final bt = BingoTypeWithIndex.column(i);
        bingos.add(bt);
        bingoToIndices[bt] = indices;
        allIndices.addAll(indices);
      }
    }

    // Diagonale 1 (\)
    {
      bool complete = true;
      List<int> indices = [];
      for (int i = 0; i < config.gridSize; i++) {
        final idx = i * config.gridSize + i;
        indices.add(idx);
        if (!_clickedIndices.contains(idx)) {
          complete = false;
          break;
        }
      }
      if (complete) {
        final bt = BingoTypeWithIndex.diagonal1();
        bingos.add(bt);
        bingoToIndices[bt] = indices;
        allIndices.addAll(indices);
      }
    }

    // Diagonale 2 (/)
    {
      bool complete = true;
      List<int> indices = [];
      for (int i = 0; i < config.gridSize; i++) {
        final idx = i * config.gridSize + (config.gridSize - 1 - i);
        indices.add(idx);
        if (!_clickedIndices.contains(idx)) {
          complete = false;
          break;
        }
      }
      if (complete) {
        final bt = BingoTypeWithIndex.diagonal2();
        bingos.add(bt);
        bingoToIndices[bt] = indices;
        allIndices.addAll(indices);
      }
    }

    return _BingoScanResult(
      bingos: bingos,
      allIndices: allIndices,
      bingoToIndices: bingoToIndices,
    );
  }

  /// Speichert aktuellen Spielstand
  void saveGameState() {
    AppPreferences.instance.saveGameState({
      'boardIndices': _board
          .map((item) => BingoItemsData.allItems.indexOf(item))
          .toList(),
      'clickedIndices': _clickedIndices.toList(),
      'bingoCount': _bingoCount,
      'config': config.toJson(),
    });
  }

  /// Loescht gespeicherten Spielstand
  void clearSavedGameState() {
    AppPreferences.instance.clearGameState();
  }

  void generateBoard() {
    final totalCells = config.gridSize * config.gridSize;
    final sourceItems = BingoItemsData.itemsFor(
      area: config.area,
      season: config.season,
    );
    assert(
      sourceItems.length >= totalCells,
      'Zu wenige Items fuer ${config.area}/${config.season}: '
      '${sourceItems.length} verfuegbar, $totalCells benoetigt.',
    );
    final shuffled = List.of(sourceItems)..shuffle();
    _board = shuffled.take(totalCells).toList();
    notifyListeners();
  }

  void toggleCell(int index) {
    if (_clickedIndices.contains(index)) {
      _clickedIndices.remove(index);
    } else {
      _clickedIndices.add(index);
    }
    _audioPlayer.playClickSound();
    notifyListeners();
    _checkWin();
  }

  void toggleText() {
    _showText = !_showText;
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _audioPlayer.soundEnabled = _soundEnabled;
    // Stoppe laufenden Sound sofort wenn gemutet
    if (!_soundEnabled) {
      _audioPlayer.stop();
    }
    notifyListeners();
  }

  /// Dismisses the victory dialog (called from View)
  void dismissVictoryDialog() {
    _showVictoryDialog = false;
    notifyListeners();
  }

  void resetGame() {
    _blinkGeneration++; // Cancel laufende Blink-Animation
    _victoryDialogTimer?.cancel();
    _winMessageTimer?.cancel();
    for (final t in _blinkTimers) { t.cancel(); }
    _blinkTimers.clear();
    _clickedIndices.clear();
    _bingoCount = 0;
    _completedBingos.clear();
    _showWinMessage = false;
    _showVictoryDialog = false;
    _isFinalVictory = false;
    _blinkingIndex = null;
    _blinkingAllIndices.clear();
    generateBoard();
    notifyListeners();
  }

  void _checkWin() {
    final result = _findAllBingos();
    final currentBingos = result.bingos;
    final bingoTypeToIndices = result.bingoToIndices;

    // Update highlighted indices
    _highlightedIndices = result.allIndices;

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
      _bingoCount = currentBingos.length;

      // Starte Animation mit allen Indices der neuen Bingos
      if (newBingoIndices.isNotEmpty) {
        _startBlinkAnimation(newBingoIndices);
      }

      if (config.gameMode == GameMode.jagd && _bingoCount >= config.targetBingos) {
        _showVictory(count: _bingoCount, isFinal: true);
      } else {
        _showVictory(count: _bingoCount, isFinal: false);
      }
    } else if (currentBingos.length < _completedBingos.length) {
      // Bingo wurde zurueckgenommen
      _completedBingos = currentBingos;
      _bingoCount = currentBingos.length;
      _blinkingIndex = null;
      _blinkingAllIndices.clear();
    }

    // Bei Suche-Modus: Prüfen ob gesamtes Feld voll ist
    if (config.gameMode == GameMode.suche && !_showVictoryDialog) {
      final totalCells = config.gridSize * config.gridSize;
      if (_clickedIndices.length == totalCells) {
        _audioPlayer.playVictorySound();
        _isFinalVictory = true;
        clearSavedGameState();

        _victoryDialogTimer?.cancel();
        _victoryDialogTimer = Timer(const Duration(milliseconds: 500), () {
          if (_isDisposed) return;
          _showVictoryDialog = true;
          notifyListeners();
        });
      }
    }

    notifyListeners();
  }

  void _startBlinkAnimation(List<int> indices) {
    _blinkGeneration++;
    final myGeneration = _blinkGeneration;
    _blinkingIndex = null;
    _blinkingAllIndices = {};

    // Alle laufenden Blink-Timer canceln
    for (final t in _blinkTimers) { t.cancel(); }
    _blinkTimers.clear();

    int elapsed = 0;
    for (final index in indices) {
      // An-Phase
      _blinkTimers.add(Timer(Duration(milliseconds: elapsed), () {
        if (_isDisposed || _blinkGeneration != myGeneration) return;
        _blinkingIndex = index;
        notifyListeners();
      }));
      elapsed += 250;
      // Aus-Phase
      _blinkTimers.add(Timer(Duration(milliseconds: elapsed), () {
        if (_isDisposed || _blinkGeneration != myGeneration) return;
        _blinkingIndex = null;
        notifyListeners();
      }));
      elapsed += 20;
    }
    // Alle zusammen blinken
    _blinkTimers.add(Timer(Duration(milliseconds: elapsed), () {
      if (_isDisposed || _blinkGeneration != myGeneration) return;
      _blinkingAllIndices = Set.from(indices);
      notifyListeners();
    }));
    elapsed += 400;
    // Aus
    _blinkTimers.add(Timer(Duration(milliseconds: elapsed), () {
      if (_isDisposed || _blinkGeneration != myGeneration) return;
      _blinkingAllIndices.clear();
      notifyListeners();
    }));
  }

  void _showVictory({required int count, required bool isFinal}) {
    if (isFinal) {
      _audioPlayer.playVictorySound();
      _isFinalVictory = true;
      notifyListeners();

      // Victory Dialog nach kurzer Verzoegerung
      _victoryDialogTimer?.cancel();
      _victoryDialogTimer = Timer(const Duration(milliseconds: 500), () {
        if (_isDisposed) return;
        _showVictoryDialog = true;
        notifyListeners();
      });
    } else {
      _audioPlayer.playBingoSound(count: count);
      _isFinalVictory = false;
      // Zeige visuelle Notification fuer Bingo - immer nur "BINGO!"
      _winMessage = 'BINGO!';
      _showWinMessage = true;
      notifyListeners();

      _winMessageTimer?.cancel();
      _winMessageTimer = Timer(const Duration(seconds: 2), () {
        if (_isDisposed) return;
        _showWinMessage = false;
        notifyListeners();
      });
    }
  }

  /// Stoppt alle Sounds sofort (fuer Zurueck-Navigation)
  void stopAllSounds() {
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _victoryDialogTimer?.cancel();
    _winMessageTimer?.cancel();
    for (final t in _blinkTimers) { t.cancel(); }
    _blinkTimers.clear();
    _audioPlayer.reset(); // Reset statt dispose - Singleton bleibt am Leben
    super.dispose();
  }
}

/// Result of scanning for all completed bingos
class _BingoScanResult {
  final Set<BingoTypeWithIndex> bingos;
  final Set<int> allIndices;
  final Map<BingoTypeWithIndex, List<int>> bingoToIndices;

  const _BingoScanResult({
    required this.bingos,
    required this.allIndices,
    required this.bingoToIndices,
  });
}
