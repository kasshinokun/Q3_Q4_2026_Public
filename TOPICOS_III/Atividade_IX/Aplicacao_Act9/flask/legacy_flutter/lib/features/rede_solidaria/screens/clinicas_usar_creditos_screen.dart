import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_list_card.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Lista completa de serviços (Clínica PetCuida + prestadores parceiros)
/// disponíveis para agendamento com preço social / créditos solidários.
class ClinicasUsarCreditosScreen extends StatelessWidget {
  const ClinicasUsarCreditosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final servicos = context.watch<AppDataService>().servicos;

    return AppScaffold(
      title: 'Serviços',
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: servicos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 11),
        itemBuilder: (context, index) {
          final s = servicos[index];
          return AppListCard(
            leadingEmoji: '🏥',
            leadingBackground: AppColors.navySoft,
            title: s.nome,
            subtitle: '${s.prestador} · ${s.local}\n${s.descricao}',
            trailingText: s.preco,
            tagLabel: 'Preço social',
            actionLabel: s.agendado ? 'Agendado ✓' : 'Agendar',
            actionDisabled: s.agendado,
            onAction: () => context.push(AppRoutes.redeAgendamento, extra: s),
          );
        },
      ),
    );
  }
}
