import 'package:flutter/foundation.dart';

import '../models/atividade_model.dart';
import '../models/pedido_model.dart';
import '../models/perfil_model.dart';
import '../models/pet_model.dart';
import '../models/servico_model.dart';

/// Fonte única de dados mockados do protótipo: perfil do tutor, pet,
/// serviços da rede solidária e pedidos do mural.
///
/// Centralizar essas listas em um [ChangeNotifier] (em vez de espalhar
/// estado mutável pelas telas) é o que permite, por exemplo, que agendar
/// um serviço na Rede Solidária reflita automaticamente no Dashboard e
/// no histórico do Perfil, sem passar callbacks manualmente entre telas.
class AppDataService extends ChangeNotifier {
  AppDataService() {
    _seed();
  }

  late PerfilModel perfil;
  final List<ServicoModel> servicos = [];
  final List<PedidoModel> pedidos = [];

  void _seed() {
    perfil = PerfilModel(
      nome: 'Tutor(a) PetCuida',
      email: 'contato@petcuida.exemplo',
      bairro: 'Padre Eustáquio, Belo Horizonte',
      saldoCreditos: 3.5,
      pet: const PetModel(
        id: 'pet-1',
        nome: 'Rex',
        especie: 'Cão, SRD',
        idade: '3 anos',
      ),
      atividades: const [
        AtividadeModel(
          id: 'a1',
          nome: 'Consulta veterinária de rotina',
          status: AtividadeStatus.concluido,
          data: '02/08/2026',
          variacaoCreditos: null,
        ),
        AtividadeModel(
          id: 'a2',
          nome: 'Vacinação V10',
          status: AtividadeStatus.agendado,
          data: '15/09/2026',
          variacaoCreditos: null,
        ),
      ],
    );

    servicos.addAll(const [
      ServicoModel(
        id: 's1',
        nome: 'Consulta veterinária de rotina',
        prestador: 'Clínica PetCuida',
        local: 'Padre Eustáquio',
        preco: 'R\$ 60',
        descricao: 'Avaliação clínica geral com veterinário credenciado.',
      ),
      ServicoModel(
        id: 's2',
        nome: 'Vacinação V10',
        prestador: 'Clínica PetCuida',
        local: 'Padre Eustáquio',
        preco: 'R\$ 45',
        descricao: 'Aplicação de vacina múltipla e atualização do prontuário.',
      ),
      ServicoModel(
        id: 's3',
        nome: 'Castração',
        prestador: 'Clínica PetCuida',
        local: 'Padre Eustáquio',
        preco: 'R\$ 120',
        descricao: 'Pagamento misto com créditos + dinheiro.',
      ),
      ServicoModel(
        id: 's4',
        nome: 'Banho e tosa',
        prestador: 'Ana Pet Estética',
        local: 'Floresta',
        preco: 'R\$ 35',
        descricao: 'Higienização completa e corte de unhas.',
      ),
    ]);

    pedidos.addAll(const [
      PedidoModel(
        id: 'p1',
        titulo: 'Levar cão ao veterinário amanhã',
        solicitante: 'Marcos T.',
        local: 'Padre Eustáquio',
        recompensa: 2,
        descricao: 'Ajuda para transportar o cão até a Clínica PetCuida.',
      ),
      PedidoModel(
        id: 'p2',
        titulo: 'Cuidar do gato por 2 dias',
        solicitante: 'Renata A.',
        local: 'Floresta',
        recompensa: 4,
        descricao: 'Alimentar e dar atenção ao gato durante uma viagem.',
      ),
      PedidoModel(
        id: 'p3',
        titulo: 'Passear com 2 cães à tarde',
        solicitante: 'Carla S.',
        local: 'Prado',
        recompensa: 1,
        descricao: 'Passeio diário de 30 minutos.',
      ),
    ]);
  }

  void agendarServico(String servicoId) {
    final index = servicos.indexWhere((s) => s.id == servicoId);
    if (index == -1 || servicos[index].agendado) return;

    servicos[index] = servicos[index].copyWith(agendado: true);

    perfil = perfil.copyWith(
      atividades: [
        AtividadeModel(
          id: 'atv-${DateTime.now().microsecondsSinceEpoch}',
          nome: servicos[index].nome,
          status: AtividadeStatus.agendado,
          data: 'Hoje',
        ),
        ...perfil.atividades,
      ],
    );
    notifyListeners();
  }

  void candidatarPedido(String pedidoId) {
    final index = pedidos.indexWhere((p) => p.id == pedidoId);
    if (index == -1 || pedidos[index].candidatado) return;

    pedidos[index] = pedidos[index].copyWith(candidatado: true);

    perfil = perfil.copyWith(
      atividades: [
        AtividadeModel(
          id: 'atv-${DateTime.now().microsecondsSinceEpoch}',
          nome: pedidos[index].titulo,
          status: AtividadeStatus.emAndamento,
          data: 'Hoje',
        ),
        ...perfil.atividades,
      ],
    );
    notifyListeners();
  }

  void atualizarPet(PetModel pet) {
    perfil = perfil.copyWith(pet: pet);
    notifyListeners();
  }
}
