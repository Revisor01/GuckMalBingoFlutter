import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import '../l10n/app_localizations.dart';

/// Prüft ob Onboarding bereits gezeigt wurde
Future<bool> hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenOnboarding') ?? false;
}

/// Markiert Onboarding als gesehen
Future<void> setOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasSeenOnboarding', true);
}

/// OnboardingView - Erklärt die App beim ersten Start
class OnboardingView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool showCloseButton;

  const OnboardingView({
    super.key,
    required this.onComplete,
    this.showCloseButton = false,
  });

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late BackgroundTheme _selectedTheme;
  bool _themeLoaded = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 5;

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    await setOnboardingSeen();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (!_themeLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final brightness = Theme.of(context).brightness;
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      // Seite 1: Willkommen
      _OnboardingPage(
        icon: Icons.family_restroom,
        iconColor: Colors.amber,
        title: l10n.onboardingWelcomeTitle,
        subtitle: l10n.onboardingWelcomeSubtitle,
        description: l10n.onboardingWelcomeDesc,
      ),
      // Seite 2: Kategorien
      _OnboardingPage(
        icon: Icons.category,
        iconColor: Colors.teal,
        title: l10n.onboardingCategoriesTitle,
        description: l10n.onboardingCategoriesDesc,
      ),
      // Seite 3: Wie Bingo funktioniert
      _BingoExplanationPage(
        title: l10n.onboardingBingoTitle,
        description: l10n.onboardingBingoDesc,
      ),
      // Seite 4: Spielmodi
      _OnboardingPage(
        icon: Icons.gamepad,
        iconColor: Colors.green,
        title: l10n.onboardingModesTitle,
        description: l10n.onboardingModesDesc,
      ),
      // Seite 5: Los geht's
      _OnboardingPage(
        icon: Icons.rocket_launch,
        iconColor: Colors.purple,
        title: l10n.onboardingReadyTitle,
        description: l10n.onboardingReadyDesc,
      ),
    ];

    return ClipRRect(
      borderRadius: widget.showCloseButton
          ? const BorderRadius.vertical(top: Radius.circular(30))
          : BorderRadius.zero,
      child: Scaffold(
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
                    // Close Button (nur wenn über Hilfe aufgerufen)
                    if (widget.showCloseButton)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Semantics(
                            button: true,
                            label: l10n.accessibilityBackButton,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                customBorder: const CircleBorder(),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
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
                      ),

                    // PageView
                    Expanded(
                      child: Semantics(
                        label: l10n.onboardingPageLabel(_currentPage + 1, _totalPages),
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: pages,
                        ),
                      ),
                    ),

                    // Page Indicator
                    Semantics(
                      label: l10n.onboardingPageLabel(_currentPage + 1, _totalPages),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _totalPages,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: Semantics(
                          button: true,
                          label: _currentPage < _totalPages - 1
                              ? l10n.onboardingNext
                              : l10n.onboardingStart,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: _selectedTheme.gradient.colors.first,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _currentPage < _totalPages - 1
                                  ? l10n.onboardingNext
                                  : l10n.onboardingStart,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Einzelne Onboarding-Seite mit Icon
class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $description',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: iconColor,
              ),
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle (optional)
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 20),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bingo-Erklärungsseite mit Grid-Visualisierung
class _BingoExplanationPage extends StatelessWidget {
  final String title;
  final String description;

  const _BingoExplanationPage({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: '$title. $description. ${l10n.onboardingBingoAccessibility}',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Drei Mini Bingo Grids nebeneinander
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _MiniBingoGrid(bingoType: _BingoType.horizontal),
                _MiniBingoGrid(bingoType: _BingoType.vertical),
                _MiniBingoGrid(bingoType: _BingoType.diagonal),
              ],
            ),

            const SizedBox(height: 30),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

enum _BingoType { horizontal, vertical, diagonal }

/// Mini Bingo Grid zur Visualisierung
class _MiniBingoGrid extends StatelessWidget {
  final _BingoType bingoType;

  const _MiniBingoGrid({required this.bingoType});

  // Bildnamen für das Demo-Grid (bekannte, gut erkennbare Items)
  static const _images = [
    'rotesauto',   // 0
    'baum',        // 1
    'haus',        // 2
    'hund',        // 3
    'bus',         // 4
    'blumen',      // 5
    'katze',       // 6
    'fahrrad',     // 7
    'flugzeug',    // 8
  ];

  List<bool> get _found {
    switch (bingoType) {
      case _BingoType.horizontal:
        // Mittlere Reihe (Index 3, 4, 5)
        return [false, false, false, true, true, true, false, false, false];
      case _BingoType.vertical:
        // Mittlere Spalte (Index 1, 4, 7)
        return [false, true, false, false, true, false, false, true, false];
      case _BingoType.diagonal:
        // Diagonal von links oben (Index 0, 4, 8)
        return [true, false, false, false, true, false, false, false, true];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final isFound = _found[index];
          return Container(
            decoration: BoxDecoration(
              color: isFound
                  ? const Color(0xFF4CAF50)
                  : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
              border: isFound
                  ? Border.all(color: const Color(0xFF388E3C), width: 1.5)
                  : null,
            ),
            padding: const EdgeInsets.all(2),
            child: Image.asset(
              'assets/images/${_images[index]}.webp',
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
