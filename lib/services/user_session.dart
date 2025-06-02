class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  int? userId;

  void login(int id) {
    userId = id;
  }

  int? getId() {
    try {
      if (userId == null) {
        throw Exception('Não há usuário logado.');
      }
      return userId;
    } catch (e) {
      if (e.toString().contains('Não há usuário logado')) {
        rethrow; // Propaga a exceção para o teste
      }
    }
  }

  void logout() {
    userId = null;
  }

  bool get isLoggedIn => userId != null;
}
