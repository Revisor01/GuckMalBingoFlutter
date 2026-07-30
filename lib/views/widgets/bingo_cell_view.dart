import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/bingo_item.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/app_localizations_extension.dart';

/// Bingo Cell Widget
class BingoCellView extends StatelessWidget {
  final BingoItem item;
  final bool isClicked;
  final bool isHighlighted;
  final bool isBlinking;
  final bool showText;
  final int gridSize;
  final VoidCallback onTap;

  /// Pixelgröße der Zelle im Auto-Modus — skaliert Emoji und Text mit,
  /// statt der festen Grid-Size-Stufen.
  final double? cellSize;

  const BingoCellView({
    super.key,
    required this.item,
    required this.isClicked,
    required this.isHighlighted,
    required this.isBlinking,
    required this.showText,
    required this.gridSize,
    required this.onTap,
    this.cellSize,
  });

  double get fontSize {
    if (cellSize != null) return cellSize! * 0.42;
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
    if (cellSize != null) return (cellSize! * 0.10).clamp(10.0, 20.0);
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
    final localizedName = AppLocalizations.of(context)!.getByKey(item.name) ?? item.name;
    final statusText = isClicked
        ? AppLocalizations.of(context)!.accessibilityFound
        : AppLocalizations.of(context)!.accessibilityNotFound;

    return Semantics(
      button: true,
      label: '$localizedName, $statusText',
      hint: AppLocalizations.of(context)!.accessibilityTapToMark,
      child: GestureDetector(
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
                      Colors.white.withValues(alpha:
                          brightness == Brightness.dark ? 0.25 : 0.45),
                      Colors.white.withValues(alpha:
                          brightness == Brightness.dark ? 0.2 : 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isClicked
                  ? AppColors.successGreenDark
                  : Colors.white.withValues(alpha:0.4),
              width: isClicked ? 2.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isClicked
                    ? AppColors.successGreen.withValues(alpha:0.3)
                    : (brightness == Brightness.dark
                        ? Colors.white.withValues(alpha:0.05)
                        : Colors.black.withValues(alpha:0.1)),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: item.imageName != null
                ? _buildImageContent(context)
                : _buildEmojiContent(context),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/${item.imageName}.webp',
            fit: BoxFit.contain,
            opacity: AlwaysStoppedAnimation(isClicked ? 0.7 : 1.0),
            errorBuilder: (ctx, error, stackTrace) {
              // Fallback to emoji
              return _buildEmojiContent(context);
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
                color: Colors.black.withValues(alpha:0.6),
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

  Widget _buildEmojiContent(BuildContext context) {
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
            AppLocalizations.of(context)!.getByKey(item.name) ?? item.name,
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
