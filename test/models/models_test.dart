import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/viewmodels/cadastro_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Ficha ficha;

  test('Deve atribuir exercicios a uma ficha', () {
    ficha = Ficha(titulo: "Ficha 1");
    Exercicio exercicio_1 = Exercicio(
      nome: "Agachamento",
      musculoAlvo: 'coxa',
      series: 12,
      repeticoes: 3,
    );
    Exercicio exercicio_2 = Exercicio(
      nome: "supino",
      musculoAlvo: "peito",
      series: 2,
      repeticoes: 10,
    );
    ficha.exercicios.addAll([exercicio_1, exercicio_2]);

    expect(ficha.exercicios.length, 2);
  });

  test('Deve atribuir uma ficha a um usuário', () {
    ficha = Ficha(titulo: "Ficha 1");
    Usuario user = Usuario(
      nome: "Fulano",
      email: "teste@teste",
      password: "password",
    );
    user.fichas.add(ficha);
    expect(user.fichas.length, 1);
    expect(user.fichas[0].titulo, "Ficha 1");
  });
}
