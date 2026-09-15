import 'atividade_model.dart';
import 'pet_model.dart';

/// Perfil do tutor autenticado: dados pessoais, pet principal, saldo de
/// créditos solidários e histórico de atividades.
class PerfilModel {
  final String nome;
  final String email;
  final String bairro;
  final double saldoCreditos;
  final PetModel pet;
  final List<AtividadeModel> atividades;

  const PerfilModel({
    required this.nome,
    required this.email,
    required this.bairro,
    required this.saldoCreditos,
    required this.pet,
    this.atividades = const [],
  });

  PerfilModel copyWith({
    PetModel? pet,
    double? saldoCreditos,
    List<AtividadeModel>? atividades,
  }) {
    return PerfilModel(
      nome: nome,
      email: email,
      bairro: bairro,
      saldoCreditos: saldoCreditos ?? this.saldoCreditos,
      pet: pet ?? this.pet,
      atividades: atividades ?? this.atividades,
    );
  }
}
