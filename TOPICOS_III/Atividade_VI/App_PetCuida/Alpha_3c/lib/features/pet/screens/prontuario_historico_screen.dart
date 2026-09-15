import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_list_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/tag_chip.dart';

class _RegistroClinico {
  const _RegistroClinico({required this.titulo, required this.data, required this.status, required this.variant});
  final String titulo;
  final String data;
  final String status;
  final TagVariant variant;
}

/// Prontuário e histórico médico do pet. Reúne consultas, vacinas e
/// lembretes já registrados, com atalho para exportar via QR Code.
class ProntuarioHistoricoScreen extends StatelessWidget {
  const ProntuarioHistoricoScreen({super.key});

  static const _registros = [
    _RegistroClinico(titulo: 'Consulta veterinária de rotina', data: '02/08/2026 · Clínica PetCuida', status: 'Concluído', variant: TagVariant.good),
    _RegistroClinico(titulo: 'Vacinação anual', data: '20/10/2025', status: 'Concluído', variant: TagVariant.good),
    _RegistroClinico(titulo: 'Vermifugação', data: 'Próximo lembrete em 24 dias', status: 'Lembrete', variant: TagVariant.neutral),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Prontuário e histórico',
      actions: [
        IconButton(
          tooltip: 'Exportar via QR Code',
          icon: const Icon(Icons.qr_code_2_outlined),
          onPressed: () => context.push(AppRoutes.petQrCode),
        ),
      ],
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: _registros.length,
        separatorBuilder: (_, __) => const SizedBox(height: 11),
        itemBuilder: (context, index) {
          final r = _registros[index];
          return AppListCard(
            leadingEmoji: r.status == 'Concluído' ? '📋' : '⏰',
            leadingBackground: r.status == 'Concluído' ? AppColors.navySoft : AppColors.yellow,
            title: r.titulo,
            subtitle: r.data,
            tagLabel: r.status,
            tagVariant: r.variant,
          );
        },
      ),
    );
  }
}
