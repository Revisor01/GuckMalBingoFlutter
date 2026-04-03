import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Wiederverwendbare Text/Sound Toggle-Buttons.
/// Wird von BingoGameView und DuellGameView genutzt.
class SharedToggleButtons extends StatelessWidget {
  final bool showText;
  final bool soundEnabled;
  final VoidCallback onToggleText;
  final VoidCallback onToggleSound;

  const SharedToggleButtons({
    super.key,
    required this.showText,
    required this.soundEnabled,
    required this.onToggleText,
    required this.onToggleSound,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
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
                onTap: onToggleText,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        showText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        showText ? l10n.gameTextOff : l10n.gameTextOn,
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
                onTap: onToggleSound,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        soundEnabled ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        soundEnabled ? l10n.gameSoundOff : l10n.gameSoundOn,
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
    );
  }
}
