import 'package:flutter/material.dart';
import '../models/game_config.dart';
import '../models/game_mode.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../utilities/app_localizations_extension.dart';
import 'settings_view.dart';
import 'theme_selection_view.dart';

/// GameModeSelectionView - Portiert von Swift
/// Erste Auswahl: Spielmodus (Suche oder Jagd)
class GameModeSelectionView extends StatefulWidget {
  final GameConfig config;
  final Function(GameMode) onModeSelected;

  const GameModeSelectionView({
    super.key,
    required this.config,
    required this.onModeSelected,
  });

  @override
  State<GameModeSelectionView> createState() => _GameModeSelectionViewState();
}

class _GameModeSelectionViewState extends State<GameModeSelectionView> {
  late BackgroundTheme _selectedTheme;
  bool _themeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await BackgroundTheme.loadSavedTheme();
    if (!mounted) return;
    setState(() {
      _selectedTheme = theme;
      _themeLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_themeLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final brightness = Theme.of(context).brightness;
    final isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedTheme.adaptiveGradient(brightness),
        ),
        child: Stack(
          children: [
            // Background Pattern
            const BackgroundPatternView(),

            // Content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          // Settings & Theme Buttons oben
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                // Settings Button
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => Padding(
                                            padding: const EdgeInsets.only(
                                              top: 60,
                                            ),
                                            child: const SettingsView(),
                                          ),
                                        );
                                      },
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha:0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.info,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Theme Button
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => Padding(
                                            padding: const EdgeInsets.only(
                                              top: 60,
                                            ),
                                            child: ThemeSelectionView(
                                              selectedTheme: _selectedTheme,
                                              onThemeSelected: (theme) {
                                                setState(() {
                                                  _selectedTheme = theme;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha:0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.palette,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Guck mal! Title
                          Padding(
                            padding: EdgeInsets.only(
                              top: isLandscape ? 10 : 20,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.appTitle,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Question - kleiner Abstand zum Titel
                          Padding(
                            padding: EdgeInsets.only(
                              top: isLandscape ? 10 : 20,
                              bottom: isLandscape ? 15 : 20,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.gamemodeSelectionQuestion,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha:0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Mode Buttons - kleiner Abstand zur Frage
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: GameMode.values
                                  .map((mode) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: GameModeButton(
                                          mode: mode,
                                          onTap: () =>
                                              widget.onModeSelected(mode),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),

                          // Flexibler Abstand - drückt Erklärungen nach unten
                          const Spacer(),

                          // Erklärungen ganz unten - fester Abstand von unten
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bingo Suche
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.gamemodeSucheName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.gamemodeSucheDescription,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha:0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bingo Jagd
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.gamemodeJagdName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.gamemodeJagdDescription,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha:0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Game Mode Button Widget
class GameModeButton extends StatelessWidget {
  final GameMode mode;
  final VoidCallback onTap;

  const GameModeButton({
    super.key,
    required this.mode,
    required this.onTap,
  });

  Color get iconColor {
    switch (mode) {
      case GameMode.suche:
        return AppColors.successGreen;
      case GameMode.jagd:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha:0.15)
                : Colors.white.withValues(alpha:0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(
                mode.icon,
                size: 36, // Größer: 28 -> 36
                color: iconColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)!.getByKey(mode.displayNameKey) ?? mode.displayNameKey,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.white.withValues(alpha:0.5),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}
