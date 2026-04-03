import 'package:flutter/material.dart';

/// Wiederverwendbares Beschreibungs-Widget für Footer-Sektionen
/// Zeigt einen Titel (bold) und eine Beschreibung (leicht transparent)
class DescriptionItem extends StatelessWidget {
  final String title;
  final String description;
  final EdgeInsetsGeometry? padding;

  const DescriptionItem({
    super.key,
    required this.title,
    required this.description,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
