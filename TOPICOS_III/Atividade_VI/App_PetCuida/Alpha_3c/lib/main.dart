import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/services/app_data_service.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const PetCuidaApp());
}

/// Widget raiz do PetCuida.
///
/// Os serviços de estado ([AuthService] e [AppDataService]) são criados
/// uma única vez aqui e disponibilizados via `provider` para todo o app.
/// O [GoRouter] é construído a partir do [AuthService] para que login,
/// logout e onboarding disparem redirecionamentos automáticos — nenhuma
/// tela precisa saber "para onde ir" depois de autenticar.
class PetCuidaApp extends StatefulWidget {
  const PetCuidaApp({super.key});

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
    _appDataService = AppDataService();
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
