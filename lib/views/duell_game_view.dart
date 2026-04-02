import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/duell_game_viewmodel.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../utilities/theme_provider.dart';
import '../utilities/app_localizations_extension.dart';
import '../l10n/app_localizations.dart';
import 'widgets/victory_dialog_view.dart';

/// DuellGameView — Einzelitem-Ansicht fuer den Duell-Modus.
///
/// Zeigt ein Item gross mit Bild und lokalisiertem Namen.
/// Tap auf das Item = gefunden (gruenes Feedback), roter Skip-Button.
/// Victory-Dialog bei Erreichen des Ziels.
class DuellGameView extends StatefulWidget {
  final VoidCallback onBackToStart;

  const DuellGameView({
    super.key,
    required this.onBackToStart,
  });

  @override
  State<DuellGameView> createState() => _DuellGameViewState();
}

class _DuellGameViewState extends State<DuellGameView>
    with WidgetsBindingObserver {
  // ViewModel als State-Field gespeichert — sicher in dispose() verwendbar
  // (context ist in dispose() nicht mehr zugreifbar)
  late final DuellGameViewModel _viewModel;

  // Transientes State fuer gruenes Gefunden-Feedback (NICHT im ViewModel)
  bool _isFound = false;
  Timer? _foundTimer;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DuellGameViewModel>();
    WidgetsBinding.instance.addObserver(this);
  }

  /// WidgetsBindingObserver — speichert Spielstand bei App-Hintergrund (DUELL-07).
  /// Unverzichtbar: iOS/Android koennen den Prozess ohne dispose() killen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _viewModel.saveGameState();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _foundTimer?.cancel();
    _viewModel.saveGameState();
    super.dispose();
  }

  void _onItemTap() {
    if (_isFound) return; // Kein Doppel-Tap waehrend Feedback-Animation
    setState(() => _isFound = true);
    // 400ms gruenes Feedback, dann Score erhoehen und naechstes Item anzeigen
    _foundTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _viewModel.markFound();
      setState(() => _isFound = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = context.watch<ThemeNotifier>().theme;
    final brightness = Theme.of(context).brightness;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Victory-Dialog offen → Dialog schliessen statt navigieren (Pitfall 7)
        if (_viewModel.showVictoryDialog) {
          _viewModel.dismissVictoryDialog();
        } else {
          _viewModel.saveGameState();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: selectedTheme.adaptiveGradient(brightness),
          ),
          child: Stack(
            children: [
              // D-02: Hintergrundmuster konsistent mit allen Screens
              BackgroundPatternView(area: _viewModel.config.area),

              // Spielinhalt
              SafeArea(
                child: Consumer<DuellGameViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        // --- TopBar ---
                        _buildTopBar(context, viewModel, l10n),

                        // --- Item-Karte (Expanded) ---
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32),
                            child: _buildItemCard(context, viewModel, l10n),
                          ),
                        ),

                        // --- Skip-Button ---
                        _buildSkipButton(context, viewModel, l10n),

                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),

              // --- Victory-Overlay ---
              Consumer<DuellGameViewModel>(
                builder: (context, viewModel, child) {
                  if (!viewModel.showVictoryDialog) return const SizedBox.shrink();
                  return VictoryDialogView(
                    bingoCount: viewModel.score,
                    scoreText: l10n.duellVictoryScore(viewModel.score),
                    onPlayAgain: () => _viewModel.resetGame(), // D-09
                    onBackToStart: widget.onBackToStart, // D-09
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// TopBar: Zurueck-Button, Titel "Duell", Score-Anzeige
  Widget _buildTopBar(
    BuildContext context,
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Zurueck-Button (kreisfoermig, weiss 0.2 alpha)
          GestureDetector(
            onTap: () {
              _viewModel.saveGameState();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Titel "Duell" zentriert
          Expanded(
            child: Center(
              child: Text(
                l10n.gamemodeDuellName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),

          // Score-Anzeige (weiss 0.2 alpha, borderRadius 12)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${viewModel.score} / ${viewModel.targetScore}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Nunito',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Item-Karte: Bild/Emoji + Name, AnimatedContainer fuer Gefunden-Feedback
  Widget _buildItemCard(
    BuildContext context,
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final item = viewModel.currentItem;
    final itemName = l10n.getByKey(item.name) ?? item.name;

    return Center(
      child: GestureDetector(
        onTap: _onItemTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _isFound
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.successGreen,
                      AppColors.successGreenDark,
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.20),
                    ],
                  ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isFound
                  ? AppColors.successGreenDark
                  : Colors.white.withValues(alpha: 0.4),
              width: _isFound ? 2.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bild oder Emoji-Fallback
                if (item.imageName != null)
                  Image.asset(
                    'assets/images/${item.imageName}.webp',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 80),
                        textAlign: TextAlign.center,
                      );
                    },
                  )
                else
                  Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 80),
                    textAlign: TextAlign.center,
                  ),

                // Lokalisierter Item-Name
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Nunito',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Skip-Button: Rot, volle Breite, Icon + Text
  Widget _buildSkipButton(
    BuildContext context,
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: () => _viewModel.skip(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.skip_next, size: 24, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                l10n.duellSkip,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
