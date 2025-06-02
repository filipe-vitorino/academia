import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../models/user_model.dart';

class ObjectBoxService {
  late final Store _store;
  late final Box<Usuario> usuarioBox;
  late final Box<Ficha> fichaBox;
  late final Box<Exercicio> exercicioBox;

  static final ObjectBoxService _instance = ObjectBoxService._internal();

  factory ObjectBoxService() {
    return _instance;
  }

  ObjectBoxService._internal();

  Future<void> init() async {
    _store = await openStore();
    usuarioBox = _store.box<Usuario>();
    fichaBox = _store.box<Ficha>();
    exercicioBox = _store.box<Exercicio>();
  }
}
