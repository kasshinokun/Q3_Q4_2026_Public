import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/servico_model.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Check-out híbrido: simula o pagamento combinando créditos solidários
/// disponíveis e o valor restante em dinheiro. Ao confirmar, marca o
/// serviço como agendado via [AppDataService].
class CheckoutHibridoScreen extends StatefulWidget {
  const CheckoutHibridoScreen({super.key, required this.servico});

  final ServicoModel servico;

  @override
  State<CheckoutHibridoScreen> createState() => _CheckoutHibridoScreenState();
}

class _CheckoutHibridoScreenState extends State<CheckoutHibridoScreen> {
  bool _usarCreditos = true;
  bool _confirmando = false;

  @override
  Widget build(BuildContext context) {
    final saldo = context.watch<AppDataService>().perfil.saldoCreditos;
    final creditosAplicados = _usarCreditos ? (saldo >= 1 ? 1.0 : saldo) : 0.0;

    return AppScaffold(
      title: 'Check-out',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.servico.nome, style: AppTheme.display(size: 15)),
                        const SizedBox(height: 4),
                        Text(widget.servico.prestador, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Text(widget.servico.preco, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Forma de pagamento', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 10),
          SwitchListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.line),
            ),
            value: _usarCreditos,
            onChanged: (value) => setState(() => _usarCreditos = value),

            // Substitua:
            // activeColor: AppColors.navy,

            // Por:
            activeThumbColor: AppColors.navy,
            title: const Text('Usar créditos solidários', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('Saldo disponível: $saldo créditos', style: const TextStyle(fontSize: 11)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: AppColors.yellowInk),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _usarCreditos
                        ? '$creditosAplicados crédito(s) serão usados. O restante é pago em dinheiro no local.'
                        : 'O valor total será pago em dinheiro no local.',
                    style: const TextStyle(fontSize: 12, color: AppColors.yellowInk, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _confirmando
                ? null
                : () async {
                    setState(() => _confirmando = true);
                    await Future.delayed(const Duration(milliseconds: 400));
                    if (!context.mounted) return;
                    context.read<AppDataService>().agendarServico(widget.servico.id);
                    context.go(AppRoutes.rede);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${widget.servico.nome} agendado com sucesso!')),
                    );
                  },
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            child: _confirmando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                  )
                : const Text('Confirmar agendamento'),
          ),
        ],
      ),
    );
  }
}
