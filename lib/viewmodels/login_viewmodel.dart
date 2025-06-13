import 'package:academia/services/user_session.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final AuthService _authService = AuthService();

  String? errorMessage;
  bool isLoading = false;

  Future<void> autenticar() async {
    isLoading = true;
    notifyListeners();

    final sucesso = await _authService.login(
      usuarioController.text.trim(),
      senhaController.text,
    );
    isLoading = false;

    if (sucesso != null) {
      sessao(sucesso);
      errorMessage = null;
    } else {
      errorMessage = 'Usuário ou senha inválidos';
    }

    notifyListeners();
  }

  bool sessao(int user_Id) {
    if (user_Id != null) {
      UserSession().login(user_Id);

      return true;
    }

    return false;
  }
}
