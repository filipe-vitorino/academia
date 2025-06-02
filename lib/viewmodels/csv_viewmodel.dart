import 'package:flutter/material.dart';
import '../services/csv_service.dart';

class CsvViewModel extends ChangeNotifier {
  final CsvService _csvService;

  List<dynamic> data = [];
  bool isLoading = true;

  CsvViewModel(this._csvService);

  Future<void> loadData(String path) async {
    try {
      isLoading = true;
      notifyListeners();

      data = await _csvService.loadExercises();
    } catch (e) {
      data = [];
      debugPrint('Erro ao carregar CSV: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
