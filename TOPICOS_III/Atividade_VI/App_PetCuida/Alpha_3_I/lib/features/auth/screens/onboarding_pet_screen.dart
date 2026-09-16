import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/pet_model.dart';
import '../../../core/services/app_data_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/image_picker_helper.dart';
import '../../../core/widgets/pet_avatar.dart';

/// Onboarding exibido apenas na primeira vez que uma conta nova acessa
/// o app (ver `AuthService.needsOnboarding` e o redirect no GoRouter).
/// Coleta os dados básicos do pet — incluindo foto, tipo de animal e
/// data de nascimento — antes de liberar o Dashboard.
class OnboardingPetScreen extends StatefulWidget {
  const OnboardingPetScreen({super.key});

  @override
  State<OnboardingPetScreen> createState() => _OnboardingPetScreenState();
}

class _OnboardingPetScreenState extends State<OnboardingPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _especieController = TextEditingController();

  TipoAnimal _tipoAnimal = TipoAnimal.cao;
  DateTime? _dataNascimento;
  String? _fotoPath;
  bool _tentouEnviar = false;

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
      initialDate: _dataNascimento ?? DateTime(hoje.year - 1, hoje.month, hoje.day),
      firstDate: DateTime(hoje.year - 30),
      lastDate: hoje,
      helpText: 'Data de nascimento do pet',
    );
    if (escolhida == null) return;
    setState(() => _dataNascimento = escolhida);
  }

  void _submit() {
    setState(() => _tentouEnviar = true);
    final formValido = _formKey.currentState!.validate();
    if (!formValido || _dataNascimento == null) return;

    context.read<AppDataService>().atualizarPet(
          PetModel(
            id: 'pet-${DateTime.now().microsecondsSinceEpoch}',
            nome: _nomeController.text.trim(),
            especie: _especieController.text.trim(),
            tipoAnimal: _tipoAnimal,
            dataNascimento: _dataNascimento!,
            fotoPath: _fotoPath,
          ),
        );
    context.read<AuthService>().completeOnboarding();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final petPreview = PetModel(
      id: 'preview',
      nome: _nomeController.text,
      especie: _especieController.text,
      tipoAnimal: _tipoAnimal,
      dataNascimento: _dataNascimento ?? DateTime.now(),
      fotoPath: _fotoPath,
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Vamos conhecer seu pet?', style: AppTheme.display(size: 24)),
                const SizedBox(height: 6),
                const Text(
                  'Esses dados ajudam a personalizar vacinas, lembretes e o prontuário.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.45),
                ),
                const SizedBox(height: 22),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          PetAvatar(pet: petPreview, size: 92),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'NOME DO PET', hintText: 'ex.: Rex'),
                  onChanged: (_) => setState(() {}),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome do pet.' : null,
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
                  decoration: const InputDecoration(labelText: 'RAÇA (OPCIONAL)', hintText: 'ex.: SRD, Golden Retriever'),
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
                      border: Border.all(
                        color: (_tentouEnviar && _dataNascimento == null) ? AppColors.danger : AppColors.line,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake_outlined, size: 18, color: AppColors.navy),
                        const SizedBox(width: 10),
                        Text(
                          _dataNascimento == null
                              ? 'Toque para escolher'
                              : '${_dataNascimento!.day.toString().padLeft(2, '0')}/${_dataNascimento!.month.toString().padLeft(2, '0')}/${_dataNascimento!.year}  ·  ${petPreview.idadeLabel}',
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_tentouEnviar && _dataNascimento == null) ...[
                  const SizedBox(height: 6),
                  const Text('Informe a data de nascimento.', style: TextStyle(fontSize: 11.5, color: AppColors.danger)),
                ],
                const SizedBox(height: 28),
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
