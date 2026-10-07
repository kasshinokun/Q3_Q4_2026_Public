import 'package:cloud_firestore/cloud_firestore.dart';

import 'remote_data_source.dart';

/// Adaptador real para Firebase Cloud Firestore.
///
/// Implementação completa desde a 3i: mapeia [readDocument]/
/// [writeDocument]/[deleteDocument]/[watchCollection] diretamente para
/// `FirebaseFirestore.instance`. Fica "dormente" apenas no sentido de
/// que ninguém a registra no composition root enquanto
/// [BackendConfig.current.provider] permanecer em [BackendProvider.local]
/// — o código em si já é funcional, não um stub.
///
/// Pré-requisitos para ativar (ver `backend_config.dart` e `README.md`
/// desta pasta):
/// - `firebase_core` e `cloud_firestore` no `pubspec.yaml`;
/// - `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
///   chamado em `main.dart` antes de `runApp` (feito automaticamente
///   quando o provider é [BackendProvider.firebaseFirestore]);
/// - `lib/firebase_options.dart` gerado por `flutterfire configure`
///   (veja `firebase_options.template.dart`).
final class FirebaseFirestoreDataSource implements RemoteDataSource {
  FirebaseFirestoreDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<Map<String, dynamic>?> readDocument({
    required String collection,
    required String id,
  }) async {
    final snapshot = await _db.collection(collection).doc(id).get();
    if (!snapshot.exists) return null;
    return {...snapshot.data() ?? {}, 'id': snapshot.id};
  }

  @override
  Future<void> writeDocument({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    // `merge: true` preserva campos não incluídos em [data], permitindo
    // atualizações parciais (ex.: só `fotoPath`) sem sobrescrever o
    // documento inteiro.
    await _db.collection(collection).doc(id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteDocument({
    required String collection,
    required String id,
  }) async {
    await _db.collection(collection).doc(id).delete();
  }

  @override
  Stream<List<Map<String, dynamic>>> watchCollection({required String collection}) {
    return _db.collection(collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList(growable: false),
        );
  }
}
