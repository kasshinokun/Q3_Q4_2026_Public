import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum TagVariant { neutral, good, warn }

/// Selo pequeno de status ("Agendado", "Concluído", "Preço social"...),
/// equivalente ao `.tag` da PWA.
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label, this.variant = TagVariant.neutral});

  final String label;
  final TagVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      TagVariant.good => (AppColors.successBg, AppColors.success),
      TagVariant.warn => (AppColors.yellow, AppColors.yellowInk),
      TagVariant.neutral => (AppColors.navySoft, AppColors.navy),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }
}
