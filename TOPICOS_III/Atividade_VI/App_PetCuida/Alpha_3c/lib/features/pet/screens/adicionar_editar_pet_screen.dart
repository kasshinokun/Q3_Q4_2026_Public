import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

/// Formulário de criação/edição do pet. Reaproveitado tanto para o
/// primeiro cadastro (a partir do Onboarding) quanto para edições
/// posteriores feitas a partir da Área do Pet.
class AdicionarEditarPetScreen extends StatefulWidget {
  const AdicionarEditarPetScreen({super.key});

  @override
  State<AdicionarEditarPetScreen> createState() => _AdicionarEditarPetScreenState();
}

class _AdicionarEditarPetScreenState extends State<AdicionarEditarPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _especieController;
  late final TextEditingController _idadeController;

  @override
  void initState() {
    super.initState();
    final pet = context.read<AppDataService>().perfil.pet;
    _nomeController = TextEditingController(text: pet.nome);
    _especieController = TextEditingController(text: pet.especie);
    _idadeController = TextEditingController(text: pet.idade);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especieController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final data = context.read<AppDataService>();
    data.atualizarPet(
      data.perfil.pet.copyWith(
        nome: _nomeController.text.trim(),
        especie: _especieController.text.trim(),
        idade: _idadeController.text.trim(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados do pet atualizados.')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Editar pet',
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'NOME DO PET'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _especieController,
                decoration: const InputDecoration(labelText: 'ESPÉCIE / RAÇA'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a espécie.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'IDADE'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a idade.' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _salvar,
                style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                child: const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
