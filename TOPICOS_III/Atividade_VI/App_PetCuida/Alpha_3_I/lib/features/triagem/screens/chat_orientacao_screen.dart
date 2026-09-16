import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

class _Mensagem {
  const _Mensagem({required this.texto, required this.doTutor});
  final String texto;
  final bool doTutor;
}

/// Chat de Orientação: alternativa conversacional à Triagem por
/// perguntas fechadas. As respostas são orientações genéricas e fixas
/// neste estágio alfa — não há IA/backend real por trás do chat ainda.
class ChatOrientacaoScreen extends StatefulWidget {
  const ChatOrientacaoScreen({super.key});

  @override
  State<ChatOrientacaoScreen> createState() => _ChatOrientacaoScreenState();
}

class _ChatOrientacaoScreenState extends State<ChatOrientacaoScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  final List<_Mensagem> _mensagens = [
    const _Mensagem(
      texto: 'Olá! Posso ajudar a organizar informações sobre o que você observou no seu pet. '
          'Esta conversa é orientativa e não substitui um médico-veterinário.',
      doTutor: false,
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _inputController.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensagens.add(_Mensagem(texto: texto, doTutor: true));
      _mensagens.add(const _Mensagem(
        texto: 'Obrigado por descrever. Anote quando os sinais começaram, a intensidade e qualquer mudança '
            'de comportamento. Se houver piora, procure uma clínica parceira na Rede Solidária.',
        doTutor: false,
      ));
      _inputController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Chat de orientação',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final m = _mensagens[index];
                return Align(
                  alignment: m.doTutor ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(13),
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: m.doTutor ? AppColors.navySoft : Colors.white,
                      border: m.doTutor ? null : Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(m.texto, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(hintText: 'Descreva o que observou…'),
                      onSubmitted: (_) => _enviar(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _enviar,
                    style: IconButton.styleFrom(backgroundColor: AppColors.navy),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
