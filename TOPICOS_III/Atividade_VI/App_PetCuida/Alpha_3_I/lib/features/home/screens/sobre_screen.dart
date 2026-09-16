import 'package:flutter/material.dart';

import '../../../core/models/creditos_projeto.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Tela "Sobre": identifica o projeto acadêmico (universidade, curso,
/// disciplina, equipe e professores) e reúne Termos de Uso e Política
/// de Privacidade — exigidos mesmo em um protótipo alfa que lida com
/// dados pessoais (foto do tutor/pet) e de localização.
class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sobre',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: Column(
              children: [
                Image.asset('assets/brasao-pucminas.png', height: 120),
                const SizedBox(height: 10),
                Text(CreditosProjeto.universidade, textAlign: TextAlign.center, style: AppTheme.display(size: 15)),
                const SizedBox(height: 3),
                const Text(
                  CreditosProjeto.etapa,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _InfoCard(
            titulo: 'Dados acadêmicos',
            linhas: const [
              ('Curso', CreditosProjeto.curso),
              ('Disciplina', CreditosProjeto.disciplina),
              ('Turma / grupo', CreditosProjeto.turmaOuGrupo),
            ],
          ),
          const SizedBox(height: 14),
          _ListaCard(titulo: 'Equipe de desenvolvimento', icone: Icons.code_outlined, nomes: CreditosProjeto.desenvolvedores),
          const SizedBox(height: 14),
          _ListaCard(titulo: 'Professores orientadores', icone: Icons.school_outlined, nomes: CreditosProjeto.professores),
          const SizedBox(height: 22),
          const Text('Documentos', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 10),
          Card(
            child: ExpansionTile(
              title: const Text('Termos de uso', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: const [_TermosDeUsoTexto()],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ExpansionTile(
              title: const Text('Política de privacidade', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: const [_PoliticaDePrivacidadeTexto()],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('PetCuida — © 2026\nversão alfa 3H rev 2\nProjeto acadêmico sem fins comerciais', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.titulo, required this.linhas});

  final String titulo;
  final List<(String, String)> linhas;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(titulo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.muted)),
            ),
          ),
          for (final (label, valor) in linhas)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: label == linhas.first.$1 ? Colors.transparent : AppColors.line),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  Flexible(
                    child: Text(
                      valor,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ListaCard extends StatelessWidget {
  const _ListaCard({required this.titulo, required this.icone, required this.nomes});

  final String titulo;
  final IconData icone;
  final List<String> nomes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, size: 17, color: AppColors.navy),
                const SizedBox(width: 8),
                Text(titulo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            for (final nome in nomes)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 5, color: AppColors.muted),
                    const SizedBox(width: 8),
                    Expanded(child: Text(nome, style: const TextStyle(fontSize: 12.5))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TermosDeUsoTexto extends StatelessWidget {
  const _TermosDeUsoTexto();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'O PetCuida é um protótipo acadêmico desenvolvido para fins de estudo, sem fins comerciais e sem '
      'garantias de disponibilidade ou continuidade. As informações de triagem apresentadas no app são '
      'orientativas e não substituem, em nenhuma hipótese, a avaliação de um médico-veterinário. Ao usar '
      'este protótipo, você concorda que os dados inseridos (nomes, fotos e demais informações) são '
      'fictícios ou de demonstração e que o app pode ser modificado, reiniciado ou descontinuado a '
      'qualquer momento sem aviso prévio, por se tratar de um trabalho em desenvolvimento.',
      style: TextStyle(fontSize: 12.5, height: 1.55, color: AppColors.muted),
    );
  }
}

class _PoliticaDePrivacidadeTexto extends StatelessWidget {
  const _PoliticaDePrivacidadeTexto();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Nesta versão alfa, todos os dados (perfil do tutor, dados do pet, fotos escolhidas na galeria, '
      'saldo de créditos e histórico de atividades) permanecem apenas no dispositivo, em memória, e são '
      'perdidos ao fechar o aplicativo — não há envio a servidores externos nem compartilhamento com '
      'terceiros. As fotos escolhidas para o perfil do tutor e do pet são acessadas apenas localmente, '
      'a partir da galeria do próprio dispositivo, e usadas exclusivamente para exibição dentro do app. '
      'Em versões futuras com backend real, esta política será atualizada para detalhar coleta, '
      'armazenamento e direitos do titular dos dados, conforme a LGPD.',
      style: TextStyle(fontSize: 12.5, height: 1.55, color: AppColors.muted),
    );
  }
}
