/// Representa o pet cadastrado pelo tutor.
class PetModel {
  final String id;
  final String nome;
  final String especie;
  final String idade;

  /// Emoji usado como avatar enquanto não há foto real do pet.
  final String avatarEmoji;

  const PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.idade,
    this.avatarEmoji = '🐶',
  });

  PetModel copyWith({
    String? nome,
    String? especie,
    String? idade,
    String? avatarEmoji,
  }) {
    return PetModel(
      id: id,
      nome: nome ?? this.nome,
      especie: especie ?? this.especie,
      idade: idade ?? this.idade,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}
