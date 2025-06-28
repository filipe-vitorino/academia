import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart'; // 1. Importe o path_provider

// Importe seus modelos e serviços
import 'package:academia/models/user_model.dart';
import 'package:academia/services/user_service.dart';
import 'package:academia/models/objectbox_service.dart';
import 'package:academia/objectbox.g.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final objectBox = ObjectBoxService();
  late UserService userService;
  late Box<Usuario> userBox;

  // Variável para guardar o caminho do diretório de teste
  late Directory testDirectory;

  setUpAll(() async {
    // 2. Obtenha o diretório temporário seguro para escrita
    final tempDir = await getTemporaryDirectory();

    // 3. Crie o caminho completo para o nosso banco de dados de teste dentro do diretório temporário
    testDirectory = Directory(p.join(tempDir.path, 'test_data'));

    // Garante um ambiente limpo
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
    // Cria o diretório no caminho seguro
    await testDirectory.create(recursive: true);

    // 4. Inicializa o ObjectBox com o caminho seguro
    await objectBox.init(directory: testDirectory.path);

    userService = UserService();
    userBox = objectBox.usuarioBox;
  });

  tearDownAll(() async {
    objectBox.close();
    // Limpa o diretório de teste após a execução
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  tearDown(() {
    userBox.removeAll();
  });

  group('Testes de integração do UserService com Singleton', () {
    test('Deve salvar e buscar um usuário com sucesso', () {
      final novoUsuario = Usuario(
        nome: 'Teste Seguro',
        email: 'seguro@exemplo.com',
        password: '123',
      );

      final idSalvo = userService.salvaUsuario(novoUsuario);
      final usuarioSalvo = userService.buscaUsuarioPorId(idSalvo);

      expect(usuarioSalvo, isNotNull);
      expect(usuarioSalvo!.nome, 'Teste Seguro');
    });

    test('Deve excluir um usuário corretamente', () {
      final usuarioParaExcluir = Usuario(
        nome: 'Para Excluir',
        email: 'teste@',
        password: 'senha',
      );
      final id = userService.salvaUsuario(usuarioParaExcluir);

      final usuarioSalvo = userService.buscaUsuarioPorId(id)!;
      expect(usuarioSalvo, isNotNull);

      final sucesso = userService.excluirUsuario(usuarioSalvo);

      expect(sucesso, isTrue);
      expect(userService.buscaUsuarioPorId(id), isNull);
    });
  });
}
