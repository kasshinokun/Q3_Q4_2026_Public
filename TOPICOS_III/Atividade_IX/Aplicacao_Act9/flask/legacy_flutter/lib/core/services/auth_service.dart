import 'package:flutter/foundation.dart';

/// Serviço de autenticação do protótipo.
///
/// Mantido em memória (sem backend real) apenas para viabilizar a
/// navegação condicionada por login, igual ao comportamento da PWA
/// original. Em produção, isto seria substituído por uma implementação
/// que fala com uma API (ex.: Firebase Auth, REST, etc.), mantendo a
/// mesma interface pública para não impactar as telas.
class AuthService extends ChangeNotifier {
  AuthService() {
    // Usuário de demonstração, igual ao da PWA.
    _users['petcuida'] = 'meu pet';
  }

  final Map<String, String> _users = {};

  /// Contas que já concluíram o Onboarding do Pet. A conta de demonstração
  /// já entra "pronta" para não atrapalhar quem só quer explorar o app.
  final Set<String> _onboardedUsers = {'petcuida'};

  String? _currentUsername;
  String? get currentUsername => _currentUsername;
  bool get isAuthenticated => _currentUsername != null;

  /// Indica se a conta logada ainda precisa passar pelo Onboarding do Pet
  /// (ver diagrama: Login/Cadastro -> Onboarding do Pet -> Home/Dashboard).
  bool get needsOnboarding => isAuthenticated && !_onboardedUsers.contains(_currentUsername);

  void completeOnboarding() {
    if (_currentUsername == null) return;
    _onboardedUsers.add(_currentUsername!);
    notifyListeners();
  }

  /// Tenta autenticar. Retorna `null` em caso de sucesso ou uma mensagem
  /// de erro amigável para exibir na tela.
  String? login({required String username, required String password}) {
    if (username.trim().isEmpty || password.isEmpty) {
      return 'Informe usuário e senha.';
    }
    if (_users[username] == password) {
      _currentUsername = username;
      notifyListeners();
      return null;
    }
    return 'Usuário ou senha incorretos.';
  }

  /// Simula o login social. Em produção, chamaria o SDK do provedor
  /// (google_sign_in, sign_in_with_apple, etc.).
  void loginWithGoogle() {
    _users['tutor.google'] = 'google';
    _currentUsername = 'tutor.google';
    notifyListeners();
  }

  /// Cria uma nova conta. Retorna `null` em caso de sucesso ou uma
  /// mensagem de erro para exibir no formulário de cadastro.
  String? register({
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    if (username.trim().isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return 'Preencha todos os campos.';
    }
    if (password != confirmPassword) {
      return 'As senhas não conferem.';
    }
    if (password.length < 4) {
      return 'A senha deve ter pelo menos 4 caracteres.';
    }
    if (_users.containsKey(username)) {
      return 'Este usuário já está em uso.';
    }
    _users[username] = password;
    return null;
  }

  void logout() {
    _currentUsername = null;
    notifyListeners();
  }
}
