/// Pedido de ajuda publicado no Mural de Pedidos/Ofertas (banco de horas).
class PedidoModel {
  final String id;
  final String titulo;
  final String solicitante;
  final String local;
  final int recompensa;
  final String descricao;
  final bool candidatado;

  const PedidoModel({
    required this.id,
    required this.titulo,
    required this.solicitante,
    required this.local,
    required this.recompensa,
    required this.descricao,
    this.candidatado = false,
  });

  PedidoModel copyWith({bool? candidatado}) {
    return PedidoModel(
      id: id,
      titulo: titulo,
      solicitante: solicitante,
      local: local,
      recompensa: recompensa,
      descricao: descricao,
      candidatado: candidatado ?? this.candidatado,
    );
  }
}
