import 'package:flutter/material.dart';

/// Paleta de cores do PetCuida, extraída do design original da PWA.
///
/// Mantida centralizada para que nenhuma tela precise usar cores
/// "mágicas" (hardcoded) — sempre referenciar [AppColors] ou o [ThemeData].
abstract final class AppColors {
  static const cream = Color(0xFFFEFAF7);
  static const background = Color(0xFFE8E5E2);

  static const navy = Color(0xFF4F6997);
  static const navyDeep = Color(0xFF334D79);
  static const navySoft = Color(0xFFE4E9F2);

  static const pink = Color(0xFFF9CFD3);
  static const pinkStrong = Color(0xFFE98CA0);
  static const pinkInk = Color(0xFF8C4A58);

  static const yellow = Color(0xFFFEEDCB);
  static const yellowStrong = Color(0xFFE0AE55);
  static const yellowInk = Color(0xFF7A5A20);

  static const lavender = Color(0xFFEFE3EC);
  static const lavenderStrong = Color(0xFFA98BB0);
  static const lavenderInk = Color(0xFF6B4A73);

  static const ink = Color(0xFF25334A);
  static const muted = Color(0xFF718096);
  static const line = Color(0xFFE9E4E0);

  static const success = Color(0xFF3E8061);
  static const successBg = Color(0xFFDCEDE4);
  static const danger = Color(0xFFB94B59);
}
