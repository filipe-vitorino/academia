import 'package:academia/services/user_service.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ListaViewModel extends ChangeNotifier {
  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  String? _erro;
  String? get erro => _erro;

  void carregarUsuarios() {
    UserService us = UserService();

    try {
      _erro = null;
      _usuarios = us.buscaTodosUsuarios();
    } catch (e) {
      _erro = 'Erro ao carregar usuários: $e';
      _usuarios = []; // Limpa a lista em caso de erro
    }
    notifyListeners();
  }
}
