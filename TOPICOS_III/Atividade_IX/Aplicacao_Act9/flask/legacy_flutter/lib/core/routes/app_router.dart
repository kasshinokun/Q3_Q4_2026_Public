import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/cadastro_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/onboarding_pet_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/home/screens/home_dashboard_screen.dart';
import '../../features/home/screens/home_shell.dart';
import '../../features/home/screens/sobre_screen.dart';

import '../../features/perfil/screens/configuracoes_conta_screen.dart';
import '../../features/perfil/screens/menu_perfil_screen.dart';
import '../../features/perfil/screens/meus_agendamentos_screen.dart';
import '../../features/perfil/screens/saldo_extrato_screen.dart';
import '../../features/perfil/screens/suporte_ajuda_screen.dart';
import '../../features/pet/screens/adicionar_editar_pet_screen.dart';
import '../../features/pet/screens/area_do_pet_screen.dart';
import '../../features/pet/screens/calendario_vacinas_screen.dart';
import '../../features/pet/screens/gerar_qrcode_screen.dart';
import '../../features/pet/screens/prontuario_historico_screen.dart';
import '../../features/rede_solidaria/screens/agendamento_horario_screen.dart';
import '../../features/rede_solidaria/screens/checkout_hibrido_screen.dart';
import '../../features/rede_solidaria/screens/clinicas_usar_creditos_screen.dart';
import '../../features/rede_solidaria/screens/mapa_clinicas_screen.dart';
import '../../features/rede_solidaria/screens/mural_pedidos_ofertas_screen.dart';
import '../../features/rede_solidaria/screens/rede_solidaria_screen.dart';
import '../../features/triagem/screens/chat_orientacao_screen.dart';
import '../../features/triagem/screens/triagem_orientativa_screen.dart';
import '../models/servico_model.dart';
import '../services/auth_service.dart';

/// Nomes de rota centralizados: evita strings soltas espalhadas pelas
/// telas e facilita renomear caminhos sem quebrar `context.go(...)`.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const cadastro = '/cadastro';
  static const onboarding = '/onboarding-pet';


  static const home = '/home';
  static const pet = '/home/pet';
  static const triagem = '/home/triagem';
  static const rede = '/home/rede';

  // Antes: Sobre = '/home/sobre'  (dentro do ShellRoute)
  // Agora: rota de tela cheia, irmã das demais rotas "full screen".
  static const sobre = '/sobre';

  static const petEditar = '/home/pet/editar';
  static const petVacinas = '/home/pet/vacinas';
  static const petProntuario = '/home/pet/prontuario';
  static const petQrCode = '/home/pet/qrcode';

  static const triagemChat = '/home/triagem/chat';

  static const redeClinicas = '/home/rede/clinicas';
  static const redeMapa = '/home/rede/mapa';
  static const redeMural = '/home/rede/mural';
  static const redeAgendamento = '/home/rede/agendamento';
  static const redeCheckout = '/home/rede/checkout';

  static const perfil = '/perfil';
  static const perfilSaldo = '/perfil/saldo';
  static const perfilAgendamentos = '/perfil/agendamentos';
  static const perfilConfiguracoes = '/perfil/configuracoes';
  static const perfilSuporte = '/perfil/suporte';

}

/// Constrói o [GoRouter] do app. Recebe [authService] para reagir a
/// login/logout/onboarding via `refreshListenable`, garantindo que o
/// redirecionamento aconteça automaticamente sem lógica duplicada nas telas.
GoRouter buildAppRouter(AuthService authService) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authService,
    redirect: (context, state) {
      // A splash decide sozinha quando sair (ver SplashScreen), então o
      // redirect não deve competir com ela enquanto a animação roda.
      if (state.matchedLocation == AppRoutes.splash) return null;

      final loggedIn = authService.isAuthenticated;
      final goingToAuth = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.cadastro;
      final goingToOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (!loggedIn) {
        return goingToAuth ? null : AppRoutes.login;
      }
      if (authService.needsOnboarding) {
        return goingToOnboarding ? null : AppRoutes.onboarding;
      }
      if (goingToAuth || goingToOnboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginScreen(successMessage: state.extra as String?),
      ),
      GoRoute(path: AppRoutes.cadastro, builder: (context, state) => const CadastroScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingPetScreen()),

      // Shell com bottom navigation — mantém a barra inferior fixa enquanto
      // troca apenas o conteúdo entre Início / Meu pet / Triagem / Rede.
      ShellRoute(
        builder: (context, state, child) => HomeShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeDashboardScreen()),
          GoRoute(path: AppRoutes.pet, builder: (context, state) => const AreaDoPetScreen()),
          GoRoute(path: AppRoutes.triagem, builder: (context, state) => const TriagemOrientativaScreen()),
          GoRoute(path: AppRoutes.rede, builder: (context, state) => const RedeSolidariaScreen()),
          // ❌ GoRoute(path: AppRoutes.Sobre, ...)  — REMOVIDO daqui
        ],
      ),

      // ✅ AQUI, no topo — fora do ShellRoute
      GoRoute(path: AppRoutes.sobre, builder: (context, state) => const SobreScreen()),

      GoRoute(path: AppRoutes.petEditar, builder: (context, state) => const AdicionarEditarPetScreen()),
      GoRoute(path: AppRoutes.petVacinas, builder: (context, state) => const CalendarioVacinasScreen()),
      GoRoute(path: AppRoutes.petProntuario, builder: (context, state) => const ProntuarioHistoricoScreen()),
      GoRoute(path: AppRoutes.petQrCode, builder: (context, state) => const GerarQrCodeScreen()),

      GoRoute(path: AppRoutes.triagemChat, builder: (context, state) => const ChatOrientacaoScreen()),

      GoRoute(path: AppRoutes.redeClinicas, builder: (context, state) => const ClinicasUsarCreditosScreen()),
      GoRoute(path: AppRoutes.redeMapa, builder: (context, state) => const MapaClinicasScreen()),
      GoRoute(path: AppRoutes.redeMural, builder: (context, state) => const MuralPedidosOfertasScreen()),
      GoRoute(
        path: AppRoutes.redeAgendamento,
        builder: (context, state) => AgendamentoHorarioScreen(servico: state.extra as ServicoModel),
      ),
      GoRoute(
        path: AppRoutes.redeCheckout,
        builder: (context, state) => CheckoutHibridoScreen(servico: state.extra as ServicoModel),
      ),

      GoRoute(path: AppRoutes.perfil, builder: (context, state) => const MenuPerfilScreen()),
      GoRoute(path: AppRoutes.perfilSaldo, builder: (context, state) => const SaldoExtratoScreen()),
      GoRoute(path: AppRoutes.perfilAgendamentos, builder: (context, state) => const MeusAgendamentosScreen()),
      GoRoute(path: AppRoutes.perfilConfiguracoes, builder: (context, state) => const ConfiguracoesContaScreen()),
      GoRoute(path: AppRoutes.perfilSuporte, builder: (context, state) => const SuporteAjudaScreen()),

    ],
  );
}
