import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

class _Faq {
  const _Faq({required this.pergunta, required this.resposta});
  final String pergunta;
  final String resposta;
}

/// Suporte humano / Ajuda: perguntas frequentes e um atalho para
/// contato. Nesta versão alfa o "contato" apenas confirma o envio de
/// forma simulada — a conexão com um canal humano real é um ponto de
/// integração para uma próxima etapa.
class SuporteAjudaScreen extends StatelessWidget {
  const SuporteAjudaScreen({super.key});

  static const _faqs = [
    _Faq(
      pergunta: 'A triagem orientativa substitui uma consulta veterinária?',
      resposta: 'Não. Ela apenas ajuda a organizar informações e indicar o próximo passo. Sinais de alerta exigem atendimento imediato.',
    ),
    _Faq(
      pergunta: 'Como funcionam os créditos solidários?',
      resposta: 'Você ganha créditos ajudando outros tutores no banco de horas e pode usá-los para abater o valor de serviços com preço social.',
    ),
    _Faq(
      pergunta: 'Meus dados estão seguros?',
      resposta: 'Nesta versão alfa, os dados são apenas demonstrativos e ficam somente no dispositivo, sem envio a um servidor.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Suporte e ajuda',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Perguntas frequentes', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 10),
          ..._faqs.map(
            (f) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(f.pergunta, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(f.resposta, style: const TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.muted))],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Suporte humano será conectado em uma próxima etapa.')),
            ),
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
            icon: const Icon(Icons.support_agent_outlined),
            label: const Text('Falar com o suporte'),
          ),
        ],
      ),
    );
  }
}
