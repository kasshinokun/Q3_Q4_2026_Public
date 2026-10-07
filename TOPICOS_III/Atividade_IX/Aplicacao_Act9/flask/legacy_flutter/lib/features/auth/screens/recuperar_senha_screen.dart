import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Exibe a recuperação de senha como um diálogo modal sobre o login,
/// em vez de uma rota de tela cheia — mais rápido de dispensar e mais
/// próximo do comportamento esperado para esse tipo de aviso curto.
Future<void> showRecuperarSenhaDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recuperar senha', style: AppTheme.display(size: 18)),
            const SizedBox(height: 10),
            const Text(
              'Em um app real, enviaríamos instruções para o e-mail cadastrado. '
              'Nesta simulação, nenhum e-mail é enviado.',
              style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.muted),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Entendi', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
