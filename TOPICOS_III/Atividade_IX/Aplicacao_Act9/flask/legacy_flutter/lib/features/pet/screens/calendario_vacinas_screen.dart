import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_list_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/tag_chip.dart';

class _EventoVacina {
  const _EventoVacina({
    required this.titulo,
    required this.dataReal,
    required this.status,
    required this.variant,
    required this.emoji,
    required this.corFundo,
  });

  final String titulo;
  final DateTime dataReal;
  final String status;
  final TagVariant variant;
  final String emoji;
  final Color corFundo;
}

class CalendarioVacinasScreen extends StatefulWidget {
  const CalendarioVacinasScreen({super.key});

  @override
  State<CalendarioVacinasScreen> createState() => _CalendarioVacinasScreenState();
}

class _CalendarioVacinasScreenState extends State<CalendarioVacinasScreen> {
  late final List<_EventoVacina> _eventos;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    _eventos = [
      _EventoVacina(
        titulo: 'V10 - Reforço',
        dataReal: hoje.add(const Duration(days: 3)),
        status: 'Alerta',
        variant: TagVariant.warn,
        emoji: '💉',
        corFundo: AppColors.pink,
      ),
      _EventoVacina(
        titulo: 'Banho e tosa',
        dataReal: hoje.add(const Duration(days: 30)),
        status: 'Agendado',
        variant: TagVariant.neutral,
        emoji: '✂️',
        corFundo: AppColors.yellow,
      ),
    ];
  }

  String _calcularTempoRelativo(DateTime dataBase) {
    final hoje = DateTime.now();
    final data = DateTime(dataBase.year, dataBase.month, dataBase.day);
    final hojeSemHora = DateTime(hoje.year, hoje.month, hoje.day);
    final diferenca = data.difference(hojeSemHora).inDays;

    if (diferenca == 0) return 'Hoje';
    if (diferenca == 1) return 'Amanhã';
    if (diferenca == -1) return 'Ontem';
    if (diferenca > 1 && diferenca < 30) return 'em $diferenca dias';
    if (diferenca >= 30) {
      final meses = diferenca ~/ 30;
      return 'em $meses mês${meses > 1 ? 'es' : ''}';
    }
    return 'Há ${diferenca.abs()} dias';
  }

  void _mostrarDialogoNovoLembrete() {
    final tituloController = TextEditingController();
    DateTime dataEscolhida = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Novo Lembrete', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Título (ex: Vacina V8)'),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () async {
                    final data = await showDatePicker(
                      context: context,
                      initialDate: dataEscolhida,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (data != null) {
                      setStateDialog(() => dataEscolhida = data);
                    }
                  },
                  icon: const Icon(Icons.calendar_month_outlined, color: AppColors.navy),
                  label: Text(
                    '${dataEscolhida.day.toString().padLeft(2, '0')}/${dataEscolhida.month.toString().padLeft(2, '0')}/${dataEscolhida.year}',
                    style: const TextStyle(color: AppColors.ink),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar', style: TextStyle(color: AppColors.muted)),
              ),
              FilledButton(
                onPressed: () {
                  if (tituloController.text.isNotEmpty) {
                    setState(() {
                      _eventos.add(_EventoVacina(
                        titulo: tituloController.text,
                        dataReal: dataEscolhida,
                        status: 'Novo',
                        variant: TagVariant.good,
                        emoji: '📅',
                        corFundo: AppColors.navySoft,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Calendário',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // A caixa do topo sumiu! Agora as datas vivem só dentro dos cartões.
          ..._eventos.map((e) {
            final dataFormatada = '${e.dataReal.day.toString().padLeft(2, '0')}/${e.dataReal.month.toString().padLeft(2, '0')}';
            final tempoRelativo = _calcularTempoRelativo(e.dataReal);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 11.0),
              child: AppListCard(
                leadingEmoji: e.emoji,
                leadingBackground: e.corFundo,
                title: e.titulo,
                subtitle: '$dataFormatada · $tempoRelativo', 
                tagLabel: e.status,
                tagVariant: e.variant,
              ),
            );
          }),
          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: _mostrarDialogoNovoLembrete,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.navy),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('+ Novo lembrete', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}