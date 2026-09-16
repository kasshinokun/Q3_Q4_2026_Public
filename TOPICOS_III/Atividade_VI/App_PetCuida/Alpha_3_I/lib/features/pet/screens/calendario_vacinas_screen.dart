import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_list_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/tag_chip.dart';

class _EventoVacina {
  const _EventoVacina({required this.titulo, required this.data, required this.status, required this.variant});
  final String titulo;
  final String data;
  final String status;
  final TagVariant variant;
}

/// Calendário e lembretes de vacina: lista de eventos preventivos do pet.
/// Dados genéricos/estáticos, alinhados ao estágio alfa do protótipo.
class CalendarioVacinasScreen extends StatelessWidget {
  const CalendarioVacinasScreen({super.key});

  static const _eventos = [
    _EventoVacina(titulo: 'Vacinação V10', data: '15/09/2026', status: 'Agendado', variant: TagVariant.warn),
    _EventoVacina(titulo: 'Vermifugação', data: 'Lembrete em 24 dias', status: 'Lembrete', variant: TagVariant.neutral),
    _EventoVacina(titulo: 'Vacina antirrábica', data: '20/10/2026', status: 'Programado', variant: TagVariant.neutral),
    _EventoVacina(titulo: 'Consulta preventiva', data: '12/12/2026', status: 'Sugestão', variant: TagVariant.neutral),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Vacinas e lembretes',
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: _eventos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 11),
        itemBuilder: (context, index) {
          final e = _eventos[index];
          return AppListCard(
            leadingEmoji: '💉',
            leadingBackground: AppColors.pink,
            title: e.titulo,
            subtitle: e.data,
            tagLabel: e.status,
            tagVariant: e.variant,
          );
        },
      ),
    );
  }
}
