import 'dart:io'; // Importe para manipulação de arquivos/diretórios
import 'package:flutter_test/flutter_test.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/services/user_service.dart';
import 'package:academia/models/objectbox_service.dart';

void main() {
  // Crie uma instância do ObjectBoxService fora do setUpAll
  // para que possamos acessá-la no tearDownAll
  final objectBox = ObjectBoxService();

  // Crie um diretório específico para os testes
  final testDirectory = Directory('./test_data');

  // Este hook é executado UMA VEZ antes de todos os testes neste arquivo
  setUpAll(() async {
    // Certifique-se de que o binding está inicializado ANTES de qualquer outra coisa
    TestWidgetsFlutterBinding.ensureInitialized();

    // Se o diretório de teste já existir de uma execução anterior, delete-o
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
    // Crie o diretório para o banco de dados de teste
    await testDirectory.create();

    // Inicialize o ObjectBox passando o diretório de teste
    await objectBox.init(directory: testDirectory.path);

    // Agora o UserService pode ser criado, pois o ObjectBox já foi inicializado
    // (Assumindo que seu UserService depende de uma instância singleton do ObjectBox)
  });

  // Este hook é executado UMA VEZ depois de todos os testes neste arquivo
  tearDownAll(() async {
    // Fecha a store do ObjectBox para liberar o arquivo
    objectBox.store.close();

    // Limpa o diretório de teste
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  group('Testes de Integração do UserService', () {
    late UserService userService;
    late int usuarioId;

    setUp(() {
      // Recriamos o UserService para cada teste para garantir isolamento,
      // ele usará a mesma instância do ObjectBox inicializada no setUpAll.
      userService =
          UserService(); // Você pode precisar passar a store: objectBox.store

      final usuario = Usuario(
        nome: 'Teste Integrado',
        email: 'teste@exemplo.com',
        password: 'senha123',
      );
      usuarioId = userService.salvaUsuario(usuario);
    });

    tearDown(() {
      // Remove o usuário após cada teste, se existir

      final usuario = userService.buscaUsuarioPorId(usuarioId);

      if (usuario != null) {
        userService.excluirUsuario(usuario);
      }
    });

    test('Buscar usuário salvo e validar os dados', () {
      final salvo = userService.buscaUsuarioPorId(usuarioId);
      expect(salvo, isNotNull);
      expect(salvo!.nome, 'Teste Integrado');
      expect(salvo.email, 'teste@exemplo.com');
    });

    test('Excluir usuário deve removê-lo do banco', () {
      final usuarioParaExcluir = userService.buscaUsuarioPorId(usuarioId);
      expect(usuarioParaExcluir, isNotNull);

      userService.excluirUsuario(usuarioParaExcluir!);

      final usuarioExcluido = userService.buscaUsuarioPorId(usuarioId);
      expect(usuarioExcluido, isNull);
    });
  });
}
