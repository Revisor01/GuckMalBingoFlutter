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
/// Zeigt ein Item gross mit Bild und lokalisiertem Namen im BingoCellView-Layout.
/// Tap auf das Item = gefunden (gruenes Feedback + Slide-Animation).
/// Long-Press auf Skip = Item ueberspringen (Fuell-Animation).
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
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // ViewModel als State-Field gespeichert — sicher in dispose() verwendbar
  late final DuellGameViewModel _viewModel;

  // Transientes State fuer gruenes Gefunden-Feedback (NICHT im ViewModel)
  bool _isFound = false;
  Timer? _foundTimer;

  // AnimationController fuer Long-Press Skip Fuell-Animation (800ms)
  late final AnimationController _skipProgressController;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DuellGameViewModel>();
    WidgetsBinding.instance.addObserver(this);

    _skipProgressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _skipProgressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _viewModel.skip();
        _skipProgressController.reset();
      }
    });
  }

  /// WidgetsBindingObserver — speichert Spielstand bei App-Hintergrund (DUELL-07).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _viewModel.saveGameState();
    }
  }

  @override
  void dispose() {
    _skipProgressController.dispose();
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
        // Victory-Dialog offen → Dialog schliessen statt navigieren
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
              // Hintergrundmuster konsistent mit allen Screens
              BackgroundPatternView(area: _viewModel.config.area),

              // Spielinhalt
              SafeArea(
                child: Consumer<DuellGameViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        // --- TopBar ---
                        _buildTopBar(context, viewModel, l10n),

                        // --- Fortschrittsbalken ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: viewModel.targetScore > 0
                                  ? viewModel.score / viewModel.targetScore
                                  : 0,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.successGreen),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Item-Karte (Expanded, zentriert) ---
                        Expanded(
                            child: _buildItemCard(context, viewModel, l10n)),

                        const SizedBox(height: 16),

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
                  if (!viewModel.showVictoryDialog) {
                    return const SizedBox.shrink();
                  }
                  return VictoryDialogView(
                    bingoCount: viewModel.score,
                    scoreText: viewModel.skipCount > 0
                        ? '${l10n.duellVictoryScore(viewModel.score)}\n${l10n.duellSkipCount(viewModel.skipCount)}'
                        : l10n.duellVictoryScore(viewModel.score),
                    onPlayAgain: () => _viewModel.resetGame(),
                    onBackToStart: widget.onBackToStart,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// TopBar: Zurueck-Button (chevron_left), "Guck mal!" Titel + "Duell" Untertitel,
  /// Score-Badge + Skip-Zaehler (per D-11, D-12, D-06, DUELL-09)
  Widget _buildTopBar(
    BuildContext context,
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Zurueck-Button: Material+InkWell+CircleBorder (wie BingoGameView)
          Semantics(
            button: true,
            label: l10n.accessibilityBackButton,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _viewModel.saveGameState();
                  Navigator.of(context).pop();
                },
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
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

          // Titel-Block zentriert: "Guck mal!" oben, "Duell" als Untertitel
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  l10n.gamemodeDuellName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),

          // Rechte Seite: Score-Badge + Skip-Zaehler
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Score-Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              // Skip-Zaehler (nur anzeigen wenn > 0)
              if (viewModel.skipCount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.duellSkipCount(viewModel.skipCount),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Item-Karte mit AnimatedSwitcher (Slide+Fade bei Item-Wechsel)
  /// und quadratischem BingoCellView-Layout (borderRadius 14)
  Widget _buildItemCard(
    BuildContext context,
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: AspectRatio(
          aspectRatio: 1.0, // D-02: quadratisch
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: GestureDetector(
              key: ValueKey(
                  '${viewModel.currentItem.name}_${viewModel.queueIndex}'),
              onTap: _onItemTap,
              child: _buildItemCardContent(viewModel, l10n),
            ),
          ),
        ),
      ),
    );
  }

  /// Item-Karte Inhalt — BingoCellView-Layout (borderRadius 14, Bild+Text-Stack)
  Widget _buildItemCardContent(
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final item = viewModel.currentItem;
    final itemName = l10n.getByKey(item.name) ?? item.name;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: _isFound
            ? const LinearGradient(
                colors: [AppColors.successGreen, AppColors.successGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(14), // D-01: wie BingoCellView
        border: Border.all(
          color: _isFound
              ? AppColors.successGreenDark
              : Colors.white.withValues(alpha: 0.4),
          width: _isFound ? 2.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Bild mit Padding (wie BingoCellView)
          if (item.imageName != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Image.asset(
                  'assets/images/${item.imageName}.webp',
                  fit: BoxFit.contain,
                  opacity: AlwaysStoppedAnimation(_isFound ? 0.7 : 1.0),
                  errorBuilder: (ctx, error, stackTrace) => Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 80),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            Center(
              child: Text(
                item.emoji,
                style: const TextStyle(fontSize: 80),
                textAlign: TextAlign.center,
              ),
            ),
          // Name-Label unten (wie BingoCellView _buildImageContent)
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                itemName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Nunito',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Skip-Button mit Long-Press und visueller Fuell-Animation (D-04, D-05, UAT-04)
  Widget _buildSkipButton(
    BuildContext context,
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onLongPressStart: (_) => _skipProgressController.forward(),
        onLongPressEnd: (_) {
          if (_skipProgressController.status != AnimationStatus.completed) {
            _skipProgressController.reverse();
          }
        },
        onLongPressCancel: () => _skipProgressController.reverse(),
        child: AnimatedBuilder(
          animation: _skipProgressController,
          builder: (context, _) => Stack(
            children: [
              // Basis-Container (helles Rot)
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Animierter Fill von links
              FractionallySizedBox(
                widthFactor: _skipProgressController.value,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // Text + Icon (immer sichtbar, zentriert)
              SizedBox(
                width: double.infinity,
                height: 60,
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
            ],
          ),
        ),
      ),
    );
  }
}
