import 'package:academia/viewmodels/cadastro_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CadastroViewModel viewModel;

  setUp(() {
    viewModel = CadastroViewModel();
  });
  group('CadastroUsuarioViewModel - Validações', () {
    test('Deve atribuir o nome e limpar erro se nome válido', () {
      viewModel.setNome('João');

      expect(viewModel.nome, 'João');
      expect(viewModel.erroNome, isNull);
    });

    test('Deve definir erro se nome for vazio', () {
      viewModel.setNome('');

      expect(viewModel.nome, '');
      expect(viewModel.erroNome, 'Nome obrigatório');
    });

    test('Deve atribuir o email e limpar erro se email válido', () {
      viewModel.setEmail('email@email');

      expect(viewModel.email, 'email@email');
      expect(viewModel.erroEmail, isNull);
    });

    test('Deve definir erro se email não conter @', () {
      viewModel.setEmail('email');
      expect(viewModel.erroEmail, 'E-mail inválido');
    });

    test('Deve atribuir a senha e limpar erro se senha válida', () {
      viewModel.setSenha('123456');

      expect(viewModel.senha, '123456');
      expect(viewModel.erroSenha, isNull);
    });

    test('Deve definir erro se senha não conter 6 caracteres', () {
      viewModel.setSenha('123');
      expect(viewModel.erroSenha, 'Senha deve ter no mínimo 6 caracteres');
    });

    test('Deve lançar exceção se campo de formulário for vazio', () {
      viewModel.setNome('');
      viewModel.setEmail('');
      viewModel.setSenha('');
      //print(viewModel.formularioValido);

      expect(
        () => viewModel.cadastrarUsuario(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'mensagem de erro',
            contains('Formulário inválido.'),
          ),
        ),
      );
    });
  });
}
