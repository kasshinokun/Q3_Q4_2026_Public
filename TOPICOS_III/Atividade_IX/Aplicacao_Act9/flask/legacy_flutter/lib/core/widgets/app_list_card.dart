import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'tag_chip.dart';

/// Cartão de lista reutilizado em Serviços, Pedidos e Atividades:
/// ícone/emoji + título + subtítulo + valor/preço + rodapé opcional
/// (tag + botão de ação). Equivalente ao `.card` da PWA.
class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingEmoji,
    this.leadingBackground,
    this.trailingText,
    this.tagLabel,
    this.tagVariant = TagVariant.neutral,
    this.actionLabel,
    this.onAction,
    this.actionDisabled = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? leadingEmoji;
  final Color? leadingBackground;
  final String? trailingText;
  final String? tagLabel;
  final TagVariant tagVariant;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool actionDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leadingEmoji != null) ...[
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: leadingBackground ?? AppColors.navySoft,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(leadingEmoji!, style: const TextStyle(fontSize: 17)),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  if (trailingText != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      trailingText!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.navy),
                    ),
                  ],
                ],
              ),
              if (tagLabel != null || actionLabel != null) ...[
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (tagLabel != null) TagChip(label: tagLabel!, variant: tagVariant) else const SizedBox.shrink(),
                    if (actionLabel != null)
                      ElevatedButton(
                        onPressed: actionDisabled ? null : onAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          disabledBackgroundColor: const Color(0xFFB9C2D0),
                          minimumSize: const Size(0, 34),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                        child: Text(actionLabel!),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
