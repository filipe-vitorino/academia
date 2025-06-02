import 'package:academia/services/user_session.dart';
import 'package:academia/viewmodels/ficha_viewmodel.dart';
import 'package:academia/views/exercicio_ficha_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  _MainMenu createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  // Lista de dados com 4 campos
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aqui pode chamar notifyListeners(), alterar estado, etc
      final viewModel = context.read<FichaViewmodel>();
      viewModel.carregarFichas();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FichaViewmodel>(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // Aqui pode chamar notifyListeners(), alterar estado, etc
    // viewModel.carregarFichas();
    // });
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Meu App')),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Início')),
            ListTile(leading: Icon(Icons.person), title: Text('Perfil')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suas fichas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            viewModel.fichas.isNotEmpty
                ? Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.fichas.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // para efeito ripple arredondado
                            onTap: () {
                              final ficha = viewModel.fichas[index];
                              print(
                                'Ficha clicada: ${ficha.titulo} e ${ficha.id}',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetalhesFichaPage(
                                        idFicha: ficha.id,
                                        nome: ficha.titulo,
                                      ),
                                ),
                              );
                              // Aqui você pode navegar para outra tela ou fazer outra ação
                            },

                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Text(viewModel.fichas[index].titulo),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                : const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: Text(
                      'Nenhuma ficha cadastrada.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddExerciseDialog(context);

          // ação ao clicar em "Nova ficha"
          //Navigator.push(
          // context,
          //  MaterialPageRoute(
          //    builder: (context) => FichaPage(valor: 'Segunda'),
          //  ),
          // );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova ficha'),
      ),
    );
  }

  void showAddExerciseDialog(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final viewModel = Provider.of<FichaViewmodel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Nova Ficha'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome da Ficha',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    final nome = nomeController.text;
                    print('Nome: $nome');
                    viewModel.criarFicha(nome);
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                DetalhesFichaPage(idFicha: 0, nome: nome),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
