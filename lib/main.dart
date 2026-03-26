import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/game_config.dart';
import 'models/game_mode.dart';
import 'models/category_theme.dart';
import 'models/season.dart';
import 'models/area.dart';
import 'viewmodels/bingo_game_viewmodel.dart';
import 'views/game_mode_selection_view.dart';
import 'views/selection_views.dart';
import 'views/bingo_game_view.dart';
import 'views/onboarding_view.dart';
import 'l10n/app_localizations.dart';
import 'views/snowfall_widget.dart';
import 'utilities/debug_utils.dart';
import 'utilities/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide status bar for immersive experience (wie in iOS app)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Lade Schneefall-Einstellung
  await loadSnowfallSetting();

  // Theme einmalig vor App-Start laden
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(
    ChangeNotifierProvider.value(
      value: themeNotifier,
      child: const GuckMalBingoApp(),
    ),
  );
}

class GuckMalBingoApp extends StatelessWidget {
  const GuckMalBingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guck mal!',
      locale: const Locale('de'), // Deutsch
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
        Locale('nl'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        // Fade-Transition statt Slide verhindert weißen Blitz
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.light().textTheme.copyWith(
            displayLarge: const TextStyle(fontWeight: FontWeight.bold),
            displayMedium: const TextStyle(fontWeight: FontWeight.bold),
            displaySmall: const TextStyle(fontWeight: FontWeight.bold),
            headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
            headlineMedium: const TextStyle(fontWeight: FontWeight.bold),
            titleLarge: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // Fade-Transition statt Slide verhindert weißen Blitz
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.dark().textTheme.copyWith(
            displayLarge: const TextStyle(fontWeight: FontWeight.bold),
            displayMedium: const TextStyle(fontWeight: FontWeight.bold),
            displaySmall: const TextStyle(fontWeight: FontWeight.bold),
            headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
            headlineMedium: const TextStyle(fontWeight: FontWeight.bold),
            titleLarge: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      builder: (context, child) {
        // Responsive text scaling: Kleinere Fonts nur auf Tablets
        final width = MediaQuery.of(context).size.width;
        double textScaleFactor = 1.0;

        // Nur für Tablets (>600px) kleiner skalieren
        // Normale Phones (iPhone, Pixel, etc.) behalten 1.0
        if (width > 600) {
          textScaleFactor = 0.95;
        }

        // Weihnachts-Special: Schneefalleffekt mit reaktivem Toggle
        Widget wrappedChild = ValueListenableBuilder<bool>(
          valueListenable: snowfallEnabledNotifier,
          builder: (context, snowfallEnabled, _) {
            return SnowfallWidget(
              enabled: isChristmasSeason() && snowfallEnabled,
              snowflakeCount: 40,
              child: child!,
            );
          },
        );

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: wrappedChild,
        );
      },
      home: const NavigationCoordinator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Navigation Coordinator
/// Verwaltet den Navigationsfluss: Mode → [Target if Jagd] → Category → [Season] → Area → Size → Game
class NavigationCoordinator extends StatefulWidget {
  const NavigationCoordinator({super.key});

  @override
  State<NavigationCoordinator> createState() => _NavigationCoordinatorState();
}

class _NavigationCoordinatorState extends State<NavigationCoordinator> {
  GameConfig _config = GameConfig();
  bool _showOnboarding = false;
  bool _onboardingChecked = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final seen = await hasSeenOnboarding();
    if (!mounted) return;
    setState(() {
      _showOnboarding = !seen;
      _onboardingChecked = true;
    });
  }

  void _onOnboardingComplete() {
    setState(() {
      _showOnboarding = false;
    });
  }

  void _onModeSelected(GameMode mode) {
    setState(() {
      _config = _config.copyWith(gameMode: mode);
    });

    // TargetBingos DIREKT nach Jagd-Auswahl
    if (mode == GameMode.jagd) {
      _navigateToTargetBingos();
    } else {
      _navigateToThemeCategory();
    }
  }

  void _navigateToThemeCategory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ThemeCategorySelectionView(
          config: _config,
          onThemeSelected: _onThemeCategorySelected,
        ),
      ),
    );
  }

  void _onThemeCategorySelected(CategoryTheme theme) {
    setState(() {
      _config = _config.copyWith(categoryTheme: theme);
    });

    // Season selection nur bei Reise-Kategorie
    if (theme.hasSeasons) {
      _navigateToSeasonSelection();
    } else {
      _navigateToAreaSelection();
    }
  }

  void _navigateToSeasonSelection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SeasonSelectionView(
          config: _config,
          onSeasonSelected: _onSeasonSelected,
        ),
      ),
    );
  }

  void _onSeasonSelected(Season season) {
    setState(() {
      _config = _config.copyWith(season: season);
    });
    _navigateToAreaSelection();
  }

  void _navigateToAreaSelection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AreaSelectionView(
          config: _config,
          onAreaSelected: _onAreaSelected,
        ),
      ),
    );
  }

  void _onAreaSelected(Area area) {
    setState(() {
      _config = _config.copyWith(area: area);
    });
    _navigateToSizeSelection();
  }

  void _navigateToSizeSelection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SizeSelectionView(
          config: _config,
          onSizeSelected: _onSizeSelected,
        ),
      ),
    );
  }

  void _onSizeSelected(int size) {
    setState(() {
      _config = _config.copyWith(gridSize: size);
    });
    _navigateToGame();
  }

  void _navigateToTargetBingos() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TargetBingosView(
          config: _config,
          onTargetSelected: _onTargetSelected,
        ),
      ),
    );
  }

  void _onTargetSelected(int target) {
    setState(() {
      _config = _config.copyWith(targetBingos: target);
    });
    _navigateToThemeCategory();
  }

  void _navigateToGame() {
    final viewModel = BingoGameViewModel(config: _config);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: BingoGameView(
            onBackToStart: () {
              // Pop all views zurück zum Start
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warte bis Onboarding-Status geprüft wurde
    if (!_onboardingChecked) {
      return const SizedBox.shrink();
    }

    // Zeige Onboarding beim ersten Start
    if (_showOnboarding) {
      return OnboardingView(
        onComplete: _onOnboardingComplete,
      );
    }

    return GameModeSelectionView(
      config: _config,
      onModeSelected: _onModeSelected,
    );
  }
}
