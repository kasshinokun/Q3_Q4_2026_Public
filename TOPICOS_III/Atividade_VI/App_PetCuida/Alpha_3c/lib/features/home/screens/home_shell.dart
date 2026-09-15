import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/brand_mark.dart';

/// Casca visual persistente das telas principais: cabeçalho com marca e
/// atalho para o Perfil, e a barra de navegação inferior. O conteúdo de
/// cada aba é injetado pelo [ShellRoute] do go_router (ver app_router.dart).
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
        title: Row(
          children: const [
            BrandMark(size: 32),
            SizedBox(width: 10),
            Text('PetCuida', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Perfil de ${perfil.nome}',
            icon: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person_outline, color: Colors.white, size: 20),
            ),
            onPressed: () => context.push(AppRoutes.perfil),
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
