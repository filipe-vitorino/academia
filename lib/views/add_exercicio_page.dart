import 'package:academia/viewmodels/csv_viewmodel.dart';
import 'package:academia/viewmodels/ficha_viewmodel.dart'; // Mantive a importação, pois seu dialog a usa
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExercicioPage extends StatefulWidget {
  final int idFicha;
  const AddExercicioPage({super.key, required this.idFicha});

  @override
  _AddExercicioPage createState() => _AddExercicioPage();
}

class _AddExercicioPage extends State<AddExercicioPage> {
  @override
  void initState() {
    super.initState();
    // Garante que o carregamento dos dados seja chamado apenas uma vez após a UI ser construída
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usamos `listen: false` aqui porque só queremos chamar o método, não ouvir mudanças no initState
      final vm = Provider.of<CsvViewModel>(context, listen: false);
      // Chama o método loadData do ViewModel (ele agora sabe como chamar o CsvService)
      vm.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch para que a UI se reconstrua quando o filtro for aplicado (notifyListeners)
    final vm = context.watch<CsvViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Adicionar Exercício')),
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
                  // Barra de busca funcional
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            // CONECTA O TEXTFIELD AO VIEWMODEL
                            onChanged: (value) => vm.filterData(value),
                            decoration: InputDecoration(
                              hintText: 'Buscar exercício ou músculo...',
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
                            // Lógica para um futuro filtro avançado pode ser colocada aqui
                            print('Filtro avançado pressionado');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Lista de cards que reage ao filtro
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      // USA OS DADOS FILTRADOS DO VIEWMODEL
                      itemCount: vm.filteredData.length,
                      itemBuilder: (context, index) {
                        final row = vm.filteredData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              row['Exercise_Name'] ?? 'Nome indisponível',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Músculo: ${row['muscle_gp'] ?? 'N/A'}',
                            ),
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
                ],
              ),
    );
  }

  // O seu método para mostrar o diálogo continua o mesmo
  void showAddExerciseDialog(BuildContext context, Map<String, dynamic> row) {
    final TextEditingController repController = TextEditingController();
    final TextEditingController seriesController = TextEditingController();
    // Usamos context.read aqui porque estamos dentro de uma função de callback
    // e não precisamos que esta parte da UI se reconstrua.
    final fichaViewModel = context.read<FichaViewmodel>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Exercício'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: repController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número de repetições',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: seriesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número de séries',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Salvar'),
                  onPressed: () async {
                    // O callback precisa ser async
                    final rep = int.tryParse(repController.text) ?? 0;
                    final series = int.tryParse(seriesController.text) ?? 0;

                    // Agora só precisamos chamar um método.
                    // Usamos `await` para esperar que ele salve E recarregue a lista.
                    print(widget.idFicha);
                    await fichaViewModel.salvaExercicio(
                      rep,
                      series,
                      row['Exercise_Name'],
                      row['muscle_gp'],
                      widget.idFicha,
                    );

                    // Como o recarregamento já aconteceu, podemos simplesmente voltar.
                    // A verificação `if (!mounted)` é uma boa prática em operações async
                    if (!mounted) return;
                    Navigator.of(context).pop(); // Fecha o dialog
                    Navigator.of(
                      context,
                    ).pop(); // Volta para a tela de detalhes
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
