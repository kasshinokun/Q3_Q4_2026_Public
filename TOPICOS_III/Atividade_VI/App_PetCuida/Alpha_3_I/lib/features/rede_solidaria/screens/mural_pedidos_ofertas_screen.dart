import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/tag_chip.dart';

/// Mural de pedidos disponíveis no banco de horas: troque tempo e
/// cuidado por créditos solidários para usar com o próprio pet.
class MuralPedidosOfertasScreen extends StatelessWidget {
  const MuralPedidosOfertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataService>();

    return AppScaffold(
      title: 'Pedidos disponíveis',
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(18),
        itemCount: data.pedidos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final p = data.pedidos[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text('${p.solicitante} · ${p.local}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      Text('+${p.recompensa} cr.', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(p.descricao, style: const TextStyle(fontSize: 12.5, height: 1.45, color: AppColors.ink)),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TagChip(label: 'Banco de horas', variant: TagVariant.warn),
                      FilledButton(
                        onPressed: p.candidatado ? null : () => data.candidatarPedido(p.id),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          disabledBackgroundColor: const Color(0xFFB9C2D0),
                          minimumSize: const Size(0, 36),
                        ),
                        child: Text(p.candidatado ? 'Candidatura enviada ✓' : 'Candidatar-se'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em breve: Formulário de criação de pedido')),
                );
              },
              backgroundColor: AppColors.navy,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Criar Pedido', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}