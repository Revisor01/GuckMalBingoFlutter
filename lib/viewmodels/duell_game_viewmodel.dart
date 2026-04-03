import 'package:flutter/foundation.dart';
import '../models/game_config.dart';
import '../models/bingo_item.dart';
import '../data/bingo_items_data.dart';
import '../utilities/audio_player.dart';
import '../utilities/app_preferences.dart';

/// DuellGameViewModel — Verwaltet den Spielzustand des Duell-Modus.
///
/// Haelt eine gemischte Item-Queue, trackt den Score und triggert
/// den Victory-Dialog bei Erreichen des Ziels.
class DuellGameViewModel extends ChangeNotifier {
  final GameConfig config;
  late List<BingoItem> _queue;
  int _queueIndex = 0;
  int _score = 0;
  int _skipCount = 0;
  bool _showVictoryDialog = false;

  late final GameAudioPlayer _audioPlayer;

  /// Das aktuell angezeigte Item
  BingoItem get currentItem => _queue[_queueIndex];

  /// Aktueller Score (Anzahl gefundener Items)
  int get score => _score;

  /// Ziel-Score (aus GameConfig.targetBingos)
  int get targetScore => config.targetBingos;

  /// Ob der Victory-Dialog angezeigt werden soll
  bool get showVictoryDialog => _showVictoryDialog;

  /// Anzahl der uebersprungenen Items
  int get skipCount => _skipCount;

  /// Aktueller Queue-Index (fuer AnimatedSwitcher-Key)
  int get queueIndex => _queueIndex;

  DuellGameViewModel({required this.config}) {
    _audioPlayer = GameAudioPlayer();
    _buildQueue();
  }

  /// Baut die Item-Queue aus itemsFor() und mischt sie
  void _buildQueue() {
    final sourceItems = BingoItemsData.itemsFor(
      area: config.area,
      season: config.season,
    );
    _queue = List.of(sourceItems)..shuffle();
    // Sicherstellen dass Queue nie leer ist
    if (_queue.isEmpty) {
      // Fallback: fruehling_sommer als Standardsaison
      _queue = List.of(BingoItemsData.itemsFor(
        area: config.area,
        season: config.season,
      ))..shuffle();
    }
  }

  /// Item als gefunden markieren — Score erhoehen, naechstes Item anzeigen
  void markFound() {
    _score++;
    _audioPlayer.stop();
    _audioPlayer.playClickSound();
    if (_score >= config.targetBingos) {
      _triggerVictory();
      return;
    }
    _advanceQueue();
    notifyListeners();
  }

  /// Aktuelles Item ueberspringen — kein Score, naechstes Item anzeigen
  void skip() {
    _skipCount++;
    _advanceQueue();
    notifyListeners();
  }

  /// Queue um eins weiterschalten — D-10: Zyklischer Neustart wenn alle Items abgearbeitet
  void _advanceQueue() {
    _queueIndex++;
    if (_queueIndex >= _queue.length) {
      _queue.shuffle();
      _queueIndex = 0;
    }
  }

  /// Victory ausloesen — Dialog anzeigen und Sound spielen
  void _triggerVictory() {
    _showVictoryDialog = true;
    notifyListeners();
    // Kurze Verzoegerung damit click-Sound abklingt, dann Victory-Sound
    Future.delayed(const Duration(milliseconds: 300), () {
      _audioPlayer.stop();
      _audioPlayer.playVictorySound();
    });
  }

  /// Victory-Dialog verbergen (ohne Spiel zu beenden)
  void dismissVictoryDialog() {
    _showVictoryDialog = false;
    notifyListeners();
  }

  /// Spiel zuruecksetzen — Score 0, neue Queue, kein Victory-Dialog
  void resetGame() {
    _score = 0;
    _skipCount = 0;
    _queueIndex = 0;
    _showVictoryDialog = false;
    _buildQueue();
    notifyListeners();
  }

  // --- Persistence ---

  /// Speichert den aktuellen Spielstand in SharedPreferences
  void saveGameState() {
    final queueItemNames = _queue.map((item) => item.name).toList();
    AppPreferences.instance.saveDuellState({
      'queueItemNames': queueItemNames,
      'queueIndex': _queueIndex,
      'score': _score,
      'skipCount': _skipCount,
      'config': config.toJson(),
    });
  }

  /// Loescht den gespeicherten Spielstand
  void clearSavedGameState() {
    AppPreferences.instance.clearDuellState();
  }

  /// Stellt ViewModel aus gespeichertem Zustand wieder her
  factory DuellGameViewModel.fromSavedState(Map<String, dynamic> state) {
    final config = GameConfig.fromJson(state['config'] as Map<String, dynamic>);
    final vm = DuellGameViewModel(config: config);
    vm._score = state['score'] as int? ?? 0;
    vm._skipCount = state['skipCount'] as int? ?? 0;
    vm._queueIndex = state['queueIndex'] as int? ?? 0;

    // Queue aus gespeicherten Keys wiederherstellen
    final savedNames = (state['queueItemNames'] as List?)?.cast<String>();
    if (savedNames != null && savedNames.isNotEmpty) {
      final allItems = BingoItemsData.itemsFor(
        area: config.area,
        season: config.season,
      );
      final itemMap = {for (final item in allItems) item.name: item};
      final restored =
          savedNames.map((key) => itemMap[key]).whereType<BingoItem>().toList();
      if (restored.isNotEmpty) {
        vm._queue = restored;
      }
    }

    // QueueIndex in gueltigen Bereich bringen
    if (vm._queueIndex >= vm._queue.length) {
      vm._queueIndex = 0;
    }
    return vm;
  }

  @override
  void dispose() {
    _audioPlayer.reset(); // Singleton — reset() nicht dispose()!
    super.dispose();
  }
}
