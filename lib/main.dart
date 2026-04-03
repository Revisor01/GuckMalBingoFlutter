import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'models/game_config.dart';
import 'models/game_mode.dart';
import 'models/category_theme.dart';
import 'models/season.dart';
import 'models/area.dart';
import 'viewmodels/bingo_game_viewmodel.dart';
import 'viewmodels/duell_game_viewmodel.dart';
import 'views/game_mode_selection_view.dart';
import 'views/selection_views.dart';
import 'views/bingo_game_view.dart';
import 'views/duell_game_view.dart';
import 'views/onboarding_view.dart';
import 'l10n/app_localizations.dart';
import 'utilities/app_localizations_extension.dart';
import 'views/snowfall_widget.dart';
import 'views/easter_effect_widget.dart';
import 'utilities/app_preferences.dart';
import 'utilities/theme_provider.dart';
import 'utilities/season_service.dart';
import 'views/widgets/resume_dialog_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-Edge fuer Android 16+ (SDK 36)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  // Zentrale Preferences einmalig laden
  await AppPreferences.init();

  // Theme einmalig vor App-Start laden (synchron, da AppPreferences bereits initialisiert)
  final themeNotifier = ThemeNotifier();
  themeNotifier.loadTheme();

  // SeasonService als einzige Quelle fuer saisonalen State
  final seasonService = SeasonService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeNotifier),
        ChangeNotifierProvider.value(value: seasonService),
      ],
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
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Nunito',
        ).copyWith(
          displayLarge: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600),
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
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Nunito',
        ).copyWith(
          displayLarge: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600),
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

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: _AppLifecycleWrapper(child: child!),
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
  bool _resumeDialogShown = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  void _checkOnboarding() {
    final seen = hasSeenOnboarding();
    setState(() {
      _showOnboarding = !seen;
      _onboardingChecked = true;
    });
    if (seen) {
      _checkSavedGame();
    }
  }

  void _checkSavedGame() {
    if (!_resumeDialogShown) {
      if (AppPreferences.instance.hasSavedGameState) {
        _resumeDialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showResumeDialog();
        });
      } else if (AppPreferences.instance.hasSavedDuellState) {
        _resumeDialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showDuellResumeDialog();
        });
      }
    }
  }

  void _showResumeDialog() {
    final state = AppPreferences.instance.loadGameState();
    if (state == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent, // ResumeDialogView hat eigenen Overlay
      builder: (ctx) => ResumeDialogView(
        onContinue: () {
          Navigator.of(ctx).pop();
          final viewModel = BingoGameViewModel.fromSavedState(state);
          _navigateToGame(existingViewModel: viewModel);
        },
        onBackToStart: () {
          Navigator.of(ctx).pop();
          AppPreferences.instance.clearGameState();
        },
      ),
    );
  }

  void _showDuellResumeDialog() {
    final state = AppPreferences.instance.loadDuellState();
    if (state == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent, // ResumeDialogView hat eigenen Overlay
      builder: (ctx) => ResumeDialogView(
        onContinue: () {
          Navigator.of(ctx).pop();
          final viewModel = DuellGameViewModel.fromSavedState(state);
          _navigateToDuellGame(existingViewModel: viewModel);
        },
        onBackToStart: () {
          Navigator.of(ctx).pop();
          AppPreferences.instance.clearDuellState();
        },
      ),
    );
  }

  void _onOnboardingComplete() {
    setState(() {
      _showOnboarding = false;
    });
    _checkSavedGame();
  }

  void _onModeSelected(GameMode mode) {
    setState(() {
      _config = _config.copyWith(gameMode: mode);
    });

    // TargetBingos DIREKT nach Jagd-Auswahl
    // Duell: Kategorie zuerst (D-07: Kategorie → Saison → Area → Ziel-Anzahl)
    if (mode == GameMode.jagd) {
      _navigateToTargetBingos();
    } else if (mode == GameMode.duell) {
      _navigateToThemeCategory();
    } else {
      _navigateToThemeCategory();
    }
  }

  /// Gibt den Spielmodus-Namen als Untertitel zurueck (null fuer Suche-Modus)
  String? _getModeSubtitle(BuildContext context) {
    if (_config.gameMode == GameMode.suche) return null;
    final l10n = AppLocalizations.of(context)!;
    return l10n.getByKey(_config.gameMode.displayNameKey);
  }

  void _navigateToThemeCategory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ThemeCategorySelectionView(
          config: _config,
          subtitle: _getModeSubtitle(context),
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
          subtitle: _getModeSubtitle(context),
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
          subtitle: _getModeSubtitle(context),
          onAreaSelected: _onAreaSelected,
        ),
      ),
    );
  }

  void _onAreaSelected(Area area) {
    setState(() {
      _config = _config.copyWith(area: area);
    });
    if (_config.gameMode == GameMode.duell) {
      _navigateToDuellTarget();
    } else {
      _navigateToSizeSelection();
    }
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
          subtitle: _getModeSubtitle(context),
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

  void _navigateToDuellTarget() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TargetBingosView(
          config: _config,
          subtitle: _getModeSubtitle(context),
          questionOverride: AppLocalizations.of(context)!.duellTargetQuestion,
          onTargetSelected: _onDuellTargetSelected,
          maxTarget: 20,
          initialTarget: 5,
        ),
      ),
    );
  }

  void _onDuellTargetSelected(int target) {
    setState(() {
      _config = _config.copyWith(targetBingos: target);
    });
    _navigateToDuellGame();
  }

  void _navigateToDuellGame({DuellGameViewModel? existingViewModel}) {
    final viewModel = existingViewModel ?? DuellGameViewModel(config: _config);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: DuellGameView(
            onBackToStart: () {
              viewModel.clearSavedGameState();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ),
    );
  }

  void _navigateToGame({BingoGameViewModel? existingViewModel}) {
    final viewModel = existingViewModel ?? BingoGameViewModel(config: _config);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: BingoGameView(
            onBackToStart: () {
              viewModel.clearSavedGameState();
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

/// App-Level Lifecycle Observer für saisonale Animationen
/// Pausiert Schnefall/Osterblüten wenn die App im Hintergrund ist
class _AppLifecycleWrapper extends StatefulWidget {
  final Widget child;
  const _AppLifecycleWrapper({required this.child});

  @override
  State<_AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<_AppLifecycleWrapper>
    with WidgetsBindingObserver {
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isActive = state == AppLifecycleState.resumed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SeasonService aus dem Context lesen (bereits von Provider bereitgestellt)
    final season = context.watch<SeasonService>();
    return season.isEaster
        ? EasterEffectWidget(
            enabled: season.shouldShowEasterEffect && _isActive,
            petalCount: 25,
            child: widget.child,
          )
        : season.isChristmas
            ? SnowfallWidget(
                enabled: season.shouldShowSnowfall && _isActive,
                snowflakeCount: 40,
                child: widget.child,
              )
            : widget.child;
  }
}
