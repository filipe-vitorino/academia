import 'package:academia/models/ficha_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Exercicio {
  @Id()
  int id = 0;

  String nome;
  String musculoAlvo;
  int series;
  int repeticoes;

  final ficha = ToOne<Ficha>();

  Exercicio({
    required this.nome,
    required this.musculoAlvo,
    required this.series,
    required this.repeticoes,
  });
}
