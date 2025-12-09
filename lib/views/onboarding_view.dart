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
    if (_currentPage < 3) {
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
      _OnboardingPage(
        icon: Icons.waving_hand,
        iconColor: Colors.amber,
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDesc,
      ),
      _OnboardingPage(
        icon: Icons.gamepad,
        iconColor: Colors.green,
        title: l10n.onboardingModesTitle,
        description: l10n.onboardingModesDesc,
      ),
      _OnboardingPage(
        icon: Icons.touch_app,
        iconColor: Colors.blue,
        title: l10n.onboardingPlayTitle,
        description: l10n.onboardingPlayDesc,
      ),
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

                    // PageView
                    Expanded(
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

                    // Page Indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
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

                    // Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                      child: SizedBox(
                        width: double.infinity,
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
                            _currentPage < 3
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

/// Einzelne Onboarding-Seite
class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
