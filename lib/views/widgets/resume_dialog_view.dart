import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utilities/app_colors.dart';

/// Resume Dialog im VictoryDialog-Stil.
/// Wird als fullscreen Overlay in einem Stack gerendert (wie VictoryDialogView).
/// Zeigt bei App-Start "Weiterspielen" und "Zurück zum Start".
/// Gilt für ALLE Spielmodi (Suche, Jagd, Duell).
class ResumeDialogView extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBackToStart;

  const ResumeDialogView({
    super.key,
    required this.onContinue,
    required this.onBackToStart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const bgColor = AppColors.primary;

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
                // Play Icon
                const Icon(Icons.play_circle_outline, size: 80, color: Colors.white),
                const SizedBox(height: 24),
                // Titel
                Text(
                  l10n.resumeGameTitle,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  l10n.resumeGameMessage,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: 'Nunito',
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      // Weiterspielen (Primary)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onContinue,
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
                              const Icon(Icons.play_arrow, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                l10n.resumeGameContinue,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Zurück zum Start (Secondary)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
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
                                l10n.resumeGameBackToStart,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
