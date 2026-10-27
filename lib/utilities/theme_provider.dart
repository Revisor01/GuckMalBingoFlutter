import 'package:flutter/foundation.dart';
import '../models/background_theme.dart';

/// App-weiter Theme-Zustand, einmal beim Start geladen.
class ThemeNotifier extends ChangeNotifier {
  BackgroundTheme _theme = BackgroundTheme.lightBlue;

  /// Aktuelles Theme
  BackgroundTheme get theme => _theme;

  /// Laedt das gespeicherte Theme aus AppPreferences (einmalig beim Start)
  void loadTheme() {
    _theme = BackgroundTheme.loadSavedTheme();
    notifyListeners();
  }

  /// Setzt ein neues Theme, benachrichtigt Listener und speichert es
  Future<void> setTheme(BackgroundTheme newTheme) async {
    _theme = newTheme;
    notifyListeners();
    await newTheme.save();
  }
}
