/// Contrato agnóstico para persistência remota do PetCuida.
///
/// Os adaptadores [FirebaseFirestoreDataSource] e [SupabaseDataSource]
/// (nesta mesma pasta) já são implementações reais, não stubs — o que
/// permanece dormente é apenas o *registro* deles no composition root:
/// enquanto [BackendConfig.current.provider] for [BackendProvider.local],
/// `main.dart` continua injetando [LocalDataSource] e o app funciona
/// 100% offline, com os dados mockados de [AppDataService]. Ativar um
/// backend real na versão de entrega é só trocar essa configuração (ver
/// `backend_config.dart`) — nenhuma tela ou modelo de domínio precisa
/// mudar.
abstract interface class RemoteDataSource {
  Future<Map<String, dynamic>?> readDocument({required String collection, required String id});

  Future<void> writeDocument({required String collection, required String id, required Map<String, dynamic> data});

  Future<void> deleteDocument({required String collection, required String id});

  Stream<List<Map<String, dynamic>>> watchCollection({required String collection});
}

/// Implementação temporária para desenvolvimento offline.
/// Não persiste nada: serve apenas para manter a aplicação explicitamente
/// desacoplada enquanto o backend ainda não foi ativado.
final class LocalDataSource implements RemoteDataSource {
  const LocalDataSource();

  @override
  Future<Map<String, dynamic>?> readDocument({required String collection, required String id}) async => null;

  @override
  Future<void> writeDocument({required String collection, required String id, required Map<String, dynamic> data}) async {}

  @override
  Future<void> deleteDocument({required String collection, required String id}) async {}

  @override
  Stream<List<Map<String, dynamic>>> watchCollection({required String collection}) => const Stream.empty();
}

/// Erro usado pelos adaptadores dormentes quando alguém tenta ativá-los antes
/// de instalar/configurar o SDK correspondente.
final class BackendNotConfiguredException implements Exception {
  const BackendNotConfiguredException(this.backend);

  final String backend;

  @override
  String toString() => 'Backend "$backend" ainda não está configurado.';
}
