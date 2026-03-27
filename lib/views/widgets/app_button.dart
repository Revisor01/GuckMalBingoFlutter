import 'package:flutter/material.dart';

/// Unified configurable button widget replacing duplicated button patterns.
///
/// Supports all button variants in the app:
/// - Selection buttons (icon + title + chevron)
/// - Size buttons (icon + title + subtitle + chevron)
/// - Game mode buttons (icon + title + chevron)
/// - Settings buttons (icon + title, no trailing)
/// - Settings link buttons (icon + title + external link icon)
/// - Theme buttons (custom leading widget + title + check icon + optional border)
class AppButton extends StatelessWidget {
  /// Leading icon. Ignored if [leadingWidget] is provided.
  final IconData? icon;

  /// Size of the leading icon. Defaults to 36.
  final double iconSize;

  /// Color of the leading icon.
  final Color? iconColor;

  /// Custom leading widget (e.g., gradient preview). Overrides [icon].
  final Widget? leadingWidget;

  /// Button title text.
  final String title;

  /// Whether the title is a localization key that should be resolved.
  /// If false, title is used as-is.
  final bool localizeTitle;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Trailing widget. Common options: chevron_right, open_in_new, check icon.
  /// If null, no trailing widget is shown.
  final Widget? trailing;

  /// Called when the button is tapped.
  final VoidCallback onTap;

  /// Optional border (e.g., for selected state).
  final Border? border;

  const AppButton({
    super.key,
    this.icon,
    this.iconSize = 36,
    this.iconColor,
    this.leadingWidget,
    required this.title,
    this.localizeTitle = false,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.border,
  });

  /// Convenience: creates a trailing chevron_right icon.
  static Widget trailingChevron() => Icon(
        Icons.chevron_right,
        size: 24,
        color: Colors.white.withValues(alpha: 0.5),
      );

  /// Convenience: creates a trailing open_in_new icon.
  static Widget trailingExternalLink() => Icon(
        Icons.open_in_new,
        size: 20,
        color: Colors.white.withValues(alpha: 0.5),
      );

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              // Leading
              if (leadingWidget != null)
                leadingWidget!
              else if (icon != null)
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              const SizedBox(width: 16),
              // Title + optional subtitle
              Expanded(
                child: subtitle != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(context),
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      )
                    : _buildTitle(context),
              ),
              // Trailing
              if (trailing != null) ...[
                trailing!,
                const SizedBox(width: 24),
              ] else
                const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
