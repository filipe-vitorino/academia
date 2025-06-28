import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/objectbox.g.dart'; // Seu arquivo gerado
import 'package:objectbox/objectbox.dart';
import '../models/user_model.dart';

class ObjectBoxService {
  late final Store _store;
  late final Box<Usuario> usuarioBox;
  late final Box<Ficha> fichaBox;
  late final Box<Exercicio> exercicioBox;

  // Flag para evitar reinicialização
  bool _isInitialized = false;

  // Padrão Singleton para garantir uma única instância
  static final ObjectBoxService _instance = ObjectBoxService._internal();

  factory ObjectBoxService() {
    return _instance;
  }

  ObjectBoxService._internal();

  /// Retorna a instância da Store do ObjectBox.
  /// Lança um erro se o serviço não foi inicializado.
  Store get store {
    if (!_isInitialized) {
      throw Exception(
        'ObjectBoxService não inicializado. Chame init() antes de usar.',
      );
    }
    return _store;
  }

  /// Inicializa a Store do ObjectBox.
  ///
  /// [directory] é um parâmetro opcional usado para testes. Se fornecido,
  /// o banco de dados será criado nesse diretório. Se nulo, usará o
  /// caminho padrão do aplicativo (via path_provider).
  Future<void> init({String? directory}) async {
    // 1. Evita que o banco de dados seja inicializado mais de uma vez
    if (_isInitialized) {
      return;
    }

    // 2. Passa o diretório diretamente para a função openStore.
    //    Se 'directory' for nulo, openStore usará o padrão do path_provider.
    //    Se 'directory' for um caminho, ele será usado (ideal para testes).
    _store = await openStore(directory: directory);

    // 3. Inicializa os Boxes como antes
    usuarioBox = _store.box<Usuario>();
    fichaBox = _store.box<Ficha>();
    exercicioBox = _store.box<Exercicio>();

    _isInitialized = true;
  }

  void close() {
    if (_isInitialized) {
      _store.close();
      _isInitialized = false;
    }
  }
}
