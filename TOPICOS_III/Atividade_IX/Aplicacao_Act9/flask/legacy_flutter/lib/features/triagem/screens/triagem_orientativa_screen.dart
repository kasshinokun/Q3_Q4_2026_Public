import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/colored_head.dart';
import '../../../core/widgets/notice_banner.dart';

enum _RespostaTriagem { urgente, leve, duvida }

/// Triagem orientativa: reproduz o wizard de 2 perguntas da PWA original.
/// É estritamente orientativa — nunca deve ser apresentada como diagnóstico.
class TriagemOrientativaScreen extends StatefulWidget {
  const TriagemOrientativaScreen({super.key});

  @override
  State<TriagemOrientativaScreen> createState() => _TriagemOrientativaScreenState();
}

class _TriagemOrientativaScreenState extends State<TriagemOrientativaScreen> {
  int _step = 1;
  _RespostaTriagem? _resposta;
  bool _concluido = false;
  String _tituloResultado = '';
  String _textoResultado = '';

  void _responder(_RespostaTriagem resposta) {
    setState(() {
      _resposta = resposta;
      if (_step == 1) {
        if (resposta == _RespostaTriagem.urgente) {
          _concluido = true;
          _tituloResultado = 'Procure atendimento agora';
          _textoResultado =
              'Sinais de alerta devem ser avaliados imediatamente por um médico-veterinário. '
              'Encontre uma clínica parceira na Rede Solidária.';
        } else {
          _step = 2;
          _resposta = null;
        }
      } else {
        _concluido = true;
        _tituloResultado = 'Acompanhe e agende uma avaliação';
        _textoResultado =
            'Registre os sinais no prontuário e procure um parceiro se eles persistirem ou piorarem. '
            'A prevenção é sempre o melhor caminho.';
      }
    });
  }

  void _refazer() {
    setState(() {
      _step = 1;
      _resposta = null;
      _concluido = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        const ColoredHead(
          eyebrow: 'Triagem orientativa',
          title: 'Vamos entender o que está acontecendo?',
          description:
              'Responda algumas perguntas. Esta experiência é orientativa e não substitui uma avaliação veterinária.',
          background: AppColors.yellow,
          foreground: AppColors.yellowInk,
        ),
        const SizedBox(height: 16),
        if (!_concluido) ...[
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERGUNTA $_step DE 2',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                Text(
                  _step == 1
                      ? 'O seu pet apresenta algum sinal de alerta agora?'
                      : 'Quando os sinais começaram?',
                  style: AppTheme.display(size: 15),
                ),
                const SizedBox(height: 14),
                _Escolha(
                  label: _step == 1 ? 'Sim, parece algo urgente' : 'Há poucas horas',
                  selected: _resposta == _RespostaTriagem.urgente,
                  onTap: () => _responder(_RespostaTriagem.urgente),
                ),
                const SizedBox(height: 8),
                _Escolha(
                  label: _step == 1 ? 'Não, são sinais leves' : 'Há alguns dias',
                  selected: _resposta == _RespostaTriagem.leve,
                  onTap: () => _responder(_RespostaTriagem.leve),
                ),
                const SizedBox(height: 8),
                _Escolha(
                  label: 'Ainda não tenho certeza',
                  selected: _resposta == _RespostaTriagem.duvida,
                  onTap: () => _responder(_RespostaTriagem.duvida),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_tituloResultado, style: AppTheme.display(size: 16, color: AppColors.yellowInk)),
                const SizedBox(height: 5),
                Text(_textoResultado, style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.yellowInk)),
              ],
            ),
          ),
          const SizedBox(height: 13),
          FilledButton(
            onPressed: _refazer,
            style: FilledButton.styleFrom(backgroundColor: AppColors.navy, minimumSize: const Size.fromHeight(48)),
            child: const Text('Refazer orientação'),
          ),
          const SizedBox(height: 9),
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.rede),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: const Text('Encontrar atendimento na rede'),
          ),
        ],
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: () => context.push(AppRoutes.triagemChat),
          icon: const Icon(Icons.chat_bubble_outline, size: 18),
          label: const Text('Prefiro descrever em uma conversa'),
        ),
        const NoticeBanner(
          icon: Icons.info_outline,
          background: AppColors.navySoft,
          foreground: AppColors.navy,
          child: Text(
            'Em caso de falta de ar, convulsão, sangramento intenso ou perda de consciência, '
            'procure atendimento clínico imediato.',
          ),
        ),
      ],
    );
  }
}

class _Escolha extends StatelessWidget {
  const _Escolha({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.yellow : Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: selected ? AppColors.yellowStrong : AppColors.line, width: 1.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.yellowInk : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
