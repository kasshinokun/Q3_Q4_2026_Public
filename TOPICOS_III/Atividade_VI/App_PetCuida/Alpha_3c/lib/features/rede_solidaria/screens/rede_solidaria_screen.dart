import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_list_card.dart';
import '../../../core/widgets/colored_head.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../core/widgets/tag_chip.dart';

/// Hub da Rede Solidária: saldo de créditos, serviços com preço social
/// disponíveis para agendamento e uma prévia do mural de pedidos.
class RedeSolidariaScreen extends StatelessWidget {
  const RedeSolidariaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataService>();
    final perfil = data.perfil;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        const ColoredHead(
          eyebrow: 'Rede solidária',
          title: 'Cuidado acessível perto de você',
          description: 'Encontre parceiros, use créditos e participe do banco de horas da sua região.',
          background: AppColors.navySoft,
          foreground: AppColors.navy,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: StatTile(value: '${perfil.saldoCreditos}', label: 'créditos')),
            const SizedBox(width: 9),
            const Expanded(child: StatTile(value: '12', label: 'parceiros')),
            const SizedBox(width: 9),
            const Expanded(child: StatTile(value: '4,9', label: 'avaliação')),
          ],
        ),
        SectionHeader(
          title: 'Serviços para agendar',
          actionLabel: 'Ver todos',
          onAction: () => context.push(AppRoutes.redeClinicas),
        ),
        ...data.servicos.take(3).map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: AppListCard(
                  leadingEmoji: '♡',
                  leadingBackground: AppColors.navySoft,
                  title: s.nome,
                  subtitle: '${s.prestador} · ${s.local}',
                  trailingText: s.preco,
                  tagLabel: 'Preço social',
                  actionLabel: s.agendado ? 'Agendado ✓' : 'Agendar',
                  actionDisabled: s.agendado,
                  onAction: () => context.push(AppRoutes.redeAgendamento, extra: s),
                ),
              ),
            ),
        SectionHeader(
          title: 'Pedidos de ajuda',
          actionLabel: 'Ver todos',
          onAction: () => context.push(AppRoutes.redeMural),
        ),
        ...data.pedidos.take(2).map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: AppListCard(
                  leadingEmoji: '♧',
                  leadingBackground: AppColors.yellow,
                  title: p.titulo,
                  subtitle: '${p.local} · +${p.recompensa} créditos',
                  tagLabel: 'Banco de horas',
                  tagVariant: TagVariant.warn,
                  actionLabel: p.candidatado ? 'Enviado ✓' : 'Ajudar',
                  actionDisabled: p.candidatado,
                  onAction: () => data.candidatarPedido(p.id),
                ),
              ),
            ),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.redeMapa),
          icon: const Icon(Icons.map_outlined),
          label: const Text('Ver mapa de clínicas e preços sociais'),
        ),
      ],
    );
  }
}
