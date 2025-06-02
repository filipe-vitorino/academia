import 'package:academia/models/objectbox_service.dart';
import '../models/user_model.dart';
import 'package:objectbox/objectbox.dart';

class UserService {
  final usuarioBox = ObjectBoxService().usuarioBox;

  int salvaUsuario(Usuario usuario) {
    try {
      return usuarioBox.put(usuario);
    } catch (e) {
      throw Exception('Erro ao salvar no banco: $e');
    }
  }

  List<Usuario> buscaTodosUsuarios() {
    List<Usuario> users = usuarioBox.getAll();
    if (users.isEmpty) {
      return [];
    }
    return users;
  }

  Usuario? buscaUsuarioPorId(int id) {
    return usuarioBox.get(id);
  }

  bool excluirUsuario(Usuario usuario) {
    final fichaBox = ObjectBoxService().fichaBox;
    final fichasParaRemover = usuario.fichas.toList(); // cópia da lista
    for (var ficha in fichasParaRemover) {
      fichaBox.remove(ficha.id);
    }
    return usuarioBox.remove(usuario.id);
  }
}
