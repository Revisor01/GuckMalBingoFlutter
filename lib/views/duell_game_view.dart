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

/// DuellGameView — Einzelitem-Ansicht für den Duell-Modus.
///
/// Layout identisch zum BingoGameView: Header mit "Guck mal!", Grid-Hintergrund
/// mit 1x1-Zelle (BingoCellView-Stil), Ton/Text-Toggle Buttons unten.
/// Tap auf das Item = gefunden. Long-Press Skip mit Füll-Animation.
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
  late final DuellGameViewModel _viewModel;

  bool _isFound = false;
  Timer? _foundTimer;

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
    if (_isFound) return;
    setState(() => _isFound = true);
    _foundTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _viewModel.markFound();
      setState(() => _isFound = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = context.watch<ThemeNotifier>().theme;

    return Consumer<DuellGameViewModel>(
      builder: (context, viewModel, child) {
        final brightness = Theme.of(context).brightness;
        final l10n = AppLocalizations.of(context)!;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
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
                  BackgroundPatternView(area: _viewModel.config.area),

                  // Content — identisches Layout wie BingoGameView._ContentView
                  SafeArea(
                    child: Column(
                      children: [
                        // Header mit fixer Höhe (wie BingoGameView)
                        SizedBox(
                          height: 140,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                                child: Row(
                                  children: [
                                    // Back Button (identisch zu BingoGameView)
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

                                    const Spacer(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Titel "Guck mal!" (identisch zu BingoGameView)
                              Text(
                                l10n.appTitle,
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Punkte-Anzeige (wie Bingo-Jagd Zähler)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 6,
                              children: List.generate(
                                viewModel.targetScore,
                                (index) => Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index < viewModel.score
                                        ? Colors.yellow
                                        : Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Grid-Hintergrund mit 1x1 Item-Karte (wie BingoGrid Container)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: brightness == Brightness.dark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: brightness == Brightness.dark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    )),
                                    child: FadeTransition(opacity: animation, child: child),
                                  );
                                },
                                child: GestureDetector(
                                  key: ValueKey('${viewModel.currentItem.name}_${viewModel.queueIndex}'),
                                  onTap: _onItemTap,
                                  child: _buildCellContent(viewModel, l10n, brightness),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Skip-Button mit Long-Press
                        _buildSkipButton(viewModel, l10n),

                        const Spacer(),

                        // Controls unten (Ton + Text Toggle — identisch zu BingoGameView)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Row(
                            children: [
                              // Text Toggle
                              Semantics(
                                button: true,
                                label: l10n.accessibilityTextToggle,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => viewModel.toggleText(),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            viewModel.showText ? Icons.visibility : Icons.visibility_off,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            viewModel.showText ? l10n.gameTextOff : l10n.gameTextOn,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Sound Toggle
                              Semantics(
                                button: true,
                                label: l10n.accessibilitySoundToggle,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => viewModel.toggleSound(),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            viewModel.soundEnabled ? Icons.volume_up : Icons.volume_off,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            viewModel.soundEnabled ? l10n.gameSoundOff : l10n.gameSoundOn,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
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

                  // Victory-Overlay
                  if (viewModel.showVictoryDialog)
                    VictoryDialogView(
                      bingoCount: viewModel.score,
                      scoreText: viewModel.skipCount > 0
                          ? '${l10n.duellVictoryScore(viewModel.score)}\n${l10n.duellSkipCount(viewModel.skipCount)}'
                          : l10n.duellVictoryScore(viewModel.score),
                      onPlayAgain: () => _viewModel.resetGame(),
                      onBackToStart: widget.onBackToStart,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Item-Karte Inhalt — BingoCellView-Stil (borderRadius 14, Bild+Text-Stack)
  Widget _buildCellContent(
    DuellGameViewModel viewModel,
    AppLocalizations l10n,
    Brightness brightness,
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
                  Colors.white.withValues(alpha: brightness == Brightness.dark ? 0.25 : 0.45),
                  Colors.white.withValues(alpha: brightness == Brightness.dark ? 0.2 : 0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFound
              ? AppColors.successGreenDark
              : Colors.white.withValues(alpha: 0.4),
          width: _isFound ? 2.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFound
                ? AppColors.successGreen.withValues(alpha: 0.3)
                : (brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.1)),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
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
          // Name-Label unten (wie BingoCellView, nur wenn showText)
          if (viewModel.showText)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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

  /// Skip-Button mit Long-Press und visueller Füll-Animation
  Widget _buildSkipButton(
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
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              FractionallySizedBox(
                widthFactor: _skipProgressController.value,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.skip_next, size: 22, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          l10n.duellSkip,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      l10n.duellSkipHint,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
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
