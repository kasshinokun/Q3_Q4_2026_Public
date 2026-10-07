import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Faixa de aviso/informação (ex.: próximo cuidado, alerta de urgência),
/// equivalente ao `.notice` da PWA.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner({
    super.key,
    required this.icon,
    required this.child,
    this.background = AppColors.yellow,
    this.foreground = AppColors.yellowInk,
  });

  final IconData icon;
  final Widget child;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 17),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(17)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 12, height: 1.4, color: foreground),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
