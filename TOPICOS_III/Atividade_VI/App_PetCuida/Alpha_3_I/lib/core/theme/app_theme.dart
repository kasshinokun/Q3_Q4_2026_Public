import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema visual único do PetCuida.
///
/// Centralizar o [ThemeData] evita duplicar `TextStyle`/`BoxDecoration`
/// espalhados pelas telas e garante consistência visual em todo o app.
/// Usa apenas as fontes padrão do sistema (sem `google_fonts`) para manter
/// o build do estágio alfa leve e sem dependência de rede em tempo de execução.
abstract final class AppTheme {
  static TextStyle display({
    double size = 20,
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.ink,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing ?? -0.4,
      height: 1.1,
    );
  }

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        surface: AppColors.cream,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.cream,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: display(size: 24, letterSpacing: -0.8),
        titleLarge: display(size: 19),
        titleMedium: display(size: 16),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy, width: 1.5),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.ink),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.navySoft,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
