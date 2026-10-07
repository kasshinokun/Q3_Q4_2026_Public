import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_list_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/tag_chip.dart';

class _RegistroClinico {
  const _RegistroClinico({
    required this.titulo,
    required this.dataDetalhes,
    required this.status,
    required this.variant,
    required this.emoji,
    required this.corFundo,
  });

  final String titulo;
  final String dataDetalhes;
  final String status;
  final TagVariant variant;
  final String emoji;
  final Color corFundo;
}

class ProntuarioHistoricoScreen extends StatefulWidget {
  const ProntuarioHistoricoScreen({super.key});

  @override
  State<ProntuarioHistoricoScreen> createState() => _ProntuarioHistoricoScreenState();
}

class _ProntuarioHistoricoScreenState extends State<ProntuarioHistoricoScreen> {
  // Lista colorida igual a identidade do app
  final List<_RegistroClinico> _registros = [
    const _RegistroClinico(
      titulo: 'Vacina antirrábica',
      dataDetalhes: 'aplicada 12/03 - próxima 12/04',
      status: 'Concluído',
      variant: TagVariant.good,
      emoji: '💉',
      corFundo: AppColors.pink, // Corzinha Rosa
    ),
    const _RegistroClinico(
      titulo: 'Consulta de rotina',
      dataDetalhes: 'vet - clínica 1 - 04/05',
      status: 'Concluído',
      variant: TagVariant.good,
      emoji: '🩺',
      corFundo: AppColors.yellow, // Corzinha Amarela
    ),
    const _RegistroClinico(
      titulo: 'Exame de sangue',
      dataDetalhes: 'anexo - 05/06',
      status: 'Anexo',
      variant: TagVariant.neutral,
      emoji: '📎',
      corFundo: AppColors.lavender, // Corzinha Lilás
    ),
  ];

  void _mostrarDialogoNovoRegistro() {
    final tituloController = TextEditingController();
    final detalhesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Registro', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título (ex: Cirurgia)'),
            ),
            TextField(
              controller: detalhesController,
              decoration: const InputDecoration(labelText: 'Detalhes/Data (ex: 15/09 - Clínica X)'),
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
              if (tituloController.text.isNotEmpty && detalhesController.text.isNotEmpty) {
                setState(() {
                  _registros.add(_RegistroClinico(
                    titulo: tituloController.text,
                    dataDetalhes: detalhesController.text,
                    status: 'Novo',
                    variant: TagVariant.good,
                    emoji: '📝',
                    corFundo: AppColors.navySoft, // Azul clarinho para os novos
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Prontuário',
      actions: [
        IconButton(
          tooltip: 'Exportar via QR Code',
          icon: const Icon(Icons.qr_code_2_outlined),
          onPressed: () => context.push(AppRoutes.petQrCode),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Lista de cartões coloridos
          ..._registros.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 11.0),
                child: AppListCard(
                  leadingEmoji: r.emoji,
                  leadingBackground: r.corFundo,
                  title: r.titulo,
                  subtitle: r.dataDetalhes,
                  tagLabel: r.status,
                  tagVariant: r.variant,
                ),
              )),
          const SizedBox(height: 12),

          // Botão coloridão para Adicionar
          FilledButton.icon(
            onPressed: _mostrarDialogoNovoRegistro,
            icon: const Icon(Icons.add),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            label: const Text('Adicionar registro', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),

          // Botão coloridão para o QR Code (usando o tema lilás)
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.petQrCode),
            icon: const Icon(Icons.qr_code_2_outlined, color: AppColors.lavenderInk),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.lavender,
              foregroundColor: AppColors.lavenderInk,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            label: const Text('Ver QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}