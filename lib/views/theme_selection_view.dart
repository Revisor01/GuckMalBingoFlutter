import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../utilities/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../utilities/app_localizations_extension.dart';
import '../utilities/debug_utils.dart';

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
  bool _snowfallEnabled = true;
  bool _easterEffectEnabled = true;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.selectedTheme;
    _snowfallEnabled = snowfallEnabledNotifier.value;
    _easterEffectEnabled = easterEffectEnabledNotifier.value;
  }

  void _selectTheme(BackgroundTheme theme) {
    setState(() {
      _currentTheme = theme;
    });
    context.read<ThemeNotifier>().setTheme(theme);
    widget.onThemeSelected(theme);
  }

  void _toggleSnowfall(bool enabled) {
    setState(() {
      _snowfallEnabled = enabled;
    });
    setSnowfallEnabled(enabled);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

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
            const BackgroundPatternView(),
            SafeArea(
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
                    if (isChristmasSeason()) ...[
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
                                value: _snowfallEnabled,
                                onChanged: _toggleSnowfall,
                                activeTrackColor: Colors.lightBlue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Oster-Effekt-Toggle (nur in der Osterzeit)
                    if (isEasterSeason()) ...[
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
                              const Expanded(
                                child: Text(
                                  'Oster-Effekt',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Switch(
                                value: _easterEffectEnabled,
                                onChanged: (enabled) {
                                  setState(() {
                                    _easterEffectEnabled = enabled;
                                  });
                                  setEasterEffectEnabled(enabled);
                                },
                                activeTrackColor: const Color(0xFFFFB7C5),
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
                            .where((theme) => (theme != BackgroundTheme.christmas || isChristmasSeason()) && (theme != BackgroundTheme.easter || isEasterSeason()))
                            .map((theme) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ThemeButton(
                                    theme: theme,
                                    isSelected: _currentTheme == theme,
                                    onTap: () => _selectTheme(theme),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    // Extra Padding für iPhone Home Indicator
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
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

/// Theme Button
class ThemeButton extends StatelessWidget {
  final BackgroundTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeButton({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

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
            border: isSelected
                ? Border.all(
                    color: AppColors.successGreen,
                    width: 3,
                  )
                : null,
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              // Color Preview
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: theme.gradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.5),
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)!.getByKey(theme.displayNameKey) ?? theme.displayNameKey,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 24,
                color: isSelected
                    ? AppColors.successGreen
                    : Colors.white.withValues(alpha:0.3),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}
