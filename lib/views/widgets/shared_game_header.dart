import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Wiederverwendbarer Header mit Back-Button und Titel "Guck mal!"
/// Wird von BingoGameView und SprintGameView genutzt.
class SharedGameHeader extends StatelessWidget {
  final VoidCallback onBack;
  final Widget? trailing;

  const SharedGameHeader({
    super.key,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Row(
              children: [
                // Back Button
                Semantics(
                  button: true,
                  label: AppLocalizations.of(context)!.accessibilityBackButton,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBack,
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

                // Optionales trailing Widget (z.B. Reset-Button)
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Titel
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
    );
  }
}
