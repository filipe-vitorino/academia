import 'package:objectbox/objectbox.dart';
import 'ficha_model.dart';

@Entity()
class Usuario {
  @Id()
  int id = 0;

  String nome;
  String email;
  String password;

  @Backlink()
  final fichas = ToMany<Ficha>();

  Usuario({
    this.id = 0,
    required this.nome,
    required this.email,
    required this.password,
  });
}
