import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/servico_model.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Agendamento de horário para o [servico] recebido via `extra` da rota.
/// Coleta apenas dia/horário (dados genéricos) e segue para o Check-out
/// Híbrido, onde o pagamento em créditos + dinheiro é simulado.
class AgendamentoHorarioScreen extends StatefulWidget {
  const AgendamentoHorarioScreen({super.key, required this.servico});

  final ServicoModel servico;

  @override
  State<AgendamentoHorarioScreen> createState() => _AgendamentoHorarioScreenState();
}

class _AgendamentoHorarioScreenState extends State<AgendamentoHorarioScreen> {
  static const _dias = ['Seg 15/09', 'Ter 16/09', 'Qua 17/09', 'Qui 18/09'];
  static const _horarios = ['09:00', '10:30', '14:00', '16:30'];

  int _diaSelecionado = 0;
  int _horarioSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Agendar horário',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.servico.nome, style: AppTheme.display(size: 15)),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.servico.prestador} · ${widget.servico.local}',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.servico.preco, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Escolha o dia', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_dias.length, (index) {
              final selected = index == _diaSelecionado;
              return ChoiceChip(
                label: Text(_dias[index]),
                selected: selected,
                onSelected: (_) => setState(() => _diaSelecionado = index),
                selectedColor: AppColors.navySoft,
                labelStyle: TextStyle(color: selected ? AppColors.navy : AppColors.ink, fontWeight: FontWeight.w700),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text('Escolha o horário', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_horarios.length, (index) {
              final selected = index == _horarioSelecionado;
              return ChoiceChip(
                label: Text(_horarios[index]),
                selected: selected,
                onSelected: (_) => setState(() => _horarioSelecionado = index),
                selectedColor: AppColors.navySoft,
                labelStyle: TextStyle(color: selected ? AppColors.navy : AppColors.ink, fontWeight: FontWeight.w700),
              );
            }),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: () => context.push(AppRoutes.redeCheckout, extra: widget.servico),
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            child: const Text('Continuar para o check-out'),
          ),
        ],
      ),
    );
  }
}
