import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/atividade_model.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/tag_chip.dart';

/// Meus Agendamentos: recorte da atividade do tutor filtrado para
/// mostrar apenas o que está agendado ou em andamento.
class MeusAgendamentosScreen extends StatelessWidget {
  const MeusAgendamentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final atividades = context
        .watch<AppDataService>()
        .perfil
        .atividades
        .where((a) => a.status != AtividadeStatus.concluido)
        .toList();

    return AppScaffold(
      title: 'Meus agendamentos',
      body: atividades.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Você ainda não possui agendamentos ativos.\nExplore a Rede Solidária para agendar um serviço.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: atividades.length,
              separatorBuilder: (_, __) => const SizedBox(height: 11),
              itemBuilder: (context, index) {
                final a = atividades[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.yellow,
                      child: Icon(Icons.event_outlined, color: AppColors.yellowInk, size: 18),
                    ),
                    title: Text(a.nome, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    subtitle: Text(a.data, style: const TextStyle(fontSize: 11)),
                    trailing: TagChip(
                      label: a.status.label,
                      variant: a.status == AtividadeStatus.agendado ? TagVariant.warn : TagVariant.neutral,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
