import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/auth_hero.dart';

/// Tela de criação de conta. Ao concluir com sucesso, volta para o login
/// já com uma mensagem de confirmação (via `extra` da rota).
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // Verificação inserida IMEDIATAMENTE após o await:
    if (!mounted) return;

    final error = context.read().register(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmController.text,
        );

    if (error != null) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = error;
      });
      return;
    }

    context.go('/login', extra: 'Conta criada com sucesso! Faça login.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHero(
              eyebrow: 'Rede local de cuidado',
              title: 'Cuide antes.\nCuide junto.',
              description: 'Faça parte da rede PetCuida e cuide do seu pet com apoio da comunidade.',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Transform.translate(
                offset: const Offset(0, -32),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1A2F3E58), blurRadius: 28, offset: Offset(0, 12)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Crie sua conta', style: AppTheme.display(size: 21)),
                        const SizedBox(height: 4),
                        const Text(
                          'Faça parte da rede PetCuida.',
                          style: TextStyle(fontSize: 13, color: AppColors.muted),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'USUÁRIO',
                            hintText: 'escolha um nome de usuário',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Escolha um usuário.' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'SENHA', hintText: 'crie uma senha'),
                          validator: (v) => (v == null || v.length < 4) ? 'Mínimo de 4 caracteres.' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'CONFIRMAR SENHA', hintText: 'repita a senha'),
                          onFieldSubmitted: (_) => _submit(),
                          validator: (v) => (v == null || v.isEmpty) ? 'Confirme a senha.' : null,
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                              : const Text('Criar minha conta', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                          child: const Text('Voltar para o login'),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.danger),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
