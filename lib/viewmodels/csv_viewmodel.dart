import 'package:flutter/material.dart';
import '../services/csv_service.dart';

class CsvViewModel extends ChangeNotifier {
  final CsvService _csvService;

  // 1. Renomeamos `data` para `filteredData` para mais clareza.
  //    Esta é a lista que a UI vai de fato usar e que será alterada pelo filtro.
  List<dynamic> filteredData = [];

  // 2. Adicionamos `_allData` para guardar a lista original e imutável de exercícios.
  //    O filtro sempre será aplicado sobre esta lista completa.
  List<dynamic> _allData = [];

  bool isLoading = true;

  CsvViewModel(this._csvService);

  Future<void> loadData() async {
    try {
      isLoading = true;
      notifyListeners();

      // Carrega os dados do serviço
      _allData = await _csvService.loadExercises();

      // 3. No início, a lista filtrada é uma cópia da lista completa.
      filteredData = List.from(_allData);
    } catch (e) {
      _allData = [];
      filteredData = [];
      debugPrint('Erro ao carregar os dados: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- NOSSO NOVO MÉTODO DE FILTRO ---
  void filterData(String query) {
    // Se a busca estiver vazia, restaura a lista filtrada para a lista completa.
    if (query.isEmpty) {
      filteredData = List.from(_allData);
    } else {
      // Caso contrário, aplica o filtro sobre a lista original (_allData)
      filteredData =
          _allData.where((exercicio) {
            // Assegura que os valores não são nulos antes de chamar os métodos de String
            final exerciseName =
                (exercicio['Exercise_Name']?.toString() ?? '').toLowerCase();
            final muscleGroup =
                (exercicio['muscle_gp']?.toString() ?? '').toLowerCase();
            final searchQuery = query.toLowerCase();

            // Retorna true se o nome do exercício OU o grupo muscular contiver o texto da busca
            return exerciseName.contains(searchQuery) ||
                muscleGroup.contains(searchQuery);
          }).toList();
    }

    // Notifica a UI que a lista `filteredData` mudou e ela precisa se redesenhar.
    notifyListeners();
  }
}
