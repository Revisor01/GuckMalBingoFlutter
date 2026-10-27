import 'package:flutter/material.dart';
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

/// Spielansicht mit Bingo-Raster.
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
                BackgroundPatternView(area: viewModel.config.area, theme: selectedTheme),

                // Content
                SafeArea(
                  child: isLandscape
                      ? SingleChildScrollView(
                          child: _ContentView(
                            viewModel: viewModel,
                            isLandscape: true,
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

  const _ContentView({
    required this.viewModel,
    required this.isLandscape,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SharedGameHeader(
          onBack: onBack,
          trailing: Semantics(
            button: true,
            label: AppLocalizations.of(context)!.accessibilityResetButton,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => viewModel.resetGame(),
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.refresh, color: Colors.white, size: 24),
                ),
              ),
            ),
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
