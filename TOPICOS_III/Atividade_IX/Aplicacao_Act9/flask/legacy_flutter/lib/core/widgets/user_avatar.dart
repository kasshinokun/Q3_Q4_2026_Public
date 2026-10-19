import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Avatar do tutor: mostra a foto de perfil escolhida quando existir,
/// ou as iniciais do nome (fallback de ícone) caso contrário.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.nome,
    this.fotoPath,
    this.radius = 26,
    this.background = AppColors.lavenderStrong,
    this.foreground = Colors.white,
  });

  final String nome;
  final String? fotoPath;
  final double radius;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final temFoto = fotoPath != null && fotoPath!.isNotEmpty && File(fotoPath!).existsSync();

    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      backgroundImage: temFoto ? FileImage(File(fotoPath!)) : null,
      child: temFoto
          ? null
          : Text(
              nome.trim().isNotEmpty ? nome.trim()[0].toUpperCase() : '?',
              style: TextStyle(color: foreground, fontWeight: FontWeight.w800, fontSize: radius * 0.8),
            ),
    );
  }
}
