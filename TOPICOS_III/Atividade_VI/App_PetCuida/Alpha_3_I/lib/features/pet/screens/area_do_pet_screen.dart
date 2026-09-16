import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pet_avatar.dart';

class AreaDoPetScreen extends StatelessWidget {
  const AreaDoPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<AppDataService>().perfil.pet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Pet', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(Icons.pets, color: AppColors.ink),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 28),
        children: [
          // Foto e Informações Centralizadas (Estrutura do Wireframe, mas colorido)
          Center(
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: PetAvatar(pet: pet, size: 100, background: AppColors.pinkStrong),
                ),
                const SizedBox(height: 16),
                Text(
                  pet.nome,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet.tipoAnimal.toString().split('.').last} · ${pet.idadeLabel}',
                  style: const TextStyle(fontSize: 14, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Lista de Botões Coloridos (Baseado no design original da sua equipe)
          _ColoredListTile(
            icon: Icons.edit_outlined,
            iconColor: AppColors.pinkInk,
            circleColor: AppColors.pink,
            title: 'Adicionar/Editar pet',
            onTap: () => context.push(AppRoutes.petEditar),
          ),
          const SizedBox(height: 12),
          _ColoredListTile(
            icon: Icons.event_available_outlined,
            iconColor: AppColors.yellowInk,
            circleColor: AppColors.yellow,
            title: 'Calendário e lembretes',
            onTap: () => context.push(AppRoutes.petVacinas),
          ),
          const SizedBox(height: 12),
          _ColoredListTile(
            icon: Icons.folder_shared_outlined,
            iconColor: AppColors.navy,
            circleColor: AppColors.navySoft,
            title: 'Prontuário e histórico médico',
            onTap: () => context.push(AppRoutes.petProntuario),
          ),
          const SizedBox(height: 12),
          _ColoredListTile(
            icon: Icons.qr_code_2_outlined,
            iconColor: AppColors.lavenderInk,
            circleColor: AppColors.lavender,
            title: 'Gerar QR Code',
            onTap: () => context.push(AppRoutes.petQrCode),
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar para manter o código limpo e os botões super coloridos
class _ColoredListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color circleColor;
  final String title;
  final VoidCallback onTap;

  const _ColoredListTile({
    required this.icon,
    required this.iconColor,
    required this.circleColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
      leading: CircleAvatar(
        backgroundColor: circleColor,
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.ink),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
      onTap: onTap,
    );
  }
}