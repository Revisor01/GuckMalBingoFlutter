import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guck_mal_bingo/utilities/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Bestand, wie ihn die Store-Fassung 2.1.0 im sicheren Speicher hinterlässt:
// Ein Update darf Spielstand und Einstellungen nicht verlieren.
void main() {
  test('Spielstand und Einstellungen aus dem Bestand bleiben nach dem Start erhalten', () async {
    FlutterSecureStorage.setMockInitialValues({
      '_migrated_to_secure': 'true',
      'sprint_migration_done': 'true',
      'savedGameState': '{"felder":[1,2,3],"runde":4}',
      'hasSeenOnboarding': 'true',
      'snowfallEnabled': 'false',
      'backgroundTheme': 'ocean',
    });
    // Alte SharedPreferences dürfen den Bestand nicht überschreiben.
    SharedPreferences.setMockInitialValues({'savedGameState': '{"alt":true}'});

    await AppPreferences.init();
    final prefs = AppPreferences.instance;

    expect(prefs.hasSavedGameState, isTrue);
    expect(prefs.loadGameState(), {
      'felder': [1, 2, 3],
      'runde': 4,
    });
    expect(prefs.hasSeenOnboarding, isTrue);
    expect(prefs.snowfallEnabled, isFalse);
    expect(prefs.backgroundThemeRaw, 'ocean');
  });
}
