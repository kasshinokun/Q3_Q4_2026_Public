import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';

/// Tela principal da Rede Solidária reconstruída para seguir o wireframe
/// com o mapa em destaque, mas mantendo a identidade visual do app.
class RedeSolidariaScreen extends StatelessWidget {
  const RedeSolidariaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<AppDataService>().perfil;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TOPO: BOTÃO VOLTAR E SALDO (Estilizado)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.ink),
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.yellow, // Corzinha amarela do app
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_outlined, size: 20, color: AppColors.yellowInk),
                        const SizedBox(width: 8),
                        Text(
                          'Saldo: ${perfil.saldoCreditos}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.yellowInk),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. BARRA DE PESQUISA (Estilizada com bordas arredondadas)
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: AppColors.navy),
                  hintText: 'Buscar clínicas ou pedidos...',
                  hintStyle: const TextStyle(color: AppColors.muted),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. ÁREA DO MAPA COM OS PINS COLORIDOS
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.navySoft, // Fundo simulando mapa
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.line, width: 1.5),
                  ),
                  child: Stack(
                    children: [
                      // Ícone central de localização
                      const Center(
                        child: Icon(Icons.location_on, size: 56, color: AppColors.navy),
                      ),
                      // Pin Clínica 1 (Rosa)
                      Positioned(
                        top: 30,
                        right: 30,
                        child: _CaixaMapa(
                          icone: Icons.favorite_border,
                          texto: 'Clínica 1',
                          corFundo: AppColors.pink,
                          corIcone: AppColors.pinkInk,
                          aoClicar: () => context.push(AppRoutes.redeClinicas),
                        ),
                      ),
                      // Pin Clínica 2 (Lilás)
                      Positioned(
                        bottom: 100,
                        left: 20,
                        child: _CaixaMapa(
                          icone: Icons.favorite_border,
                          texto: 'Clínica 2',
                          corFundo: AppColors.lavender,
                          corIcone: AppColors.lavenderInk,
                          aoClicar: () => context.push(AppRoutes.redeClinicas),
                        ),
                      ),
                      // Pin Ajuda (Amarelo)
                      Positioned(
                        bottom: 40,
                        right: 20,
                        child: _CaixaMapa(
                          icone: Icons.error_outline,
                          texto: 'Ajuda',
                          corFundo: AppColors.yellow,
                          corIcone: AppColors.yellowInk,
                          aoClicar: () => context.push(AppRoutes.redeMural),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. BOTÃO INFERIOR (Oferecer Ajuda - Azul Navy)
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.redeMural),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.pets, color: Colors.white, size: 24),
                label: const Text(
                  'Oferecer Ajuda',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para desenhar as caixinhas coloridas dentro do mapa
class _CaixaMapa extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color corFundo;
  final Color corIcone;
  final VoidCallback aoClicar;

  const _CaixaMapa({
    required this.icone,
    required this.texto,
    required this.corFundo,
    required this.corIcone,
    required this.aoClicar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoClicar,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x1A2F3E58), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 18, color: corIcone),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: corIcone),
            ),
          ],
        ),
      ),
    );
  }
}