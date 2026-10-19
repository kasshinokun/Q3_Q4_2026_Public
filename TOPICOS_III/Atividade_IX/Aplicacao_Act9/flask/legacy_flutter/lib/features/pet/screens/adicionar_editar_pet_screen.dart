import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_picker_helper.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/pet_avatar.dart';

/// Formulário de edição do pet já cadastrado (o primeiro cadastro
/// acontece no Onboarding — ver `OnboardingPetScreen`).
class AdicionarEditarPetScreen extends StatefulWidget {
  const AdicionarEditarPetScreen({super.key});

  @override
  State<AdicionarEditarPetScreen> createState() => _AdicionarEditarPetScreenState();
}

class _AdicionarEditarPetScreenState extends State<AdicionarEditarPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _especieController;

  late TipoAnimal _tipoAnimal;
  late DateTime _dataNascimento;
  String? _fotoPath;

  @override
  void initState() {
    super.initState();
    final pet = context.read<AppDataService>().perfil.pet;
    _nomeController = TextEditingController(text: pet.nome);
    _especieController = TextEditingController(text: pet.especie);
    _tipoAnimal = pet.tipoAnimal;
    _dataNascimento = pet.dataNascimento;
    _fotoPath = pet.fotoPath;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especieController.dispose();
    super.dispose();
  }

  Future<void> _escolherFoto() async {
    final caminho = await ImagePickerHelper.escolherComOpcoes(context);
    if (caminho == null || !mounted) return;
    setState(() => _fotoPath = caminho);
  }

  Future<void> _escolherDataNascimento() async {
    final hoje = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _dataNascimento,
      firstDate: DateTime(hoje.year - 30),
      lastDate: hoje,
      helpText: 'Data de nascimento do pet',
    );
    if (escolhida == null) return;
    setState(() => _dataNascimento = escolhida);
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final data = context.read<AppDataService>();
    data.atualizarPet(
      data.perfil.pet.copyWith(
        nome: _nomeController.text.trim(),
        especie: _especieController.text.trim(),
        tipoAnimal: _tipoAnimal,
        dataNascimento: _dataNascimento,
        fotoPath: _fotoPath,
        limparFoto: _fotoPath == null,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados do pet atualizados.')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final petPreview = context.watch<AppDataService>().perfil.pet.copyWith(
          nome: _nomeController.text,
          tipoAnimal: _tipoAnimal,
          dataNascimento: _dataNascimento,
          fotoPath: _fotoPath,
          limparFoto: _fotoPath == null,
        );

    return AppScaffold(
      title: 'Editar pet',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        PetAvatar(pet: petPreview, size: 88),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: AppColors.navy,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _escolherFoto,
                              child: const Padding(
                                padding: EdgeInsets.all(7),
                                child: Icon(Icons.photo_camera_outlined, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _escolherFoto,
                      child: Text(_fotoPath == null ? 'Adicionar foto do pet' : 'Trocar foto'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'NOME DO PET'),
                onChanged: (_) => setState(() {}),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome.' : null,
              ),
              const SizedBox(height: 16),
              const Text('TIPO DE ANIMAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TipoAnimal.values.map((tipo) {
                  final selecionado = tipo == _tipoAnimal;
                  return ChoiceChip(
                    label: Text('${tipo.emoji} ${tipo.label}'),
                    selected: selecionado,
                    onSelected: (_) => setState(() => _tipoAnimal = tipo),
                    selectedColor: AppColors.navySoft,
                    labelStyle: TextStyle(
                      color: selecionado ? AppColors.navy : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _especieController,
                decoration: const InputDecoration(labelText: 'RAÇA (OPCIONAL)'),
              ),
              const SizedBox(height: 16),
              const Text('DATA DE NASCIMENTO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _escolherDataNascimento,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cake_outlined, size: 18, color: AppColors.navy),
                      const SizedBox(width: 10),
                      Text(
                        '${_dataNascimento.day.toString().padLeft(2, '0')}/${_dataNascimento.month.toString().padLeft(2, '0')}/${_dataNascimento.year}  ·  ${petPreview.idadeLabel}',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
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
