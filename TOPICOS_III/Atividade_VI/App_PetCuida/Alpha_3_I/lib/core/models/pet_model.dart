/// Categoria geral do pet, usada para escolher o ícone/emoji padrão
/// quando o tutor ainda não adicionou uma foto real.
enum TipoAnimal { cao, gato, passaro, outro }

extension TipoAnimalLabel on TipoAnimal {
  String get label => switch (this) {
        TipoAnimal.cao => 'Cão',
        TipoAnimal.gato => 'Gato',
        TipoAnimal.passaro => 'Pássaro',
        TipoAnimal.outro => 'Outro',
      };

  /// Emoji usado como avatar padrão enquanto não há foto do pet.
  String get emoji => switch (this) {
        TipoAnimal.cao => '🐶',
        TipoAnimal.gato => '🐱',
        TipoAnimal.passaro => '🐦',
        TipoAnimal.outro => '🐾',
      };
}

/// Representa o pet cadastrado pelo tutor.
class PetModel {
  final String id;
  final String nome;

  /// Raça/observação livre (ex.: "SRD", "Golden Retriever").
  final String especie;

  /// Categoria do animal (Cão, Gato, Pássaro, Outro), usada sobretudo
  /// para escolher o emoji padrão quando não há foto cadastrada.
  final TipoAnimal tipoAnimal;

  /// Data de nascimento do pet. A idade em anos é sempre calculada a
  /// partir dela (ver [idadeAnos]) em vez de armazenada diretamente,
  /// para nunca ficar desatualizada.
  final DateTime dataNascimento;

  /// Caminho local da foto do pet escolhida pelo tutor (galeria).
  /// `null` quando nenhuma foto foi escolhida — nesse caso a UI usa o
  /// emoji de [tipoAnimal] como avatar.
  final String? fotoPath;

  const PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.dataNascimento,
    this.tipoAnimal = TipoAnimal.outro,
    this.fotoPath,
  });

  /// Idade em anos completos, calculada como a diferença entre a data
  /// atual e [dataNascimento] — nunca armazenada, sempre recalculada.
  int get idadeAnos {
    final hoje = DateTime.now();
    var anos = hoje.year - dataNascimento.year;
    final aniversarioEsteAno = DateTime(hoje.year, dataNascimento.month, dataNascimento.day);
    if (hoje.isBefore(aniversarioEsteAno)) anos -= 1;
    return anos < 0 ? 0 : anos;
  }

  /// Texto pronto para exibição (ex.: "3 anos", "6 meses" para filhotes
  /// com menos de 1 ano de vida).
  String get idadeLabel {
    if (idadeAnos >= 1) return '$idadeAnos ${idadeAnos == 1 ? "ano" : "anos"}';
    final hoje = DateTime.now();
    var meses = (hoje.year - dataNascimento.year) * 12 + (hoje.month - dataNascimento.month);
    if (hoje.day < dataNascimento.day) meses -= 1;
    meses = meses < 0 ? 0 : meses;
    return '$meses ${meses == 1 ? "mês" : "meses"}';
  }

  /// Serializa para um mapa simples (chaves String, valores primitivos),
  /// pronto para persistência remota (Firestore/Supabase) — ver
  /// `core/data/`.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'especie': especie,
        'tipoAnimal': tipoAnimal.name,
        'dataNascimento': dataNascimento.toIso8601String(),
        'fotoPath': fotoPath,
      };

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      especie: json['especie'] as String,
      tipoAnimal: TipoAnimal.values.firstWhere(
        (t) => t.name == json['tipoAnimal'],
        orElse: () => TipoAnimal.outro,
      ),
      dataNascimento: DateTime.parse(json['dataNascimento'] as String),
      fotoPath: json['fotoPath'] as String?,
    );
  }

  PetModel copyWith({
    String? nome,
    String? especie,
    TipoAnimal? tipoAnimal,
    DateTime? dataNascimento,
    String? fotoPath,
    bool limparFoto = false,
  }) {
    return PetModel(
      id: id,
      nome: nome ?? this.nome,
      especie: especie ?? this.especie,
      tipoAnimal: tipoAnimal ?? this.tipoAnimal,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      fotoPath: limparFoto ? null : (fotoPath ?? this.fotoPath),
    );
  }
}
