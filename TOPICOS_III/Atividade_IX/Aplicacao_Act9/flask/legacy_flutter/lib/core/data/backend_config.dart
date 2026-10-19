/// Backend do PetCuida: pronto para ativação, desligado por padrão.
///
/// A 3i implementa de fato os adaptadores Firebase/Firestore e Supabase
/// (ver [FirebaseFirestoreDataSource] e [SupabaseDataSource]) — eles não
/// são mais stubs que lançam exceção. O que falta para "ativar" um deles
/// na versão de entrega é só:
///
/// 1. Trocar [provider] abaixo de [BackendProvider.local] para o backend
///    escolhido;
/// 2. Preencher as credenciais correspondentes (ou usar variáveis de
///    ambiente/`--dart-define`, nunca comitar chave real no repositório);
/// 3. No caso do Firebase, gerar `lib/firebase_options.dart` com
///    `flutterfire configure` (veja o template em
///    `firebase_options.template.dart`).
///
/// Os pacotes `firebase_core`, `cloud_firestore` e `supabase_flutter`
/// já estão no `pubspec.yaml` (os adaptadores em `core/data/` são
/// implementações reais, não stubs) — não é preciso editar o
/// `pubspec.yaml` para ativar, só rodar `flutter pub get` normalmente.
///
/// Nenhuma outra mudança de código é necessária: [main.dart] já lê esta
/// configuração para inicializar o SDK certo e registrar o
/// [RemoteDataSource] correspondente, e [AppDataService] já espelha toda
/// escrita local para o backend remoto quando [isRemote] é verdadeiro.
enum BackendProvider { local, firebaseFirestore, supabase }

final class BackendConfig {
  const BackendConfig({
    this.provider = BackendProvider.local,
    this.firebaseProjectId,
    this.supabaseUrl,
    this.supabaseAnonKey,
  });

  /// Configuração ativa do app. Mantida em [BackendConfig.current] no
  /// composition root (`main.dart`) — troque apenas esta constante para
  /// ativar um backend real na build de entrega.
  static const BackendConfig current = BackendConfig(
    provider: BackendProvider.local,
    // firebaseProjectId: 'petcuida-prod',
    // supabaseUrl: 'https://xxxxxxxx.supabase.co',
    // supabaseAnonKey: 'ey...',
  );

  final BackendProvider provider;

  /// Usado apenas como referência de log/diagnóstico; a inicialização
  /// real do Firebase usa `firebase_options.dart` (gerado pelo
  /// FlutterFire CLI), não este id diretamente.
  final String? firebaseProjectId;

  final String? supabaseUrl;
  final String? supabaseAnonKey;

  bool get isRemote => provider != BackendProvider.local;

  bool get isFirebase => provider == BackendProvider.firebaseFirestore;

  bool get isSupabase => provider == BackendProvider.supabase;
}
