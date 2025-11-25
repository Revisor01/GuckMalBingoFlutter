import 'package:flutter/material.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.selectedTheme;
  }

  void _selectTheme(BackgroundTheme theme) {
    setState(() {
      _currentTheme = theme;
    });
    theme.save();
    widget.onThemeSelected(theme);
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
                                color: Colors.white.withOpacity(0.2),
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

                    const SizedBox(height: 60),

                    // Theme Buttons (Christmas nur in Weihnachtszeit)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: BackgroundTheme.values
                            .where((theme) => theme != BackgroundTheme.christmas || isChristmasSeason())
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

                    const SizedBox(height: 60),
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
                ? Colors.white.withOpacity(0.15)
                : Colors.white.withOpacity(0.25),
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
                    color: Colors.white.withOpacity(0.5),
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
                    : Colors.white.withOpacity(0.3),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}
