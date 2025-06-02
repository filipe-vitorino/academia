import 'package:academia/services/user_service.dart';
import 'package:academia/services/user_session.dart';
import '../models/user_model.dart';

class AuthService {
  // Simulação de banco de usuários

  int? login(String email, String password) {
    UserService us = UserService();
    final List<Usuario> _usuarios = us.buscaTodosUsuarios();
    // Simula um delay de autenticação

    for (var user in _usuarios) {
      if (user.email == email && user.password == password) {
        iniciaSessao(user.id);
        return user.id;
      }
    }

    return null;
  }

  void iniciaSessao(int id) {
    UserSession().login(id);
  }

  void logout() {
    UserSession().logout();
  }

  int? getIdLogado() {
    return UserSession().getId();
  }

  bool isLoggedIn() {
    return UserSession().isLoggedIn;
  }
}
