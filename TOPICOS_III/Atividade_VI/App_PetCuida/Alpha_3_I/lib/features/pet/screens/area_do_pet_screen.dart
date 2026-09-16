import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/colored_head.dart';
import '../../../core/widgets/pet_avatar.dart';
import '../../../core/widgets/section_header.dart';

/// Área do Pet (raiz da aba "Meu pet"): cartão do pet + próximos cuidados
/// + atalhos para prontuário/histórico e QR code exportável.
class AreaDoPetScreen extends StatelessWidget {
  const AreaDoPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<AppDataService>().perfil.pet;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        ColoredHead(
          eyebrow: 'Área do Pet',
          title: 'O cuidado do ${pet.nome} em um só lugar',
          description: 'Rotina, prevenção e histórico para você acompanhar com tranquilidade.',
          background: AppColors.pink,
          foreground: AppColors.pinkInk,
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.pink, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.pinkStrong, borderRadius: BorderRadius.circular(18)),
                child: PetAvatar(pet: pet, size: 52, background: AppColors.pinkStrong),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.pinkInk)),
                    const SizedBox(height: 2),
                    Text('${pet.tipoAnimal.label} · ${pet.idadeLabel}', style: const TextStyle(fontSize: 12, color: AppColors.pinkInk)),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () => context.push(AppRoutes.petEditar),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.pinkStrong,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 36),
                ),
                child: const Text('Editar'),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Próximos cuidados'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.pink, borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.favorite_outline, size: 18, color: AppColors.pinkInk),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vacinação V10', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          Text('Clínica PetCuida · 15/09/2026', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: const LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 8,
                    backgroundColor: Color(0xFFEEE9E5),
                    valueColor: AlwaysStoppedAnimation(AppColors.pinkStrong),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Seu calendário preventivo está 68% atualizado.',
                  style: TextStyle(fontSize: 11, color: AppColors.pinkInk),
                ),
              ],
            ),
          ),
        ),
        SectionHeader(
          title: 'Prontuário e histórico',
          actionLabel: 'Ver tudo',
          onAction: () => context.push(AppRoutes.petProntuario),
        ),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.line),
          ),
          leading: const CircleAvatar(
            backgroundColor: AppColors.navySoft,
            child: Icon(Icons.folder_shared_outlined, color: AppColors.navy, size: 18),
          ),
          title: const Text('Ver prontuário completo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          subtitle: const Text('Histórico de consultas, vacinas e lembretes', style: TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRoutes.petProntuario),
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.line),
          ),
          leading: const CircleAvatar(
            backgroundColor: AppColors.yellow,
            child: Icon(Icons.event_available_outlined, color: AppColors.yellowInk, size: 18),
          ),
          title: const Text('Calendário e lembretes de vacina', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          subtitle: const Text('Acompanhe as próximas datas', style: TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRoutes.petVacinas),
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.line),
          ),
          leading: const CircleAvatar(
            backgroundColor: AppColors.lavender,
            child: Icon(Icons.qr_code_2_outlined, color: AppColors.lavenderInk, size: 18),
          ),
          title: const Text('Gerar QR Code exportável', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          subtitle: const Text('Compartilhe os dados essenciais do pet', style: TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRoutes.petQrCode),
        ),
      ],
    );
  }
}
