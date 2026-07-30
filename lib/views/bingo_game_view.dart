import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../viewmodels/bingo_game_viewmodel.dart';
import '../models/game_mode.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/theme_provider.dart';
import 'widgets/shared_game_header.dart';
import 'widgets/shared_toggle_buttons.dart';
import 'widgets/victory_dialog_view.dart';
import 'widgets/win_message_view.dart';
import 'widgets/bingo_cell_view.dart';
import 'widgets/round_icon_button.dart';

/// BingoGameView - Portiert von Swift
/// Hauptspiel-Ansicht mit Bingo-Grid
class BingoGameView extends StatefulWidget {
  final VoidCallback onBackToStart;

  const BingoGameView({
    super.key,
    required this.onBackToStart,
  });

  @override
  State<BingoGameView> createState() => _BingoGameViewState();
}

class _BingoGameViewState extends State<BingoGameView> with WidgetsBindingObserver {
  bool _carMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (_carMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _enterCarMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    setState(() => _carMode = true);
  }

  void _exitCarMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    setState(() => _carMode = false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      final viewModel = Provider.of<BingoGameViewModel>(context, listen: false);
      if (!viewModel.isFinalVictory) {
        viewModel.saveGameState();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = context.watch<ThemeNotifier>().theme;

    return Consumer<BingoGameViewModel>(
      builder: (context, viewModel, child) {
        final brightness = Theme.of(context).brightness;
        final isLandscape = MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: selectedTheme.adaptiveGradient(brightness),
            ),
            child: Stack(
              children: [
                // Background Pattern
                BackgroundPatternView(area: viewModel.config.area),

                // Content
                SafeArea(
                  child: _carMode
                      ? _CarModeContent(
                          viewModel: viewModel,
                          onExit: _exitCarMode,
                        )
                      : isLandscape
                          ? SingleChildScrollView(
                              child: _ContentView(
                                viewModel: viewModel,
                                isLandscape: true,
                                onCarMode: _enterCarMode,
                                onBack: () {
                                  viewModel.stopAllSounds();
                                  if (!viewModel.isFinalVictory) viewModel.clearSavedGameState();
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          : _ContentView(
                              viewModel: viewModel,
                              isLandscape: false,
                              onCarMode: _enterCarMode,
                              onBack: () {
                                viewModel.stopAllSounds();
                                if (!viewModel.isFinalVictory) viewModel.clearSavedGameState();
                                Navigator.of(context).pop();
                              },
                            ),
                ),

                // Win Message
                if (viewModel.showWinMessage)
                  Center(
                    child: WinMessageView(
                      message: viewModel.winMessage,
                      isFinalVictory: viewModel.isFinalVictory,
                    ),
                  ),

                // Victory Dialog
                if (viewModel.showVictoryDialog)
                  VictoryDialogView(
                    bingoCount: viewModel.bingoCount,
                    onPlayAgain: () {
                      viewModel.dismissVictoryDialog();
                      viewModel.resetGame();
                    },
                    onBackToStart: widget.onBackToStart,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContentView extends StatelessWidget {
  final BingoGameViewModel viewModel;
  final bool isLandscape;
  final VoidCallback onBack;
  final VoidCallback onCarMode;

  const _ContentView({
    required this.viewModel,
    required this.isLandscape,
    required this.onBack,
    required this.onCarMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SharedGameHeader(
          onBack: onBack,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundIconButton(
                icon: Icons.directions_car,
                semanticLabel:
                    AppLocalizations.of(context)!.accessibilityCarModeButton,
                onTap: onCarMode,
              ),
              const SizedBox(width: 8),
              RoundIconButton(
                icon: Icons.refresh,
                semanticLabel:
                    AppLocalizations.of(context)!.accessibilityResetButton,
                onTap: () => viewModel.resetGame(),
              ),
            ],
          ),
        ),

        // Bingo Counter (nur bei Jagd-Modus)
        if (viewModel.config.gameMode == GameMode.jagd)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      viewModel.config.targetBingos,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < viewModel.bingoCount
                                ? Colors.yellow
                                : Colors.white.withValues(alpha:0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Spacer
        if (isLandscape)
          const SizedBox(height: 20)
        else
          const Spacer(),

        // Bingo Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BingoGrid(viewModel: viewModel),
        ),

        // Spacer
        if (isLandscape)
          const SizedBox(height: 20)
        else
          const Spacer(),

        // Controls
        SharedToggleButtons(
          showText: viewModel.showText,
          soundEnabled: viewModel.soundEnabled,
          onToggleText: () => viewModel.toggleText(),
          onToggleSound: () => viewModel.toggleSound(),
        ),
      ],
    );
  }
}

/// Auto-Modus: immersiver Großbildmodus.
/// Grid füllt den Bildschirm, Zellen haben eine Mindestgröße —
/// passt das Grid nicht komplett, wird vertikal gescrollt.
class _CarModeContent extends StatelessWidget {
  final BingoGameViewModel viewModel;
  final VoidCallback onExit;

  static const double _spacing = 8;
  static const double _minCell = 120;

  const _CarModeContent({
    required this.viewModel,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Slim Top-Bar: Exit, Jagd-Zähler, Reset
          Row(
            children: [
              RoundIconButton(
                icon: Icons.fullscreen_exit,
                semanticLabel: AppLocalizations.of(context)!
                    .accessibilityExitCarModeButton,
                onTap: onExit,
              ),
              const Spacer(),
              if (viewModel.config.gameMode == GameMode.jagd)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      viewModel.config.targetBingos,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < viewModel.bingoCount
                                ? Colors.yellow
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              RoundIconButton(
                icon: Icons.refresh,
                semanticLabel:
                    AppLocalizations.of(context)!.accessibilityResetButton,
                onTap: () => viewModel.resetGame(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Grid — füllt den Rest, scrollt bei Bedarf
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final n = viewModel.config.gridSize;
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final cellFitW = (w - (n - 1) * _spacing) / n;
                final cellFitH = (h - (n - 1) * _spacing) / n;
                double cell = cellFitW < cellFitH ? cellFitW : cellFitH;
                final needsScroll = cell < _minCell;
                if (needsScroll) {
                  cell = cellFitW < _minCell ? cellFitW : _minCell;
                }
                final gridWidth = n * cell + (n - 1) * _spacing;

                final grid = SizedBox(
                  width: gridWidth,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: n,
                      crossAxisSpacing: _spacing,
                      mainAxisSpacing: _spacing,
                    ),
                    itemCount: viewModel.board.length,
                    itemBuilder: (context, index) {
                      return BingoCellView(
                        item: viewModel.board[index],
                        isClicked: viewModel.clickedIndices.contains(index),
                        isHighlighted:
                            viewModel.highlightedIndices.contains(index),
                        isBlinking: viewModel.blinkingIndex == index ||
                            viewModel.blinkingAllIndices.contains(index),
                        showText: viewModel.showText,
                        gridSize: n,
                        cellSize: cell,
                        onTap: () => viewModel.toggleCell(index),
                      );
                    },
                  ),
                );

                return needsScroll
                    ? SingleChildScrollView(child: Center(child: grid))
                    : Center(child: grid);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Bingo Grid Widget
class BingoGrid extends StatelessWidget {
  final BingoGameViewModel viewModel;

  const BingoGrid({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? Colors.white.withValues(alpha:0.15)
            : Colors.white.withValues(alpha:0.25),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha:0.1)
                : Colors.black.withValues(alpha:0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: viewModel.config.gridSize,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: viewModel.board.length,
        itemBuilder: (context, index) {
          return BingoCellView(
            item: viewModel.board[index],
            isClicked: viewModel.clickedIndices.contains(index),
            isHighlighted: viewModel.highlightedIndices.contains(index),
            isBlinking: viewModel.blinkingIndex == index ||
                viewModel.blinkingAllIndices.contains(index),
            showText: viewModel.showText,
            gridSize: viewModel.config.gridSize,
            onTap: () => viewModel.toggleCell(index),
          );
        },
      ),
    );
  }
}
