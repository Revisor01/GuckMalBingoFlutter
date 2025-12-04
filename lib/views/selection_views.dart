import 'package:flutter/material.dart';
import '../models/game_config.dart';
import '../models/category_theme.dart';
import '../models/season.dart';
import '../models/area.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../utilities/app_localizations_extension.dart';

/// Basis für alle Auswahl-Views
class _BaseSelectionView extends StatefulWidget {
  final String title;
  final String question;
  final Widget content;

  const _BaseSelectionView({
    required this.title,
    required this.question,
    required this.content,
  });

  @override
  State<_BaseSelectionView> createState() => _BaseSelectionViewState();
}

class _BaseSelectionViewState extends State<_BaseSelectionView> {
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
    final isLandscape = MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedTheme.adaptiveGradient(brightness),
        ),
        child: Stack(
          children: [
            const BackgroundPatternView(),
            SafeArea(
              child: Column(
                children: [
                  // Back Button
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
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Title
                          Padding(
                            padding: EdgeInsets.only(
                              top: isLandscape ? 10 : 20,
                            ),
                            child: Text(
                              widget.title,
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
                              widget.question,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha:0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Content - kleiner Abstand zur Frage
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: widget.content,
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category Theme Selection
class ThemeCategorySelectionView extends StatefulWidget {
  final GameConfig config;
  final Function(CategoryTheme) onThemeSelected;

  const ThemeCategorySelectionView({
    super.key,
    required this.config,
    required this.onThemeSelected,
  });

  @override
  State<ThemeCategorySelectionView> createState() => _ThemeCategorySelectionViewState();
}

class _ThemeCategorySelectionViewState extends State<ThemeCategorySelectionView> {
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
    final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedTheme.adaptiveGradient(brightness),
        ),
        child: Stack(
          children: [
            const BackgroundPatternView(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          // Back Button
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
                                      Icons.chevron_left,
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
                              AppLocalizations.of(context)!.categorySelectionQuestion,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha:0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Category Buttons - kleiner Abstand zur Frage
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: CategoryTheme.values
                                  .map((theme) => Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: _SelectionButton(
                                          title: theme.displayNameKey,
                                          icon: theme.icon,
                                          iconColor: theme == CategoryTheme.reise
                                              ? Colors.blue
                                              : Colors.red.shade700,
                                          onTap: () => widget.onThemeSelected(theme),
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
                              children: CategoryTheme.values.map((theme) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Builder(
                                        builder: (context) => Text(
                                          AppLocalizations.of(context)!.getByKey(theme.displayNameKey) ?? theme.displayNameKey,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Builder(
                                        builder: (context) => Text(
                                          AppLocalizations.of(context)!.getByKey(theme.descriptionKey) ?? theme.descriptionKey,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withValues(alpha:0.8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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

/// Season Selection
class SeasonSelectionView extends StatefulWidget {
  final GameConfig config;
  final Function(Season) onSeasonSelected;

  const SeasonSelectionView({
    super.key,
    required this.config,
    required this.onSeasonSelected,
  });

  @override
  State<SeasonSelectionView> createState() => _SeasonSelectionViewState();
}

class _SeasonSelectionViewState extends State<SeasonSelectionView> {
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
    final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedTheme.adaptiveGradient(brightness),
        ),
        child: Stack(
          children: [
            const BackgroundPatternView(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          // Back Button
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
                                      Icons.chevron_left,
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
                              AppLocalizations.of(context)!.seasonSelectionQuestion,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha:0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Season Buttons - kleiner Abstand zur Frage
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: Season.mainCases
                                  .map((season) => Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: _SelectionButton(
                                          title: season.displayNameKey,
                                          icon: season.icon,
                                          iconColor: season == Season.fruehling_sommer
                                              ? Colors.orange
                                              : Colors.blue,
                                          onTap: () => widget.onSeasonSelected(season),
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
                                // Frühling/Sommer
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.seasonFruehling_sommerName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.seasonFruehling_sommerDescription,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha:0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Herbst/Winter
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.seasonHerbst_winterName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.seasonHerbst_winterDescription,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha:0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Besondere Zeiten
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.seasonSpecialTimesName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(context)!.seasonSpecialTimesDescription,
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

/// Area Selection
class AreaSelectionView extends StatelessWidget {
  final GameConfig config;
  final Function(Area) onAreaSelected;

  const AreaSelectionView({
    super.key,
    required this.config,
    required this.onAreaSelected,
  });

  Color _getAreaColor(Area area) {
    switch (area) {
      case Area.autobahn:
        return Colors.grey;
      case Area.land:
        return Colors.green;
      case Area.stadt:
        return Colors.orange;
      case Area.zug:
        return Colors.red;
      case Area.kirche:
        return Colors.brown;
      case Area.zuHause:
        return Colors.blue;
      case Area.zoo:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableAreas = config.categoryTheme.areas;

    return _BaseSelectionView(
      title: AppLocalizations.of(context)!.appTitle,
      question: AppLocalizations.of(context)!.areaSelectionQuestion,
      content: Column(
        children: availableAreas
            .map((area) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SelectionButton(
                    title: area.displayNameKey,
                    icon: area.icon,
                    iconColor: _getAreaColor(area),
                    onTap: () => onAreaSelected(area),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

/// Grid Size Selection
class SizeSelectionView extends StatelessWidget {
  final GameConfig config;
  final Function(int) onSizeSelected;

  const SizeSelectionView({
    super.key,
    required this.config,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseSelectionView(
      title: AppLocalizations.of(context)!.appTitle,
      question: AppLocalizations.of(context)!.sizeSelectionQuestion,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SizeButton(
              size: 3,
              icon: Icons.bolt,
              iconColor: Colors.yellow,
              titleKey: 'sizeQuick',
              subtitle: '3 × 3',
              onTap: () => onSizeSelected(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SizeButton(
              size: 4,
              icon: Icons.directions_car,
              iconColor: Colors.blue,
              titleKey: 'sizeMedium',
              subtitle: '4 × 4',
              onTap: () => onSizeSelected(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SizeButton(
              size: 5,
              icon: Icons.alt_route,
              iconColor: Colors.grey,
              titleKey: 'sizeLong',
              subtitle: '5 × 5',
              onTap: () => onSizeSelected(5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Target Bingos Selection (nur für Jagd-Modus)
class TargetBingosView extends StatefulWidget {
  final GameConfig config;
  final Function(int) onTargetSelected;

  const TargetBingosView({
    super.key,
    required this.config,
    required this.onTargetSelected,
  });

  @override
  State<TargetBingosView> createState() => _TargetBingosViewState();
}

class _TargetBingosViewState extends State<TargetBingosView> {
  late BackgroundTheme _selectedTheme;
  bool _themeLoaded = false;
  int _targetBingos = 3; // Default: 3 Bingos

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
    final isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _selectedTheme.adaptiveGradient(brightness),
        ),
        child: Stack(
          children: [
            const BackgroundPatternView(),
            SafeArea(
              child: Column(
                children: [
                  // Back Button
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
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Title
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
                              AppLocalizations.of(context)!.targetbingosQuestion,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha:0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Plus/Minus Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Minus Button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _targetBingos > 1
                                      ? () {
                                          setState(() {
                                            _targetBingos--;
                                          });
                                        }
                                      : null,
                                  customBorder: const CircleBorder(),
                                  child: Icon(
                                    Icons.remove_circle,
                                    size: 50,
                                    color: Colors.white
                                        .withValues(alpha:_targetBingos > 1 ? 1.0 : 0.3),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 30),

                              // Number Display
                              SizedBox(
                                width: 100,
                                child: Text(
                                  '$_targetBingos',
                                  style: const TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(width: 30),

                              // Plus Button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _targetBingos < 10
                                      ? () {
                                          setState(() {
                                            _targetBingos++;
                                          });
                                        }
                                      : null,
                                  customBorder: const CircleBorder(),
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 50,
                                    color: Colors.white
                                        .withValues(alpha:_targetBingos < 10 ? 1.0 : 0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Continue Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => widget.onTargetSelected(_targetBingos),
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
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!.buttonContinue,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }
}

/// Reusable Selection Button
class _SelectionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SelectionButton({
    required this.title,
    required this.icon,
    required this.iconColor,
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
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(
                icon,
                size: 36, // Größer: 28 -> 36
                color: iconColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Builder(
                  builder: (context) => Text(
                    AppLocalizations.of(context)!.getByKey(title) ?? title,
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

/// Size Button with title and subtitle
class _SizeButton extends StatelessWidget {
  final int size;
  final IconData icon;
  final Color iconColor;
  final String titleKey;
  final String subtitle;
  final VoidCallback onTap;

  const _SizeButton({
    required this.size,
    required this.icon,
    required this.iconColor,
    required this.titleKey,
    required this.subtitle,
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
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(
                icon,
                size: 36, // Größer: 28 -> 36
                color: iconColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => Text(
                        AppLocalizations.of(context)!.getByKey(titleKey) ?? titleKey,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha:0.7),
                      ),
                    ),
                  ],
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
