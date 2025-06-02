import 'package:academia/viewmodels/ficha_viewmodel.dart';
import 'package:academia/views/add_exercicio_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetalhesFichaPage extends StatefulWidget {
  final int idFicha;
  final String nome;

  const DetalhesFichaPage({
    super.key,
    required this.idFicha,
    required this.nome,
  });

  @override
  _DetalhesFichaPageState createState() => _DetalhesFichaPageState();
}

class _DetalhesFichaPageState extends State<DetalhesFichaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = context.read<FichaViewmodel>();
      viewModel.carregarExerciciosFicha(widget.idFicha);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FichaViewmodel>();

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
            Text(
              widget.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center, // centraliza horizontalmente
              child: Text('Exercícios', style: const TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 16),

            viewModel.exercicios.isNotEmpty
                ? Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.exercicios.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              final ficha = viewModel.fichas[index];
                              print(
                                'Ficha clicada: ${ficha.titulo} e ${ficha.id}',
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start, // Alinha à esquerda
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      viewModel.exercicios[index].nome,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Séries: ${viewModel.exercicios[index].series}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Repetições: ${viewModel.exercicios[index].repeticoes}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                : const Expanded(
                  child: Center(
                    child: Text(
                      'Nenhum Exercício cadastrado.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExercicioPage()),
            ),
        icon: const Icon(Icons.add),
        label: const Text('Novo Exercicio'),
      ),
    );
  }
}
