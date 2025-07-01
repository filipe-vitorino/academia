import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/models/objectbox_service.dart';
import 'package:academia/objectbox.g.dart';

class FichaService {
  // 1. Pega a instância única (Singleton) do ObjectBox UMA VEZ.
  final ObjectBoxService _objectbox = ObjectBoxService();

  // Getters para acessar as "caixas" de forma limpa.
  Box<Ficha> get _fichaBox => _objectbox.store.box<Ficha>();
  Box<Usuario> get _usuarioBox => _objectbox.store.box<Usuario>();

  /// Adiciona uma nova ficha a um usuário e persiste ambas as relações.
  int adicionarFicha(Ficha ficha, Usuario user) {
    // 1. Busca a instância mais recente do usuário para evitar dados obsoletos.
    final userFromDb = _usuarioBox.get(user.id);
    if (userFromDb == null) return 0;

    // 2. Estabelece a relação nos dois sentidos.
    userFromDb.fichas.add(ficha);
    ficha.usuario.target = userFromDb;

    // 3. Salva o usuário "pai" para persistir a nova relação ToMany.
    //    O ObjectBox é inteligente e salvará a `ficha` nova ao mesmo tempo.
    _usuarioBox.put(userFromDb);
    print("AAA");
    return ficha.id;
  }

  /// Busca uma ficha específica pelo seu ID.
  Ficha buscaFichaPorId(int idFicha) {
    // Usar `get` retorna nulo se não encontrar, o que é mais seguro.
    final ficha = _fichaBox.get(idFicha);
    if (ficha == null) {
      throw Exception('Ficha com ID $idFicha não encontrada.');
    }
    return ficha;
  }

  /// Adiciona um exercício a uma ficha e salva a relação corretamente.
  /// ESTE MÉTODO CORRIGE O BUG DE NÃO SALVAR.
  void addExercicioToFicha(int fichaId, Exercicio novoExercicio) {
    // 1. Busca a instância mais recente da Ficha do banco.
    final ficha = _fichaBox.get(fichaId);
    if (ficha == null) return;

    // 2. Adiciona o novo exercício à lista de exercícios da ficha (em memória).
    ficha.exercicios.add(novoExercicio);

    // 3. O PASSO CRUCIAL: Salva o objeto "pai" (Ficha) de volta.
    //    Isso força o ObjectBox a persistir a nova relação e salvar o `novoExercicio`
    //    na sua própria Box se ele for novo.
    _fichaBox.put(ficha);
  }
}
