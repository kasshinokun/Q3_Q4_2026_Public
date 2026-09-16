import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';

/// Tela de abertura: anima a marca e o slogan enquanto um indicador de
/// carregamento circular gira, e então segue para o login (ou direto
/// para o dashboard, se por algum motivo a sessão já estiver ativa).
///
/// A navegação é feita explicitamente por esta tela (não pelo
/// `redirect` do GoRouter), para que a animação sempre tenha tempo de
/// ser vista antes de qualquer troca de tela.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

    _logoFade = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut));
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack)),
    );
    _textFade = CurvedAnimation(parent: _controller, curve: const Interval(0.35, 1.0, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.35, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward();

    // Tempo total de exibição da splash (animação + uma pequena pausa
    // para o slogan "assentar" antes de seguir para o login).
    Future.delayed(const Duration(milliseconds: 2200), _avancar);
  }

  void _avancar() {
    if (!mounted) return;
    final autenticado = context.read<AuthService>().isAuthenticated;
    context.go(autenticado ? AppRoutes.home : AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: const BrandMark(size: 68, background: Colors.white, foreground: AppColors.navy),
                  ),
                ),
                const SizedBox(height: 18),
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Text('PetCuida', style: AppTheme.display(size: 26, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 6),
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Text(
                      'Cuidado que cabe na rotina',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13.5),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                FadeTransition(
                  opacity: _textFade,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.6, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
