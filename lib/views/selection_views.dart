import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_config.dart';
import '../models/category_theme.dart';
import '../models/season.dart';
import '../models/area.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../utilities/app_localizations_extension.dart';
import 'widgets/app_button.dart';

/// Basis fuer alle Auswahl-Views
class _BaseSelectionView extends StatelessWidget {
  final String title;
  final String question;
  final Widget content;
  final Widget? footer;

  const _BaseSelectionView({
    required this.title,
    required this.question,
    required this.content,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>().theme;
    final brightness = Theme.of(context).brightness;
    final isLandscape = MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.adaptiveGradient(brightness),
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
                      child: Semantics(
                        button: true,
                        label: AppLocalizations.of(context)!.accessibilityBackButton,
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
                  ),

                  // Content
                  Expanded(
                    child: footer != null
                        ? _buildWithFooter(context, isLandscape)
                        : _buildWithScroll(context, isLandscape),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Layout mit Footer: LayoutBuilder + Spacer zwischen content und footer
  Widget _buildWithFooter(BuildContext context, bool isLandscape) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                _buildTitleAndQuestion(context, isLandscape),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: content,
                ),
                const Spacer(),
                footer!,
              ],
            ),
          ),
        );
      },
    );
  }

  /// Layout ohne Footer: einfaches ScrollView
  Widget _buildWithScroll(BuildContext context, bool isLandscape) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTitleAndQuestion(context, isLandscape),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: content,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Gemeinsamer Title + Question Block
  Widget _buildTitleAndQuestion(BuildContext context, bool isLandscape) {
    return Column(
      children: [
        // Title
        Padding(
          padding: EdgeInsets.only(
            top: isLandscape ? 10 : 20,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Question
        Padding(
          padding: EdgeInsets.only(
            top: isLandscape ? 10 : 20,
            bottom: isLandscape ? 15 : 20,
          ),
          child: Text(
            question,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha:0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Category Theme Selection
class ThemeCategorySelectionView extends StatelessWidget {
  final GameConfig config;
  final Function(CategoryTheme) onThemeSelected;

  const ThemeCategorySelectionView({
    super.key,
    required this.config,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseSelectionView(
      title: AppLocalizations.of(context)!.appTitle,
      question: AppLocalizations.of(context)!.categorySelectionQuestion,
      content: Column(
        children: CategoryTheme.values
            .map((theme) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppButton(
                    title: AppLocalizations.of(context)!.getByKey(theme.displayNameKey) ?? theme.displayNameKey,
                    icon: theme.icon,
                    iconColor: theme == CategoryTheme.reise
                        ? Colors.blue
                        : Colors.red.shade700,
                    trailing: AppButton.trailingChevron(),
                    onTap: () => onThemeSelected(theme),
                  ),
                ))
            .toList(),
      ),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: CategoryTheme.values.map((theme) {
            return _DescriptionItem(
              title: AppLocalizations.of(context)!.getByKey(theme.displayNameKey) ?? theme.displayNameKey,
              description: AppLocalizations.of(context)!.getByKey(theme.descriptionKey) ?? theme.descriptionKey,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Season Selection
class SeasonSelectionView extends StatelessWidget {
  final GameConfig config;
  final Function(Season) onSeasonSelected;

  const SeasonSelectionView({
    super.key,
    required this.config,
    required this.onSeasonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseSelectionView(
      title: AppLocalizations.of(context)!.appTitle,
      question: AppLocalizations.of(context)!.seasonSelectionQuestion,
      content: Column(
        children: Season.mainCases
            .map((season) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppButton(
                    title: AppLocalizations.of(context)!.getByKey(season.displayNameKey) ?? season.displayNameKey,
                    icon: season.icon,
                    iconColor: season == Season.fruehling_sommer
                        ? Colors.orange
                        : Colors.blue,
                    trailing: AppButton.trailingChevron(),
                    onTap: () => onSeasonSelected(season),
                  ),
                ))
            .toList(),
      ),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DescriptionItem(
              title: AppLocalizations.of(context)!.seasonFruehling_sommerName,
              description: AppLocalizations.of(context)!.seasonFruehling_sommerDescription,
            ),
            _DescriptionItem(
              title: AppLocalizations.of(context)!.seasonHerbst_winterName,
              description: AppLocalizations.of(context)!.seasonHerbst_winterDescription,
            ),
            _DescriptionItem(
              title: AppLocalizations.of(context)!.seasonSpecialTimesName,
              description: AppLocalizations.of(context)!.seasonSpecialTimesDescription,
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
                  child: AppButton(
                    title: AppLocalizations.of(context)!.getByKey(area.displayNameKey) ?? area.displayNameKey,
                    icon: area.icon,
                    iconColor: _getAreaColor(area),
                    trailing: AppButton.trailingChevron(),
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
            child: AppButton(
              icon: Icons.bolt,
              iconColor: Colors.yellow,
              title: AppLocalizations.of(context)!.getByKey('sizeQuick') ?? 'sizeQuick',
              subtitle: '3 \u00d7 3',
              trailing: AppButton.trailingChevron(),
              onTap: () => onSizeSelected(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppButton(
              icon: Icons.directions_car,
              iconColor: Colors.blue,
              title: AppLocalizations.of(context)!.getByKey('sizeMedium') ?? 'sizeMedium',
              subtitle: '4 \u00d7 4',
              trailing: AppButton.trailingChevron(),
              onTap: () => onSizeSelected(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppButton(
              icon: Icons.alt_route,
              iconColor: Colors.grey,
              title: AppLocalizations.of(context)!.getByKey('sizeLong') ?? 'sizeLong',
              subtitle: '5 \u00d7 5',
              trailing: AppButton.trailingChevron(),
              onTap: () => onSizeSelected(5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Target Bingos Selection (nur fuer Jagd-Modus)
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
  int _targetBingos = 3; // Default: 3 Bingos

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return _BaseSelectionView(
      title: AppLocalizations.of(context)!.appTitle,
      question: AppLocalizations.of(context)!.targetbingosQuestion,
      content: Column(
        children: [
          const SizedBox(height: 20),
          // Plus/Minus Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _targetBingos > 1
                      ? () { setState(() { _targetBingos--; }); }
                      : null,
                  customBorder: const CircleBorder(),
                  child: Icon(Icons.remove_circle, size: 50,
                    color: Colors.white.withValues(alpha:_targetBingos > 1 ? 1.0 : 0.3)),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                width: 100,
                child: Text('$_targetBingos',
                  style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center),
              ),
              const SizedBox(width: 30),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _targetBingos < 10
                      ? () { setState(() { _targetBingos++; }); }
                      : null,
                  customBorder: const CircleBorder(),
                  child: Icon(Icons.add_circle, size: 50,
                    color: Colors.white.withValues(alpha:_targetBingos < 10 ? 1.0 : 0.3)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Continue Button
          Material(
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
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 24, color: Colors.white.withValues(alpha:0.5)),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// Reusable description item for footer sections
class _DescriptionItem extends StatelessWidget {
  final String title;
  final String description;

  const _DescriptionItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha:0.8),
            ),
          ),
        ],
      ),
    );
  }
}

