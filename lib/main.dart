import 'package:academia/models/exercicio_model.dart';
import 'package:academia/models/ficha_model.dart';
import 'package:academia/models/objectbox_service.dart';
import 'package:academia/models/user_model.dart';
import 'package:academia/objectbox.g.dart';
import 'package:academia/services/csv_service.dart';
import 'package:academia/viewmodels/cadastro_viewmodel.dart';
import 'package:academia/viewmodels/csv_viewmodel.dart';
import 'package:academia/viewmodels/ficha_viewmodel.dart';
import 'package:academia/viewmodels/lista_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'viewmodels/login_viewmodel.dart';
import 'package:objectbox/objectbox.dart';

late Store store;
late Box<Usuario> usuarioBox;
late Box<Ficha> fichaBox;
late Box<Exercicio> exercicioBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBoxService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CadastroViewModel()),
        ChangeNotifierProvider(create: (_) => ListaViewModel()),
        ChangeNotifierProvider(create: (_) => FichaViewmodel()),
        ChangeNotifierProvider(
          create: (_) => CsvViewModel(CsvService())..loadData(),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
