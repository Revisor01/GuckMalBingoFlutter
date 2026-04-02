import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/season_service.dart';

/// Victory Dialog - 1:1 wie Swift Original (mit Weihnachts-Theme)
class VictoryDialogView extends StatelessWidget {
  final int bingoCount;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToStart;
  final String? scoreText;

  const VictoryDialogView({
    super.key,
    required this.bingoCount,
    required this.onPlayAgain,
    required this.onBackToStart,
    this.scoreText,
  });

  @override
  Widget build(BuildContext context) {
    // Saisonaler Victory-Dialog
    final season = context.read<SeasonService>();
    final Color bgColor;
    final IconData iconData;
    final Color iconColor;
    if (season.isChristmas) {
      bgColor = const Color(0xFFC41E3A); // Weihnachtsrot
      iconData = Icons.park; // Weihnachtsbaum
      iconColor = const Color(0xFF228B22); // Grün
    } else if (season.isEaster) {
      bgColor = const Color(0xFFC06080); // Frühlings-Rosa
      iconData = Icons.local_florist; // Blume
      iconColor = const Color(0xFFFFD700); // Gold
    } else {
      bgColor = AppColors.successGreen;
      iconData = Icons.emoji_events; // Trophy
      iconColor = Colors.yellow;
    }

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
                    if (season.isChristmas)
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
                    fontFamily: 'Nunito',
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                // Bingo Count
                Text(
                  scoreText ?? '$bingoCount ${bingoCount != 1 ? AppLocalizations.of(context)!.victoryBingoPlural : AppLocalizations.of(context)!.victoryBingoSingular}',
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
