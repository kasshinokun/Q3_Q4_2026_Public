import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/auth_hero.dart';
import 'recuperar_senha_screen.dart';

/// Tela de login. Recebe uma mensagem de sucesso opcional (ex.: após o
/// cadastro), exibida como confirmação acima do formulário.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.successMessage});

  final String? successMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 350));

    // Verificação inserida IMEDIATAMENTE após o await:
    if (!mounted) return;

    final error = context.read<AuthService>().login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

    setState(() {
      _isSubmitting = false;
      _errorMessage = error;
    });
  }

  void _loginWithGoogle() {
    context.read<AuthService>().loginWithGoogle();
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
              description:
                  'Prevenção, orientação e apoio para você cuidar do seu pet sem deixar o orçamento de lado.',
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
                        Text('Que bom ter você aqui', style: AppTheme.display(size: 21)),
                        const SizedBox(height: 4),
                        const Text(
                          'Entre para continuar o cuidado do seu pet.',
                          style: TextStyle(fontSize: 13, color: AppColors.muted),
                        ),
                        const SizedBox(height: 20),
                        if (widget.successMessage != null) ...[
                          _InlineMessage(text: widget.successMessage!, color: AppColors.success),
                          const SizedBox(height: 14),
                        ],
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'USUÁRIO', hintText: 'seu usuário'),
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty) ? 'Informe o usuário.' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'SENHA',
                            hintText: 'sua senha',
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          validator: (value) => (value == null || value.isEmpty) ? 'Informe a senha.' : null,
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
                              : const Text('Entrar na minha conta', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _isSubmitting ? null : _loginWithGoogle,
                          icon: const Text('G', style: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.w900)),
                          label: const Text('Entrar com Google'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            side: const BorderSide(color: AppColors.line, width: 1.5),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _InlineMessage(text: _errorMessage!, color: AppColors.danger),
                        ],
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => showRecuperarSenhaDialog(context),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Text('Esqueci a senha'),
                            ),
                            TextButton(
                              onPressed: () => context.push('/cadastro'),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Text('Criar conta'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Text(
                            'Acesso de demonstração: petcuida / meu pet',
                            style: TextStyle(fontSize: 12, color: AppColors.yellowInk, height: 1.4),
                          ),
                        ),
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

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color));
  }
}
