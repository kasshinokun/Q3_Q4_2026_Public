import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Saldo e extrato de créditos solidários: mostra o saldo atual e as
/// movimentações derivadas das atividades do tutor (agendamentos e
/// candidaturas a pedidos).
class SaldoExtratoScreen extends StatelessWidget {
  const SaldoExtratoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<AppDataService>().perfil;

    return AppScaffold(
      title: 'Saldo e extrato',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(22)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo disponível', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('${perfil.saldoCreditos} créditos', style: AppTheme.display(size: 26, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Movimentações', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 10),
          if (perfil.atividades.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Nenhuma movimentação ainda.', style: TextStyle(color: AppColors.muted)),
            )
          else
            ...perfil.atividades.map(
              (a) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.navySoft,
                    child: Icon(Icons.swap_horiz, color: AppColors.navy, size: 18),
                  ),
                  title: Text(a.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  subtitle: Text('${a.status.label} · ${a.data}', style: const TextStyle(fontSize: 11)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
