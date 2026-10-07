import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Scaffold padrão das telas internas: título, botão de voltar opcional
/// e fundo consistente (`AppColors.cream`), evitando repetir a mesma
/// `AppBar`/`Scaffold` em cada tela de detalhe.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBack,
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}
