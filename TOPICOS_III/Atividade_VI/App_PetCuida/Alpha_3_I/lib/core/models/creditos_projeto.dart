/// Dados institucionais e de créditos exibidos na tela "Sobre".
///
/// Centralizado em um único arquivo para que baste editar os valores
/// abaixo (nomes, disciplina, professores) sem precisar mexer em
/// nenhuma tela. Os valores atuais são placeholders — troque pelos
/// nomes reais da equipe antes da entrega final.
abstract final class CreditosProjeto {
  static const universidade = 'Pontifícia Universidade Católica de Minas Gerais (PUC Minas)';
  static const curso = 'Engenharia/Ciências da Computação'; // TODO: confirmar nome exato do curso
  static const disciplina = 'Tópicos III - Empreendedorismo e Inovação'; // TODO: confirmar nome exato da disciplina
  static const turmaOuGrupo = 'Grupo 4';
  static const etapa = 'Etapa VI — versão alfa Android (build 3i)';

  /// TODO: substituir pelos nomes completos reais da equipe.
  static const desenvolvedores = <String>[
    'Giovanna',
    'Gabriel',
    'Kathleen',
    'Julia',
  ];

  /// TODO: substituir pelos nomes reais dos professores orientadores.
  static const professores = <String>[
    'João Carlos',
    'Paulo'
  ];
}
