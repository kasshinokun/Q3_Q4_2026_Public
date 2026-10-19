import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/remote_data_source.dart';
import '../models/atividade_model.dart';
import '../models/pedido_model.dart';
import '../models/perfil_model.dart';
import '../models/pet_model.dart';
import '../models/servico_model.dart';

/// Fonte única de dados do app: perfil do tutor, pet, serviços da rede
/// solidária e pedidos do mural.
///
/// Centralizar essas listas em um [ChangeNotifier] (em vez de espalhar
/// estado mutável pelas telas) é o que permite, por exemplo, que agendar
/// um serviço na Rede Solidária reflita automaticamente no Dashboard e
/// no histórico do Perfil, sem passar callbacks manualmente entre telas.
///
/// Continua 100% funcional offline (dados mockados via [_seed]) mesmo
/// com um [RemoteDataSource] remoto injetado: o mock nunca é removido,
/// apenas complementado. Quando [_remote] é remoto (Firebase/Supabase
/// ativados em `BackendConfig`, ver `main.dart`), cada mutação também é
/// espelhada nele em segundo plano (best-effort, nunca bloqueia nem
/// derruba a UI se a escrita remota falhar) e o estado inicial tenta
/// hidratar do documento remoto antes de cair no mock local.
class AppDataService extends ChangeNotifier {
  AppDataService({RemoteDataSource? remote}) : _remote = remote ?? const LocalDataSource() {
    _seed();
    if (_remote is! LocalDataSource) {
      _hidratarDoRemoto();
    }
  }

  final RemoteDataSource _remote;

  /// Id fixo de documento/linha usado enquanto o app não tem múltiplas
  /// contas reais sincronizadas — na ativação com login remoto, troque
  /// por `AuthService.currentUsername`.
  static const _perfilRemotoId = 'tutor-demo';
  static const _catalogoRemotoId = 'catalogo';

  late PerfilModel perfil;
  final List<ServicoModel> servicos = [];
  final List<PedidoModel> pedidos = [];

  void _seed() {
    perfil = PerfilModel(
      nome: 'Tutor(a) PetCuida',
      email: 'contato@petcuida.exemplo',
      bairro: 'Padre Eustáquio, Belo Horizonte',
      saldoCreditos: 3.5,
      pet: PetModel(
        id: 'pet-1',
        nome: 'Rex',
        especie: 'SRD',
        tipoAnimal: TipoAnimal.cao,
        dataNascimento: DateTime(DateTime.now().year - 3, 4, 12),
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

  /// Tenta carregar o perfil (e, junto, o pet e as atividades) do
  /// backend remoto ativo. Se não houver documento ainda (primeira
  /// execução após ativar o backend), publica o estado local atual
  /// como ponto de partida — assim o remoto nunca fica vazio depois de
  /// ativado. Qualquer falha de rede aqui é silenciosa: o app já está
  /// funcionando com os dados locais.
  Future<void> _hidratarDoRemoto() async {
    try {
      final doc = await _remote.readDocument(collection: 'perfil', id: _perfilRemotoId);
      if (doc != null) {
        perfil = PerfilModel.fromJson(doc);
        notifyListeners();
      } else {
        await _persistirPerfil();
      }
      await _persistirCatalogo();
    } catch (e) {
      debugPrint('AppDataService: hidratação remota falhou (seguindo offline): $e');
    }
  }

  Future<void> _persistirPerfil() async {
    if (_remote is LocalDataSource) return;
    try {
      await _remote.writeDocument(
        collection: 'perfil',
        id: _perfilRemotoId,
        data: perfil.toJson(),
      );
    } catch (e) {
      debugPrint('AppDataService: escrita remota de perfil falhou: $e');
    }
  }

  Future<void> _persistirCatalogo() async {
    if (_remote is LocalDataSource) return;
    try {
      await _remote.writeDocument(
        collection: 'servicos',
        id: _catalogoRemotoId,
        data: {'itens': servicos.map((s) => s.toJson()).toList()},
      );
      await _remote.writeDocument(
        collection: 'pedidos',
        id: _catalogoRemotoId,
        data: {'itens': pedidos.map((p) => p.toJson()).toList()},
      );
    } catch (e) {
      debugPrint('AppDataService: escrita remota de catálogo falhou: $e');
    }
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
    unawaited(_persistirPerfil());
    unawaited(_persistirCatalogo());
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
    unawaited(_persistirPerfil());
    unawaited(_persistirCatalogo());
  }

  void atualizarPet(PetModel pet) {
    perfil = perfil.copyWith(pet: pet);
    notifyListeners();
    unawaited(_persistirPerfil());
  }

  /// Atualiza a foto de perfil do tutor. Passe `null` para voltar ao
  /// avatar padrão (iniciais do nome).
  void atualizarFotoPerfil(String? fotoPath) {
    perfil = perfil.copyWith(fotoPath: fotoPath, limparFoto: fotoPath == null);
    notifyListeners();
    unawaited(_persistirPerfil());
  }
}
