import 'package:academia/services/user_session.dart';
import 'package:academia/viewmodels/lista_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  // Lista de dados com 4 campos
  // Lista de itens expandidos
  final List<bool> expandedItems = List.generate(4, (index) => false);

  void toggleExpansion(int index) {
    setState(() {
      expandedItems[index] = !expandedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ListaViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Aqui pode chamar notifyListeners(), alterar estado, etc
      viewModel.carregarUsuarios();
    });

    return Scaffold(
      appBar: AppBar(title: const Text("ListView Expandido")),
      body:
          viewModel.erro != null
              ? Center(
                child: Text(
                  viewModel.erro!,
                  style: TextStyle(color: Colors.red),
                ),
              )
              : ListView.builder(
                itemCount: viewModel.usuarios.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => toggleExpansion(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.usuarios[index].nome!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('ID: ${viewModel.usuarios[index].id}'),
                          const SizedBox(height: 5),
                          Text(viewModel.usuarios[index].email!),
                          const SizedBox(height: 5),
                          Text('Data: ${viewModel.usuarios[index].password}'),
                          const SizedBox(height: 5),

                          // Expansão com os botões
                          if (expandedItems[index]) ...[
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                print('Botão 1 clicado');
                              },
                              child: const Text('Botão 1'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                print(UserSession().getId());
                              },
                              child: const Text('Botão 2'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
