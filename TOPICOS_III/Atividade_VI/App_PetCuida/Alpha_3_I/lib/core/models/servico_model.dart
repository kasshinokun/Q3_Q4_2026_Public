/// Serviço oferecido pela Clínica PetCuida ou por um prestador parceiro
/// dentro da Rede Solidária (preço social, agendamento, etc.).
class ServicoModel {
  final String id;
  final String nome;
  final String prestador;
  final String local;
  final String preco;
  final String descricao;
  final bool agendado;

  const ServicoModel({
    required this.id,
    required this.nome,
    required this.prestador,
    required this.local,
    required this.preco,
    required this.descricao,
    this.agendado = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'prestador': prestador,
        'local': local,
        'preco': preco,
        'descricao': descricao,
        'agendado': agendado,
      };

  factory ServicoModel.fromJson(Map<String, dynamic> json) {
    return ServicoModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      prestador: json['prestador'] as String,
      local: json['local'] as String,
      preco: json['preco'] as String,
      descricao: json['descricao'] as String,
      agendado: json['agendado'] as bool? ?? false,
    );
  }

  ServicoModel copyWith({bool? agendado}) {
    return ServicoModel(
      id: id,
      nome: nome,
      prestador: prestador,
      local: local,
      preco: preco,
      descricao: descricao,
      agendado: agendado ?? this.agendado,
    );
  }
}
