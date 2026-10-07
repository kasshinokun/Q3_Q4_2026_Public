import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cabeçalho colorido usado no topo das telas de detalhe (Área do Pet,
/// Triagem, Rede Solidária, Perfil), equivalente ao `.colored-head` da PWA.
class ColoredHead extends StatelessWidget {
  const ColoredHead({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.background,
    required this.foreground,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(21)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: foreground,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: AppTheme.display(size: 17, color: foreground)),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 12, height: 1.45, color: foreground.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
