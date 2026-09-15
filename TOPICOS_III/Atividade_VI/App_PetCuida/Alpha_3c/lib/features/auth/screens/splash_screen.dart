import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';

/// Tela inicial exibida enquanto o app decide para onde navegar
/// (login ou dashboard), conforme o estado de [AuthService].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Pequeno delay apenas para dar tempo do branding aparecer;
    // o redirecionamento real é feito pelo GoRouter (ver app_router.dart),
    // que reage a mudanças em [AuthService] via `refreshListenable`.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      context.read<AuthService>();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: 64, background: Colors.white, foreground: AppColors.navy),
            const SizedBox(height: 16),
            Text('PetCuida', style: AppTheme.display(size: 24, color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              'Cuidado que cabe na rotina',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
