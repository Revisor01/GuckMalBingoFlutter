import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../viewmodels/bingo_game_viewmodel.dart';
import '../models/bingo_item.dart';
import '../models/background_theme.dart';
import '../models/game_mode.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/app_colors.dart';
import '../utilities/app_localizations_extension.dart';
import '../utilities/debug_utils.dart';

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

class _BingoGameViewState extends State<BingoGameView> {
  late BackgroundTheme _selectedTheme;
  bool _themeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await BackgroundTheme.loadSavedTheme();
    setState(() {
      _selectedTheme = theme;
      _themeLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_themeLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<BingoGameViewModel>(
      builder: (context, viewModel, child) {
        final brightness = Theme.of(context).brightness;
        final isLandscape = MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: _selectedTheme.adaptiveGradient(brightness),
            ),
            child: Stack(
              children: [
                // Background Pattern
                BackgroundPatternView(area: viewModel.config.area),

                // Content
                SafeArea(
                  child: isLandscape
                      ? SingleChildScrollView(
                          child: _ContentView(
                            viewModel: viewModel,
                            isLandscape: true,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                        )
                      : _ContentView(
                          viewModel: viewModel,
                          isLandscape: false,
                          onBack: () => Navigator.of(context).pop(),
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
                      viewModel.showVictoryDialog = false;
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
        // Header mit fixer Höhe
        SizedBox(
          height: 140,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Row(
                  children: [
                    // Back Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onBack,
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
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

                    const Spacer(),

                    // Reset Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => viewModel.resetGame(),
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                Text(
                  AppLocalizations.of(context)!.gameYourBingos,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
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
                                : Colors.white.withOpacity(0.3),
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
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            children: [
              // Text Toggle
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => viewModel.toggleText(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.showText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          viewModel.showText
                              ? AppLocalizations.of(context)!.gameTextOff
                              : AppLocalizations.of(context)!.gameTextOn,
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

              const Spacer(),

              // Sound Toggle
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => viewModel.toggleSound(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.soundEnabled
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          viewModel.soundEnabled
                              ? AppLocalizations.of(context)!.gameSoundOff
                              : AppLocalizations.of(context)!.gameSoundOn,
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
            ],
          ),
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
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.15),
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

/// Bingo Cell Widget
class BingoCellView extends StatelessWidget {
  final BingoItem item;
  final bool isClicked;
  final bool isHighlighted;
  final bool isBlinking;
  final bool showText;
  final int gridSize;
  final VoidCallback onTap;

  const BingoCellView({
    super.key,
    required this.item,
    required this.isClicked,
    required this.isHighlighted,
    required this.isBlinking,
    required this.showText,
    required this.gridSize,
    required this.onTap,
  });

  double get fontSize {
    switch (gridSize) {
      case 3:
        return 56;
      case 4:
        return 46;
      default:
        return 36;
    }
  }

  double get textSize {
    switch (gridSize) {
      case 3:
        return 11;
      case 4:
        return 9;
      default:
        return 7.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isBlinking ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: isClicked
                ? const LinearGradient(
                    colors: [
                      AppColors.successGreen,
                      AppColors.successGreenDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withOpacity(
                          brightness == Brightness.dark ? 0.25 : 0.45),
                      Colors.white.withOpacity(
                          brightness == Brightness.dark ? 0.2 : 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isClicked
                  ? AppColors.successGreenDark
                  : Colors.white.withOpacity(0.4),
              width: isClicked ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isClicked
                    ? AppColors.successGreen.withOpacity(0.3)
                    : (brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.1)),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: item.imageName != null
                ? _buildImageContent(context)
                : _buildEmojiContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    return Stack(
      children: [
        // TODO: Load image from assets
        Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/${item.imageName}.png',
            fit: BoxFit.contain,
            opacity: AlwaysStoppedAnimation(isClicked ? 0.7 : 1.0),
            errorBuilder: (ctx, error, stackTrace) {
              // Fallback to emoji
              return _buildEmojiContent();
            },
          ),
        ),
        if (showText)
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                AppLocalizations.of(context)!.getByKey(item.name) ?? item.name,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmojiContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.emoji,
          style: TextStyle(fontSize: fontSize),
        ),
        if (showText) ...[
          const SizedBox(height: 2),
          Text(
            item.name, // TODO: Localize
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Win Message Overlay
class WinMessageView extends StatelessWidget {
  final String message;
  final bool isFinalVictory;

  const WinMessageView({
    super.key,
    required this.message,
    required this.isFinalVictory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 28,
            color: Colors.yellow,
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.star,
            size: 28,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}

/// Victory Dialog - 1:1 wie Swift Original (mit Weihnachts-Theme)
class VictoryDialogView extends StatelessWidget {
  final int bingoCount;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToStart;

  const VictoryDialogView({
    super.key,
    required this.bingoCount,
    required this.onPlayAgain,
    required this.onBackToStart,
  });

  @override
  Widget build(BuildContext context) {
    // Weihnachts-Special: Rotes Theme im Dezember
    final isChristmas = isChristmasSeason();
    final bgColor = isChristmas ? const Color(0xFFB22222) : AppColors.successGreen; // Dunkelrot für Weihnachten
    final iconData = isChristmas ? Icons.park : Icons.emoji_events; // Weihnachtsbaum statt Trophy
    final iconColor = isChristmas ? const Color(0xFF228B22) : Colors.yellow; // Grüner Baum

    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy Icon (oder Weihnachtsbaum)
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Icon(
                      iconData,
                      size: 80,
                      color: iconColor,
                    ),
                    // Stern auf dem Weihnachtsbaum
                    if (isChristmas)
                      const Positioned(
                        top: -5,
                        child: Icon(
                          Icons.star,
                          size: 24,
                          color: Colors.yellow,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  AppLocalizations.of(context)!.victoryWon,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Rounded',
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                // Bingo Count
                Text(
                  '$bingoCount ${bingoCount != 1 ? AppLocalizations.of(context)!.victoryBingoPlural : AppLocalizations.of(context)!.victoryBingoSingular}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      // Play Again Button
                      ElevatedButton(
                        onPressed: onPlayAgain,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: bgColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadowColor: Colors.black.withValues(alpha: 0.2),
                          elevation: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.refresh, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.victoryPlayAgain,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Back to Start Button
                      TextButton(
                        onPressed: onBackToStart,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.victoryBackToStart,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
