import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/data/backend_config.dart';
import 'core/data/firebase_firestore_data_source.dart';
import 'core/data/remote_data_source.dart';
import 'core/data/supabase_data_source.dart';
import 'core/routes/app_router.dart';
import 'core/services/app_data_service.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  final remote = await _prepararBackend(BackendConfig.current);
  runApp(PetCuidaApp(remote: remote));
}

/// Inicializa o SDK do backend escolhido (se algum) e devolve o
/// [RemoteDataSource] correspondente para injeção no composition root.
///
/// Enquanto [BackendConfig.current.provider] for [BackendProvider.local]
/// (padrão da entrega alfa), esta função não toca em rede nenhuma e
/// devolve [LocalDataSource] — o app continua 100% offline. Trocar o
/// provider em `backend_config.dart` é a única mudança necessária para
/// "ativar" um backend real (ver `core/data/README.md`).
Future<RemoteDataSource> _prepararBackend(BackendConfig config) async {
  switch (config.provider) {
    case BackendProvider.local:
      return const LocalDataSource();

    case BackendProvider.firebaseFirestore:
      WidgetsFlutterBinding.ensureInitialized();
      // Usa a configuração nativa da plataforma (google-services.json
      // no Android / GoogleService-Info.plist no iOS). Se preferir
      // gerar `lib/firebase_options.dart` com `flutterfire configure`
      // (template em core/data/firebase_options.template.dart), troque
      // esta chamada por:
      //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await Firebase.initializeApp();
      return FirebaseFirestoreDataSource(firestore: FirebaseFirestore.instance);

    case BackendProvider.supabase:
      WidgetsFlutterBinding.ensureInitialized();
      await Supabase.initialize(
        url: config.supabaseUrl ?? '',
        anonKey: config.supabaseAnonKey ?? '',
      );
      return SupabaseDataSource(client: Supabase.instance.client);
  }
}

/// Widget raiz do PetCuida.
///
/// Os serviços de estado ([AuthService] e [AppDataService]) são criados
/// uma única vez aqui e disponibilizados via `provider` para todo o app.
/// [AppDataService] recebe o [RemoteDataSource] resolvido em [main] —
/// local por padrão, ou Firebase/Supabase quando ativado em
/// `BackendConfig`. O [GoRouter] é construído a partir do [AuthService]
/// para que login, logout e onboarding disparem redirecionamentos
/// automáticos — nenhuma tela precisa saber "para onde ir" depois de
/// autenticar.
class PetCuidaApp extends StatefulWidget {
  const PetCuidaApp({super.key, required this.remote});

  final RemoteDataSource remote;

  @override
  State<PetCuidaApp> createState() => _PetCuidaAppState();
}

class _PetCuidaAppState extends State<PetCuidaApp> {
  late final AuthService _authService;
  late final AppDataService _appDataService;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _appDataService = AppDataService(remote: widget.remote);
    _router = buildAppRouter(_authService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _appDataService),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'PetCuida',
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
