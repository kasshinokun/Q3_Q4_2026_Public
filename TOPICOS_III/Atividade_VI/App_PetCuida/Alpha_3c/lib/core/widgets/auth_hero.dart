import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'brand_mark.dart';

/// Cabeçalho navy com curva inferior, compartilhado pelas telas de
/// Login e Cadastro — extraído para evitar duplicar o mesmo `ClipPath`
/// em dois arquivos.
class AuthHero extends StatelessWidget {
  const AuthHero({super.key, required this.eyebrow, required this.title, required this.description});

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomCurveClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 52, 24, 72),
        color: AppColors.navy,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                BrandMark(size: 40),
                SizedBox(width: 10),
                Text('PetCuida', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 36),
            Text(
              eyebrow.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(title, style: AppTheme.display(size: 27, color: Colors.white, letterSpacing: -1)),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                description,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 13.5, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 30)
      ..quadraticBezierTo(size.width / 2, size.height + 24, size.width, size.height - 30)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
