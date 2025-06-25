import 'package:academia/services/csv_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // necessário para rootBundle funcionar

  group('Teste de integração - CsvService com JSON', () {
    late CsvService csvService;

    setUp(() {
      csvService = CsvService(); // inicializa antes de cada teste
    });

    test(
      'Verifica se o JSON é carregado corretamente e contém campos esperados',
      () async {
        final exercicios = await csvService.loadExercises();

        expect(exercicios, isNotEmpty);

        final primeiro = exercicios[0];
        expect(primeiro['Exercise_Name'], isNotNull);
        expect(primeiro['muscle_gp'], isNotNull);
      },
    );
  });
}
