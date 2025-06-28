import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:academia/main.dart' as app;
import 'package:academia/models/objectbox_service.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/objectbox.g.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ObjectBoxService objectBox;
  late Directory testDirectory;

  setUpAll(() async {
    final tempDir = await getTemporaryDirectory();
    testDirectory = Directory(p.join(tempDir.path, 'e2e_test_db'));
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
    await testDirectory.create(recursive: true);
    objectBox = ObjectBoxService();
    await objectBox.init(directory: testDirectory.path);
  });

  tearDownAll(() {
    objectBox.close();
    if (testDirectory.existsSync()) {
      testDirectory.deleteSync(recursive: true);
    }
  });

  setUp(() {
    objectBox.store.box<Usuario>().removeAll();
  });

  group('Fluxo de Cadastro E2E', () {
    testWidgets(
      'Deve preencher o formulário, cadastrar, ver o sucesso e voltar para a tela de login',
      (WidgetTester tester) async {
        // ARRANGE: Inicia o aplicativo na tela de Login
        app.main();
        await tester.pumpAndSettle();

        // NAVEGAÇÃO: Clica no botão para ir para a tela de cadastro
        await tester.tap(find.byKey(const Key('goto_cadastro_button')));
        await tester.pumpAndSettle();

        // VERIFICAÇÃO: Confirma que estamos na tela de Cadastro
        expect(find.text('Cadastro'), findsOneWidget);

        // AÇÃO: Preenche todos os campos do formulário de cadastro
        final uniqueEmail =
            'teste.e2e.${DateTime.now().millisecondsSinceEpoch}@exemplo.com';
        await tester.enterText(
          find.byKey(const Key('cadastro_nome_field')),
          'Usuário de Teste',
        );
        await tester.enterText(
          find.byKey(const Key('cadastro_email_field')),
          uniqueEmail,
        );
        await tester.enterText(
          find.byKey(const Key('cadastro_senha_field')),
          'senhaForte123',
        );
        await tester.enterText(
          find.byKey(const Key('cadastro_confirmar_senha_field')),
          'senhaForte123',
        );

        // `pump` é necessário para o `ViewModel` atualizar o estado e habilitar o botão.
        await tester.pump();

        // AÇÃO: Clica no botão de cadastrar
        await tester.tap(find.byKey(const Key('cadastro_submit_button')));

        // AGORA VEM A PARTE MAIS IMPORTANTE: Lidar com o fluxo pós-cadastro

        // 1. O `ViewModel` processa e o `addPostFrameCallback` é acionado no próximo frame.
        // Usamos `pump` para renderizar esse frame, que deve mostrar a SnackBar.
        await tester.pump();

        // 2. VERIFICAÇÃO: Confirma se a SnackBar de sucesso apareceu.
        //expect(find.text('Usuário cadastrado com sucesso!'), findsOneWidget);

        // 3. MANIPULAÇÃO DO TEMPO: O código tem um `Future.delayed` de 2 segundos.
        // `pumpAndSettle` pode expirar, então avançamos o tempo manualmente.
        await tester.pump(const Duration(seconds: 2));

        // 4. NAVEGAÇÃO DE VOLTA: Após o delay, o `Navigator.pop` é chamado.
        // `pumpAndSettle` agora vai esperar a animação de "pop" da tela terminar.
        await tester.pumpAndSettle();

        // 5. VERIFICAÇÃO FINAL (UI): Garante que voltamos para a tela de Login.
        expect(
          find.text('Login'),
          findsOneWidget,
        ); // O AppBar da LoginPage deve estar visível.

        // 6. VERIFICAÇÃO FINAL (BANCO DE DADOS): Garante que os dados foram persistidos corretamente.
        final userBox = objectBox.store.box<Usuario>();
        final query = userBox.query(Usuario_.email.equals(uniqueEmail)).build();
        final userInDb = query.findFirst();
        query.close();

        expect(
          userInDb,
          isNotNull,
          reason: 'O usuário deveria ter sido salvo no banco de dados.',
        );
        expect(userInDb!.nome, 'Usuário de Teste');
      },
    );
  });
}
