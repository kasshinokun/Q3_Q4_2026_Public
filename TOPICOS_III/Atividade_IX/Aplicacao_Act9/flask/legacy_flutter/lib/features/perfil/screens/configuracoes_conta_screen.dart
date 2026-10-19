import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Configurações da conta: preferências do tutor. Nesta versão alfa os
/// controles são apenas visuais (estado local), sem persistência real.
class ConfiguracoesContaScreen extends StatefulWidget {
  const ConfiguracoesContaScreen({super.key});

  @override
  State<ConfiguracoesContaScreen> createState() => _ConfiguracoesContaScreenState();
}

class _ConfiguracoesContaScreenState extends State<ConfiguracoesContaScreen> {
  bool _notificacoesPush = true;
  bool _lembretesVacina = true;
  bool _emailsNovidades = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Configurações da conta',
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Notificações', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          _SwitchTile(
            title: 'Notificações push',
            subtitle: 'Alertas gerais do aplicativo',
            value: _notificacoesPush,
            onChanged: (v) => setState(() => _notificacoesPush = v),
          ),
          _SwitchTile(
            title: 'Lembretes de vacina',
            subtitle: 'Avisos sobre o calendário preventivo',
            value: _lembretesVacina,
            onChanged: (v) => setState(() => _lembretesVacina = v),
          ),
          _SwitchTile(
            title: 'E-mails de novidades',
            subtitle: 'Comunicados e conteúdos da rede',
            value: _emailsNovidades,
            onChanged: (v) => setState(() => _emailsNovidades = v),
          ),
          const SizedBox(height: 18),
          const Text('Conta', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.line)),
            leading: const Icon(Icons.lock_outline, color: AppColors.navy),
            title: const Text('Alterar senha', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Disponível em uma próxima etapa.'))),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({required this.title, required this.subtitle, required this.value, required this.onChanged});

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: SwitchListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.line)),
        value: value,
        onChanged: onChanged,

        // Substitua:
        // activeColor: AppColors.navy,

        // Por:
        activeThumbColor: AppColors.navy,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}
