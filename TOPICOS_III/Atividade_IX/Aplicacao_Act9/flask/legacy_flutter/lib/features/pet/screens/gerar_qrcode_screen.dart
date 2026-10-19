import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Gera um QR Code com os dados essenciais do pet (nome, espécie, idade)
/// para compartilhamento rápido com clínicas parceiras — por exemplo, na
/// recepção de um atendimento, sem precisar reescrever o histórico.
class GerarQrCodeScreen extends StatelessWidget {
  const GerarQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<AppDataService>().perfil.pet;
    final payload = 'PETCUIDA|id:${pet.id}|nome:${pet.nome}|tipo:${pet.tipoAnimal.label}|idade:${pet.idadeLabel}';

    return AppScaffold(
      title: 'QR Code do pet',
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    QrImageView(
                      data: payload,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.ink),
                      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.ink),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      pet.nome.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Código demonstrativo para identificação rápida do pet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compartilhamento será conectado em uma próxima etapa.')),
                ),
                style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                icon: const Icon(Icons.share_outlined),
                label: const Text('Compartilhar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
