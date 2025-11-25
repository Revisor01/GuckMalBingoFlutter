import 'package:audioplayers/audioplayers.dart';
import 'debug_utils.dart';

/// AudioPlayer - Portiert von Swift
/// Verwaltet alle Sound-Effekte der App
class GameAudioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<String> _bingoSounds;
  late List<String> _victorySounds;
  late List<String> _clickSounds;
  late List<String> _christmasBellSounds;
  late List<String> _christmasVictorySounds;
  bool soundEnabled = true;

  GameAudioPlayer() {
    _loadSoundFiles();
    _preloadSounds();
  }

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

    // Weihnachts-Sounds (bells_01 bis bells_03) - TODO: Sound-Dateien hinzufügen
    _christmasBellSounds = List.generate(
      3,
      (i) => 'sounds/bells_${(i + 1).toString().padLeft(2, '0')}.mp3',
    );

    // Weihnachts-Victory-Sounds (christmas_victory_01 bis _03)
    _christmasVictorySounds = List.generate(
      3,
      (i) => 'sounds/christmas_victory_${(i + 1).toString().padLeft(2, '0')}.mp3',
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

  /// Zufälliger Click-Sound (Glocken in der Weihnachtszeit)
  Future<void> playClickSound() async {
    if (!soundEnabled) return;

    // Weihnachts-Special: Glocken-Sound im Dezember/Anfang Januar
    if (isChristmasSeason()) {
      final randomBell = (_christmasBellSounds..shuffle()).first;
      final success = await _playSoundWithFallback(randomBell);
      if (success) return;
    }

    // Standard Click-Sound
    final randomSound = (_clickSounds..shuffle()).first;
    await _playSound(randomSound);
  }

  /// Zufälliger Bingo-Sound (nur bei Bingo!)
  Future<void> playBingoSound({required int count}) async {
    if (!soundEnabled) return;
    final randomSound = (_bingoSounds..shuffle()).first;
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

  void dispose() {
    _audioPlayer.dispose();
  }
}
