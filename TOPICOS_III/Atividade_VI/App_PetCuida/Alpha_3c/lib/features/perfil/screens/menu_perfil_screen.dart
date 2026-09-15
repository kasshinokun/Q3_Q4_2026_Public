import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/atividade_model.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/tag_chip.dart';

/// Hub do Perfil do tutor: dados pessoais, saldo, pet cadastrado,
/// atividade recente e atalhos para Saldo/Extrato, Agendamentos,
/// Configurações e Suporte — além do logout.
class MenuPerfilScreen extends StatelessWidget {
  const MenuPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final perfil = context.watch<AppDataService>().perfil;
    final username = auth.currentUsername ?? 'petcuida';

    return AppScaffold(
      title: 'Perfil',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.lavenderStrong,
                  child: Text(
                    username.isNotEmpty ? username[0].toUpperCase() : 'P',
                    style: AppTheme.display(size: 21, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(perfil.nome, style: AppTheme.display(size: 16, color: AppColors.lavenderInk)),
                      const SizedBox(height: 3),
                      Text('@$username · ${perfil.email}', style: const TextStyle(fontSize: 11, color: AppColors.lavenderInk)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                _InfoRow(label: 'Saldo de créditos', value: '${perfil.saldoCreditos} cr.'),
                _InfoRow(label: 'Pet cadastrado', value: '${perfil.pet.nome} (${perfil.pet.especie})'),
                _InfoRow(label: 'Bairro', value: perfil.bairro, isLast: true),
              ],
            ),
          ),
          const SectionHeader(title: 'Atalhos'),
          _MenuTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Saldo / Extrato de créditos',
            onTap: () => context.push(AppRoutes.perfilSaldo),
          ),
          const SizedBox(height: 9),
          _MenuTile(
            icon: Icons.event_note_outlined,
            title: 'Meus agendamentos',
            onTap: () => context.push(AppRoutes.perfilAgendamentos),
          ),
          const SizedBox(height: 9),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Configurações da conta',
            onTap: () => context.push(AppRoutes.perfilConfiguracoes),
          ),
          const SizedBox(height: 9),
          _MenuTile(
            icon: Icons.help_outline,
            title: 'Suporte humano / Ajuda',
            onTap: () => context.push(AppRoutes.perfilSuporte),
          ),
          const SectionHeader(title: 'Atividade recente'),
          ...perfil.atividades.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  title: Text(a.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  subtitle: Text(a.data, style: const TextStyle(fontSize: 11)),
                  trailing: TagChip(
                    label: a.status.label,
                    variant: switch (a.status) {
                      AtividadeStatus.concluido => TagVariant.good,
                      AtividadeStatus.agendado => TagVariant.warn,
                      AtividadeStatus.emAndamento => TagVariant.neutral,
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              auth.logout();
              context.go(AppRoutes.login);
            },
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
            child: const Text('Sair da conta'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.line)),
      leading: CircleAvatar(backgroundColor: AppColors.navySoft, child: Icon(icon, color: AppColors.navy, size: 18)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
