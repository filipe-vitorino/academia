import 'package:academia/viewmodels/csv_viewmodel.dart';
import 'package:academia/viewmodels/ficha_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExercicioPage extends StatefulWidget {
  const AddExercicioPage({super.key});

  @override
  _AddExercicioPage createState() => _AddExercicioPage();
}

class _AddExercicioPage extends State<AddExercicioPage> {
  // Lista de dados com 4 campos
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<CsvViewModel>(context, listen: false);
      vm.loadData('assets/workouts.csv');
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CsvViewModel>(context);

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

      body:
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Barra de busca com padding
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar ficha...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            print('Filtro pressionado');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Lista de cards
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: vm.data.length,
                      itemBuilder: (context, index) {
                        final row = vm.data[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              row['Exercise_Name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Músculo: ${row['muscle_gp']}'),

                            trailing: IconButton(
                              color: Colors.green,
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                showAddExerciseDialog(context, row);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
    );
  }

  void showAddExerciseDialog(BuildContext context, row) {
    final TextEditingController repController = TextEditingController();
    final TextEditingController seriesController = TextEditingController();
    final viewModel = context.read<FichaViewmodel>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Novo Exercício'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: repController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número de repetições',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: seriesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número de séries',
                        border: OutlineInputBorder(),
                      ),
                    ),
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
                    final rep = int.tryParse(repController.text) ?? 0;
                    final series = int.tryParse(seriesController.text) ?? 0;
                    print('Rep: ${viewModel.idFicha}');
                    viewModel.salvaExercicio(
                      rep,
                      series,
                      row['Exercise_Name'],
                      row['muscle_gp'],
                      viewModel.idFicha,
                    );

                    Navigator.of(context).pop();
                    viewModel.carregarExerciciosFicha(viewModel.idFicha);
                    Navigator.of(context).pop();
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
