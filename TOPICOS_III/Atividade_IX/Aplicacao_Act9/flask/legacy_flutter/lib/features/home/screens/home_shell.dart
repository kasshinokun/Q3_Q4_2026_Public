import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/user_avatar.dart';

/// Casca visual persistente das telas principais.
///
/// O cabeçalho tem dois pontos de entrada distintos, de propósito:
/// - a **marca** (à esquerda) abre um menu rápido com "Sobre, termos e
///   privacidade" — informações institucionais do app, não do usuário;
/// - o **avatar** (à direita) leva direto ao Perfil do tutor — dados e
///   configurações pessoais.
///
/// O conteúdo de cada aba é injetado pelo [ShellRoute] do go_router
/// (ver app_router.dart); a barra de navegação inferior fica fixa.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const _tabs = [AppRoutes.home, AppRoutes.pet, AppRoutes.triagem, AppRoutes.rede];

  int get _currentIndex {
    final index = _tabs.indexOf(location);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<AppDataService>().perfil;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        titleSpacing: 16,
        title: const _BrandMenuButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Tooltip(
              message: 'Perfil de ${perfil.nome}',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.push(AppRoutes.perfil),
                child: UserAvatar(
                  nome: perfil.nome,
                  fotoPath: perfil.fotoPath,
                  radius: 17,
                  background: Colors.white24,
                  foreground: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => context.go(_tabs[index]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Meu pet'),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Triagem',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'Rede',
          ),
        ],
      ),
    );
  }
}

/// Botão da marca no cabeçalho: abre um menu curto com informações
/// institucionais do app (hoje só "Sobre", mas o espaço já comporta
/// futuros itens como "Ajuda rápida" ou "Novidades da versão").
class _BrandMenuButton extends StatelessWidget {
  const _BrandMenuButton();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Sobre o PetCuida',
      offset: const Offset(0, 46),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      onSelected: (value) {
        if (value == 'sobre') {
          debugPrint('→ push ${AppRoutes.sobre}');
          context.push(AppRoutes.sobre);
        }
      },

      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          enabled: false,
          height: 36,
          child: Text(
            'PETCUIDA · VERSÃO ALFA',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 0.6),
          ),
        ),
        PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'sobre',
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.navy),
              SizedBox(width: 10),
              Text('Sobre, termos e privacidade', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          BrandMark(size: 32),
          SizedBox(width: 10),
          Text('PetCuida', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Colors.white)),
          SizedBox(width: 2),
          Icon(Icons.expand_more_rounded, size: 20, color: Colors.white70),
        ],
      ),
    );
  }
}
