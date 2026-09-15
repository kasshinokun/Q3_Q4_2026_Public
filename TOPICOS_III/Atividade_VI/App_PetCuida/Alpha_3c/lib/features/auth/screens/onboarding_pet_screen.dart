import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Onboarding exibido apenas na primeira vez que uma conta nova acessa
/// o app (ver `AuthService.needsOnboarding` e o redirect no GoRouter).
/// Coleta os dados básicos do pet antes de liberar o Dashboard.
class OnboardingPetScreen extends StatefulWidget {
  const OnboardingPetScreen({super.key});

  @override
  State<OnboardingPetScreen> createState() => _OnboardingPetScreenState();
}

class _OnboardingPetScreenState extends State<OnboardingPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _especieController = TextEditingController();
  final _idadeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _especieController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AppDataService>().atualizarPet(
          PetModel(
            id: 'pet-${DateTime.now().microsecondsSinceEpoch}',
            nome: _nomeController.text.trim(),
            especie: _especieController.text.trim(),
            idade: _idadeController.text.trim(),
          ),
        );
    context.read<AuthService>().completeOnboarding();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Vamos conhecer seu pet?', style: AppTheme.display(size: 24)),
                const SizedBox(height: 6),
                const Text(
                  'Esses dados ajudam a personalizar vacinas, lembretes e o prontuário.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.45),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'NOME DO PET', hintText: 'ex.: Rex'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome do pet.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _especieController,
                  decoration: const InputDecoration(labelText: 'ESPÉCIE / RAÇA', hintText: 'ex.: Cão, SRD'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a espécie.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _idadeController,
                  decoration: const InputDecoration(labelText: 'IDADE', hintText: 'ex.: 3 anos'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a idade.' : null,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Concluir e começar a usar', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
