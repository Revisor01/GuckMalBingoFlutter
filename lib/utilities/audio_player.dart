import 'package:audioplayers/audioplayers.dart';
import 'debug_utils.dart';

/// AudioPlayer - Singleton Pattern
/// Verwaltet alle Sound-Effekte der App mit einer einzigen Instanz
class GameAudioPlayer {
  // Singleton instance
  static GameAudioPlayer? _instance;
  static GameAudioPlayer get instance {
    _instance ??= GameAudioPlayer._internal();
    return _instance!;
  }

  // Factory constructor returns singleton
  factory GameAudioPlayer() => instance;

  // Private constructor
  GameAudioPlayer._internal() {
    _loadSoundFiles();
    _preloadSounds();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
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

  Future<void> _preloadSounds() async {
    // Preload erste 5 Sounds jeder Kategorie für schnelleres Abspielen
    final soundsToPreload = [
      ..._bingoSounds.take(5),
      ..._victorySounds.take(5),
      ..._clickSounds.take(5),
    ];

    for (final soundPath in soundsToPreload) {
      try {
        // Setze Source ohne zu spielen (Preload)
        await _audioPlayer.setSource(AssetSource(soundPath));
      } catch (e) {
        // Fehler ignorieren, Preload ist optional
      }
    }
  }

  /// Zufälliger Click-Sound (immer normale Clicks)
  Future<void> playClickSound() async {
    if (!soundEnabled) return;
    final randomSound = (_clickSounds..shuffle()).first;
    await _playSound(randomSound);
  }

  /// Zufälliger Bingo-Sound (normale + Weihnachts-Sounds in der Weihnachtszeit)
  Future<void> playBingoSound({required int count}) async {
    if (!soundEnabled) return;

    // In der Weihnachtszeit: Alle Sounds (normale + Weihnachts-Glocken)
    List<String> availableSounds = [..._bingoSounds];
    if (isChristmasSeason()) {
      availableSounds.addAll(_christmasBellSounds);
    }

    final randomSound = (availableSounds..shuffle()).first;
    await _playSound(randomSound);
  }

  /// Zufälliger Victory-Sound (Weihnachts-Sound in der Weihnachtszeit)
  Future<void> playVictorySound() async {
    if (!soundEnabled) return;

    // Weihnachts-Special: Weihnachts-Victory-Sound im Dezember/Anfang Januar
    if (isChristmasSeason()) {
      final randomXmas = (_christmasVictorySounds..shuffle()).first;
      final success = await _playSoundWithFallback(randomXmas);
      if (success) return;
    }

    // Standard Victory-Sound
    final randomSound = (_victorySounds..shuffle()).first;
    await _playSound(randomSound);
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _audioPlayer.stop(); // Stop previous sound
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // Fehler ignorieren für Release
    }
  }

  /// Spielt Sound ab und gibt true zurück bei Erfolg, false bei Fehler
  Future<bool> _playSoundWithFallback(String assetPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
      return true;
    } catch (e) {
      // Sound-Datei nicht gefunden - Fallback verwenden
      return false;
    }
  }

  /// Stoppt alle laufenden Sounds sofort
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      // Fehler ignorieren
    }
  }

  /// Stoppt Audio aber behält Singleton am Leben (für ViewModel dispose)
  void reset() {
    _audioPlayer.stop();
  }

  /// Komplett dispose - nur bei App-Ende aufrufen
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _instance = null;
  }
}
