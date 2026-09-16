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

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'status': status.name,
        'data': data,
        'variacaoCreditos': variacaoCreditos,
      };

  factory AtividadeModel.fromJson(Map<String, dynamic> json) {
    return AtividadeModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      status: AtividadeStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => AtividadeStatus.agendado,
      ),
      data: json['data'] as String,
      variacaoCreditos: (json['variacaoCreditos'] as num?)?.toDouble(),
    );
  }
}
