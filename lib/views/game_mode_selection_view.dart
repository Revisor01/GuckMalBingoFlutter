import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_config.dart';
import '../models/game_mode.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../utilities/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../utilities/app_localizations_extension.dart';
import 'settings_view.dart';
import 'theme_selection_view.dart';
import 'widgets/app_button.dart';
import 'widgets/description_item.dart';

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
  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final selectedTheme = themeNotifier.theme;
    final brightness = Theme.of(context).brightness;
    final isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: selectedTheme.adaptiveGradient(brightness),
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
                                  child: Semantics(
                                    button: true,
                                    label: AppLocalizations.of(context)!.accessibilitySettingsButton,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => const Padding(
                                              padding: EdgeInsets.only(
                                                top: 60,
                                              ),
                                              child: SettingsView(),
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
                                ),

                                const Spacer(),

                                // Theme Button
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Semantics(
                                    button: true,
                                    label: AppLocalizations.of(context)!.accessibilityThemeButton,
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
                                                selectedTheme: selectedTheme,
                                                onThemeSelected: (theme) {
                                                  context.read<ThemeNotifier>().setTheme(theme);
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
                                        child: AppButton(
                                          icon: mode.icon,
                                          iconColor: mode == GameMode.suche
                                              ? AppColors.successGreen
                                              : mode == GameMode.sprint
                                                  ? AppColors.primary
                                                  : Colors.red,
                                          title: AppLocalizations.of(context)!.getByKey(mode.displayNameKey) ?? mode.displayNameKey,
                                          trailing: AppButton.trailingChevron(),
                                          onTap: () =>
                                              widget.onModeSelected(mode),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),

                          // Kleiner Abstand zu den Erklärungen
                          const SizedBox(height: 16),

                          // Erklärungen ganz unten
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DescriptionItem(
                                  title: AppLocalizations.of(context)!.gamemodeSucheName,
                                  description: AppLocalizations.of(context)!.gamemodeSucheDescription,
                                ),
                                DescriptionItem(
                                  title: AppLocalizations.of(context)!.gamemodeJagdName,
                                  description: AppLocalizations.of(context)!.gamemodeJagdDescription,
                                ),
                                DescriptionItem(
                                  title: AppLocalizations.of(context)!.gamemodeSprintName,
                                  description: AppLocalizations.of(context)!.gamemodeSprintDescription,
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

