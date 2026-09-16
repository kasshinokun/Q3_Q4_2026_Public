import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Encapsula o acesso ao `image_picker` em um único ponto do app.
///
/// Mantém o plugin de terceiros isolado (em vez de chamado diretamente
/// em cada tela), facilitando trocar a implementação ou adicionar
/// tratamento de erro/permissão de forma centralizada.
///
/// A partir da 3i, além da galeria, o tutor pode usar a câmera do
/// aparelho para fotografar o próprio rosto ou o pet na hora — as duas
/// origens (câmera/galeria) convergem para o mesmo resultado: um
/// caminho local de imagem, ou `null` se nada foi escolhido.
abstract final class ImagePickerHelper {
  static final _picker = ImagePicker();

  /// Abre a câmera do dispositivo e retorna o caminho local da foto
  /// tirada, ou `null` se o usuário cancelar.
  static Future<String?> escolherDaCamera({int imageQuality = 80}) async {
    try {
      final XFile? arquivo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: 1024,
        preferredCameraDevice: CameraDevice.front,
      );
      return arquivo?.path;
    } catch (_) {
      // Falhas de permissão/plataforma (ex.: sem câmera, permissão
      // negada) resultam apenas em "nenhuma foto escolhida" — a UI já
      // trata `null` mostrando o ícone/emoji padrão.
      return null;
    }
  }

  /// Abre a galeria do dispositivo e retorna o caminho local da imagem
  /// escolhida, ou `null` se o usuário cancelar a seleção.
  static Future<String?> escolherDaGaleria({int imageQuality = 80}) async {
    try {
      final XFile? arquivo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: 1024,
      );
      return arquivo?.path;
    } catch (_) {
      return null;
    }
  }

  /// Mostra uma folha de opções ("Tirar foto" / "Escolher da galeria")
  /// e devolve o caminho da imagem escolhida pela origem selecionada,
  /// ou `null` se o usuário cancelar em qualquer etapa.
  ///
  /// Ponto único usado pelas telas (Onboarding do Pet, Adicionar/Editar
  /// Pet e Perfil do Tutor) para que a escolha câmera-vs-galeria tenha
  /// a mesma aparência em todo o app.
  static Future<String?> escolherComOpcoes(
    BuildContext context, {
    int imageQuality = 80,
  }) async {
    final origem = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Text(
                    'Escolher foto',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto agora'),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );

    if (origem == null) return null;
    return switch (origem) {
      ImageSource.camera => escolherDaCamera(imageQuality: imageQuality),
      ImageSource.gallery => escolherDaGaleria(imageQuality: imageQuality),
      _ => null,
    };
  }
}
