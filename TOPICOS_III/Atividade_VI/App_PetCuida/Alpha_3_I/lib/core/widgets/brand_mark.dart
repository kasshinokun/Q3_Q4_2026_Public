import 'package:flutter/material.dart';

/// Ícone de marca do PetCuida (pata de animal), usado na Splash, no
/// cabeçalho de autenticação e no `AppBar` das telas internas.
///
/// Usar [Icons.pets] em vez de recriar o SVG original mantém o visual
/// fiel ao conceito sem depender de assets vetoriais customizados.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = 44,
    this.background = const Color(0xFFE0AE55),
    this.foreground = Colors.white,
  });

  final double size;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.34),
        boxShadow: [
          BoxShadow(color: background.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Icon(Icons.pets_rounded, size: size * 0.56, color: foreground),
    );
  }
}
