import 'package:supabase_flutter/supabase_flutter.dart';

import 'remote_data_source.dart';

/// Adaptador real para Supabase (Postgres + Realtime).
///
/// Implementação completa desde a 3i: mapeia [readDocument]/
/// [writeDocument]/[deleteDocument]/[watchCollection] para operações do
/// `supabase_flutter`, usando `collection` como nome da tabela e um
/// registro com coluna primária `id` como "documento" — assim o
/// contrato [RemoteDataSource] fica idêntico ao do Firestore e as
/// telas continuam desacopladas do backend escolhido.
///
/// Pré-requisitos para ativar (ver `backend_config.dart` e `README.md`
/// desta pasta):
/// - `supabase_flutter` no `pubspec.yaml`;
/// - `Supabase.initialize(url: ..., anonKey: ...)` chamado em
///   `main.dart` antes de `runApp` (feito automaticamente quando o
///   provider é [BackendProvider.supabase], usando
///   `BackendConfig.current.supabaseUrl`/`supabaseAnonKey`);
/// - as tabelas (`perfil`, `pets`, `servicos`, `pedidos`, `atividades`)
///   criadas no projeto Supabase com uma coluna `id` (texto) como chave
///   primária, e Row Level Security configurada conforme a política de
///   acesso desejada.
final class SupabaseDataSource implements RemoteDataSource {
  SupabaseDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<Map<String, dynamic>?> readDocument({
    required String collection,
    required String id,
  }) async {
    final rows = await _client.from(collection).select().eq('id', id).limit(1);
    if (rows.isEmpty) return null;
    return Map<String, dynamic>.from(rows.first as Map);
  }

  @override
  Future<void> writeDocument({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    // `upsert` faz insert-ou-update em uma única chamada, com base na
    // chave primária `id` — equivalente ao `set(..., merge: true)` do
    // Firestore para os campos informados.
    await _client.from(collection).upsert({...data, 'id': id});
  }

  @override
  Future<void> deleteDocument({
    required String collection,
    required String id,
  }) async {
    await _client.from(collection).delete().eq('id', id);
  }

  @override
  Stream<List<Map<String, dynamic>>> watchCollection({required String collection}) {
    return _client
        .from(collection)
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((row) => Map<String, dynamic>.from(row)).toList(growable: false));
  }
}
