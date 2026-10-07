import 'atividade_model.dart';
import 'pet_model.dart';

/// Perfil do tutor autenticado: dados pessoais, foto, pet principal,
/// saldo de créditos solidários e histórico de atividades.
class PerfilModel {
  final String nome;
  final String email;
  final String bairro;
  final double saldoCreditos;
  final PetModel pet;
  final List<AtividadeModel> atividades;

  /// Caminho local da foto de perfil escolhida pelo tutor (galeria).
  /// `null` quando nenhuma foto foi escolhida — nesse caso a UI usa um
  /// ícone/iniciais como avatar padrão.
  final String? fotoPath;

  const PerfilModel({
    required this.nome,
    required this.email,
    required this.bairro,
    required this.saldoCreditos,
    required this.pet,
    this.atividades = const [],
    this.fotoPath,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'bairro': bairro,
        'saldoCreditos': saldoCreditos,
        'pet': pet.toJson(),
        'atividades': atividades.map((a) => a.toJson()).toList(),
        'fotoPath': fotoPath,
      };

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      nome: json['nome'] as String,
      email: json['email'] as String,
      bairro: json['bairro'] as String,
      saldoCreditos: (json['saldoCreditos'] as num).toDouble(),
      pet: PetModel.fromJson(Map<String, dynamic>.from(json['pet'] as Map)),
      atividades: (json['atividades'] as List? ?? [])
          .map((a) => AtividadeModel.fromJson(Map<String, dynamic>.from(a as Map)))
          .toList(),
      fotoPath: json['fotoPath'] as String?,
    );
  }

  PerfilModel copyWith({
    PetModel? pet,
    double? saldoCreditos,
    List<AtividadeModel>? atividades,
    String? fotoPath,
    bool limparFoto = false,
  }) {
    return PerfilModel(
      nome: nome,
      email: email,
      bairro: bairro,
      saldoCreditos: saldoCreditos ?? this.saldoCreditos,
      pet: pet ?? this.pet,
      atividades: atividades ?? this.atividades,
      fotoPath: limparFoto ? null : (fotoPath ?? this.fotoPath),
    );
  }
}
