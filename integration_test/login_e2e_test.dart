import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Seus imports
import 'package:academia/main.dart' as app;
import 'package:academia/models/objectbox_service.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/objectbox.g.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Configuração padrão do banco de dados de teste
  late ObjectBoxService objectBox;
  late Directory testDirectory;
  late Box<Usuario> userBox;

  setUpAll(() async {
    final tempDir = await getTemporaryDirectory();
    testDirectory = Directory(p.join(tempDir.path, 'login_e2e_db'));
    if (await testDirectory.exists())
      await testDirectory.delete(recursive: true);
    await testDirectory.create(recursive: true);
    objectBox = ObjectBoxService();
    await objectBox.init(directory: testDirectory.path);
    userBox = objectBox.store.box<Usuario>();
  });

  tearDownAll(() {
    objectBox.close();
    if (testDirectory.existsSync()) testDirectory.deleteSync(recursive: true);
  });

  // Limpa o banco antes de cada teste para garantir que não há usuários conflitantes
  setUp(() => userBox.removeAll());

  group('Fluxo de Login E2E', () {
    testWidgets('Deve fazer login com sucesso e navegar para o MainMenu', (
      WidgetTester tester,
    ) async {
      final usuarioValido = Usuario(
        nome: 'Usuario Logado',
        email: 'login.valido@exemplo.com',
        password:
            'senhaSegura123', // Seu ViewModel deve saber lidar com a senha
      );
      userBox.put(usuarioValido);

      app.main();
      await tester.pumpAndSettle(); // Espera a tela de login carregar

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'login.valido@exemplo.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_senha_field')),
        'senhaSegura123',
      );

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pumpAndSettle();

      expect(
        find.text('Suas fichas'),
        findsOneWidget,
        reason: 'Deveria ter navegado para o Menu Principal',
      );

      // 7. Garante que a tela de Login não está mais na tela.
      expect(
        find.text('Login'),
        findsNothing,
        reason: 'A tela de Login deveria ter desaparecido',
      );
    });

    testWidgets(
      'Deve exibir mensagem de erro ao tentar logar com senha incorreta',
      (WidgetTester tester) async {
        // ARRANGE
        final usuario = Usuario(
          nome: 'Usuario',
          email: 'email@errado.com',
          password: 'senhaCerta',
        );
        userBox.put(usuario);
        app.main();
        await tester.pumpAndSettle();

        // ACT
        await tester.enterText(
          find.byKey(const Key('login_email_field')),
          'email@errado.com',
        );
        await tester.enterText(
          find.byKey(const Key('login_senha_field')),
          'senhaErrada',
        );
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        expect(find.text('Usuário ou senha inválidos'), findsOneWidget);
        expect(find.text('Suas fichas'), findsNothing);
      },
    );
  });
}
