/// Status possíveis de uma atividade no histórico do tutor.
enum AtividadeStatus {
  concluido,
  agendado,
  emAndamento;

  String get label => switch (this) {
        AtividadeStatus.concluido => 'Concluído',
        AtividadeStatus.agendado => 'Agendado',
        AtividadeStatus.emAndamento => 'Em andamento',
      };
}

/// Item do extrato/histórico de atividades do tutor (serviços agendados,
/// pedidos atendidos, etc.), usado no Perfil e no Saldo/Extrato de Créditos.
class AtividadeModel {
  final String id;
  final String nome;
  final AtividadeStatus status;
  final String data;

  /// Positivo quando gera créditos (ex.: ajudou alguém), negativo quando
  /// consome créditos (ex.: usou crédito em um serviço). Nulo quando a
  /// atividade não envolve créditos solidários.
  final double? variacaoCreditos;

  const AtividadeModel({
    required this.id,
    required this.nome,
    required this.status,
    required this.data,
    this.variacaoCreditos,
  });
}
