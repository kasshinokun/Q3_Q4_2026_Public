import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Mapa GPS de clínicas e preços sociais.
///
/// Nesta versão alfa o mapa é **esquemático** (sem GPS real) — a
/// integração com um provedor de mapas (ex.: `google_maps_flutter`)
/// é um ponto de integração previsto para a próxima etapa, conforme
/// documentado no README do projeto.
class MapaClinicasScreen extends StatelessWidget {
  const MapaClinicasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mapa de clínicas',
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(color: AppColors.navySoft, borderRadius: BorderRadius.circular(22)),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.map_outlined, size: 96, color: AppColors.navy)),
                  Positioned(
                    left: 70,
                    top: 60,
                    child: _Pin(color: AppColors.pinkStrong, label: 'Clínica PetCuida'),
                  ),
                  Positioned(
                    right: 60,
                    bottom: 56,
                    child: _Pin(color: AppColors.navy, label: 'Ana Pet Estética'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Mapa demonstrativo do estágio alfa. A integração com GPS real será adicionada '
              'após a validação deste fluxo.',
              style: TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.location_on, color: color, size: 34),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
