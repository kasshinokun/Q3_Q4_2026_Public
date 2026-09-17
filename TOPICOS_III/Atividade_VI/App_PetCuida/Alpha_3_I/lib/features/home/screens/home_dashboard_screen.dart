import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/feature_tile.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/pet_avatar.dart';
import '../../../core/widgets/section_header.dart';

/// Tela inicial (equivalente ao `homeSection==='dashboard'` da PWA):
/// saudação, cartão de destaque do pet, atalhos para as áreas principais
/// e um aviso sobre o próximo cuidado agendado.
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthService>().currentUsername ?? 'petcuida';
    final data = context.watch<AppDataService>();
    final pet = data.perfil.pet;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        Text('Olá, $username.', style: AppTheme.display(size: 24, letterSpacing: -1)),
        const SizedBox(height: 4),
        const Text(
          'Um cuidado de cada vez faz toda diferença.',
          style: TextStyle(fontSize: 13, color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.pink, Color(0xFFFBE4DF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('O cuidado do ${pet.nome} está em dia?', style: AppTheme.display(size: 18, color: AppColors.pinkInk)),
              const SizedBox(height: 7),
              Text(
                'Acompanhe vacinas, histórico e encontre ajuda quando precisar.',
                style: TextStyle(fontSize: 12, color: AppColors.pinkInk.withValues(alpha: 0.9), height: 1.45),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.diamond_outlined, size: 15, color: AppColors.pinkInk),
                    const SizedBox(width: 6),
                    Text(
                      '${data.perfil.saldoCreditos} créditos solidários',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.pinkInk),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'O que você precisa hoje?'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FeatureTile(
              icon: Icons.favorite_outline,
              title: 'Área do Pet',
              subtitle: 'Vacinas, rotina e prontuário',
              background: AppColors.pink,
              foreground: AppColors.pinkInk,
              onTap: () => context.go(AppRoutes.pet),
            ),
            const SizedBox(height: 11), // Espaçamento entre os cards
            FeatureTile(
              icon: Icons.auto_awesome_outlined,
              title: 'Triagem orientativa',
              subtitle: 'Entenda o próximo passo',
              background: AppColors.yellow,
              foreground: AppColors.yellowInk,
              onTap: () => context.go(AppRoutes.triagem),
            ),
            const SizedBox(height: 11), // Espaçamento entre os cards
            FeatureTile(
              icon: Icons.volunteer_activism_outlined,
              title: 'Rede solidária',
              subtitle: 'Serviços e pedidos locais',
              background: AppColors.navySoft,
              foreground: AppColors.navy,
              onTap: () => context.go(AppRoutes.rede),
            ),
          ],
        ),
        SectionHeader(title: 'Pet em destaque', actionLabel: 'Ver área do pet', onAction: () => context.go(AppRoutes.pet)),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => context.go(AppRoutes.pet),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.pink, borderRadius: BorderRadius.circular(15)),
                    child: PetAvatar(pet: pet, size: 48, background: AppColors.pink),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pet.nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 3),
                        Text(
                          '${pet.tipoAnimal.label} · ${pet.idadeLabel}',
                          style: const TextStyle(fontSize: 11, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.navy),
                ],
              ),
            ),
          ),
        ),
        const NoticeBanner(
          icon: Icons.schedule_outlined,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Próximo cuidado\n', style: TextStyle(fontWeight: FontWeight.w800)),
                TextSpan(text: 'Vacinação V10 agendada para 15/09.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
