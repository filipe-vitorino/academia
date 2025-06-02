import 'package:flutter/services.dart';

import 'dart:convert';

class CsvService {
  Future<List<dynamic>> loadExercises() async {
    try {
      // Carrega o conteúdo do arquivo JSON
      String jsonString = await rootBundle.loadString('assets/gym.json');

      // Decodifica a string JSON em uma lista dinâmica
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Percorre a lista e imprime cada item

      return jsonList;
    } catch (e) {
      print("Erro ao carregar exercícios: $e");
      return [];
    }
  }
}
