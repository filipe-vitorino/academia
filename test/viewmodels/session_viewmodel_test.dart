import 'package:academia/models/user_model.dart';
import 'package:academia/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Usuario user;
  late AuthService session;
  setUp(() {
    user = Usuario(
      id: 10,
      nome: "Fulano",
      email: "email@email",
      password: "password",
    );
    session = AuthService();
  });
  group('User Session - Login e Logout', () {
    test('Deve iniciar uma sessão salvando o id do usuário logado', () {
      session.iniciaSessao(user.id);

      expect(session.getIdLogado(), 10);
    });
    test('Deve encerrar a sessão e retornar false para estar logado', () {
      session.iniciaSessao(user.id);
      session.logout();
      expect(session.isLoggedIn(), false);
    });
  });
  group('User Session - Tratando Exceções', () {
    test(
      'Deve lançar uma exceção ao tentar buscar um id quando não user logado',
      () {
        session.logout();
        expect(
          () => session.getIdLogado(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'mensagem de erro',
              contains('Não há usuário logado.'),
            ),
          ),
        );
      },
    );
  });
}
