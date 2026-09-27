import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../utilities/theme_provider.dart';
import '../utilities/season_service.dart';
import '../l10n/app_localizations.dart';
import '../utilities/app_localizations_extension.dart';
import 'widgets/app_button.dart';

/// ThemeSelectionView - Portiert von Swift
class ThemeSelectionView extends StatefulWidget {
  final BackgroundTheme selectedTheme;
  final Function(BackgroundTheme) onThemeSelected;

  const ThemeSelectionView({
    super.key,
    required this.selectedTheme,
    required this.onThemeSelected,
  });

  @override
  State<ThemeSelectionView> createState() => _ThemeSelectionViewState();
}

class _ThemeSelectionViewState extends State<ThemeSelectionView> {
  late BackgroundTheme _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.selectedTheme;
  }

  void _selectTheme(BackgroundTheme theme) {
    setState(() {
      _currentTheme = theme;
    });
    context.read<ThemeNotifier>().setTheme(theme);
    widget.onThemeSelected(theme);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final season = context.watch<SeasonService>();

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: _currentTheme.adaptiveGradient(brightness),
          ),
          child: Stack(
          children: [
            BackgroundPatternView(theme: _currentTheme),
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header mit Close Button
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha:0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                      child: Text(
                        AppLocalizations.of(context)!.themeSelectionTitle,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Schneefall-Toggle (nur in der Weihnachtszeit) - OBEN
                    if (season.isChristmas) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                            color: brightness == Brightness.dark
                                ? Colors.white.withValues(alpha:0.15)
                                : Colors.white.withValues(alpha:0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.ac_unit,
                                size: 28,
                                color: Colors.lightBlue,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.settingsSnowfall,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Switch(
                                value: season.snowfallEnabled,
                                onChanged: (enabled) => season.setSnowfallEnabled(enabled),
                                activeTrackColor: Colors.lightBlue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Oster-Effekt-Toggle (nur in der Osterzeit)
                    if (season.isEaster) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                            color: brightness == Brightness.dark
                                ? Colors.white.withValues(alpha:0.15)
                                : Colors.white.withValues(alpha:0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_florist,
                                size: 28,
                                color: Color(0xFFFFB7C5),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.settingsEasterEffect,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Switch(
                                value: season.easterEffectEnabled,
                                onChanged: (enabled) => season.setEasterEffectEnabled(enabled),
                                activeTrackColor: const Color(0xFFFFB7C5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Herbst-Effekt-Toggle (nur in der Herbstzeit)
                    if (season.isAutumn) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                            color: brightness == Brightness.dark
                                ? Colors.white.withValues(alpha:0.15)
                                : Colors.white.withValues(alpha:0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.eco,
                                size: 28,
                                color: Color(0xFFFF8C00),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.settingsAutumnEffect,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Switch(
                                value: season.autumnEffectEnabled,
                                onChanged: (enabled) => season.setAutumnEffectEnabled(enabled),
                                activeTrackColor: const Color(0xFFFF8C00),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Theme Buttons (Saisonale Themes nur in jeweiliger Saison)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: BackgroundTheme.values
                            .where((theme) => theme.isSelectable(
                                  isChristmas: season.isChristmas,
                                  isEaster: season.isEaster,
                                  isAutumn: season.isAutumn,
                                  isHalloween: season.isHalloween,
                                ))
                            .map((theme) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: AppButton(
                                    leadingWidget: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: theme.gradient,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.5),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    title: AppLocalizations.of(context)!.getByKey(theme.displayNameKey) ?? theme.displayNameKey,
                                    trailing: Icon(
                                      _currentTheme == theme ? Icons.check_circle : Icons.circle_outlined,
                                      size: 24,
                                      color: _currentTheme == theme
                                          ? AppColors.successGreen
                                          : Colors.white.withValues(alpha: 0.3),
                                    ),
                                    border: _currentTheme == theme
                                        ? Border.all(
                                            color: AppColors.successGreen,
                                            width: 3,
                                          )
                                        : null,
                                    onTap: () => _selectTheme(theme),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
