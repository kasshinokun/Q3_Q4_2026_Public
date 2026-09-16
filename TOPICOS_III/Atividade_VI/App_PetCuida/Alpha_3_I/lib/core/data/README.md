# Camada de dados remota (Firebase/Firestore ou Supabase)

A 3i implementa de fato os dois adaptadores desta pasta —
`FirebaseFirestoreDataSource` e `SupabaseDataSource` não são mais stubs
que lançam exceção, são código funcional que fala com o SDK real. O
alfa continua **offline por padrão**: `BackendConfig.current.provider`
está em `BackendProvider.local`, então `main.dart` injeta
`LocalDataSource` e tudo funciona com os dados mockados de
`AppDataService`, sem rede.

## Ativação na versão de entrega

Sem precisar tocar em nenhuma tela ou modelo de domínio:

1. Em `backend_config.dart`, troque `BackendConfig.current.provider`
   para `BackendProvider.firebaseFirestore` **ou**
   `BackendProvider.supabase`.
2. **Firebase**: rode `flutterfire configure` na raiz do projeto para
   gerar `lib/firebase_options.dart` (há um template comentado em
   `firebase_options.template.dart`). **Supabase**: preencha
   `supabaseUrl`/`supabaseAnonKey` em `BackendConfig.current` (ou, melhor,
   via `--dart-define` para não commitar as chaves).
3. Rode `flutter pub get` (os pacotes `firebase_core`, `cloud_firestore`
   e `supabase_flutter` já estão declarados no `pubspec.yaml` — nenhuma
   edição é necessária aqui, eles só ficam sem uso enquanto o provider
   for `local`).
4. Rode o app normalmente. `main.dart` já:
   - inicializa o SDK certo antes de `runApp` quando `isRemote` é
     verdadeiro;
   - registra o `RemoteDataSource` correspondente via `Provider`;
   - e `AppDataService` já espelha toda escrita local (agendar serviço,
     candidatar-se a pedido, atualizar pet/foto) para o backend ativo.

## Modelo de dados esperado

Cada "documento"/linha usa as mesmas coleções/tabelas:
`perfil`, `pets`, `servicos`, `pedidos`, `atividades`, todas com um
campo/coluna `id` (texto) como chave — o mesmo `id` já usado nos
modelos de domínio (`PerfilModel`, `PetModel`, etc.), então não há
tradução de esquema a fazer.

Nenhuma chave de API deve ser versionada no repositório. Use
`--dart-define`, secrets do CI/CD e regras de segurança
(Firestore Rules / Supabase RLS) no próprio backend.
