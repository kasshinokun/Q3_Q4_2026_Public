import 'dart:io';

import 'package:flutter/material.dart';

import '../models/pet_model.dart';
import '../theme/app_colors.dart';

/// Avatar do pet: mostra a foto escolhida pelo tutor quando existir, ou
/// o emoji padrão da espécie ([TipoAnimal.emoji]) caso contrário.
class PetAvatar extends StatelessWidget {
  const PetAvatar({
    super.key,
    required this.pet,
    this.size = 52,
    this.background = AppColors.pinkStrong,
  });

  final PetModel pet;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final fotoPath = pet.fotoPath;
    final temFoto = fotoPath != null && fotoPath.isNotEmpty && File(fotoPath).existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.34),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        color: background,
        child: temFoto
            ? Image.file(File(fotoPath), width: size, height: size, fit: BoxFit.cover)
            : Text(pet.tipoAnimal.emoji, style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }
}
