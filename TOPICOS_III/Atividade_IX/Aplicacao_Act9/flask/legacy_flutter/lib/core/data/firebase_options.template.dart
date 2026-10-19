// TEMPLATE — copie este arquivo para `lib/firebase_options.dart` e
// preencha com os valores reais, OU (recomendado) gere o arquivo de
// verdade automaticamente com o FlutterFire CLI:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=<seu-projeto-firebase>
//
// O comando acima cria `lib/firebase_options.dart` já com
// `DefaultFirebaseOptions.currentPlatform` resolvendo as chaves certas
// para Android/iOS/Web automaticamente — prefira isso a preencher os
// valores manualmente abaixo.
//
// Nenhuma chave real deve ser commitada neste template.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma. '
          'Rode `flutterfire configure` para gerar as opções corretas.',
        );
    }
  }

  static const android = FirebaseOptions(
    apiKey: 'TODO-substituir-pelo-flutterfire-configure',
    appId: 'TODO',
    messagingSenderId: 'TODO',
    projectId: 'TODO',
    storageBucket: 'TODO',
  );

  static const ios = FirebaseOptions(
    apiKey: 'TODO-substituir-pelo-flutterfire-configure',
    appId: 'TODO',
    messagingSenderId: 'TODO',
    projectId: 'TODO',
    storageBucket: 'TODO',
    iosBundleId: 'com.petcuida.app',
  );
}
