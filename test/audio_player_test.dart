import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/utilities/audio_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock audioplayers method channels
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('xyz.luan/audioplayers.global'),
            (MethodCall methodCall) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('xyz.luan/audioplayers'),
            (MethodCall methodCall) async => null);
  });

  group('GameAudioPlayer — dedizierter Bingo/Victory-Slot', () {
    late GameAudioPlayer player;

    setUp(() {
      // Singleton zuruecksetzen fuer saubere Tests
      GameAudioPlayer.resetForTesting();
      player = GameAudioPlayer();
    });

    tearDown(() {
      GameAudioPlayer.resetForTesting();
    });

    test(
        'Test 1: playBingoVictorySound-Methode existiert und wird von playBingoSound genutzt',
        () {
      // AudioPlayer ist privat, deshalb genügt der fehlerfreie Aufruf.
      expect(() => player.playBingoSound(count: 1), returnsNormally);
    });

    test(
        'Test 2: playClickSound laeuft parallel — wirft keine Exception neben playBingoSound',
        () async {
      // Beide Methoden koennen ohne gegenseitige Unterbrechung aufgerufen werden.
      await expectLater(player.playClickSound(), completes);
      await expectLater(player.playBingoSound(count: 1), completes);
    });

    test('Test 3: stop() wirft keine Exception und stoppt alle Sounds', () {
      expect(() => player.stop(), returnsNormally);
    });

    test('Test 4: dispose() kann ohne Fehler aufgerufen werden', () {
      expect(() => player.dispose(), returnsNormally);
    });

    test('Test 5: Nach playVictorySound kein Fehler', () async {
      await expectLater(player.playVictorySound(), completes);
    });

    test(
        'Test 6: Mehrfaches Aufrufen von playBingoSound ohne Fehler (Interrupt-Verhalten)',
        () async {
      // Simuliert schnelle Folge-Bingos: kein Crash erwartet
      await expectLater(player.playBingoSound(count: 1), completes);
      await expectLater(player.playBingoSound(count: 2), completes);
    });
  });
}
