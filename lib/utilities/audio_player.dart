import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'debug_utils.dart';

final _random = Random();

/// Einzige Instanz für alle Soundeffekte.
class GameAudioPlayer {
  static GameAudioPlayer? _instance;
  static GameAudioPlayer get instance {
    _instance ??= GameAudioPlayer._internal();
    return _instance!;
  }

  factory GameAudioPlayer() => instance;

  GameAudioPlayer._internal() {
    _loadSoundFiles();
  }

  /// Setzt Singleton zurueck — nur fuer Tests
  static void resetForTesting() {
    _instance?.dispose();
    _instance = null;
  }

  static const int _poolSize = 3;
  final List<AudioPlayer> _pool = List.generate(_poolSize, (_) => AudioPlayer());
  int _poolIndex = 0;

  /// Eigener Player für Bingo/Victory, damit ein Folgesound den vorigen sofort abbricht.
  final AudioPlayer _bingoVictoryPlayer = AudioPlayer();

  late List<String> _bingoSounds;
  late List<String> _victorySounds;
  late List<String> _clickSounds;
  late List<String> _christmasBellSounds;
  late List<String> _christmasVictorySounds;
  bool soundEnabled = true;

  void _loadSoundFiles() {
    // Sammle alle Bingo-Sounds (bingo_01 bis bingo_25)
    _bingoSounds = List.generate(
      25,
      (i) => 'sounds/bingo_${(i + 1).toString().padLeft(2, '0')}.mp3',
    );

    // Sammle alle Victory-Sounds (victory_01 bis victory_16)
    _victorySounds = List.generate(
      16,
      (i) => 'sounds/victory_${(i + 1).toString().padLeft(2, '0')}.mp3',
    );

    // Sammle alle Click-Sounds (click_01 bis click_03)
    _clickSounds = List.generate(
      3,
      (i) => 'sounds/click_${(i + 1).toString().padLeft(2, '0')}.mp3',
    );

    // Weihnachts-Bingo-Sounds (bingo_xmas1 bis bingo_xmas6)
    _christmasBellSounds = List.generate(
      6,
      (i) => 'sounds/bingo_xmas${i + 1}.mp3',
    );

    // Weihnachts-Victory-Sounds (victory_xmas1 bis victory_xmas3)
    _christmasVictorySounds = List.generate(
      3,
      (i) => 'sounds/victory_xmas${i + 1}.mp3',
    );
  }

  /// Zufälliger Click-Sound (immer normale Clicks)
  Future<void> playClickSound() async {
    if (!soundEnabled) return;
    final randomSound = _clickSounds[_random.nextInt(_clickSounds.length)];
    await _playSound(randomSound);
  }

  /// Spielt einen zufälligen Bingo-Sound, in der Weihnachtszeit auch Weihnachts-Sounds.
  Future<void> playBingoSound({required int count}) async {
    if (!soundEnabled) return;

    // In der Weihnachtszeit: Alle Sounds (normale + Weihnachts-Glocken)
    List<String> availableSounds = [..._bingoSounds];
    if (isChristmasSeason()) {
      availableSounds.addAll(_christmasBellSounds);
    }

    final randomSound = availableSounds[_random.nextInt(availableSounds.length)];
    await _playBingoVictorySound(randomSound);
  }

  /// Spielt einen zufälligen Victory-Sound, in der Weihnachtszeit den Weihnachts-Sound.
  Future<void> playVictorySound() async {
    if (!soundEnabled) return;

    // Weihnachts-Special: Weihnachts-Victory-Sound im Dezember/Anfang Januar
    if (isChristmasSeason()) {
      final randomXmas = _christmasVictorySounds[_random.nextInt(_christmasVictorySounds.length)];
      // Direkt ueber _bingoVictoryPlayer mit Fallback auf Standard-Sound
      try {
        await _bingoVictoryPlayer.stop();
        await _bingoVictoryPlayer.play(AssetSource(randomXmas));
        return;
      } catch (_) {
        // Fallback auf Standard-Victory-Sound
      }
    }

    // Standard Victory-Sound
    final randomSound = _victorySounds[_random.nextInt(_victorySounds.length)];
    await _playBingoVictorySound(randomSound);
  }

  /// Stoppt vor dem Abspielen den vorigen Bingo/Victory-Sound; Klicks bleiben im Pool.
  Future<void> _playBingoVictorySound(String assetPath) async {
    try {
      await _bingoVictoryPlayer.stop();
      await _bingoVictoryPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  Future<void> _playSound(String assetPath) async {
    try {
      final player = _pool[_poolIndex];
      _poolIndex = (_poolIndex + 1) % _poolSize;
      await player.play(AssetSource(assetPath));
    } catch (e) {
      // Fehler ignorieren fuer Release
    }
  }

  /// Stoppt alle laufenden Sounds sofort (Pool + dedizierter Bingo/Victory-Slot)
  Future<void> stop() async {
    for (final player in _pool) {
      try { await player.stop(); } catch (_) {}
    }
    try { await _bingoVictoryPlayer.stop(); } catch (_) {}
  }

  /// Stoppt Audio aber behält Singleton am Leben (für ViewModel dispose)
  void reset() {
    for (final player in _pool) {
      player.stop();
    }
    _bingoVictoryPlayer.stop();
  }

  /// Komplett dispose - nur bei App-Ende aufrufen
  void dispose() {
    for (final player in _pool) {
      player.stop();
      player.dispose();
    }
    _bingoVictoryPlayer.stop();
    _bingoVictoryPlayer.dispose();
    _instance = null;
  }
}
