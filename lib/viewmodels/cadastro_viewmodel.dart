import 'package:academia/models/user_model.dart';
import 'package:academia/services/user_service.dart';
import 'package:flutter/material.dart';

class CadastroViewModel extends ChangeNotifier {
  String _nome = '';
  String _email = '';
  String _senha = '';
  bool _sucessoCadastro = false;

  String? _erroNome;
  String? _erroEmail;
  String? _erroSenha;

  // Getters dos valores
  String get nome => _nome;
  String get email => _email;
  String get senha => _senha;
  bool get sucessoCadastro => _sucessoCadastro;

  // Getters das mensagens de erro
  String? get erroNome => _erroNome;
  String? get erroEmail => _erroEmail;
  String? get erroSenha => _erroSenha;

  // Setters com validação individual
  void setNome(String valor) {
    _nome = valor;
    _erroNome = _nome.isEmpty ? 'Nome obrigatório' : null;
    notifyListeners();
  }

  void setEmail(String valor) {
    _email = valor;
    _erroEmail = !_email.contains('@') ? 'E-mail inválido' : null;
    notifyListeners();
  }

  void setSenha(String valor) {
    _senha = valor;
    _erroSenha =
        _senha.length < 6 ? 'Senha deve ter no mínimo 6 caracteres' : null;
    notifyListeners();
  }

  bool get formularioValido =>
      _erroNome == null && _erroEmail == null && _erroSenha == null;

  void cadastrarUsuario() {
    try {
      if (!formularioValido) {
        throw Exception('Formulário inválido.');
      }

      // Simulando operação de banco de dados:
      // Pode ser substituído por Firebase, ObjectBox, etc.
      // Exemplo:
      // await userRepository.salvar(nome: _nome, email: _email, senha: _senha);
      UserService us = UserService();
      Usuario user = Usuario(nome: _nome, email: _email, password: _senha);
      int salvar = us.salvaUsuario(user);

      if (salvar > 0) {
        _sucessoCadastro = true;
      }

      notifyListeners();
      // Se quiser, pode limpar os campos aqui também
      // _nome = '';
      // _email = '';
      // _senha = '';
      // notifyListeners();
    } catch (e) {
      if (e.toString().contains('Formulário inválido')) {
        rethrow; // Propaga a exceção para o teste
      }
    }
  }

  void resetarEstado() {
    _sucessoCadastro = false;
    notifyListeners();
  }
}
