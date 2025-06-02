import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/objectbox_service.dart';
import 'package:academia/models/user_model.dart';
import '../models/ficha_model.dart';

class FichaService {
  final fichaBox = ObjectBoxService().fichaBox;
  final usuarioBox = ObjectBoxService().usuarioBox;
  final exercicioBox = ObjectBoxService().exercicioBox;

  void adicionarFicha(Ficha ficha, Usuario user) {
    user.fichas.add(ficha);
    print("USER ID:");
    print(user.id);
    ficha.usuario.target = user;
    fichaBox.put(ficha);
    usuarioBox.put(user);
    final usuarioAtualizado = usuarioBox.get(user.id)!;
    print("USER ID:");
    print(usuarioAtualizado.id);
    print(usuarioAtualizado?.fichas.length);
  }

  Ficha buscaFichaPorId(int idFicha) {
    return fichaBox.get(idFicha)!;
  }

  void salvarExercicio(Ficha ficha, Exercicio exercicio) {
    exercicio.ficha.target = ficha;
    exercicioBox.put(exercicio);
    fichaBox.put(ficha);
  }

  //database
}
