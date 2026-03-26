import 'package:flutter/foundation.dart';
import '../models/background_theme.dart';

/// Zentraler Theme-Notifier fuer die gesamte App.
/// Wird einmalig beim App-Start geladen und per ChangeNotifierProvider
/// an den Widget-Tree weitergegeben.
class ThemeNotifier extends ChangeNotifier {
  BackgroundTheme _theme = BackgroundTheme.lightBlue;

  /// Aktuelles Theme
  BackgroundTheme get theme => _theme;

  /// Laedt das gespeicherte Theme aus SharedPreferences (einmalig beim Start)
  Future<void> loadTheme() async {
    _theme = await BackgroundTheme.loadSavedTheme();
    notifyListeners();
  }

  /// Setzt ein neues Theme, benachrichtigt Listener und speichert es
  Future<void> setTheme(BackgroundTheme newTheme) async {
    _theme = newTheme;
    notifyListeners();
    await newTheme.save();
  }
}
