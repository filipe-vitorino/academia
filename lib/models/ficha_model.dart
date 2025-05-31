import 'package:academia/models/user_model.dart';
import 'package:objectbox/objectbox.dart';
import 'exercicio_model.dart';

@Entity()
class Ficha {
  @Id()
  int id = 0;

  String titulo;

  final exercicios = ToMany<Exercicio>();
  final usuario = ToOne<Usuario>();

  Ficha({required this.titulo});
}
